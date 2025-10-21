//
//  BaseProtocols.swift
//  RavenTestiOS
//
//  Created by Miguel Mexicano Herrera on 21/10/25.
//
import SwiftMessages
/// Protocolo general para las vistas.
protocol GeneralView {
    /// Función para mostrar un mensaje en una alerta.
    /// - Parameter message: Cadena con el mensaje a mostrarse en la alerta.
    func showMessage(message: String, type: Theme)
    func showHUD()
    func hideHUD()
}
extension GeneralView {
    func showMessage(message: String) {
    }
}
protocol GeneralInteractor {
    func receiveError(message: String)
}
protocol GeneralPresenter {
    func sendErrorMessage(message: String)
}
