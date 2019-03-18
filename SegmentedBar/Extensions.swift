//
//  Extensions.swift
//  SegmentedBar
//
//  Created by Max Konovalov on 25/09/2017.
//  Copyright © 2017 Max Konovalov. All rights reserved.
//

import UIKit

// MARK: - Attributes

extension UIControl.State {
    
    func from(_ existing: [UIControl.State]) -> UIControl.State {
        if existing.contains(self) {
            return self
        }
        if self.contains(.disabled) && existing.contains(.disabled) {
            return .disabled
        }
        if self.contains(.highlighted) && existing.contains(.highlighted) {
            return .highlighted
        }
        if self.contains(.selected) && existing.contains(.selected) {
            return .selected
        }
        return .normal
    }
    
}

final class TextAttributes {
        
    private var attributes: [UInt: [NSAttributedString.Key: Any]] = [:]
    
    func setAttributes(_ attributes: [NSAttributedString.Key: Any]?, for state: UIControl.State) {
        self.attributes[state.rawValue] = attributes
    }
    
    func attributes(for state: UIControl.State) -> [NSAttributedString.Key: Any]? {
        return self.attributes[state.rawValue]
    }
    
    func appliedAttributes(for state: UIControl.State) -> [NSAttributedString.Key: Any] {
        return self.attributes(for: state.from(attributes.keys.compactMap(UIControl.State.init))) ?? [:]
    }
    
}

extension TextAttributes {
    
    func enumerateAttributes(_ block: (UIControl.State, [NSAttributedString.Key: Any]) -> Void) {
        for (state, attributes) in self.attributes {
            block(UIControl.State(rawValue: state), attributes)
        }
    }
    
    func enumerateAttribute(_ attributeName: NSAttributedString.Key, using block: (UIControl.State, Any?) -> Void) {
        for (state, attributes) in self.attributes {
            for (attribute, value) in attributes where attribute == attributeName {
                block(UIControl.State(rawValue: state), value)
            }
        }
    }
    
}

final class ImageAttributes {
    
    private var colors: [UInt: UIColor] = [:]
    
    func setColor(_ color: UIColor?, for state: UIControl.State) {
        self.colors[state.rawValue] = color
    }
    
    func color(for state: UIControl.State) -> UIColor? {
        return self.colors[state.rawValue]
    }
    
    func appliedColor(for state: UIControl.State) -> UIColor? {
        return self.color(for: state.from(colors.keys.compactMap(UIControl.State.init)))
    }
    
    
}

extension UIImage {
    
    func tinted(with color: UIColor) -> UIImage {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, scale)
        let context = UIGraphicsGetCurrentContext()!
        color.setFill()
        context.fill(rect)
        self.draw(in: rect, blendMode: .destinationIn, alpha: 1)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image.resizableImage(withCapInsets: capInsets)
    }
    
}

// MARK: - Layout

extension UIView {
    
    internal func fillContainer(insets: UIEdgeInsets = .zero,
                                toMargins: Bool = false,
                                centerHorizontally: Bool = false,
                                centerVertically: Bool = false) {
        guard let superview = superview else {
            fatalError("The view must have a superview")
        }
        translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [
            NSLayoutConstraint(item: self,
                               attribute: .top,
                               relatedBy: centerVertically ? .greaterThanOrEqual : .equal,
                               toItem: superview,
                               attribute: toMargins ? .topMargin : .top,
                               multiplier: 1.0,
                               constant: insets.top),
            NSLayoutConstraint(item: self,
                               attribute: .left,
                               relatedBy: centerHorizontally ? .greaterThanOrEqual : .equal,
                               toItem: superview,
                               attribute: toMargins ? .leftMargin : .left,
                               multiplier: 1.0,
                               constant: insets.left),
            NSLayoutConstraint(item: superview,
                               attribute: toMargins ? .bottomMargin : .bottom,
                               relatedBy: centerVertically ? .greaterThanOrEqual : .equal,
                               toItem: self,
                               attribute: .bottom,
                               multiplier: 1.0,
                               constant: insets.bottom),
            NSLayoutConstraint(item: superview,
                               attribute: toMargins ? .rightMargin : .right,
                               relatedBy: centerHorizontally ? .greaterThanOrEqual : .equal,
                               toItem: self,
                               attribute: .right,
                               multiplier: 1.0,
                               constant: insets.right)
            ]
        
        if centerHorizontally {
            constraints.append(NSLayoutConstraint(item: self,
                                                  attribute: .centerX,
                                                  relatedBy: .equal,
                                                  toItem: superview,
                                                  attribute: .centerXWithinMargins,
                                                  multiplier: 1.0,
                                                  constant: 0.0))
        }
        
        if centerVertically {
            constraints.append(NSLayoutConstraint(item: self,
                                                  attribute: .centerY,
                                                  relatedBy: .equal,
                                                  toItem: superview,
                                                  attribute: .centerYWithinMargins,
                                                  multiplier: 1.0,
                                                  constant: 0.0))
        }
        
        superview.addConstraints(constraints)
    }
    
}
