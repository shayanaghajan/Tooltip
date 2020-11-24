//
//  TooltipModel.swift
//  Tooltip
//
//  Created by Shayan Aghajan on 9/2/1399 AP.
//

import UIKit

public struct TooltipModel {
    
    var id              : Int = 0
    var view            : UIView?
    var text            : String?
    var hasNextOption   : Bool?
    var hasSkipOption   : Bool?
    
    public init(id: Int, view: UIView,
         text: String,
         hasNextOption: Bool,
         hasSkipOption: Bool) {
        self.id             = id
        self.view           = view
        self.text           = text
        self.hasNextOption  = hasNextOption
        self.hasSkipOption  = hasSkipOption
    }
}
