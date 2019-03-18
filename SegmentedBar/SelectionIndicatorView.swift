//
//  SelectionIndicatorView.swift
//  SegmentedBar
//
//  Created by Max Konovalov on 25/09/2017.
//  Copyright © 2017 Max Konovalov. All rights reserved.
//

import UIKit

extension SegmentedBar {

    internal class SelectionIndicatorView: UIView {
                
        var customView: UIView? {
            didSet {
                oldValue?.removeFromSuperview()
                if let view = customView {
                    addSubview(view)
                    view.fillContainer()
                }
                tintColorDidChange()
            }
        }

        override func didMoveToWindow() {
            super.didMoveToWindow()
            tintColorDidChange()
        }

        override func tintColorDidChange() {
            super.tintColorDidChange()
            backgroundColor = customView == nil ? tintColor : .clear
        }

    }

}
