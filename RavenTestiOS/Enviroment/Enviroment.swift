//
//  Enviroment.swift
//  RavenTestiOS
//
//  Created by Miguel Mexicano Herrera on 21/10/25.
//
enum Eviroment {
    case development
    case production
}

var environment: Eviroment = {
    #if DEBUG
    return .development
    #else
    return .production
    #endif
}()

var connectionLayerDebug: Bool {
    #if DEBUG
    return true  // Activa logs detallados en desarrollo
    #else
    return false // Desactiva logs en producción
    #endif
}
