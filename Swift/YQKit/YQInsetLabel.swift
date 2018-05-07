//
//  InsetLabel.swift
//  BiuBiu
//
//  Created by meizu on 2018/3/30.
//  Copyright © 2018年 meizu. All rights reserved.
//

import Foundation
import UIKit

extension YQ {
    class InsetLabel: UILabel {
        // MARK public property
        var edgeInsets: UIEdgeInsets = UIEdgeInsets.zero
        
        override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
            var rect = super.textRect(forBounds: UIEdgeInsetsInsetRect(bounds, edgeInsets), limitedToNumberOfLines: numberOfLines)
            rect.origin.x -= edgeInsets.left
            rect.origin.y -= edgeInsets.top
            rect.size.width += edgeInsets.left + edgeInsets.right
            rect.size.height += edgeInsets.top + edgeInsets.bottom
            return rect
        }
        
        override func drawText(in rect: CGRect) {
            super.drawText(in: UIEdgeInsetsInsetRect(rect, edgeInsets))
        }
    }
}
