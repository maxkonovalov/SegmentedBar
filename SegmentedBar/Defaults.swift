//
//  Defaults.swift
//  SegmentedBar
//
//  Created by Max Konovalov on 01/10/2017.
//  Copyright © 2017 Max Konovalov. All rights reserved.
//

import UIKit

extension SegmentedBar {
    
    struct Defaults {
        
        static let contentInset: UIEdgeInsets = .zero
        
        static let itemsSpacing: CGFloat = 0
        
        static let itemInsets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        static let itemsDistribution: ItemsDistribution = .fit
        
        static let itemComponentsSpacing: CGFloat = 8
        
        static let itemComponentsLayout: ItemComponentsLayout = .horizontal
        
        static let itemComponentsArrangement: ItemComponentsArrangement = .imageFirst
        
        static let selectionIndicatorInsets: UIEdgeInsets = .zero
        
        static let selectionIndicatorSize: CGSize = CGSize(width: 0, height: 2)
        
        static let selectionIndicatorPosition: SelectionIndicatorPosition = .bottom
        
        static let selectionIndicatorAnimationDuration: TimeInterval = 0.25
        
        static let shouldScrollToSelectedItem: Bool = true
        
    }
    
}
