//
//  UserTextInputViewController.swift
//  Mes Listes
//
//  Created by Anastasiia Tanczak on 18/08/2018.
//  Copyright © 2018 Ana Viktoriv. All rights reserved.
//

import UIKit
import SnapKit

class UserTextInputViewController: UIViewController {
    
    //MARK: - Properties
    let underView = UIView()
    let textFild = UITextField()
    let titleLabel = UILabel()
    let collectionIconView = UICollectionView(frame: CGRect(x: 119, y: 420.5, width: 383, height: 124.5), collectionViewLayout: UICollectionViewFlowLayout.init())
    let moreButton = UIButton()
    let saveButton = UIButton()
    let cancelButton = UIButton()
    var keyboardHeight: CGFloat = 0.0
    
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
        //textFild.becomeFirstResponder()
    }
    
    func prepareView () {
        self.modalPresentationStyle = .overCurrentContext
        self.view.backgroundColor = UIColor.clear
        

        //underView
        underView.backgroundColor = UIColor.blue
        
        underView.frame = CGRect(x: 0, y: 0, width: 442, height: 301.5)
        self.view.addSubview(underView)
        
        //textField
        textFild.placeholder = "Type the name of the list" //need to change placeholder if it was called from ItemViewController
        textFild.backgroundColor = colorize(hex: 0xE8ECF1)
        //textFild.frame = CGRect(x: 119, y: 369, width: 383, height: 46.5)
        self.view.addSubview(textFild)
        
        //collectionView
        collectionIconView.backgroundColor = UIColor.white
        self.view.addSubview(collectionIconView)
        
        //saveButton
        saveButton.setTitle("Save", for: .normal)
        saveButton.backgroundColor = UIColor.blue
        //saveButton.frame = CGRect(x: 89.5, y: self.view.bounds.size.height - (453.5+96), width: 221, height: 20)
        saveButton.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
        self.view.addSubview(saveButton)
    }
    func prepareLayout () {
        let standardUnderViewWidth: CGFloat = self.view.bounds.size.width
        let standardUnderViewHeight: CGFloat = 191.0
        let iPhone678SreenHeight: CGFloat = 667.0
        let multiplier: CGFloat = standardUnderViewHeight/iPhone678SreenHeight
        let underViewHeight = UIScreen.main.bounds.size.height * multiplier
        let underViewSideOffset = 30.0
        //let standardBottomOffSet = 
        
        //underView
        underView.snp.makeConstraints { (make) in
           make.left.equalToSuperview().offset(underViewSideOffset)
            make.right.equalToSuperview().offset(underViewSideOffset)
            make.bottom
        }
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textFild.resignFirstResponder()
    }
}

extension UserTextInputViewController: UICollectionViewDelegate {
    
}
