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
    let backgroundColorView: UIView = UIView()
    
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

    let iconNamesArray = ["todo-icon", "star-icon", "airplane-icon", "shopping-cart-icon", "home-icon", "clothes-icon", "gift-icon", "bag-icon", "light-bulb-icon", "sport-icon", "cooking-icon", "book-icon"]
    
    let roseIconNamesArray = ["todo-icon-rose", "star-icon-rose", "airplane-icon-rose", "shopping-cart-icon-rose", "home-icon-rose", "clothes-icon-rose", "gift-icon-rose", "bag-icon-rose", "light-bulb-icon-rose", "sport-icon-rose", "cooking-icon-rose", "book-icon-rose"]
    
   // var anotherCellWasSelected = false
    
    var selectedIndexPath: IndexPath?

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupCollectionView()
        setupLayouts()

    
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 1) {
            self.backgroundColorView.alpha = 1.0

        }
                    self.textField.becomeFirstResponder()
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
        
        backgroundColorView.backgroundColor = UIColor.black.withAlphaComponent(0.34)
        backgroundColorView.isOpaque = false
        backgroundColorView.alpha = 0.0
        view.addSubview(backgroundColorView)
        
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
        textField.font = UIFont.systemFont(ofSize: 13)
        

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
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        self.collectionView = collectionView
        mainView.addSubview(collectionView)
    }
    
    private func setupLayouts () {
 
        backgroundColorView.snp.makeConstraints { (make) in
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
        collectionView?.snp.makeConstraints({ [weak self]  (make) in
            guard let `self` = self else { return }
            make.top.equalTo(self.textField.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10.0)
            make.centerX.equalToSuperview()
            make.height.equalTo(83)
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
                self.backgroundColorView.alpha = 0.0
            }) { [weak self]  (isComplete) in
                guard let `self` = self else { return }
                self.dismiss(animated: true, completion: nil)
            }
        }else if textField.text == "" && textField.text != nil{
            UIView.animate(withDuration: 2, animations: { [weak self] in
                guard let `self` = self else { return }
                self.textField.backgroundColor = UIColor.init(red: 240/255, green: 214/255, blue: 226/255, alpha: 1)
                self.view.layoutIfNeeded()
            })
            
            UIView.animate(withDuration: 2, animations: { [weak self] in
                guard let `self` = self else { return }
                self.textField.backgroundColor = .clear
                self.view.layoutIfNeeded()
            })
            
        }else{
            print("text field is nill")
        }
    }
    
    @objc func cancelButtonAction () {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let `self` = self else { return }
            self.backgroundColorView.alpha = 0.0
        }) { [weak self]  (isComplete) in
            guard let `self` = self else { return }
            self.dismiss(animated: true, completion: nil)
        }
    }

    
        //MARK: - DIFFERENT METHODS
@objc func keyboardWillShow(notification: Notification) {
    
    let keyboardSize = (notification.userInfo?  [UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
    var distanceToMove = (self.view.bounds.height/2) + 100
    if let keyboardHeight = keyboardSize?.height {
        distanceToMove = (self.view.bounds.height - keyboardHeight) - (self.mainView.bounds.height + 50)
    }
    
    UIView.animate(withDuration: 0.3) { [weak self] in
        guard let `self` = self else { return }
        self.mainView.snp.updateConstraints({ (make) in
            make.top.equalToSuperview().offset(distanceToMove)
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
}

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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        let image = UIImage (named: iconNamesArray[indexPath.row])
       // cell.fillWith(model: image!)
        //cell.backgroundColor = UIColor(patternImage: image!)
        cell.layer.contents = UIImage(named: iconNamesArray[indexPath.row])?.cgImage
        cell.contentMode = .scaleAspectFit
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let unwrappedSelectedIndexPath = selectedIndexPath {
 
            //let image = UIImage (named: iconNamesArray[unwrappedSelectedIndexPath.row])
            
            let cellToUnselect = collectionView.cellForItem(at: unwrappedSelectedIndexPath)
            
            //cellToUnselect?.contentView.backgroundColor = UIColor(patternImage: image!)
            cellToUnselect?.layer.contents = UIImage (named: iconNamesArray[unwrappedSelectedIndexPath.row])?.cgImage
            cellToUnselect?.contentMode = .scaleAspectFit
        }
        
        //let roseImage = UIImage(named: roseIconNamesArray[indexPath.row])
        let cell = collectionView.cellForItem(at: indexPath)
       
        cell?.layer.contents = UIImage(named: roseIconNamesArray[indexPath.row])?.cgImage
        cell?.contentMode = .scaleAspectFit
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


