//
//  UIView+AutoLayout.swift
//  
//
//  Created by Kien Nguyen on 05/06/2021.
//

import UIKit

enum AutoLayoutEdge: CaseIterable {
    case leading
    case trailing
    case top
    case bottom
    
    var constraintAttribute: NSLayoutConstraint.Attribute {
        switch self {
        case .leading:
            return .leading
        case .trailing:
            return .trailing
        case .top:
            return .top
        case .bottom:
            return .bottom
        }
    }
    
    func inset(from insets: UIEdgeInsets) -> CGFloat {
        switch self {
        case .leading:
            return insets.left
        case .trailing:
            return -insets.right
        case .top:
            return insets.top
        case .bottom:
            return -insets.bottom
        }
    }
}

enum AutoLayoutAxis {
    case vertical
    case horizontal
    
    var constraintAttribute: NSLayoutConstraint.Attribute {
        switch self {
        case .vertical:
            return .centerX
        case .horizontal:
            return .centerY
        }
    }
}

enum AutoLayoutDimension {
    case width
    case height
    
    var constraintAttribute: NSLayoutConstraint.Attribute {
        switch self {
        case .width:
            return .width
        case .height:
            return .height
        }
    }
}

extension UIView {
    func autoPinEdgesToSuperviewEdges(with insets: UIEdgeInsets = .zero,
                                      excludingEdge: AutoLayoutEdge? = nil) {
        for edge in AutoLayoutEdge.allCases where edge != excludingEdge {
            autoPinEdge(toSuperviewEdge: edge, withInset: edge.inset(from: insets))
        }
    }
    
    @discardableResult
    func autoPinEdge(toSuperviewEdge edge: AutoLayoutEdge,
                     withInset inset: CGFloat = 0.0,
                     relation: NSLayoutConstraint.Relation = .equal,
                     priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        precondition(superview != nil, "Superview must not be nil")
        translatesAutoresizingMaskIntoConstraints = false
        let c = NSLayoutConstraint(item: self,
                                   attribute: edge.constraintAttribute,
                                   relatedBy: relation,
                                   toItem: superview!,
                                   attribute: edge.constraintAttribute,
                                   multiplier: 1,
                                   constant: inset)
        c.priority = priority
        superview!.addConstraint(c)
        return c
    }
    
    func autoCenterInSuperview() {
        autoAlignAxis(toSuperviewAxis: .vertical)
        autoAlignAxis(toSuperviewAxis: .horizontal)
    }
    
    @discardableResult
    func autoAlignAxis(toSuperviewAxis axis: AutoLayoutAxis, withOffset offset: CGFloat = 0.0) -> NSLayoutConstraint {
        precondition(superview != nil, "Superview must not be nil")
        translatesAutoresizingMaskIntoConstraints = false
        let c = NSLayoutConstraint(item: self,
                                   attribute: axis.constraintAttribute,
                                   relatedBy: .equal,
                                   toItem: superview!,
                                   attribute: axis.constraintAttribute,
                                   multiplier: 1.0,
                                   constant: offset)
        superview!.addConstraint(c)
        return c
    }
    
    func autoPinEdges(toEdgesOf view: UIView) {
        AutoLayoutEdge.allCases.forEach {
            autoPinEdge($0, to: $0, of: view)
        }
    }
    
    @discardableResult
    func autoPinEdge(_ edge: AutoLayoutEdge,
                     to otherEdge: AutoLayoutEdge,
                     of view: UIView,
                     withOffset offset: CGFloat = 0.0,
                     multiplier: CGFloat = 1.0) -> NSLayoutConstraint {
        precondition(superview != nil, "Superview must not be nil")
        translatesAutoresizingMaskIntoConstraints = false
        let c = NSLayoutConstraint(item: self,
                                   attribute: edge.constraintAttribute,
                                   relatedBy: .equal,
                                   toItem: view,
                                   attribute: otherEdge.constraintAttribute,
                                   multiplier: multiplier,
                                   constant: offset)
        superview!.addConstraint(c)
        return c
    }
    
    @discardableResult
    func autoMatch(_ dimension: AutoLayoutDimension,
                   to otherDimension: AutoLayoutDimension,
                   of view: UIView,
                   withMultiplier multiplier: CGFloat = 1.0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let c = NSLayoutConstraint(item: self,
                                   attribute: dimension.constraintAttribute,
                                   relatedBy: .equal,
                                   toItem: view,
                                   attribute: otherDimension.constraintAttribute,
                                   multiplier: multiplier,
                                   constant: 0.0)
        addConstraint(c)
        return c
    }
    
    @discardableResult
    func autoSetDimension(_ dimension: AutoLayoutDimension,
                          toSize size: CGFloat) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let c = NSLayoutConstraint(item: self,
                                   attribute: dimension.constraintAttribute,
                                   relatedBy: .equal,
                                   toItem: nil,
                                   attribute: .notAnAttribute,
                                   multiplier: 1.0,
                                   constant: size)
        addConstraint(c)
        return c
    }
}

extension UIView {
    static func nib(name: String? = nil) -> UINib {
        UINib(nibName: name ?? String(describing: self), bundle: Bundle.resource)
    }
}
