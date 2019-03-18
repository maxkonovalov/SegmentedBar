//
//  CollectionView.swift
//  SegmentedBar
//
//  Created by Max Konovalov on 25/09/2017.
//  Copyright © 2017 Max Konovalov. All rights reserved.
//

import UIKit

extension SegmentedBar {
    
    internal class CollectionView: UICollectionView {
        
        var selectedCellIndex: Int? {
            return indexPathsForSelectedItems?.first?.item
        }
        
        var selectedIndex: Float?
        
        func setSelectedIndex(_ index: Float?, animated: Bool = false) {
            selectedIndex = index
            defer {
                updateSelectionIndicator(animated: animated)
            }
            guard let index = index else {
                indexPathsForSelectedItems?.forEach {
                    deselectItem(at: $0, animated: true)
                }
                return
            }
            let cellIndex = Int(round(index))
            if selectedCellIndex != cellIndex {
                DispatchQueue.main.async {
                    self.selectItem(at: IndexPath(item: cellIndex, section: 0), animated: true, scrollPosition: .centeredHorizontally)
                }
            }
        }
        
        var itemsCount: Int {
            return numberOfItems(inSection: 0)
        }
        
        var flowLayout: CollectionViewFlowLayout {
            return collectionViewLayout as! CollectionViewFlowLayout
        }
        
        convenience init() {
            self.init(frame: .zero, collectionViewLayout: CollectionViewFlowLayout())
            backgroundColor = .clear
            showsVerticalScrollIndicator = false
            showsHorizontalScrollIndicator = false
            insertSubview(selectionIndicator, at: 0)
            selectionIndicator.isHidden = true
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            if !isAnimatingSelectionIndicator {
                updateSelectionIndicator()
            }
        }
        
        // MARK: - Selection Indicator
        
        lazy var selectionIndicator: SelectionIndicatorView = {
            let selectionIndicator = SelectionIndicatorView()
            selectionIndicator.layer.masksToBounds = true
            selectionIndicator.layer.zPosition = -1
            selectionIndicator.isUserInteractionEnabled = false
            return selectionIndicator
        }()
        
        var selectionIndicatorInsets: UIEdgeInsets = Defaults.selectionIndicatorInsets {
            didSet {
                updateSelectionIndicator()
            }
        }
        
        var selectionIndicatorSize: CGSize = Defaults.selectionIndicatorSize {
            didSet {
                updateSelectionIndicator()
            }
        }
        
        var selectionIndicatorPosition: SelectionIndicatorPosition = Defaults.selectionIndicatorPosition {
            didSet {
                updateSelectionIndicator()
            }
        }
        
        var selectionIndicatorAnimationDuration: TimeInterval = Defaults.selectionIndicatorAnimationDuration
        
        private var isAnimatingSelectionIndicator = false
        
        private func selectionIndicatorFrame(for index: Int) -> CGRect {
            guard let cellFrame = flowLayout.layoutAttributesForItem(at: IndexPath(item: index, section: 0))?.frame else {
                return .zero
            }
            let frame = cellFrame.inset(by: selectionIndicatorInsets)
            let h = selectionIndicatorSize.height == 0.0 ? bounds.height : selectionIndicatorSize.height
            let y: CGFloat
            switch selectionIndicatorPosition {
            case .top:
                y = frame.minY
            case .bottom:
                y = frame.maxY - h
            case .center:
                y = frame.midY - h/2
            }
            let w = selectionIndicatorSize.width == 0.0 ? frame.width : selectionIndicatorSize.width
            let x = frame.minX + (frame.width - w)/2
            return CGRect(x: x, y: y, width: w, height: h)
        }
        
        func updateSelectionIndicator(animated: Bool = false) {
            guard let displayedIndex = selectedIndex else {
                hideSelectionIndicator(animated: animated)
                return
            }
            let currentIndex = Int(round(displayedIndex))
            var frame = selectionIndicatorFrame(for: currentIndex)
            
            var nextIndex = currentIndex
            let offset = displayedIndex - Float(currentIndex)
            if offset > 0 {
                nextIndex += 1
            } else if offset < 0 {
                nextIndex -= 1
            }
            nextIndex = min(max(nextIndex, 0), itemsCount - 1)
            
            if currentIndex != nextIndex {
                let nextFrame = selectionIndicatorFrame(for: nextIndex)
                let progress = CGFloat(abs(offset))
                frame = CGRect(x: frame.origin.x + (nextFrame.origin.x - frame.origin.x) * progress,
                               y: frame.origin.y + (nextFrame.origin.y - frame.origin.y) * progress,
                               width: frame.width + (nextFrame.width - frame.width) * progress,
                               height: frame.height + (nextFrame.height - frame.height) * progress)
            }
            
            let update = { self.selectionIndicator.frame = frame }
            if animated && !selectionIndicator.isHidden {
                isAnimatingSelectionIndicator = true
                UIView.animate(withDuration: selectionIndicatorAnimationDuration,
                               delay: 0.0,
                               usingSpringWithDamping: 1.0,
                               initialSpringVelocity: 0.0,
                               options: [],
                               animations: update,
                               completion: { _ in
                                self.isAnimatingSelectionIndicator = false
                })
            } else {
                update()
            }
            
            selectionIndicator.isHidden = false
        }
        
        func hideSelectionIndicator(animated: Bool = false) {
            guard animated else {
                selectionIndicator.isHidden = true
                return
            }
            UIView.animate(withDuration: selectionIndicatorAnimationDuration,
                           delay: 0.0,
                           usingSpringWithDamping: 1.0,
                           initialSpringVelocity: 0.0,
                           options: [],
                           animations: {
                            self.selectionIndicator.alpha = 0.0
            },
                           completion: { _ in
                            self.selectionIndicator.isHidden = true
                            self.selectionIndicator.alpha = 1.0
            })
        }

    }
    
}
