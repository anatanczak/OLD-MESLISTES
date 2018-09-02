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
    let mainView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 10
        return view
    }()
    
    let underViewForStack: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 200/255.0, green: 199/255.0, blue: 204/255.0, alpha: 0.0)
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
    var collectionView: UICollectionView?
    let saveButton = UIButton()
    let cancelButton = UIButton()
    
    //MARK: - GLOBAL VARIABLES
    var createListe: ((_ liste: Liste)->())?
    let alertViewGrayColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)
    /// property that indicates the icon name to be shown if any icon was selected
    var iconName: String?

    let iconNamesArray = ["airplane-icon", "bag-icon", "book-icon", "clothes-icon", "cooking-icon", "gift-icon", "home-icon", "light-bulb-icon", "shopping-cart-icon", "sport-icon", "star-icon", "todo-icon"]
    var anotherCellWasSelected = false
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupCollectionView()
        setupLayouts()
    }
    
    private func setupViews () {
        
        self.modalPresentationStyle = .overCurrentContext
        self.view.backgroundColor = colorize(hex: 0xB9CDD7).withAlphaComponent(0.8)
        self.view.isOpaque = false
   
        //textField
        textField.attributedPlaceholder = NSAttributedString(string: "name your new list...", attributes: [
            .foregroundColor: colorize(hex: 0x8C8C8C),
            .font: UIFont.systemFont(ofSize: 13.0, weight: .light),
            ])
        textField.setLeftPaddingPoints(10)
        textField.backgroundColor = .white
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = colorize(hex: 0xC8C7CC).cgColor
        
        //save button
        saveButton.setTitle("OK", for: .normal)
        saveButton.backgroundColor = UIColor.clear
        saveButton.setTitleColor(UIColor.black, for: .normal)
//        saveButton.layer.borderWidth = 1.0
        
//        saveButton.layer.borderColor = self.colorize(hex: 0xB9CDD7).cgColor
////
//        let topBorder = CALayer()
//        topBorder.borderColor = UIColor.black.cgColor;
//        topBorder.borderWidth = 10;
//        topBorder.frame = CGRect(x: 0, y: 0, width: saveButton.frame.width, height: 1)
//        saveButton.layer.addSublayer(topBorder)
        
        saveButton.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
        
        
        //cancel button
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(UIColor.black, for: .normal)
        cancelButton.backgroundColor = UIColor.clear
        cancelButton.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        
        [mainView, textField, buttonStackView].forEach { view.addSubview($0) }
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let viewWidth = 40
        
        
        layout.itemSize = CGSize(width: viewWidth, height: viewWidth)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UserTextInputCell.self, forCellWithReuseIdentifier: "UserTextInputCell")
        self.collectionView = collectionView
        view.addSubview(collectionView)
    }
    
    private func setupLayouts () {
  
        mainView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                        leading: view.safeAreaLayoutGuide.leadingAnchor,
                        bottom: nil,
                        trailing: view.safeAreaLayoutGuide.trailingAnchor,
                        padding: .init(top: 200, left: (self.view.bounds.size.width - 270)/2, bottom: 0, right: (self.view.bounds.size.width - 270)/2),
                        size: .init(width: 270, height: 200))
        
        textField.anchor(top: mainView.topAnchor,
                         leading: mainView.leadingAnchor,
                         bottom: nil,
                         trailing: mainView.trailingAnchor,
                         padding: .init(top: 13, left: 16, bottom: 0, right: 16),
                         size: .init(width: 238, height: 24))
        
        collectionView?.anchor(top: textField.bottomAnchor,
                               leading: mainView.leadingAnchor,
                               bottom: nil,
                               trailing: mainView.trailingAnchor,
                               padding: .init(top: 5, left: 12.5, bottom: 1, right: 12.5),
                               size: .init(width: (40*6) + 7 , height: 83) )
        
        buttonStackView.anchor(top: collectionView?.bottomAnchor,
                               leading: mainView.leadingAnchor,
                               bottom: mainView.bottomAnchor,
                               trailing: mainView.trailingAnchor)
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
                createListe!(newListe)
                }
            
            dismiss(animated: true, completion: nil)
        }
    }
        @objc func cancelButtonAction () {
            dismiss(animated: true, completion: nil)
        }
        
        //MARK: - DIFFERENT METHODS
        
        
    }
    
    
    //MARK: - TextFieldDelegate
    extension UserTextInputViewController: UITextFieldDelegate {
        //    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //        textFild.resignFirstResponder()
        //    }
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
            //        let cell = collectionView.cellForItem(at: indexPath)
            //        cell?.contentView.backgroundColor = UIColor.white
        }
        
        
}




//    var keyboardHeight: CGFloat = 0.0
//

//
//    //Life Cycle
//    override func viewWillAppear(_ animated: Bool) {
//                registerForKeyboardDidShowNotification(view: self.view)
//    }

//
//    func prepareView () {

//
//
//        //underView
//        underView.backgroundColor = UIColor.blue
//       // underView.frame = CGRect(x: 0, y: 0, width: 442, height: 301.5)
//        self.view.addSubview(underView)
//
//        //textField
//        textFild.placeholder = "Type the name of the list" //need to change placeholder if it was called from ItemViewController
//        textFild.backgroundColor = colorize(hex: 0xE8ECF1)
//        //textFild.frame = CGRect(x: 119, y: 369, width: 383, height: 46.5)
//        self.view.addSubview(textFild)
//
//        //collectionView
//        collectionIconView.backgroundColor = UIColor.white
//        self.view.addSubview(collectionIconView)
//
//        //saveButton
//        saveButton.setTitle("Save", for: .normal)

//        self.view.addSubview(saveButton)
//    }
//    func prepareLayout () {
//        let standardUnderViewWidth: CGFloat = self.view.bounds.size.width
//        let standardUnderViewHeight: CGFloat = 191.0
//        let iPhone678SreenHeight: CGFloat = 667.0
//        let multiplier: CGFloat = standardUnderViewHeight/iPhone678SreenHeight
//        let underViewHeight = UIScreen.main.bounds.size.height * multiplier
//        let underViewSideOffset = 30.0
//        let underViewtopOffSet = self.view.bounds.size.height - (underViewHeight + keyboardHeight)
//
//        //underView
//        underView.snp.makeConstraints { (make) in
//           make.left.equalToSuperview().offset(underViewSideOffset)
//            make.right.equalToSuperview().offset(-underViewSideOffset)
//            make.bottom.equalToSuperview().offset(-keyboardHeight)
//           // make.top.equalToSuperview().offset(underViewtopOffSet)
//            make.size.equalTo(CGSize(width: standardUnderViewWidth, height: standardUnderViewHeight))
//        }
//    }
//

//

//
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

