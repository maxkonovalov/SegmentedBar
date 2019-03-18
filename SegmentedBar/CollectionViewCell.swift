//
//  CollectionViewCell.swift
//  SegmentedBar
//
//  Created by Max Konovalov on 25/09/2017.
//  Copyright © 2017 Max Konovalov. All rights reserved.
//

import UIKit

extension SegmentedBar {
    
    internal class CollectionViewCell: UICollectionViewCell, SegmentedBarItemConfigurable, SegmentedBarItemMetricsConfigurable {
        
        static var identifier: String {
            return String(describing: self)
        }
        
        var isEnabled: Bool = true {
            didSet {
                updateState()
            }
        }
        
        override var isHighlighted: Bool {
            didSet {
                updateState()
            }
        }
        
        override var isSelected: Bool {
            didSet {
                updateState()
            }
        }
        
        lazy var containerView: UIView = {
            let containerView = UIView()
            containerView.translatesAutoresizingMaskIntoConstraints = false
            containerView.setContentHuggingPriority(.required, for: .horizontal)
            containerView.setContentCompressionResistancePriority(.required, for: .horizontal)
            return containerView
        }()
        
        fileprivate var centersContentHorizontally: Bool! {
            didSet {
                if oldValue != centersContentHorizontally {
                    setupContainerView()
                }
            }
        }
        
        override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
            let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
            attributes.size.height = layoutAttributes.size.height
            return attributes
        }
        
        private func setupContainerView() {
            containerView.removeFromSuperview()
            contentView.addSubview(containerView)
            containerView.fillContainer(toMargins: true, centerHorizontally: centersContentHorizontally)
        }
        
        func updateState() {}
        
        func configure(with item: Item) {}
        
        func apply(_ metrics: ItemMetrics) {
            setContentInset(metrics.insets)
            setItemsDistribution(metrics.distribution)
        }
        
        private func setContentInset(_ inset: UIEdgeInsets) {
            contentView.layoutMargins = inset
        }
        
        private func setItemsDistribution(_ distribution: ItemsDistribution) {
            switch distribution {
            case .fit:
                centersContentHorizontally = false
            case .fillEqually:
                centersContentHorizontally = true
            }
        }
        
    }
    
}

extension SegmentedBar {
    
    internal final class DefaultCollectionViewCell: CollectionViewCell {
        
        var image: UIImage? {
            didSet {
                updateImage()
            }
        }
        var imageAttributes: ImageAttributes?
        
        var title: String? {
            didSet {
                updateTitle()
            }
        }
        var titleAttributes: TextAttributes?
        
        lazy var stackView: UIStackView = {
            let stackView = UIStackView(frame: self.bounds)
            stackView.axis = .horizontal
            stackView.distribution = .fill
            stackView.alignment = .fill
            stackView.spacing = 0
            stackView.preservesSuperviewLayoutMargins = false
            stackView.layoutMargins = .zero
            return stackView
        }()
        
        lazy var imageView: UIImageView = {
            let imageView = UIImageView()
            imageView.clipsToBounds = false
            imageView.contentMode = .center
            imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            imageView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
            return imageView
        }()
        
        lazy var titleLabel: UILabel = {
            let titleLabel = UILabel()
            titleLabel.clipsToBounds = false
            titleLabel.textAlignment = .center
            titleLabel.numberOfLines = 1
            titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
            titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            return titleLabel
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            containerView.addSubview(stackView)
            stackView.fillContainer()
            
            stackView.addArrangedSubview(imageView)
            stackView.addArrangedSubview(titleLabel)
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
            let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
            var width = contentView.layoutMargins.left + contentView.layoutMargins.right + stackView.spacing
            if let image = image {
                width += image.size.width
            }
            if let title = title {
                var maxTitleWidth: CGFloat = 0
                titleAttributes?.enumerateAttributes { (_, attributes) in
                    let stringWidth = NSAttributedString(string: title, attributes: attributes).size().width
                    maxTitleWidth = max(maxTitleWidth, stringWidth)
                }
                if maxTitleWidth == 0 {
                    maxTitleWidth = NSAttributedString(string: title, attributes: [.font: titleLabel.font]).size().width
                }
                width += ceil(maxTitleWidth)
            }
            attributes.size.width = width
            return attributes
        }
        
        override func updateState() {
            updateImage()
            updateTitle()
        }
        
        private func updateImage() {
            var image = self.image
            if let color = imageAttributes?.appliedColor(for: state) {
                image = image?.tinted(with: color)
            }
            imageView.image = image
            imageView.isHidden = image == nil
        }
        
