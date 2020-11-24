//
//  Tooltip.swift
//  Tooltip
//
//  Created by Shayan Aghajan on 9/2/1399 AP.
//

import UIKit

open class Tooltip {
    
    private var tooltipModel: TooltipModel?
    
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
    
    public func show(tooltipModel: TooltipModel) {
        tooltipView = TooltipView.init(tooltipModel: tooltipModel, delegate: self)
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
