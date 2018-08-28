//
//  ViewController.swift
//  Mes Listes
//
//  Created by Anastasiia Tanczak on 20/08/2018.
//  Copyright © 2018 Ana Viktoriv. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func colorize (hex: Int, alpha: Double = 1.0) -> UIColor {
        let red = Double((hex & 0xFF0000) >> 16) / 255.0
        let green = Double((hex & 0xFF00) >> 8) / 255.0
        let blue = Double((hex & 0xFF)) / 255.0
        let color: UIColor = UIColor( red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha:CGFloat(alpha) )
        return color
    }
    
//    func registerForKeyboardDidShowNotification(view: UIView, usingBlock block: ((CGSize?) -> Void)? = nil) {
//        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardDidShow, object: nil, queue: nil, using: { [weak view] (notification) -> Void in
//            guard let `view` = view else { return }
//            
//            let userInfo = notification.userInfo!
//            let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue.size
//            print("-->keyboardSize\(keyboardSize)")
//            block?(keyboardSize)
//        })
//    }
}
