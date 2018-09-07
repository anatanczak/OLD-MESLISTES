//
//  UserTextInputViewController.swift
//  Mes Listes
//
//  Created by Anastasiia Tanczak on 18/08/2018.
//  Copyright © 2018 Ana Viktoriv. All rights reserved.
//

import UIKit

class UserTextInputViewController: UIViewController {
    //MARK: - Views
    let mainView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var buttonStackView: UIStackView  = {
        let stackView = UIStackView(arrangedSubviews: [cancelButton,
                                                        saveButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        return stackView
    }()

    let textField = UITextField()
    let subViewForCollectionView = UIView()
    var collectionView: UICollectionView?
    let saveButton = UIButton()
    let cancelButton = UIButton()
    
    //MARK: - GLOBAL VARIABLES
    var createListe: ((_ liste: Liste)->())?
    let alertViewGrayColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)
    /// property that indicates the icon name to be shown if any icon was selected
    var iconName: String?

    let iconNamesArray = ["airplane-icon", "bag-icon", "book-icon", "clothes-icon", "cooking-icon", "gift-icon", "home-icon", "light-bulb-icon", "shopping-cart-icon", "sport-icon", "star-icon", "todo-icon"]
   // var anotherCellWasSelected = false
    
    private var yConstraintNoKeyBoard: NSLayoutConstraint!
    private var yConstraintWithKeyBoard: NSLayoutConstraint!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //stextField.becomeFirstResponder()
        setupViews()
        setupCollectionView()
        setupLayouts()

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {

//        let keyboardSize = (notification.userInfo?  [UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
//        var distanceToMove =  (self.view.bounds.height/2) + 50
//        if let keyboardHeight = keyboardSize?.height {
//       //distanceToMove = self.view.bounds.height
//        }
        if #available(iOS 11.0, *){
           
        }
        else {
            //????
        }

        UIView.animate(withDuration: 0.5){
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: Notification){
        //put the view down
        UIView.animate(withDuration: 0.5){
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewWillLayoutSubviews() {
        setupLayouts()
    }
    
    private func setupViews () {
        
        self.modalPresentationStyle = .overCurrentContext
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.34)
        self.view.isOpaque = false
   
        //mainview
        view.addSubview(mainView)
        mainView.isUserInteractionEnabled = true
        //textField
        textField.delegate = self
        textField.attributedPlaceholder = NSAttributedString(string: "name your new list...", attributes: [
            .foregroundColor: colorize(hex: 0x8C8C8C),
            .font: UIFont.systemFont(ofSize: 13.0, weight: .light),
            ])
        textField.setLeftPaddingPoints(10)
        textField.backgroundColor = .clear
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = colorize(hex: 0xC8C7CC).cgColor

        //subViewForCollectionView
        subViewForCollectionView.backgroundColor = .clear
    
        
        //save button
        saveButton.setTitle("OK", for: .normal)
        saveButton.backgroundColor = UIColor.clear
        saveButton.setTitleColor(UIColor.black, for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)


        //cancel button
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(UIColor.black, for: .normal)
        cancelButton.backgroundColor = UIColor.clear
        cancelButton.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)


        [subViewForCollectionView, textField, buttonStackView].forEach { mainView.addSubview($0) }
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let itemWidthHeight = 40


        layout.itemSize = CGSize(width: itemWidthHeight, height: itemWidthHeight)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 1


        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UserTextInputCell.self, forCellWithReuseIdentifier: "UserTextInputCell")
        self.collectionView = collectionView
        subViewForCollectionView.addSubview(collectionView)
    }
    
    private func setupLayouts () {
        
        mainView.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        subViewForCollectionView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        //mainView Yconstraints
        yConstraintNoKeyBoard = mainView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        yConstraintWithKeyBoard = mainView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -200)

        mainView.widthAnchor.constraint(equalToConstant: 270).isActive = true
        mainView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        mainView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        yConstraintWithKeyBoard.isActive = true
        