        private func updateTitle() {
            let title = self.title ?? ""
            let attributes = titleAttributes?.appliedAttributes(for: state)
            titleLabel.attributedText = NSAttributedString(string: title, attributes: attributes)
            titleLabel.isHidden = title.isEmpty
        }
        
        override func configure(with item: Item) {
            guard case let .default(image, title) = item else {
                return
            }
            self.image = image
            self.title = title?.trimmingCharacters(in: .whitespaces)
        }
        
        override func apply(_ metrics: ItemMetrics) {
            super.apply(metrics)
            setStackSpacing(metrics.componentsSpacing)
            setStackLayout(metrics.componentsLayout)
            setStackArrangement(metrics.componentsArrangement)
            imageAttributes = metrics.imageAttributes
            titleAttributes = metrics.titleAttributes
        }
        
        private func setStackSpacing(_ spacing: CGFloat) {
            stackView.spacing = spacing
        }
        
        private func setStackLayout(_ layout: ItemComponentsLayout) {
            switch layout {
            case .horizontal:
                stackView.axis = .horizontal
            case .vertical:
                stackView.axis = .vertical
            }
        }
        
        private func setStackArrangement(_ arrangement: ItemComponentsArrangement) {
            switch arrangement {
            case .imageFirst where stackView.arrangedSubviews.index(of: imageView) != 0:
                stackView.insertArrangedSubview(imageView, at: 0)
            case .labelFirst where stackView.arrangedSubviews.index(of: titleLabel) != 0:
                stackView.insertArrangedSubview(titleLabel, at: 0)
            default:
                ()
            }
        }
        
    }
    
}

extension SegmentedBar {
    
    internal final class CustomCollectionViewCell: CollectionViewCell {
        
        var customView: UIView! {
            didSet {
                oldValue?.removeFromSuperview()
                prepareForReuse()
                if let view = customView {
                    containerView.addSubview(view)
                    view.fillContainer()
                    updateState()
                }
                calculateMaxContentWidth()
            }
        }
        
        private var maxContentWidth: CGFloat?
        
        private func calculateMaxContentWidth() {
            guard let view = customView as? SegmentedBarItemViewProtocol, let fn = view.contentSize else {
                maxContentWidth = nil
                return
            }
            var maxWidth: CGFloat = 0
            for state: UIControl.State in [.normal, .highlighted, .selected, .disabled] {
                let size = fn(state)
                maxWidth = max(maxWidth, size.width)
            }
            maxContentWidth = ceil(maxWidth)
        }
        
        override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
            let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
            if let width = maxContentWidth {
                attributes.size.width = contentView.layoutMargins.left + width + contentView.layoutMargins.right
            }
            return attributes
        }
        
        override func prepareForReuse() {
            super.prepareForReuse()
            (customView as? SegmentedBarItemViewProtocol)?.prepare()
        }
        
        override func updateState() {
            (customView as? SegmentedBarItemViewProtocol)?.configure(for: state)
        }
        
        override func configure(with item: Item) {
            guard case let .custom(view) = item else {
                return
            }
            self.customView = view
        }
        
    }
    
}

extension SegmentedBar.CollectionViewCell {
    
    var state: UIControl.State {
        guard isEnabled else {
            return .disabled
        }
        var state = UIControl.State.normal
        if isHighlighted {
            state.insert(.highlighted)
        }
        if isSelected {
            state.insert(.selected)
        }
        return state
    }
    
}

extension UICollectionView {
    
    func registerSegmentedBarCells() {
        self.register(SegmentedBar.DefaultCollectionViewCell.self,
                      forCellWithReuseIdentifier: SegmentedBar.DefaultCollectionViewCell.identifier)
        self.register(SegmentedBar.CustomCollectionViewCell.self,
                      forCellWithReuseIdentifier: SegmentedBar.CustomCollectionViewCell.identifier)
    }
    
    func dequeueSegmentedBarCell(for item: SegmentedBar.Item, at indexPath: IndexPath) -> SegmentedBar.CollectionViewCell {
        switch item {
        case .default:
            return self.dequeueReusableCell(withReuseIdentifier: SegmentedBar.DefaultCollectionViewCell.identifier,
                                            for: indexPath) as! SegmentedBar.CollectionViewCell
        case .custom:
            return self.dequeueReusableCell(withReuseIdentifier: SegmentedBar.CustomCollectionViewCell.identifier,
                                            for: indexPath) as! SegmentedBar.CollectionViewCell
        }
    }
    
}

