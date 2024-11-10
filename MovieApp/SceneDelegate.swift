//
//  SceneDelegate.swift
//  MovieApp
//
//  Created by Karina Piloupas Da Costa on 09/11/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    //O AppDelegate é responsável pelo ciclo de vida e configuração do app.
    
    //O SceneDelegate é responsável pelo o que é mostrado na tela, e com ele nós podemos manipular e gerenciar a forma como o app é exibido.
    
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        //Criação da TabBar
        let tabBarController = UITabBarController()
        
        //Tela de Filmes Populares
        let movieGridViewController = MovieGridViewController()
        movieGridViewController.tabBarItem = UITabBarItem(title: "Movies", image: UIImage(systemName: "list.bullet"), tag: 0)
        
        //Tela de Filmes Favoritos
        let favoriteMovieViewController = FavoriteMovieViewController()
        favoriteMovieViewController.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "suit.heart"), tag: 1)
        
        //TabBarController como a controladora das telas
        tabBarController.viewControllers = [movieGridViewController,favoriteMovieViewController]
        
        //Customização da TabBar
        customizeTabBarAppearance(tabBarController)
        
        //Configuração padrao da janela inicial
        window.rootViewController = tabBarController
        self.window = window
        window.makeKeyAndVisible()
    }
    
    // Função para customizar a TabBar
    func customizeTabBarAppearance(_ tabBarController: UITabBarController) {
        tabBarController.tabBar.tintColor = .black
        tabBarController.tabBar.unselectedItemTintColor = .lightGray
        tabBarController.tabBar.layer.borderWidth = 0.5
        tabBarController.tabBar.layer.borderColor = UIColor.lightGray.cgColor
        tabBarController.tabBar.backgroundColor = .white
        tabBarController.tabBar.isTranslucent = false
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}

