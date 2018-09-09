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
    let beckgroundColorView: UIView = UIView()
    
    let mainView: UIView = {
        let view = UIView()
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
    
    var selectedIndexPath: IndexPath?

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //textField.becomeFirstResponder()
        setupViews()
        setupCollectionView()
        setupLayouts()

    
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {

//        let keyboardSize = (notification.userInfo?  [UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
//       var distanceToMove = (self.view.bounds.height/2) + 100
//        if let keyboardHeight = keyboardSize?.height {
//        distanceToMove = (self.view.bounds.height - keyboardHeight) - 50
//        }
//        if #available(iOS 11.0, *){
//
//        }
//        else {
//            //????
//        }
//        yConstraintWithKeyBoard.isActive = true
//
//        yConstraintNoKeyBoard.isActive = false
//
//        UIView.animate(withDuration: 0.5){
//            self.view.layoutIfNeeded()
//        }
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let `self` = self else { return }
            self.mainView.snp.updateConstraints({ (make) in
                make.top.equalToSuperview().offset(100)
            })
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: Notification){

        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let `self` = self else { return }
            self.mainView.snp.updateConstraints({ (make) in
                make.top.equalToSuperview().offset(self.view.bounds.height/2 - 100)
            })
            self.view.layoutIfNeeded()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3) {
            self.beckgroundColorView.alpha = 1.0
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //setupLayouts()
    }
    
    private func setupViews () {
        
        //modalPresentationStyle = .overCurrentContext

        //scrollView.isScrollEnabled = false
        //self.processOpeningAndClosingKeyboard(forScrollView: scrollView)
        
        beckgroundColorView.backgroundColor = UIColor.black.withAlphaComponent(0.34)
        beckgroundColorView.isOpaque = false
        beckgroundColorView.alpha = 0.0
        view.addSubview(beckgroundColorView)
        
        //mainview
        view.addSubview(mainView)
        
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
        mainView.addSubview(collectionView)
    }
    
    private func setupLayouts () {
        /*
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        mainView.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        subViewForCollectionView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        //mainView Yconstraints
        yConstraintNoKeyBoard = mainView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
        yConstraintNoKeyBoard.priority = UILayoutPriority(999)
        
        yConstraintWithKeyBoard = mainView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor, constant: -100)
        yConstraintWithKeyBoard.priority = UILayoutPriority(999)


        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        scrollView.snp.makeConstraints { (make) in
//            make.left.top.right.bottom.equalToSuperview()
//        }
        mainView.widthAnchor.constraint(equalToConstant: 270).isActive = true
        mainView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        mainView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        yConstraintNoKeyBoard.isActive = true
        
        //text field width 238, height 24, centeredX, 13 from top
        textField.widthAnchor.constraint(equalToConstant: 238).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 24).isActive = true
        textField.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        textField.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 16).isActive = true
        
        //subView width, height , centerX , 8,5 from top
        subViewForCollectionView.widthAnchor.constraint(equalToConstant: 250).isActive = true
        subViewForCollectionView.heightAnchor.constraint(equalToConstant: 83).isActive = true
        subViewForCollectionView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        subViewForCollectionView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 10).isActive = true
        
        //buttonStackView top subViewForColle- 8,5, bottom  trailing and leading to mainView
        buttonStackView.topAnchor.constraint(equalTo: subViewForCollectionView.bottomAnchor, constant: 10).isActive = true
        buttonStackView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor).isActive = true
        buttonStackView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor).isActive = true
        buttonStackView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor).isActive = true

        if let localCollectionView = collectionView {
            localCollectionView.translatesAutoresizingMaskIntoConstraints = false
            localCollectionView.topAnchor.constraint(equalTo: subViewForCollectionView.topAnchor).isActive = true
            localCollectionView.bottomAnchor.constraint(equalTo: subViewForCollectionView.bottomAnchor).isActive = true
            localCollectionView.leadingAnchor.constraint(equalTo: subViewForCollectionView.leadingAnchor).isActive = true
            localCollectionView.trailingAnchor.constraint(equalTo: subViewForCollectionView.trailingAnchor).isActive = true
        }*/
        beckgroundColorView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalToSuperview()
        }
        mainView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(self.view.bounds.height/2 - 100)
            make.centerX.equalToSuperview()
            //make.size.equalTo(CGSize(width: 270, height: 200))
        }
        textField.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(16.0)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.width.equalTo(238)
            make.height.equalTo(24)
        }
//        subViewForCollectionView.snp.makeConstraints { [weak self] (make) in
//            guard let `self` = self else { return }
//            make.width.equalTo(250)
//            make.height.equalTo(83)
//            make.top.equalTo(self.textField.snp.bottom).offset(10)
//            make.centerX.equalToSuperview()
//        }
        collectionView?.snp.makeConstraints({ [weak self]  (make) in
            guard let `self` = self else { return }
            make.top.equalTo(self.textField.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10.0)
            make.centerX.equalToSuperview()
            make.height.equalTo(83)
            //make.left.top.right.bottom.equalToSuperview()
        })
        buttonStackView.snp.makeConstraints { [weak self] (make) in
            guard let `self` = self else { return }
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(self.collectionView!.snp.bottom).offset(10)
            make.height.equalTo(44)
        }
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
            
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                guard let `self` = self else { return }
                self.beckgroundColorView.alpha = 0.0
            }) { [weak self]  (isComplete) in
                guard let `self` = self else { return }
                self.dismiss(animated: true, completion: nil)
            }

        }
    }
    
    @objc func cancelButtonAction () {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let `self` = self else { return }
            self.beckgroundColorView.alpha = 0.0
        }) { [weak self]  (isComplete) in
            guard let `self` = self else { return }
            self.dismiss(animated: true, completion: nil)
        }
    }
}
    
        //MARK: - DIFFERENT METHODS

//MARK: - TextFieldDelegate
extension UserTextInputViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    func textFieldDidBeginEditing (_ textField: UITextField) {
        //            print("is working")
        //            yConstraintWithKeyBoard.isActive = true
        //
        //            yConstraintNoKeyBoard.isActive = false
        //
        //            UIView.animate(withDuration: 0.5){
        //                self.view.layoutIfNeeded()
        //            }
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let `self` = self else { return }
            self.mainView.snp.updateConstraints({ (make) in
                make.top.equalToSuperview().offset(100)
            })
            self.view.layoutIfNeeded()
            
        }
    }
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
        
        for cell in collectionView.visibleCells {
            cell.contentView.backgroundColor = UIColor.white
        }
        
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.contentView.backgroundColor = UIColor.darkGray
        selectedIndexPath = indexPath
        iconName = iconNamesArray[indexPath.row]
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


