//
//  UserTextInputViewController.swift
//  Mes Listes
//
//  Created by Anastasiia Tanczak on 18/08/2018.
//  Copyright © 2018 Ana Viktoriv. All rights reserved.
//

import UIKit

class UserTextInputViewController: UIViewController {
    
    //MARK: - Properties
    let underView = UIView()
    let textFild = UITextField()
    let titleLabel = UILabel()
    let collectionIconView = UICollectionView()
    let moreButton = UIButton()
    let saveButton = UIButton()
    
    //Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }
    
    func prepareView () {
        //underView
        underView.backgroundColor = UIColor.init(red: 115.0, green: 147.0, blue: 167.0, alpha: 1)
        underView.frame = CGRect(x: 10, y: 40, width: self.view.bounds.size.width - 20, height: self.view.bounds.size.height - 80)
        self.view.addSubview(underView)
        
        //textField
        textFild.placeholder = "Type the name of the list" //need to change placeholder if it was called from ItemViewController
        textFild.frame = CGRect(x: 10, y: 40, width: self.view.bounds.size.width - 20, height: 20)
        self.view.addSubview(textFild)
    }

}

extension UserTextInputViewController: UITextFieldDelegate {
    
}

extension UserTextInputViewController: UICollectionViewDelegate {
    
}
