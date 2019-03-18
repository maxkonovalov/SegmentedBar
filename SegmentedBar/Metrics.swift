//
//  Metrics.swift
//  SegmentedBar
//
//  Created by Max Konovalov on 11/10/2017.
//  Copyright © 2017 Max Konovalov. All rights reserved.
//

import UIKit

extension SegmentedBar {
    
    struct ItemMetrics {
        
        var distribution: ItemsDistribution
        
        var insets: UIEdgeInsets
        
        var componentsSpacing: CGFloat
        
        var componentsLayout: ItemComponentsLayout
        
        var componentsArrangement: ItemComponentsArrangement
        
        var imageAttributes = ImageAttributes()
        
        var titleAttributes = TextAttributes()
        
        init(distribution: ItemsDistribution,
             insets: UIEdgeInsets,
             componentsSpacing: CGFloat,
             componentsLayout: ItemComponentsLayout,
             componentsArrangement: ItemComponentsArrangement) {
            self.distribution = distribution
            self.insets = insets
            self.componentsSpacing = componentsSpacing
            self.componentsLayout = componentsLayout
            self.componentsArrangement = componentsArrangement
        }
        
        static let `default` = ItemMetrics(
            distribution: Defaults.itemsDistribution,
            insets: Defaults.itemInsets,
            componentsSpacing: Defaults.itemComponentsSpacing,
            componentsLayout: Defaults.itemComponentsLayout,
            componentsArrangement: Defaults.itemComponentsArrangement
        )
        
    }
    
}

protocol SegmentedBarItemMetricsConfigurable {
    func apply(_ metrics: SegmentedBar.ItemMetrics)
}
