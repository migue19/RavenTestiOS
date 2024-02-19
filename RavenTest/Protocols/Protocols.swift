//
//  Protocols.swift
//  RavenTest
//
//  Created by Miguel Mexicano Herrera on 16/02/24.
//
import SwiftMessages
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
    /// Función para mostrar un mensaje en una alerta.
    /// - Parameter message: Cadena con el mensaje a mostrarse en la alerta.
    func showMessage(message: String, type: Theme)
}

