//
//  ItemTableViewController.swift
//  Mes Listes
//
//  Created by Anastasiia Tanczak on 24/06/2018.
//  Copyright © 2018 Ana Viktoriv. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications
import EventKit
import Foundation
import SwipeCellKit

class ItemTableViewController: UIViewController {
    
    //MARK: - Properties
    let textField = UITextField()
    let tableView = UITableView()
    
    /// This property is used to enable or disable swipe action
    var isSwipeRightEnabled = true
    
    
    var items : Results <Item>?
    var itemsArray: [Item] = []
    
    var selectedItem = 0
    var nameOfTheSelectedListe = ""
    var selectedItemForTheCalendar = ""
    //let realm = RealmManager.shared.getRealm()
    
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareNavigationBar()
        prepareView()
    }

    /* How does this function work? Where's the instance declaration of this class? */
    func prepareNavigationBar () {
        
        //!!! Need to change the title to the name of the list (e.g. shopping list etc.)
        let title = "Item"
        self.title = title
        let rightNavigationButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(rightButtonAction))
        self.navigationItem.setRightBarButton(rightNavigationButton, animated: false)
    }
    
    @objc func rightButtonAction() {
      
        /* LOGIC FOR SAVE ITEM OBJECT */
        if let text = self.textField.text, text != "" {
            RealmManager.shared.createItem(title: text)
            self.itemsArray = RealmManager.shared.getAllItems()
            self.tableView.reloadData()
        }    
    }
    
    
    func showDatePicker() {
        let dateController = DatePickerPopupViewController()
        dateController.modalPresentationStyle = .overCurrentContext
        
        self.present(dateController, animated: true, completion: nil)
        self.navigationController?.show(dateController, sender: self)
    }
    
    
    func prepareView () {
        
        let statusBarHeight: CGFloat = 20.0
        let navigationBarHeight = (self.navigationController?.navigationBar.frame.height)!
        
        let textFieldHeight: CGFloat = 40.0
        let textFieldWidth = self.view.bounds.width - (20 + 20)
        let textFieldY = statusBarHeight + navigationBarHeight
        
        let tableViewHeight = self.view.bounds.size.height - statusBarHeight - navigationBarHeight - textFieldHeight
        let tableViewY = textFieldY + textFieldHeight
        
        //textField
        textField.delegate = self
        textField.placeholder = "Add a new item to your list"
        textField.frame = CGRect(x: 20, y: textFieldY, width: textFieldWidth, height: textFieldHeight)
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.gray.cgColor
        //???
        textField.layer.masksToBounds = true
        
        //tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ItemTVC.self, forCellReuseIdentifier: "ItemTVC")
        tableView.backgroundColor = UIColor.blue
        tableView.frame = CGRect(x: 0, y:tableViewY , width: self.view.bounds.size.width, height: tableViewHeight)
        
        self.view.addSubview(textField)
        self.view.addSubview(tableView)
    }
}


extension ItemTableViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
//MARK: - Table View DataSource and Delegate
extension ItemTableViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTVC", for: indexPath) as! ItemTVC
        cell.itemDelegate = self
        return cell
        
//        if let item = items?[indexPath.row] {
//
//            if item.done == true {
//                let attributedString = NSMutableAttributedString.init(string: item.title)
//                attributedString.addAttribute(.strikethroughStyle, value: 2, range: NSRange.init(location: 0, length: item.title.count))
//                attributedString.addAttribute(.foregroundColor, value: UIColor.lightGray , range: NSRange.init(location: 0, length: item.title.count))
//                cell.textLabel?.attributedText = attributedString
//
//            } else {
//                let attributedString = NSMutableAttributedString.init(string: item.title)
//                attributedString.addAttribute(.strikethroughStyle, value: 0, range: NSRange.init(location: 0, length: item.title.count))
//                cell.textLabel?.attributedText = attributedString
//            }
//        } else {
//            cell.textLabel?.text = "You haven't created an item yet"
//        }
//
        // cell.backgroundColor = colorize(hex: 0xD1C5CA)
        

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let noteVC = NoteViewController()
        self.navigationController?.pushViewController(noteVC, animated: true)
    }
}
extension ItemTableViewController: ItemTVCDelegate {
    
    func cellDidTapOnNoteButton() {
        print(":--> Button was pressed in ItemViewController")
    }
    
    
}


