//
//  SegmentedBar+Appearance.swift
//  SegmentedBar
//
//  Created by Max Konovalov on 27/10/2017.
//  Copyright © 2017 Max Konovalov. All rights reserved.
//

import UIKit

extension SegmentedBar {
    
    @objc(SegmentedBarItemsDistribution)
    public enum ItemsDistribution: Int {
        case fit
        case fillEqually
    }
    
    @objc(SegmentedBarItemComponentsLayout)
    public enum ItemComponentsLayout: Int {
        case horizontal
        case vertical
    }
    
    @objc(SegmentedBarItemComponentsArrangement)
    public enum ItemComponentsArrangement: Int {
        case imageFirst
        case labelFirst
    }
    
    @objc(SegmentedBarSelectionIndicatorPosition)
    public enum SelectionIndicatorPosition: Int {
        case bottom
        case center
        case top
    }
    
}

@objc
extension SegmentedBar {
    
    dynamic open var contentInset: UIEdgeInsets {
        get {
            return controller.collectionView.flowLayout.contentInset
        }
        set {
            controller.collectionView.flowLayout.contentInset = newValue
        }
    }
    
    // MARK: - Items
    
    dynamic open var itemInsets: UIEdgeInsets {
        get {
            return controller.metrics.insets
        }
        set {
            controller.metrics.insets = newValue
        }
    }
    
    dynamic open var itemsSpacing: CGFloat {
        get {
            return controller.collectionView.flowLayout.itemsSpacing
        }
        set {
            controller.collectionView.flowLayout.itemsSpacing = newValue
        }
    }
    
    dynamic open var itemsDistribution: ItemsDistribution {
        get {
            return controller.collectionView.flowLayout.distribution
        }
        set {
            controller.collectionView.flowLayout.distribution = newValue
            controller.metrics.distribution = newValue
        }
    }
    
    dynamic open var itemComponentsSpacing: CGFloat {
        get {
            return controller.metrics.componentsSpacing
        }
        set {
            controller.metrics.componentsSpacing = newValue
        }
    }
    
    dynamic open var itemComponentsArrangement: ItemComponentsArrangement {
        get {
            return controller.metrics.componentsArrangement
        }
        set {
            controller.metrics.componentsArrangement = newValue
        }
    }
    
    dynamic open var itemComponentsLayout: ItemComponentsLayout {
        get {
            return controller.metrics.componentsLayout
        }
        set {
            controller.metrics.componentsLayout = newValue
        }
    }
    
    // MARK: - Image
    
    dynamic open func setImageColor(_ color: UIColor?, for state: UIControl.State) {
        controller.metrics.imageAttributes.setColor(color, for: state)
        controller.collectionView.reloadData()
    }
    
    dynamic open func imageColor(for state: UIControl.State) -> UIColor? {
        return controller.metrics.imageAttributes.color(for: state)
    }
    
    // MARK: - Title
    
    dynamic open func setTitleTextAttributes(_ attributes: [NSAttributedString.Key: Any]?, for state: UIControl.State) {
        controller.metrics.titleAttributes.setAttributes(attributes, for: state)
        controller.collectionView.reloadData()
    }
    
    dynamic open func titleTextAttributes(for state: UIControl.State) -> [NSAttributedString.Key: Any]? {
        return controller.metrics.titleAttributes.attributes(for: state)
    }
    
    // MARK: - Selection Indicator
    
    dynamic open var selectionIndicatorInsets: UIEdgeInsets {
        get {
            return controller.collectionView.selectionIndicatorInsets
        }
        set {
            controller.collectionView.selectionIndicatorInsets = newValue
        }
    }
    
    dynamic open var selectionIndicatorPosition: SelectionIndicatorPosition {
        get {
            return controller.collectionView.selectionIndicatorPosition
        }
        set {
            controller.collectionView.selectionIndicatorPosition = newValue
        }
    }
    
    dynamic open var selectionIndicatorCornerRadius: CGFloat {
        get {
            return controller.collectionView.selectionIndicator.layer.cornerRadius
        }
        set {
            controller.collectionView.selectionIndicator.layer.cornerRadius = newValue
        }
    }
    
    dynamic open var selectionIndicatorSize: CGSize {
        get {
            return controller.collectionView.selectionIndicatorSize
        }
        set {
            controller.collectionView.selectionIndicatorSize = newValue
        }
    }
    
    dynamic open var selectionIndicatorView: UIView? {
        get {
            return controller.collectionView.selectionIndicator.customView
        }
        set {
            controller.collectionView.selectionIndicator.customView = newValue
        }
    }
    
}

// MARK: - Private

@objc
extension SegmentedBar {
    
    dynamic internal var selectionIndicatorAnimationDuration: TimeInterval {
        get {
            return controller.collectionView.selectionIndicatorAnimationDuration
        }
        set {
            controller.collectionView.selectionIndicatorAnimationDuration = newValue
        }
    }
    
    dynamic internal var scrollsToItemOnSelection: Bool {
        get {
            return controller.shouldScrollToSelectedItem
        }
        set {
            controller.shouldScrollToSelectedItem = newValue
        }
    }
    
}
