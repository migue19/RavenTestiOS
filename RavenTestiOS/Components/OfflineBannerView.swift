//
//  OfflineBannerView.swift
//  RavenTestiOS
//
//  Created by Miguel Mexicano Herrera on 21/10/25.
//

import UIKit

final class OfflineBannerView: UIView {
    
    // MARK: - Properties
    private var heightConstraint: NSLayoutConstraint?
    
    // MARK: - UI Components
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemOrange
        return view
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "📵 Sin conexión - Mostrando datos guardados"
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(containerView)
        containerView.addSubview(messageLabel)
        
        // Crear constraint de altura inicial en 0
        heightConstraint = heightAnchor.constraint(equalToConstant: 0)
        heightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            messageLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            messageLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8)
        ])
    }
    
    // MARK: - Public Methods
    
    /// Muestra el banner con animación
    func show(animated: Bool = true) {
        let duration = animated ? 0.3 : 0.0
        UIView.animate(withDuration: duration) {
            self.heightConstraint?.constant = 40
            self.superview?.layoutIfNeeded()
        }
    }
    
    /// Oculta el banner con animación
    func hide(animated: Bool = true) {
        let duration = animated ? 0.3 : 0.0
        UIView.animate(withDuration: duration) {
            self.heightConstraint?.constant = 0
            self.superview?.layoutIfNeeded()
        }
    }
    
    /// Actualiza el mensaje del banner
    /// - Parameter message: El nuevo mensaje a mostrar
    func setMessage(_ message: String) {
        messageLabel.text = message
    }
    
    /// Actualiza el color de fondo del banner
    /// - Parameter color: El nuevo color de fondo
    func setBackgroundColor(_ color: UIColor) {
        containerView.backgroundColor = color
    }
    
    /// Actualiza el estado del banner basado en la conectividad
    /// - Parameter isConnected: true si hay conexión, false si no
    func updateConnectivityStatus(isConnected: Bool) {
        if isConnected {
            hide()
        } else {
            show()
        }
    }
}
