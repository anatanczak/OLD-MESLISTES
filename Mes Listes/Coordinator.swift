//
//  Coordinator.swift
//  Mes Listes
//
//  Created by Anastasiia Tanczak on 17/08/2018.
//  Copyright © 2018 Ana Viktoriv. All rights reserved.
//

import Foundation
import UIKit

class Coordinator: NSObject {
    
    var window: UIWindow!
    
    init(window: UIWindow) {
        super.init()
        self.window = window
        
        setup()
    }
    
    func setup() {
        
        setupCurrentFlow()
        
//        var isUserAuth = true
//
//        isUserAuth = false
//
//        if isUserAuth {
//            setupAuthFlow()
//        } else {
//            setupCurrentFlow()
//        }
    }
    
//    private func setupAuthFlow() {
//        let window = self.window
//        
//        let loginVC = UIViewController() //LoginViewController()
//        let navController = UINavigationController(rootViewController: loginVC)
//        window!.rootViewController = navController
//        window!.makeKeyAndVisible()
//    }
    
    private func setupCurrentFlow() {
        let window = self.window
        
        /*
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
         if let viewController = storyboard.instantiateViewController(withIdentifier: "BookingDetailsViewController") as? BookingDetailsViewController {
         }*/
        
        let currentVC = ListViewController()
        let navController = UINavigationController(rootViewController: currentVC)
        window!.rootViewController = navController
        window!.makeKeyAndVisible()
        
        //does it make navigationbar clear?
        navController.view.backgroundColor = UIColor.clear
    }
}
