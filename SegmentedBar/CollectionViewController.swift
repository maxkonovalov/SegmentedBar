//
//  CollectionViewController.swift
//  SegmentedBar
//
//  Created by Max Konovalov on 25/09/2017.
//  Copyright © 2017 Max Konovalov. All rights reserved.
//

import UIKit

extension SegmentedBar {
    
    internal class CollectionViewController: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
        
        var items: [Item] = [] {
            didSet {
                collectionView.flowLayout.invalidateLayout()
                collectionView.reloadData()
            }
        }
        
        var metrics = ItemMetrics.default {
            didSet {
                collectionView.flowLayout.invalidateLayout()
                collectionView.reloadData()
            }
        }
        
        var shouldScrollToSelectedItem: Bool = Defaults.shouldScrollToSelectedItem
        
        var onSelect: (() -> Void)?
        
        lazy var collectionView: CollectionView = {
            let collectionView = CollectionView()
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.allowsMultipleSelection = false
            collectionView.registerSegmentedBarCells()
            return collectionView
        }()
        
        // MARK: - Collection View
        
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return items.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let item = items[indexPath.item]
            let cell = collectionView.dequeueSegmentedBarCell(for: item, at: indexPath)
            cell.apply(metrics)
            cell.configure(with: item)
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let index = indexPath.item
            let currentIndex = self.collectionView.selectedIndex.map { Int(round($0)) }
            self.collectionView.setSelectedIndex(Float(index), animated: true)
            if index != currentIndex {
                onSelect?()
            }
            if shouldScrollToSelectedItem {
                self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
        }
        
    }
    
}
