//
//  UITableView.swift
//  RavenTestiOS
//
//  Created by Miguel Mexicano Herrera on 21/10/25.
//
import UIKit
extension UITableView {
    /// Register a cell that conforms the ReusableView protocol
    /// - Parameter _: Class of  the cell to be registered
    func register<T: UITableViewCell>(_: T.Type) where T: ReusableView {
        register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }
    /// Dequeue a cell that conforms the ReusableView protocol
    /// - Parameter indexPath: indexPath of the cell
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
}
