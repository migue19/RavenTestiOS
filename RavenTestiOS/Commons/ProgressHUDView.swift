//
//  ProgressHUDView.swift
//  RunSession
//
//  Created by Miguel Mexicano Herrera on 15/09/25.
//
import UIKit
import Lottie

public final class ProgressHUDView: UIView {

    // MARK: - Subviews
    private let blurView: UIVisualEffectView
    private let loader: LottieAnimationView
    private let loaderSize: CGFloat

    // MARK: - Inits
    public convenience init() {
        self.init(animationName: "news-loader", loaderSize: 100, blurStyle: .dark, dimAlpha: 0.2)
    }

    public init(animationName: String = "news-loader",
                loaderSize: CGFloat = 100,
                blurStyle: UIBlurEffect.Style = .dark,
                dimAlpha: CGFloat = 0.2) {
        self.blurView = UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
        self.loader = LottieAnimationView(name: animationName)
        self.loaderSize = loaderSize
        super.init(frame: .zero)
        commonInit(dimAlpha: dimAlpha)
    }

    required init?(coder: NSCoder) {
        self.blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        self.loader = LottieAnimationView(name: "loader-run")
        self.loaderSize = 100
        super.init(coder: coder)
        commonInit(dimAlpha: 0.2)
    }

    private func commonInit(dimAlpha: CGFloat) {
        isUserInteractionEnabled = true // bloquea toques detrás
        accessibilityLabel = "Cargando…"
        accessibilityTraits = .updatesFrequently
        backgroundColor = .clear
        alpha = 0.0
        translatesAutoresizingMaskIntoConstraints = false

        // Blur + tinte leve para oscurecer
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.backgroundColor = UIColor.black.withAlphaComponent(dimAlpha)
        blurView.isUserInteractionEnabled = true
        addSubview(blurView)

        NSLayoutConstraint.activate([
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        // Loader Lottie
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.contentMode = .scaleAspectFit
        loader.loopMode = .loop
        loader.animationSpeed = 1.0
        blurView.contentView.addSubview(loader)

        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: blurView.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: blurView.centerYAnchor),
            loader.widthAnchor.constraint(equalToConstant: loaderSize),
            loader.heightAnchor.constraint(equalToConstant: loaderSize)
        ])
    }

    // MARK: - Public API

    /// Muestra el HUD cubriendo completamente `view`.
    public func present(on view: UIView, animated: Bool = true) {
        if !Thread.isMainThread {
            DispatchQueue.main.async { [weak self] in self?.present(on: view, animated: animated) }
            return
        }

        if superview == nil {
            view.addSubview(self)
            NSLayoutConstraint.activate([
                leadingAnchor.constraint(equalTo: view.leadingAnchor),
                trailingAnchor.constraint(equalTo: view.trailingAnchor),
                topAnchor.constraint(equalTo: view.topAnchor),
                bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
            layoutIfNeeded()
        }

        if animated {
            if alpha < 1 {
                alpha = 0
                UIView.animate(withDuration: 0.2) { self.alpha = 1.0 }
            }
        } else {
            alpha = 1.0
        }

        if !loader.isAnimationPlaying {
            loader.play()
        }
    }

    /// Oculta y remueve el HUD de su supervista.
    public func dismiss(animated: Bool = true) {
        if !Thread.isMainThread {
            DispatchQueue.main.async { [weak self] in self?.dismiss(animated: animated) }
            return
        }

        let teardown = {
            self.loader.stop()
            self.removeFromSuperview()
        }

        if animated {
            UIView.animate(withDuration: 0.25, animations: {
                self.alpha = 0.0
            }, completion: { _ in
                teardown()
            })
        } else {
            alpha = 0.0
            teardown()
        }
    }
}
