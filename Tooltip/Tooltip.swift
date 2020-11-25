//
//  Tooltip.swift
//  Tooltip
//
//  Created by Shayan Aghajan on 9/2/1399 AP.
//

import UIKit

open class Tooltip {
        
    private var tooltipView : TooltipView?
    
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
    
    public func show(id: String,
                     text: String,
                     hasNext: Bool = false,
                     hasSkip: Bool = false,
                     hasFinish: Bool = false,
                     topArrow: Bool,
                     view: UIView,
                     viewRect: CGRect? = nil) {
        
        tooltipView = TooltipView.init(id: id, text: text, hasNext: hasNext, hasSkip: hasSkip, hasFinish: hasFinish, topArrow: topArrow, view: view, viewRect: viewRect, delegate: self)
        tooltipView?.backgroundColor = UIColor(red: 0.0,
                                               green: 0.0,
                                               blue: 0.0,
                                               alpha: 0.2)
        appWindow?.addSubview(tooltipView!)
    }
}

extension Tooltip: TooltipViewDelegate {
    func tooltipViewIsDismissed() {
        tooltipView?.removeFromSuperview()
    }
}
