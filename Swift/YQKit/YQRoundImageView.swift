//
//  YQRoundImageView.swift
//  BiuBiu
//
//  Created by meizu on 2018/4/3.
//  Copyright © 2018年 meizu. All rights reserved.
//

import Foundation
import UIKit

extension YQ {
    class RoundImageView: UIImageView {
        override func layoutSubviews() {
            super.layoutSubviews()
            layer.cornerRadius = yqView.size.yq.minValue / 2
        }
    }
}
