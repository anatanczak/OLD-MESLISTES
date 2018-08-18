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
    //let collectionIconView = UICollectionView()
    let moreButton = UIButton()
    let saveButton = UIButton()
    let cancelButton = UIButton()
    
    var createListe: ((_ liste: Liste)->())?
//    var addIconNameToListe: ((_ iconName: String) ->())?
//    var createItem: ((_ itemTitle: String)->())?
//    var addIconNameToItem: ((_ iconName: String) ->())?
    
    /// property that indicates which controller opens the userInputController
    var isList = false
    
    ///
    var iconName: String?
    
    //Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()

    }
    
    func prepareView () {
        
        self.modalPresentationStyle = .overCurrentContext
        self.view.backgroundColor = UIColor.clear
        //underView
        underView.backgroundColor = colorize(hex: 0x7393a7)
        
        underView.frame = CGRect(x: 20, y: 80, width: self.view.bounds.size.width - 40, height: self.view.bounds.size.height - 160)
        self.view.addSubview(underView)
        
        //textField
        textFild.placeholder = "Type the name of the list" //need to change placeholder if it was called from ItemViewController
        textFild.backgroundColor = UIColor.white
        textFild.frame = CGRect(x: 30, y: 85, width: self.view.bounds.size.width - 60, height: 30)
        self.view.addSubview(textFild)
        
        //saveButton
        saveButton.setTitle("Save", for: .normal)
        saveButton.backgroundColor = UIColor.blue
        saveButton.frame = CGRect(x: self.view.bounds.size.width/2, y: self.view.bounds.size.height - 100, width: self.view.bounds.size.width/2 - 30, height: 20)
        saveButton.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
        self.view.addSubview(saveButton)
    }
    
    @objc func saveButtonAction () {
        if textFild.text != "" && textFild.text != nil {
            if isList {
                let newListe = Liste()
                newListe.name = textFild.text!
                if let iconNameLocal = iconName {
                    newListe.iconName = iconNameLocal
                }
                createListe!(newListe)
            }else{
//                createItem!(textFild.text!)
//                if let iconNameLocal = iconName {
//                    addIconNameToItem!(iconNameLocal)
//                }
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - DIFFERENT METHODS
    func colorize (hex: Int, alpha: Double = 1.0) -> UIColor {
        let red = Double((hex & 0xFF0000) >> 16) / 255.0
        let green = Double((hex & 0xFF00) >> 8) / 255.0
        let blue = Double((hex & 0xFF)) / 255.0
        let color: UIColor = UIColor( red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha:CGFloat(alpha) )
        return color
    }
}

extension UserTextInputViewController: UITextFieldDelegate {
    
}

extension UserTextInputViewController: UICollectionViewDelegate {
    
}
