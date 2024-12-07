//
//  TabBarController.swift
//  App
//
//  Created by Jinyoung Yoo on 11/26/24.
//

import UIKit

import Then

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTabBarController()
        self.configureTabBar()
    }

    private func configureTabBarController() {
        self.tabBar.backgroundColor = .white
        
        self.viewControllers = Tab.allCases.map {
            let (title, image, selectedImage) = $0.itemResource
            
            return NavigationController(rootViewController: $0.viewController).then {
                $0.tabBarItem = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
            }
        }
    }
    
    private func configureTabBar() {
        let apearance = UITabBarAppearance()
        
        apearance.configureWithOpaqueBackground()
        self.tabBar.standardAppearance = apearance
        self.tabBar.scrollEdgeAppearance = apearance
        self.tabBar.tintColor = .brandMainTheme
        self.tabBar.unselectedItemTintColor = .textSecondary
    }
}


extension TabBarController {
    typealias TabItemResource = (title: String, image: UIImage?, selectedImage: UIImage?)
    
    enum Tab: CaseIterable {
        case home
        case dm
        case setting
        
        var viewController: UIViewController {
            switch self {
            case .home:
                return WorkspaceViewController()
            case .dm:
                return DMListViewController()
            case .setting:
                return ViewController()
            }
        }
        
        var itemResource: TabItemResource {
            switch self {
            case .home:
                return (title: "홈", image: UIImage.homeIcon, selectedImage: UIImage.homeFillIcon)
            case .dm:
                return (title: "DM", image: UIImage.dmIcon, selectedImage: UIImage.dmFillIcon)
            case .setting:
                return (title: "설정", image: UIImage.settingIcon, selectedImage: UIImage.settingFillIcon)
            }
        }
    }
}

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .bgPrimary
    }
}
