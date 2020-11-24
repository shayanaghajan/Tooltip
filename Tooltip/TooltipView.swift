//
//  TooltipView.swift
//  Tooltip
//
//  Created by Shayan Aghajan on 9/2/1399 AP.
//

import UIKit
import EasyTipView

protocol TooltipViewDelegate {
    func tooltipViewIsDismissed()
}

class TooltipView: UIView {

    private var tooltipModel : TooltipModel?
    
    private var tooltipDelegate: TooltipViewDelegate?
    
    init(tooltipModel: TooltipModel, delegate: TooltipViewDelegate?) {
        self.tooltipModel = tooltipModel
        self.tooltipDelegate = delegate
        super.init(frame: UIScreen.main.bounds)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func draw(_ rect: CGRect) {
        // Drawing code
        maskView()
        showTooltip()
    }

    private func showTooltip() {
        
        var preferences = EasyTipView.Preferences()
        preferences.drawing.font = UIFont(name: "HelveticaNeue-Medium", size: 12)!
        preferences.drawing.foregroundColor = .white
        let color = rgbToHue(r:255 ,g:150, b:0)
        preferences.drawing.backgroundColor = UIColor(hue: color.h, saturation: color.s, brightness: color.b, alpha:1)
        preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.top
        
        
        if let model = tooltipModel {
            EasyTipView.show(forView: model.view!,
                             text: model.text ?? "",
                             preferences: preferences,
                             delegate: self)
        }
    }
    
    private func maskView() {
        if let model = tooltipModel {
            if let view = model.view {
                setMask(with: view.frame, in: self)
            }
        }
    }
    
    private func setMask(with hole: CGRect, in view: UIView) {

        //Calculating the position of the mask to the view
        let height   = hole.height + 8
        let width    = hole.width  + 8
        let minX     = hole.minX   - 4
        let minY     = hole.minY   - 4
        let theMaskRect = CGRect(x: minX, y: minY, width: width, height: height)
        // Create a mutable path and add a rectangle that will be h
        let mutablePath = CGMutablePath()
        mutablePath.addRect(view.bounds)
        mutablePath.addRoundedRect(in: theMaskRect, cornerWidth: 10, cornerHeight: 10)

        // Create a shape layer and cut out the intersection
        let mask = CAShapeLayer()
        mask.path = mutablePath
        mask.cornerRadius = 10
        mask.fillRule = CAShapeLayerFillRule.evenOdd

        // Add the mask to the view
        view.layer.mask = mask
    }
    
    private func rgbToHue(r:CGFloat,g:CGFloat,b:CGFloat) -> (h:CGFloat, s:CGFloat, b:CGFloat) {
        let minV:CGFloat = CGFloat(min(r, g, b))
        let maxV:CGFloat = CGFloat(max(r, g, b))
        let delta:CGFloat = maxV - minV
        var hue:CGFloat = 0
        if delta != 0 {
            if r == maxV {
                hue = (g - b) / delta
            }
            else if g == maxV {
                hue = 2 + (b - r) / delta
            }
            else {
                hue = 4 + (r - g) / delta
            }
            hue *= 60
            if hue < 0 {
                hue += 360
            }
        }
        let saturation = maxV == 0 ? 0 : (delta / maxV)
        let brightness = maxV
        return (h:hue/360, s:saturation, b:brightness)
    }
}

extension TooltipView: EasyTipViewDelegate {
    
    func easyTipViewDidDismiss(_ tipView: EasyTipView) {
        tooltipDelegate?.tooltipViewIsDismissed()
    }
    
}

