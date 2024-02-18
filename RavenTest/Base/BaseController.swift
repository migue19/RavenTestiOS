//
//  BaseController.swift
//  RavenTest
//
//  Created by Miguel Mexicano Herrera on 18/02/24.
//

import UIKit
class BaseController: UIViewController {
    var progress: ProgressView?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    func setupView() {
        progress = ProgressView(inView: self.view)
    }
    func showHUD() {
        progress?.startProgressView()
    }
    func hideHUD() {
        progress?.stopProgressView()
    }
}
