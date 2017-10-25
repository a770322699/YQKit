//
//  ViewExtension.swift
//  Demo
//
//  Created by maygolf on 2017/9/26.
//  Copyright © 2017年 yiquan. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    var yq_x: CGFloat{
        set{
            frame.origin.x = newValue
        }
        get{
            return frame.origin.x
        }
    }
    
    var yq_y: CGFloat{
        set{
            frame.origin.y = newValue
        }
        get{
            return frame.origin.y
        }
    }
    
    var yq_width: CGFloat{
        set{
            frame.size.width = newValue
        }
        get{
            return frame.size.width
        }
    }
    
    var yq_height: CGFloat{
        set{
            frame.size.height = newValue
        }
        get{
            return frame.size.height
        }
    }
    
    var yq_centerX: CGFloat{
        set{
            yq_x = newValue - yq_width / 2
        }
        get{
            return yq_x + yq_width / 2
        }
    }
    
    var yq_centerY: CGFloat{
        set{
            yq_y = newValue - yq_height / 2
        }
        get{
            return yq_y + yq_height / 2
        }
    }
    
    var yq_maxX: CGFloat{
        set{
            yq_x = newValue - yq_width
        }
        get{
            return yq_x + yq_width
        }
    }
    
    var yq_maxY: CGFloat{
        set{
            yq_y = newValue - yq_height
        }
        get{
            return yq_y + yq_height
        }
    }
    
    var yq_origin: CGPoint{
        set{
            frame.origin = newValue
        }
        get{
            return frame.origin
        }
    }
    
    var yq_center: CGPoint{
        set{
            yq_centerX = newValue.x
            yq_centerY = newValue.y
        }
        get{
            return CGPoint.init(x: yq_centerX, y: yq_centerY)
        }
    }
    
    var yq_size: CGSize{
        set{
            frame.size = yq_size
        }
        get{
            return frame.size
        }
    }
}
