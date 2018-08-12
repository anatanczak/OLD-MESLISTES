//
//  ItemViewController.swift
//  segue and swipe
//
//  Created by Anastasiia Tanczak on 16/06/2018.
//  Copyright © 2018 Ana Viktoriv. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications
import EventKit
import SwipeCellKit

class ListViewController: UIViewController {
    
    //MARK: - Property
    
    /* Views. */
    let tableView: UITableView = UITableView()
    let textField: UITextField = UITextField()
    
    
    /* Models. */
    var listesArray = [Liste]()
    
    /// This property is used to enable or disable swipe action
    var isSwipeRightEnabled = true

    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareNavigationBar()
        prepareView()
        
//        addHardcodedItems()
    }

    
    //MARK: Preparing
    /// This func used for preparing navigation bar
    func prepareNavigationBar() {
        let title = "MesListes"
        self.title = title
        let rightNavigationButton = UIBarButtonItem(title: "+",
                                                       style: .plain,
                                                       target: self,
                                                       action: #selector(rightButtonAction))
        self.navigationItem.setRightBarButton(rightNavigationButton, animated: false)
    }
    
    @objc func rightButtonAction() {
        if let text = textField.text, text != "" {
            RealmManager.shared.createListe(name: text)
            let listobjects = RealmManager.shared.getListes()
            print(listobjects)
            listesArray = listobjects
            tableView.reloadData()
        }
    }
    
    func prepareView() {
        
        view.backgroundColor = UIColor.green
        
        let statusbarHeight: CGFloat = 20.0
        let navigationBarHeight = (self.navigationController?.navigationBar.frame.height)! //44.0

        let textFieldY = statusbarHeight + navigationBarHeight
        let textFieldWidht = self.view.bounds.size.width - (20 + 20)
        let textFieldHeight: CGFloat = 40.0
        
        let tableViewHeight = self.view.bounds.size.height - statusbarHeight - navigationBarHeight - textFieldHeight
        let tableY = textFieldY + textFieldHeight
        
        //textField
        textField.delegate = self
        textField.placeholder = "Add a new list"
        textField.frame = CGRect(x: 20,
                                 y: textFieldY,
                                 width: textFieldWidht,
                                 height: textFieldHeight)
        
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.masksToBounds = true
        textField.backgroundColor = UIColor.white
        
        //textField.backgroundColor = UIColor.green
        
        //tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ListTVC.self, forCellReuseIdentifier: "ListTVC")
        
        tableView.backgroundColor = UIColor.yellow
        

        
        tableView.frame = CGRect(x: 0,
                                 y: tableY,
                                 width: self.view.bounds.size.width,
                                 height: tableViewHeight)

        self.view.addSubview(tableView)


        self.view.addSubview(textField)
    }
}

extension ListViewController: UITextFieldDelegate {

}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    /* UITableViewDataSource. */
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        tableView.deselectRow(at: indexPath, animated: true)
        
        print(":=-> didSelectRowAt  indexPath = \(indexPath)")

        /* ItemTableViewController */
        let itemVC = ItemTableViewController()
        itemVC.currentListeId = listesArray[indexPath.row].id
        self.navigationController?.pushViewController(itemVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTVC", for: indexPath) as! ListTVC
        cell.delegate = self
        
        let liste = listesArray[indexPath.row]
            
            if liste.done == true {
                let attributedString = NSMutableAttributedString.init(string: liste.name)
                attributedString.addAttribute(.strikethroughStyle, value: 2, range: NSRange.init(location: 0, length: liste.name.count))
                attributedString.addAttribute(.foregroundColor, value: UIColor.lightGray , range: NSRange.init(location: 0, length: liste.name.count))
                cell.textLabel?.attributedText = attributedString
                
            }else{
                let attributedString = NSMutableAttributedString.init(string: liste.name)
                attributedString.addAttribute(.strikethroughStyle, value: 0, range: NSRange.init(location: 0, length: liste.name.count))
                cell.textLabel?.attributedText = attributedString
            }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}

extension ListViewController: ListTVCDelegate {
  
    func cellDidTapOnOk() {
        print(":=-> view controller get ok action from cell...")
    }
}

extension ListViewController: SwipeTableViewCellDelegate {

    //MARK: - SWIPE CELL METHODS
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        //guard orientation == .right else { return nil }
        
        if orientation == .left {
            guard isSwipeRightEnabled else { return nil }
            
            let strikeOut = SwipeAction(style: .default, title: "Strike Out") { (action, indexPath) in
                
                self.strikeOut(at: indexPath)
            }
            
            let setReminder = SwipeAction(style: .default, title: "Reminder") { action, indexPath in
                
                self.updateModelByAddingAReminder(at: indexPath)
                
            }
            setReminder.image = UIImage(named: "reminder-icon")
            
            
            let addEventToCalendar = SwipeAction(style: .default, title: "Calendar") { (action, indexPath) in
                
                self.addEventToCalendar(at: indexPath)
            }
            return[strikeOut, setReminder, addEventToCalendar]
            
        } else {
            
            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                
                self.updateModel(at: indexPath)
                
            }
            // customize the action appearance
            deleteAction.image = UIImage(named: "delete-icon")
            return [deleteAction]
        }
        
    }

    //MARK: - DIFFERENT SWIPE FUNCTIONS
    func updateModel(at indexpath: IndexPath){
        //Update our data model by deleting things from the database
    }
    
    
    func updateModelByAddingAReminder(at indexpath: IndexPath){
        // add time to datamodel
    }
    
    func addEventToCalendar (at indexpath: IndexPath) {
        // add events to calendar
    }
    
    func strikeOut (at indexPath: IndexPath) {
        // stike out the text in the cell
    }


    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        
        var options = SwipeTableOptions()
        
        
        //diferent expansion styles
        options.expansionStyle = orientation == .left ? .selection : .destructive
        
        return options
    }

}

//MARK: - HARDCODED Listes
extension ListViewController {
//    func addHardcodedItems () {
//        RealmManager.shared.createListe(name: "Shopping List")
//        listesArray = RealmManager.shared.getListes()
//       // tableView.reloadData() //????
//    }
}
