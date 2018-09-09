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
}

extension UIViewController {
    
    func processOpeningAndClosingKeyboard(forScrollView scrollView: UIScrollView) {
        registerForKeyboardDidShowNotification(scrollView: scrollView)
        registerForKeyboardWillHideNotification(scrollView: scrollView)
    }
    
    func registerForKeyboardDidShowNotification(scrollView: UIScrollView, usingBlock block: ((CGSize?) -> Void)? = nil) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardDidShow, object: nil, queue: nil, using: { [weak scrollView] (notification) -> Void in
            let userInfo = notification.userInfo
            guard let scrollView = scrollView else { return }
            guard let keyboardSizeUserInfo = userInfo?[UIKeyboardFrameEndUserInfoKey] else {
                block?(nil)
                
                return
            }
            
            let keyboardSize = (keyboardSizeUserInfo as AnyObject).cgRectValue.size
            let contentInsets = UIEdgeInsetsMake(scrollView.contentInset.top, scrollView.contentInset.left, keyboardSize.height, scrollView.contentInset.right)
            
            scrollView.setContentInsetAndScrollIndicatorInsets(edgeInsets: contentInsets)
            block?(keyboardSize)
        })
    }
    
    func registerForKeyboardWillHideNotification(scrollView: UIScrollView, usingBlock block: (() -> Void)? = nil) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: nil, using: {  [weak scrollView] (notification) -> Void in
            guard let scrollView = scrollView else { return }
            let contentInsets = UIEdgeInsetsMake(scrollView.contentInset.top, scrollView.contentInset.left, 0, scrollView.contentInset.right)
            scrollView.setContentInsetAndScrollIndicatorInsets(edgeInsets: contentInsets)
            block?()
        })
    }
}
