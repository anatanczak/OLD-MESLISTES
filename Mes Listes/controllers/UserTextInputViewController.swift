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
        let viewWidth = 40

        
        layout.itemSize = CGSize(width: viewWidth, height: viewWidth)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.yellow
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        self.collectionView = collectionView
        view.addSubview(collectionView)
    }
    
    private func setupLayouts () {
        
//        mainView.translatesAutoresizingMaskIntoConstraints = false
//        mainView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        mainView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//        mainView.widthAnchor.constraint(equalToConstant: 270.0).isActive = true
//        mainView.heightAnchor.constraint(equalToConstant: 180.0).isActive = true
        
        mainView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                        leading: view.safeAreaLayoutGuide.leadingAnchor,
                        bottom: nil,
                        trailing: view.safeAreaLayoutGuide.trailingAnchor,
                        padding: .init(top: 200, left: (self.view.bounds.size.width - 270)/2, bottom: 0, right: (self.view.bounds.size.width - 270)/2),
                        size: .init(width: 270, height: 180))
        
        textField.anchor(top: mainView.topAnchor,
                         leading: mainView.leadingAnchor,
                         bottom: nil,
                         trailing: mainView.trailingAnchor,
                         padding: .init(top: 13, left: 16, bottom: 0, right: 16),
                         size: .init(width: 238, height: 24))

        collectionView?.anchor(top: textField.bottomAnchor,
                               leading: mainView.leadingAnchor,
                               bottom: buttonStackView.topAnchor,
                               trailing: mainView.trailingAnchor,
                               padding: .init(top: 5, left: 12.5, bottom: 9, right: 12.5))

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

