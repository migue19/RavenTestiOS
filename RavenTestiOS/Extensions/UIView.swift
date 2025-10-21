//
//  UIView.swift
//  RavenTestiOS
//
//  Created by Miguel Mexicano Herrera on 21/10/25.
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
