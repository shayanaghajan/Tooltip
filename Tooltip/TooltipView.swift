//
//  TooltipView.swift
//  Tooltip
//
//  Created by Shayan Aghajan on 9/2/1399 AP.
//

import UIKit
import EasyTipView

enum tipViewButtonType : String {
    case next = "Next"
    case skip = "Skip"
    case finish = "Finish"
    
    func selector() -> Selector {
        switch self {
        case .skip:
            return #selector(TooltipView.skipButtonTapped)
        case .next:
            return #selector(TooltipView.nextButtonTapped)
        case .finish:
            return #selector(TooltipView.dismissTip)
        }
    }
}

protocol TooltipViewDelegate {
    func tooltipViewIsDismissed()
    func nextButtonTapped()
    func skipButtonTapped()
}

class TooltipView: UIView {
    
    private var tooltipDelegate: TooltipViewDelegate?
    private var id: String = ""
    private var text: String = ""
    private var firstButton: tipViewButtonType? = nil
    private var secondButton: tipViewButtonType? = nil
    private var topArrow: Bool = false
    private var viewRect: CGRect?
    private var view: UIView = UIView()
    private var tipView = EasyTipView(text: "")
        
    fileprivate lazy var textSize: CGSize = {
        [unowned self] in
        #if swift(>=4.2)
        var attributes = [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Medium", size: 12)!]
        #else
        var attributes = [NSAttributedStringKey.font : UIFont(name: "HelveticaNeue-Medium", size: 12)!]
        #endif
        
        var textSize = text.boundingRect(with: CGSize(width: 200, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes, context: nil).size
        
        textSize.width = ceil(textSize.width)
        textSize.height = ceil(textSize.height)
        
        if textSize.width < 10 {
            textSize.width = 10
        }
        
        return textSize
    }()
    
    init(id: String,
         text: String,
         firstButton: tipViewButtonType? = nil,
         secondButton: tipViewButtonType? = nil,
         topArrow: Bool,
         view: UIView,
         viewRect: CGRect? = nil,
         delegate: TooltipViewDelegate?) {
        
        self.id = id
        self.text = text
        self.firstButton = firstButton
        self.secondButton = secondButton
        self.topArrow = topArrow
        self.view = view
        self.viewRect = viewRect
        self.tooltipDelegate = delegate
        
        super.init(frame: UIScreen.main.bounds)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        maskView()
        showTooltip()
    }

    private func showTooltip() {
        
        var preferences = EasyTipView.Preferences()
        preferences.drawing.foregroundColor = .white
        
        let color = rgbToHue(r:255/255 ,g:150/255, b:0/255)
        preferences.drawing.backgroundColor = UIColor(hue: color.h, saturation: color.s, brightness: color.b, alpha:1)
        
        if topArrow {
            preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.top
        } else {
            preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.bottom
        }
        
        guard firstButton != nil || secondButton != nil else {
            tipView = EasyTipView(contentView: drawSimpleBubble(), preferences: preferences, delegate: self)
            tipView.show(forView: view)
            return
        }
        
        tipView = EasyTipView(contentView: drawCustomizedBubble(), preferences: preferences, delegate: self)
        tipView.show(forView: view)
    }
    
    private func maskView() {
        guard viewRect != nil else {
            setMask(with: view.frame, in: self)
            return
        }
        setMask(with: viewRect!, in: self)
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
    
    private func createTipView() -> UIView? {
        
        guard firstButton != nil || secondButton != nil else {
            return drawSimpleBubble()
        }
        
        return UIView()
        
    }
    
    private func drawSimpleBubble() -> UIView {
        
        let button = UIButton(frame: CGRect(x: textSize.width + 8, y: 4, width: 12, height: 12))
        button.addTarget(self, action: #selector(dismissTip), for: .touchUpInside)
        if #available(iOS 13.0, *) {
            button.setImage(UIImage(systemName: "xmark"), for: .normal)
        } else {
            // Fallback on earlier versions
        }
        button.tintColor = .white
        
        
        let textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: textSize.width, height: textSize.height))
        textLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 12)!
        textLabel.numberOfLines = 0
        textLabel.textColor = .white
        textLabel.text = self.text
                
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: textSize.width + 20, height: textSize.height))
        view.addSubview(textLabel)
        view.addSubview(button)
        
        return view
    }
    
    private func drawCustomizedBubble() -> UIView {
        
        var viewWidth: CGFloat = 0.0
        if textSize.width < 108 + 16 {
            viewWidth  = 108 + 16
        } else {
            viewWidth = textSize.width
        }
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: viewWidth, height: textSize.height + 25 + 8))
        
        let textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: textSize.width, height: textSize.height))
        textLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 12)!
        textLabel.numberOfLines = 0
        textLabel.textColor = .white
        textLabel.text = self.text
        view.addSubview(textLabel)
        
        if let firstButton = firstButton {
            let button = UIButton(frame: CGRect(x: viewWidth - 108, y: textSize.height + 8, width: 52, height: 25))
            drawButtons(button, title: firstButton.rawValue)
            button.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
            view.addSubview(button)
        }
        
        if let secondButton = secondButton {
            let button = UIButton(frame: CGRect(x: viewWidth - 52, y: textSize.height + 8, width: 52, height: 25))
            drawButtons(button, title: secondButton.rawValue)
            button.addTarget(self, action: secondButton.selector(), for: .touchUpInside)
            view.addSubview(button)
        }
        
        
        return view
    }
    
    private func drawButtons(_ button: UIButton, title: String) {
        
        button.backgroundColor = .white
        button.setTitleColor(UIColor(red: 105/255,
                                     green: 105/255,
                                     blue: 105/255,
                                     alpha: 1.0), for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 12)
        button.setTitle(title, for: .normal)
        
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        button.layer.shadowOpacity = 1.0
        button.layer.shadowRadius = 0.0
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 4.0
    }
    
    @objc fileprivate func dismissTip() {
        tipView.dismiss()
        tooltipDelegate?.tooltipViewIsDismissed()
    }
    
    @objc fileprivate func nextButtonTapped() {
        self.layer.mask = nil
        tipView.dismiss()
        tooltipDelegate?.nextButtonTapped()
    }
    
    @objc fileprivate func skipButtonTapped() {
        tipView.dismiss()
        tooltipDelegate?.skipButtonTapped()
    }
}

extension TooltipView: EasyTipViewDelegate {
    func easyTipViewDidDismiss(_ tipView: EasyTipView) {
//        tooltipDelegate?.tooltipViewIsDismissed()
    }
}

