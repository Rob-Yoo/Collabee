//
//  SceneDelegate.swift
//  App
//
//  Created by Jinyoung Yoo on 11/1/24.
//

import UIKit

import Authorization
import WorkSpace
import DataSource
import Common

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    @Injected private var authUseCase: AuthUseCase
    @Injected private var workspaceRepository: WorkspaceRepository

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        NotificationCenter.default.addObserver(self, selector: #selector(connectWindowScene), name: .ChangeWindowScene, object: nil)
        connectWindowScene()
    }
    
    @objc @MainActor
    private func connectWindowScene() {
        let isAuthorized = UserDefaultsStorage.isAuthorized
        let workspaceVC = workspaceRepository.getWorkspaceID() == nil ? EmptyWorkspaceViewController() : WorkspaceViewController()
        let rootVC = isAuthorized ? UINavigationController(rootViewController: workspaceVC) : UINavigationController(rootViewController: OnboardingViewController(useCase: authUseCase))
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            authUseCase.handleOpenURL(url)
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
    }


}

