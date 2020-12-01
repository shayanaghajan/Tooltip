//
//  Tooltip.swift
//  Tooltip
//
//  Created by Shayan Aghajan on 9/2/1399 AP.
//

import UIKit

public protocol TooltipDelegate {
    func tipDismissed(_ withId: String)
}

open class Tooltip {
        
    private var tooltipView : TooltipView?
    
    private var id : String?
    
    private var delegate: TooltipDelegate?
    
    private var maximumNumberOfTips = 0
    
    private var currentTipIndex = 0
    
    private var tips = [TooltipModel]() {
        didSet {
            maximumNumberOfTips = tips.count
            showTip()
        }
    }
    
    /// The main window of the application which tooltip views are placed on
    private let appWindow: UIWindow? = {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
                .first { $0.activationState == .foregroundActive || $0.activationState == .foregroundInactive }
                .map { $0 as? UIWindowScene }
                .map { $0?.windows.first } ?? UIApplication.shared.delegate?.window ?? nil
        }
        return UIApplication.shared.delegate?.window ?? nil
    }()
    
    public init() {
    }
    
    public func show(_ tips: [TooltipModel]) {
        
        self.tips = tips
        
        tooltipView?.backgroundColor = UIColor(red: 0.0,
                                               green: 0.0,
                                               blue: 0.0,
                                               alpha: 0.2)
    }
    
    private func showTip() {
        
        let tip = tips[currentTipIndex]
        
        self.id = tip.id
        
        self.delegate = tip.delegate
        
        var firstButton: tipViewButtonType? {
            if tip.hasSkip {
                return .skip
            } else {
                return nil
            }
        }
        
        var secondButton: tipViewButtonType? {
            if tip.hasNext {
                return .next
            } else if tip.hasFinish {
                return .finish
            } else {
                return nil
            }
        }
        
        tooltipView = TooltipView.init(id: tip.id,
                                       text: tip.text,
                                       firstButton: firstButton,
                                       secondButton: secondButton,
                                       topArrow: tip.topArrow,
                                       view: tip.view,
                                       viewRect: tip.viewRect,
                                       delegate: self)
        
        appWindow?.addSubview(tooltipView!)
    }
    
    private func showNextTip() {
        currentTipIndex += 1
        showTip()
    }
}

extension Tooltip: TooltipViewDelegate {
    func tooltipViewIsDismissed() {
        delegate?.tipDismissed(id ?? "")
        tooltipView?.removeFromSuperview()
    }
    
    func nextButtonTapped() {
        showNextTip()
    }
    
    func skipButtonTapped() {
        tooltipView?.removeFromSuperview()
    }
}
