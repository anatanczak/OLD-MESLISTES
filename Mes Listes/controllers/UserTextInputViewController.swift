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
        return view
    }()

    lazy var buttonStackView: UIStackView  = {
        let stackView = UIStackView(arrangedSubviews: [saveButton,
                                                       cancelButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    let textField = UITextField()
    var collectionView: UICollectionView?
    let saveButton = UIButton()
    let cancelButton = UIButton()
    
    //MARK: - GLOBAL VARIABLES
    var createListe: ((_ liste: Liste)->())?
    
    /// property that indicates which controller opens the userInputController
    var isListe = false
    var iconName: String?
    var placeholderText: String = "name your new list..."
    
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupCollectionView()
        setupLayouts()
    }
    
    private func setupViews () {
        
        self.modalPresentationStyle = .overCurrentContext
        self.view.backgroundColor = UIColor.yellow.withAlphaComponent(0.5)
        self.view.isOpaque = false
        
        //textField
        if isListe == false {
            placeholderText = "name your new item..."
        }
        textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [
            .foregroundColor: UIColor.lightGray,
            .font: UIFont.systemFont(ofSize: 20.0, weight: .light)
            ])
        textField.setLeftPaddingPoints(10)
        textField.backgroundColor = colorize(hex: 0xE8ECF1)

        //save button
        saveButton.setTitle("Save", for: .normal)
        saveButton.backgroundColor = UIColor.blue
        saveButton.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
        //cancel button
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.backgroundColor = UIColor.blue
        cancelButton.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        
        [mainView, textField, buttonStackView].forEach { view.addSubview($0) }
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let viewWidth = (view.bounds.size.width - 80)/6

        
        layout.itemSize = CGSize(width: viewWidth, height: viewWidth)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.yellow
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        self.collectionView = collectionView
        view.addSubview(collectionView)
    }
    
    private func setupLayouts () {
        
        mainView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                        leading: view.safeAreaLayoutGuide.leadingAnchor,
                        bottom: view.safeAreaLayoutGuide.bottomAnchor,
                        trailing: view.safeAreaLayoutGuide.trailingAnchor,
                        padding: .init(top: 100, left: 40, bottom: 300, right: 40) )
        
        textField.anchor(top: mainView.topAnchor,
                         leading: mainView.leadingAnchor,
                         bottom: nil,
                         trailing: mainView.trailingAnchor,
                         padding: .init(top: 10, left: 10, bottom: 0, right: 10))

        collectionView?.anchor(top: textField.bottomAnchor,
                               leading: mainView.leadingAnchor,
                               bottom: buttonStackView.topAnchor,
                               trailing: mainView.trailingAnchor,
                               padding: .init(top: 10, left: 10, bottom: 0, right: 10))

        buttonStackView.anchor(top: collectionView?.bottomAnchor,
                               leading: mainView.leadingAnchor,
                               bottom: mainView.bottomAnchor,
                               trailing: mainView.trailingAnchor,
                               padding: .init(top: 20, left: 10, bottom: 10, right: 10))
    }
    
    //MARK: - Button Actions
    @objc func saveButtonAction () {
        if textField.text != "" && textField.text != nil {
            if isListe {
                let newListe = Liste()
                newListe.name = textField.text!
                if let iconNameLocal = iconName {
                    newListe.iconName = iconNameLocal
                }
                createListe!(newListe)
            }else{

            }
        }
            dismiss(animated: true, completion: nil)
        }
    @objc func cancelButtonAction () {
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


//MARK: - TextFieldDelegate
extension UserTextInputViewController: UITextFieldDelegate {
    //    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    //        textFild.resignFirstResponder()
    //    }
}

//MARK: - UICollectionViewDelegate and DataSource
extension UserTextInputViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor.green
        
        return cell
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

