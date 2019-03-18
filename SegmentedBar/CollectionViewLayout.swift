//
//  CollectionViewLayout.swift
//  SegmentedBar
//
//  Created by Max Konovalov on 27/09/2017.
//  Copyright © 2017 Max Konovalov. All rights reserved.
//

import UIKit

extension SegmentedBar {
    
    class CollectionViewFlowLayout: UICollectionViewFlowLayout {
        
        var distribution: ItemsDistribution = Defaults.itemsDistribution {
            didSet {
                invalidateLayout()
            }
        }
        
        var contentInset: UIEdgeInsets = Defaults.contentInset {
            didSet {
                sectionInset = contentInset
                invalidateLayout()
            }
        }
        
        var itemsSpacing: CGFloat = Defaults.itemsSpacing {
            didSet {
                minimumLineSpacing = itemsSpacing
                minimumInteritemSpacing = itemsSpacing
                invalidateLayout()
            }
        }
        
        override init() {
            super.init()
            scrollDirection = .horizontal
            defer {
                contentInset = Defaults.contentInset
                itemsSpacing = Defaults.itemsSpacing
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func prepare() {
            defer {
                super.prepare()
            }
            guard let collectionView = collectionView else {
                return
            }
            let itemsCount = collectionView.numberOfItems(inSection: 0)
            let height = collectionView.bounds.height
            switch distribution {
            case .fit:
                let size = CGSize(width: 50, height: height)
                itemSize = size
                estimatedItemSize = size
            case .fillEqually:
                let width = (collectionView.bounds.width - contentInset.left - contentInset.right - CGFloat(max(0, itemsCount - 1)) * itemsSpacing) / CGFloat(itemsCount)
                itemSize = CGSize(width: width, height: height)
                estimatedItemSize = .zero
            }
        }
        
        override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
            return newBounds.size != collectionView?.bounds.size
        }
        
    }
    
}
