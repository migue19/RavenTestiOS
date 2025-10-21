//
//  BaseController.swift
//  RavenTestiOS
//
//  Created by Miguel Mexicano Herrera on 21/10/25.
//
import UIKit
import SwiftMessages
class BaseController: UIViewController {
    private lazy var hud = ProgressHUDView()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func showHUD() {
        hud.present(on: view)
    }
    func hideHUD() {
        hud.dismiss()
    }
    /// Función para mostrar un toast
    func showMessage(message: String, type: Theme) {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(type)
        view.button?.isHidden = true
        view.iconImageView?.isHidden = true
        view.titleLabel?.isHidden = true
        view.iconLabel?.isHidden = true
        view.configureDropShadow()
        view.configureContent(body: message)
        view.layoutMarginAdditions = UIEdgeInsets(top: 5, left: 20, bottom: 20, right: 20)
        (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
        let config = getConfigMessage()
        SwiftMessages.show(config: config, view: view)
    }
    /// Función para obteber la configuracion para el mensaje de error.
    func getConfigMessage() -> SwiftMessages.Config {
        var config = SwiftMessages.Config()
        config.presentationStyle = .top
        config.presentationContext = .window(windowLevel: .statusBar)
        config.prefersStatusBarHidden = true
        config.duration = .seconds(seconds: 3.0)
        config.dimMode = .gray(interactive: true)
        config.interactiveHide = false
        config.preferredStatusBarStyle = .lightContent
        return config
    }
    
    @objc func backAction() {
        self.dismiss(animated: true)
    }
}

