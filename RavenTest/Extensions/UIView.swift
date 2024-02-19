//
//  UIView.swift
//  RavenTest
//
//  Created by Miguel Mexicano Herrera on 18/02/24.
//

import UIKit
public protocol ReusableView: AnyObject {
    /// Represents the reusesable identifier for a cell
    static var reuseIdentifier: String { get }
}
public extension ReusableView where Self: UIView {
    /// Set the reuse identifier to be equal to the class name
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
extension UIView {
    func elevate(elevation: Double) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.shadowColor.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: elevation)
        self.layer.shadowRadius = CGFloat(elevation)
        self.layer.shadowOpacity = 0.5
    }
}
