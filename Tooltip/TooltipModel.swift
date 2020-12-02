//
//  TooltipModel.swift
//  Tooltip
//
//  Created by Shayan Aghajan on 12/1/20.
//

import UIKit

public class TooltipModel {
    public var id: String
    var text: String
    var hasNext: Bool
    var hasSkip: Bool
    var hasFinish: Bool
    var topArrow: Bool
    var view: UIView?
    var viewRect: CGRect?
    var barButton: UIBarItem?
    var delegate: TooltipDelegate?
    
    public init(id: String,
         text: String,
         hasNext: Bool = false,
         hasSkip: Bool = false,
         hasFinish: Bool = false,
         topArrow: Bool = true,
         view: UIView? = nil,
         viewRect: CGRect? = nil,
         barButton: UIBarItem? = nil,
         delegate: TooltipDelegate? = nil) {
        
        self.id = id
        self.text = text
        self.hasNext = hasNext
        self.hasSkip = hasSkip
        self.hasFinish = hasFinish
        self.topArrow = topArrow
        self.view = view
        self.viewRect = viewRect
        self.barButton = barButton
        self.delegate = delegate
        
    }
}
