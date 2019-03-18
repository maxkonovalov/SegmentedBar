//
//  Item.swift
//  SegmentedBar
//
//  Created by Max Konovalov on 25/09/2017.
//  Copyright © 2017 Max Konovalov. All rights reserved.
//

import UIKit

extension SegmentedBar {
    
    enum Item {
        
        case `default`(image: UIImage?, title: String?)
        case custom(view: UIView)
        
        init(image: UIImage? = nil, title: String? = nil) {
            assert(image != nil || title != nil, "`image` or `title` should be provided.")
            self = .default(image: image, title: title)
        }
        
        init(customView: UIView) {
            self = .custom(view: customView)
        }
        
    }
    
}

protocol SegmentedBarItemConfigurable {
    func configure(with item: SegmentedBar.Item)
}
