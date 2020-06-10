//
//  UIView+Anchors.swift
//  StoriesApp
//
//  Created by Dmitrii Ziablikov on 10.06.2020.
//  Copyright © 2020 Dimzfresh. All rights reserved.
//

import UIKit

enum RoundType {
    case top
    case right
    case left
    case none
    case bottom
    case both
    case rightTop
    case leftTop
}

extension UIView {
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        if #available(iOS 11.0, *) {
            clipsToBounds = true
            layer.cornerRadius = radius
            layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
        } else {
            layer.mask = nil
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
    }
    
    func round(with type: RoundType, radius: CGFloat = 5.0) {
        var corners: UIRectCorner
        
        switch type {
        case .top:
            corners = [.topLeft, .topRight]
        case .right:
            corners = [.bottomRight, .topRight]
        case .rightTop:
            corners = [.topRight]
        case .leftTop:
            corners = [.topLeft]
        case .left:
            corners = [.bottomLeft, .topLeft]
        case .none:
            corners = []
        case .bottom:
            corners = [.bottomLeft, .bottomRight]
        case .both:
            corners = [.allCorners]
        }
        
        DispatchQueue.main.async {
            self.layer.mask = nil
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
    }
}

// NSLayoutAnchor Helper
extension UIView {
    @discardableResult
    func topAnchor(to anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0) -> Self {
        topAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        return self
    }
    @discardableResult
    func leadingAnchor(to anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> Self {
        leadingAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        return self
    }
    @discardableResult
    func bottomAnchor(to anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0) -> Self {
        bottomAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        return self
    }
    @discardableResult
    func trailingAnchor(to anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> Self {
        trailingAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        return self
    }
    @discardableResult
    func widthAnchor(constant: CGFloat) -> Self {
        widthAnchor.constraint(equalToConstant: constant).isActive = true
        return self
    }
    @discardableResult
    func heightAnchor(constant: CGFloat) -> Self {
        heightAnchor.constraint(equalToConstant: constant).isActive = true
        return self
    }
    @discardableResult
    func dimensionAnchors(width widthConstant: CGFloat, height heightConstant: CGFloat) -> Self {
        widthAnchor.constraint(equalToConstant: widthConstant).isActive = true
        heightAnchor.constraint(equalToConstant: heightConstant).isActive = true
        return self
    }
    @discardableResult
    func dimensionAnchors(size: CGSize) -> Self {
        widthAnchor.constraint(equalToConstant: size.width).isActive = true
        heightAnchor.constraint(equalToConstant: size.height).isActive = true
        return self
    }
    @discardableResult
    func centerYAnchor(to anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0)  -> Self {
        centerYAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        return self
    }
    @discardableResult
    func centerXAnchor(to anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0)  -> Self {
        centerXAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        return self
    }
    
    func activateAnchors() {
        translatesAutoresizingMaskIntoConstraints = false
    }
}
