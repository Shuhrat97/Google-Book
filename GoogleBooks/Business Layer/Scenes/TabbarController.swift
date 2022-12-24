//
//  TabbarController.swift
//  GoogleBooks
//
//  Created by Shuhrat Nurov on 24/12/22.
//

import UIKit

class TabbarController: UITabBarController {
    
    override func viewDidLoad(){
        super.viewDidLoad()
        setupVCs()
    }
    
    func setupVCs() {
        viewControllers = [
            createNavControllers(for: SearchViewController(), title: "Поиск", image: UIImage(systemName: "magnifyingglass")),
            createNavControllers(for: FavoriteBooksViewController(), title: "Избранное", image: UIImage(systemName: "heart.fill"))
        ]
    }
    
    fileprivate func createNavControllers(for rootViewController:UIViewController, title:String, image:UIImage?)->UIViewController{
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        rootViewController.navigationItem.title = title
        return navController
    }
}
