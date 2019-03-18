//
//  SegmentedBar.swift
//  SegmentedBar
//
//  Created by Max Konovalov on 22/09/2017.
//  Copyright © 2017 Max Konovalov. All rights reserved.
//

import UIKit

open class SegmentedBar: UIControl {
    
    @objc open var backgroundView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            if let view = backgroundView {
                insertSubview(view, at: 0)
                view.fillContainer()
            }
        }
    }
    
    internal lazy var controller: CollectionViewController = {
        let controller = CollectionViewController()
        self.addSubview(controller.collectionView)
        controller.collectionView.fillContainer()
        controller.onSelect = { [weak self] in
            self?.sendActions(for: .valueChanged)
        }
        return controller
    }()
    
    private var items: [Item] {
        get {
            return controller.items
        }
        set {
            controller.items = newValue
        }
    }
    
    @objc public convenience init(items: [Any]?) {
        self.init()
        if let segments = items {
            self.setSegments(segments)
        }
    }
    
    @objc open var selectedSegmentIndex: Int {
        get {
            return controller.collectionView.selectedCellIndex ?? NSNotFound
        }
        set {
            setSelectedSegmentIndex(Float(newValue))
        }
    }
    
    @objc open func setSelectedSegmentIndex(_ index: Float, animated: Bool = false) {
        let index = min(max(index, 0), Float(numberOfSegments - 1))
        controller.collectionView.setSelectedIndex(index, animated: animated)
    }
    
    @objc open func deselectAllSegments(animated: Bool = false) {
        controller.collectionView.setSelectedIndex(nil, animated: animated)
    }
    
    @objc open var numberOfSegments: Int {
        return items.count
    }
    
    @objc open func setSegments(_ segments: [Any]) {
        items = segments.compactMap { (item) in
            switch item {
            case let view as UIView:
                return Item(customView: view)
            case let image as UIImage:
                return Item(image: image)
            case let title as String:
                return Item(title: title)
            case let (image, title) as (UIImage, String):
                return Item(image: image, title: title)
            case let (title, image) as (String, UIImage):
                return Item(image: image, title: title)
            default:
                return nil
            }
        }
    }
        
}

@objc
public protocol SegmentedBarItemViewProtocol {
    
    @objc
    func prepare()
    
    @objc(configureForState:)
    func configure(for state: UIControl.State)
    
    @objc(contentSizeForState:)
    optional func contentSize(for state: UIControl.State) -> CGSize
    
}
