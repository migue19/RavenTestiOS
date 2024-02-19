//
//  BaseController.swift
//  RavenTest
//
//  Created by Miguel Mexicano Herrera on 18/02/24.
//

import UIKit
import SwiftMessages
class BaseController: UIViewController {
    var progress: ProgressView?
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    func initView() {
        progress = ProgressView(inView: self.view)
    }
    func showHUD() {
        progress?.startProgressView()
    }
    func hideHUD() {
        progress?.stopProgressView()
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
}
