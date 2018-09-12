//
//  TextInputForItemVC.swift
//  Mes Listes
//
//  Created by Anastasiia Tanczak on 11/09/2018.
//  Copyright © 2018 Ana Viktoriv. All rights reserved.
//

import UIKit

class TextInputForItemVC: UIViewController {
    
    //MARK: - Properties
    var createItem: ((_ item: Item)->())?
    
    let backgroundColorView = UIView()
    let mainView = UIView()
    let oKButton = UIButton()
    let cancelButton = UIButton()
    let textField = UITextField()
    
    var yConstraintNoKeyboard: NSLayoutConstraint?
    var yConstraintWithKeyboard: NSLayoutConstraint?
    
    let alertViewGrayColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)
    
    lazy var buttonStackView: UIStackView  = {
        let stackView = UIStackView(arrangedSubviews: [cancelButton,
                                                       oKButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        return stackView
    }()
    
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayout()
        
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cancelButton.addBorder(side: .Top, color: alertViewGrayColor, width: 1)
        cancelButton.addBorder(side: .Right, color: alertViewGrayColor, width: 0.5)
        oKButton.addBorder(side: .Top, color: alertViewGrayColor, width: 1)
        oKButton.addBorder(side: .Left, color: alertViewGrayColor, width: 0.5)
    }
    
    private func setupViews () {
        
        backgroundColorView.backgroundColor = UIColor.black.withAlphaComponent(0.34)
        backgroundColorView.isOpaque = false
        backgroundColorView.alpha = 0.0
        view.addSubview(backgroundColorView)
        
        mainView.backgroundColor = .white
        mainView.layer.cornerRadius = 13
        
        //textField
        textField.delegate = self
        textField.attributedPlaceholder = NSAttributedString(string: "name your new item...", attributes: [
            .foregroundColor: colorize(hex: 0x8C8C8C),
            .font: UIFont.systemFont(ofSize: 13.0, weight: .light),
            ])
        textField.setLeftPaddingPoints(10)
        textField.backgroundColor = .clear
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = colorize(hex: 0xC8C7CC).cgColor
        textField.font = UIFont.systemFont(ofSize: 13)
        
        //save button
        oKButton.setTitle("OK", for: .normal)
        oKButton.backgroundColor = UIColor.clear
        oKButton.setTitleColor(UIColor.black, for: .normal)
        oKButton.addTarget(self, action: #selector(oKButtonAction), for: .touchUpInside)
        
        
        //cancel button
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(UIColor.black, for: .normal)
        cancelButton.backgroundColor = UIColor.clear
        cancelButton.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        
        
        [mainView, buttonStackView, textField].forEach { view.addSubview($0)}
    }
    
    private func setupLayout () {
        backgroundColorView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalToSuperview()
        }
        
        mainView.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        yConstraintNoKeyboard = mainView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        yConstraintNoKeyboard?.priority = UILayoutPriority(999)
        yConstraintWithKeyboard = mainView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100)
        yConstraintWithKeyboard?.priority = UILayoutPriority(999)
        
        NSLayoutConstraint.activate([
            mainView.widthAnchor.constraint(equalToConstant: 270),
            mainView.heightAnchor.constraint(equalToConstant: 104),
            mainView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            yConstraintNoKeyboard!,
            
            textField.widthAnchor.constraint(equalToConstant: 238),
            textField.heightAnchor.constraint(equalToConstant: 24),
            textField.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            textField.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 17.5),
            
            buttonStackView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 17.5),
            buttonStackView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
            buttonStackView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor)
            ])
    }
    
    //MARK: - ACTIONS
    @objc func cancelButtonAction () {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let `self` = self else { return }
            self.backgroundColorView.alpha = 0.0
        }) { [weak self]  (isComplete) in
            guard let `self` = self else { return }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func oKButtonAction () {
        if textField.text != "" && textField.text != nil {
            let newItem = Item()
            newItem.title = textField.text!

            createItem!(newItem)
            
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
    //MARK: - Different methods
    @objc func keyboardWillShow(notification: Notification) {
        
        let keyboardSize = (notification.userInfo?  [UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
//        var distanceToMove = (self.view.bounds.height/2) + 100
//        if let keyboardHeight = keyboardSize?.height {
//            distanceToMove = (self.view.bounds.height - keyboardHeight) - (self.mainView.bounds.height + 50)
//        }
        self.yConstraintNoKeyboard?.isActive = false
        self.yConstraintWithKeyboard?.isActive = true
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let `self` = self else { return }

            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: Notification){
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let `self` = self else { return }
            self.yConstraintNoKeyboard?.isActive = true
            self.yConstraintWithKeyboard?.isActive = false
//            self.mainView.snp.updateConstraints({ (make) in
//                make.top.equalToSuperview().offset(self.view.bounds.height/2 - 100)
//            })
            self.view.layoutIfNeeded()
        }
    }
}

//MARK: - TextFieldDelegate
extension TextInputForItemVC: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    func textFieldDidBeginEditing (_ textField: UITextField) {
//        UIView.animate(withDuration: 0.3) {
//            [weak self] in
//            guard let `self` = self else { return }
//
//
//            self.view.layoutIfNeeded()
//
//        }
    }
    }