        //text field width 238, height 24, centeredX, 13 from top
        textField.widthAnchor.constraint(equalToConstant: 238).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 24).isActive = true
        textField.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        textField.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 16).isActive = true
        
        NSLayoutConstraint.activate([


            
            //subView width, height , centerX , 8,5 from top
            subViewForCollectionView.widthAnchor.constraint(equalToConstant: 250),
            subViewForCollectionView.heightAnchor.constraint(equalToConstant: 83),
            subViewForCollectionView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            subViewForCollectionView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 10),
            
            //buttonStackView top subViewForColle- 8,5, bottom  trailing and leading to mainView
            buttonStackView.topAnchor.constraint(equalTo: subViewForCollectionView.bottomAnchor, constant: 10),
            buttonStackView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
            buttonStackView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor)
        ])
        
        if let localCollectionView = collectionView {
            localCollectionView.translatesAutoresizingMaskIntoConstraints = false
            localCollectionView.topAnchor.constraint(equalTo: subViewForCollectionView.topAnchor).isActive = true
            localCollectionView.bottomAnchor.constraint(equalTo: subViewForCollectionView.bottomAnchor).isActive = true
            localCollectionView.leadingAnchor.constraint(equalTo: subViewForCollectionView.leadingAnchor).isActive = true
            localCollectionView.trailingAnchor.constraint(equalTo: subViewForCollectionView.trailingAnchor).isActive = true
        }

    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
        cancelButton.addBorder(side: .Top, color: alertViewGrayColor, width: 1)
        cancelButton.addBorder(side: .Right, color: alertViewGrayColor, width: 0.5)
        saveButton.addBorder(side: .Top, color: alertViewGrayColor, width: 1)
        saveButton.addBorder(side: .Left, color: alertViewGrayColor, width: 0.5)
    }

    //MARK: - Button Actions
    @objc func saveButtonAction () {
        if textField.text != "" && textField.text != nil {
            let newListe = Liste()
            newListe.name = textField.text!
            if let iconNameLocal = iconName {
                newListe.iconName = iconNameLocal
                }
            createListe!(newListe)
            dismiss(animated: true, completion: nil)
        }
    }
        @objc func cancelButtonAction () {
            dismiss(animated: true, completion: nil)

        }

}
    
        //MARK: - DIFFERENT METHODS

    //MARK: - TextFieldDelegate
    extension UserTextInputViewController: UITextFieldDelegate {
//            override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//                textField.resignFirstResponder()
//            }
//        func textFieldDidBeginEditing (_ textField: UITextField) {
//            print("is working")
//
//                mainView.translatesAutoresizingMaskIntoConstraints = false
//                mainView.widthAnchor.constraint(equalToConstant: 270).isActive = true
//                mainView.heightAnchor.constraint(equalToConstant: 200).isActive = true
//                mainView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100)
//mainView.updateConstraints()
//            self.view.layoutIfNeeded()
//        }
    }

    //MARK: - UICollectionViewDelegate and DataSource
    extension UserTextInputViewController: UICollectionViewDelegate, UICollectionViewDataSource {

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 12
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserTextInputCell", for: indexPath) as! UserTextInputCell
            cell.backgroundColor = UIColor.white
            let image = UIImage (named: iconNamesArray[indexPath.row])
            cell.fillWith(model: image!)

            return cell
        }

        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        }

        func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.contentView.backgroundColor = UIColor.darkGray
            iconName = iconNamesArray[indexPath.row]

        }
        func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {

        }


}


//    func registerForKeyboardDidShowNotification(view: UIView, usingBlock block: ((CGSize?) -> Void)? = nil) {
//        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardDidShow, object: nil, queue: nil, using: { [weak view] (notification) -> Void in
//            guard let `view` = view else { return }
//
//            let userInfo = notification.userInfo!
//            let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue.size
//            self.keyboardHeight = keyboardSize.height
//            print("keyboardwill appear")
//            block?(keyboardSize)
//        })
//    }
//

