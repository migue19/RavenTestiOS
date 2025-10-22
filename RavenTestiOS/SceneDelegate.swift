//
//  SceneDelegate.swift
//  RavenTestiOS
//
//  Created by Miguel Mexicano Herrera on 21/10/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let windows = UIWindow(windowScene: windowScene)
        
        // Si estamos ejecutando tests unitarios, evitar inicializaciones que toquen UI o servicios globales
        let isRunningTests = ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
        if !isRunningTests {
            // Inicializar Core Data
            setupCoreData()
            // Inicializar Network Monitor
            NetworkMonitor.shared.startMonitoring()
        } else {
            print("ℹ️ SceneDelegate: running under tests — skipping runtime initializations")
        }
        
        let rootViewController = HomeRouter.createHomeModule()
        let navigationController = UINavigationController(rootViewController: rootViewController)
        //let rootViewController = Constants.createTabBar()
        windows.rootViewController = navigationController
        windows.makeKeyAndVisible()
        self.window = windows
    }
    
    // MARK: - Core Data Setup
    private func setupCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        // Asegurarse de que el persistent container esté cargado
        _ = appDelegate.persistentContainer
        
        // Verificar que Core Data esté funcionando correctamente
        CoreDataManager.shared.hasCachedArticles { hasCache in
            if hasCache {
                print("✅ Core Data inicializado - Se encontraron artículos en cache")
            } else {
                print("ℹ️ Core Data inicializado - No hay artículos en cache")
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}
