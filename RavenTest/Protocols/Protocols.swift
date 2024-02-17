//
//  Protocols.swift
//  RavenTest
//
//  Created by Miguel Mexicano Herrera on 16/02/24.
//
import Foundation
protocol CreateView {
    func setupView()
    func addSubviews()
    func setupConstraints()
}
extension CreateView {
    func showHUD() {}
    func hideHUD() {}
}
protocol GeneralView {
    func showHUD()
    func hideHUD()
}

