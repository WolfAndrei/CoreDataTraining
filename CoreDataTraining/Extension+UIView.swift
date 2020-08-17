//
//  Extension+UIView.swift
//  CoreDataTraining
//
//  Created by Andrei Volkau on 13.08.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit
//@discardableResult
//open func withSize<T: UIView>(_ size: CGSize) -> T {
//    translatesAutoresizingMaskIntoConstraints = false
//    widthAnchor.constraint(equalToConstant: size.width).isActive = true
//    heightAnchor.constraint(equalToConstant: size.height).isActive = true
//    return self as! T
//}
//
//@discardableResult
//open func withHeight(_ height: CGFloat) -> UIView {
//    translatesAutoresizingMaskIntoConstraints = false
//    heightAnchor.constraint(equalToConstant: height).isActive = true
//    return self
//}
//
//@discardableResult
//open func withWidth(_ width: CGFloat) -> UIView {
//    translatesAutoresizingMaskIntoConstraints = false
//    widthAnchor.constraint(equalToConstant: width).isActive = true
//    return self
//}

extension UIView {
    
    @discardableResult
    func withWidth(_ width: CGFloat) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
        return self
    }
    
    func stack(views: [UIView], distribution: UIStackView.Distribution = .fill, alignment: UIStackView.Alignment = .fill, axis: NSLayoutConstraint.Axis, spacing: CGFloat = 0) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.alignment = alignment
        stackView.distribution = distribution
        stackView.axis = axis
        stackView.spacing = spacing
        self.addSubview(stackView)
        stackView.fillSuperview()
        return stackView
    }
    
    @discardableResult
    func hStack(views: UIView..., distribution: UIStackView.Distribution = .fill, alignment: UIStackView.Alignment = .fill, spacing: CGFloat = 0) -> UIStackView {
        return stack(views: views, distribution: distribution, alignment: alignment, axis: .horizontal, spacing: spacing)
    }
    
    @discardableResult
    func vStack(views: UIView..., distribution: UIStackView.Distribution = .fill, alignment: UIStackView.Alignment = .fill, spacing: CGFloat = 0) -> UIStackView {
        return stack(views: views, distribution: distribution, alignment: alignment, axis: .vertical, spacing: spacing)
    }
    
    
    struct AnchoredContraints {
        var top, bottom, leading, trailing, width, height: NSLayoutConstraint?
    }
    
    @discardableResult
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, size: CGSize = .zero, padding: UIEdgeInsets = .zero) -> AnchoredContraints {
        
        var anchoredContraints = AnchoredContraints()
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            anchoredContraints.top = self.topAnchor.constraint(equalTo: top, constant: padding.top)
        }
        if let leading = leading {
            anchoredContraints.leading = self.leadingAnchor.constraint(equalTo: leading, constant: padding.left)
        }
        if let bottom = bottom {
            anchoredContraints.bottom = self.bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom)
        }
        if let trailing = trailing {
            anchoredContraints.trailing = self.trailingAnchor.constraint(equalTo: trailing, constant: -padding.right)
        }
        
        if size.width != 0 {
            anchoredContraints.width = self.widthAnchor.constraint(equalToConstant: size.width)
        }
        if size.height != 0 {
            anchoredContraints.height = self.heightAnchor.constraint(equalToConstant: size.height)
        }
        
        [anchoredContraints.top, anchoredContraints.bottom, anchoredContraints.leading, anchoredContraints.trailing, anchoredContraints.width, anchoredContraints.height].forEach{$0?.isActive = true}
        
        return anchoredContraints
    }
    
    func fillSuperview(padding: UIEdgeInsets = .zero) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let superviewTopAnchor = superview?.topAnchor {
            self.topAnchor.constraint(equalTo: superviewTopAnchor, constant: padding.top).isActive = true
        }
        if let superviewBottomAnchor = superview?.bottomAnchor {
            self.bottomAnchor.constraint(equalTo: superviewBottomAnchor, constant: -padding.bottom).isActive = true
        }
        if let superviewLeadingAnchor = superview?.leadingAnchor {
            self.leadingAnchor.constraint(equalTo: superviewLeadingAnchor, constant: padding.left).isActive = true
        }
        if let superviewTrailingAnchor = superview?.trailingAnchor {
            self.trailingAnchor.constraint(equalTo: superviewTrailingAnchor, constant: -padding.right).isActive = true
        }
    }
    
    
    
    
}

