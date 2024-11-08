//
//  TabBarViewController.swift
//  MovieApp
//
//  Created by Karina Piloupas Da Costa on 08/11/24.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        customizeTabBarAppearance()
        
    }
    
    private func setupTabBar() {
            // Configurar a primeira aba
            let vc = ViewController()
            vc.tabBarItem = UITabBarItem(title: "Movies", image: UIImage(systemName: "list.bullet"), tag: 0)

            // Configurar a segunda aba
            let favoritesViewController = FavoritesViewController()
            favoritesViewController.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "suit.heart"), tag: 1)

            // Adicionar as abas ao TabBarController
            viewControllers = [vc, favoritesViewController]
        }
    
    func customizeTabBarAppearance() {
        tabBar.tintColor = .systemRed
        tabBar.unselectedItemTintColor = .lightGray
        tabBar.layer.borderWidth = 0.5
        tabBar.layer.borderColor = UIColor.lightGray.cgColor
        tabBar.backgroundColor = .white
        tabBar.isTranslucent = false
      }

    

}
