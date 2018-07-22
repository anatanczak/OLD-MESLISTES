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
    var lists : Results <Liste>?
    
    /// This property used for enebled or disable swipe action
    var isSwipeRightEnabled = true

    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareNavigationBar()
        prepareView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /* Poin where screen did load but not appear. */
        print(":=-> Poin where screen did load but not appear.")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      
        /* Poin where screen did load and did apear. */
        print(":=-> Poin where screen did load but not appear.")
    }
    
    
    //MARK: Preparing
    /// This func used for preparing navigation bar
    func prepareNavigationBar() {
        let title = "List"
        self.title = title
        let rightNavigationBatButton = UIBarButtonItem(title: "Add new",
                                                       style: .plain,
                                                       target: self,
                                                       action: #selector(rightButtonAction))
        self.navigationItem.setRightBarButton(rightNavigationBatButton, animated: false)
    }
    
    @objc func rightButtonAction() {
        print(":=-> rightButtonAction")
        /* Make new item for table. */
    }
    
    func prepareView() {
        
        let statusbarHeight: CGFloat = 20.0
        let navigationBarHeight = (self.navigationController?.navigationBar.frame.height)! //44.0

        let textFieldY = statusbarHeight + navigationBarHeight
        let textFieldWidht = self.view.bounds.size.width - (20 + 20)
        let textFieldHeight: CGFloat = 40.0
        
        let tableViewHeight = self.view.bounds.size.height - statusbarHeight - navigationBarHeight - textFieldHeight
        let tableY = textFieldY + textFieldHeight
        
        //textField
        textField.delegate = self
        textField.placeholder = "Put name for new item"
        textField.frame = CGRect(x: 20,
                                 y: textFieldY,
                                 width: textFieldWidht,
                                 height: textFieldHeight)
        
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.masksToBounds = true
        
        //textField.backgroundColor = UIColor.green
        
        //tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SwipeTableViewCell.self, forCellReuseIdentifier: "SwipeTableViewCell")
        
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
   
    // return NO to not change text
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
    
    // called when clear button pressed. return NO to ignore (no notifications)
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
        
    }
}

//MAKE: - UITableViewDataSource, UITableViewDelegate
extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    /* UITableViewDataSource. */
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.lists?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwipeTableViewCell", for: indexPath) as! SwipeTableViewCell
        
        //makes this class delegate and enables the implementation of all the methods for a swipe cell
        cell.delegate = self
        
        if let liste = lists?[indexPath.row] {
            
            if liste.done == true {
                let attributedString = NSMutableAttributedString.init(string: liste.name)
                attributedString.addAttribute(.strikethroughStyle, value: 2, range: NSRange.init(location: 0, length: liste.name.count))
                attributedString.addAttribute(.foregroundColor, value: UIColor.lightGray , range: NSRange.init(location: 0, length: liste.name.count))
                cell.textLabel?.attributedText = attributedString
                
            } else {
                let attributedString = NSMutableAttributedString.init(string: liste.name)
                attributedString.addAttribute(.strikethroughStyle, value: 0, range: NSRange.init(location: 0, length: liste.name.count))
                cell.textLabel?.attributedText = attributedString
            }
        } else {
            cell.textLabel?.text = "You haven't created a list yet"
        }
        
        // cell.backgroundColor = colorize(hex: 0xD1C5CA)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
}

extension ListViewController: SwipeTableViewCellDelegate {
        /**
         Asks the delegate for the actions to display in response to a swipe in the specified row.
         
         - parameter tableView: The table view object which owns the cell requesting this information.
         
         - parameter indexPath: The index path of the row.
         
         - parameter orientation: The side of the cell requesting this information.
         
         - returns: An array of `SwipeAction` objects representing the actions for the row. Each action you provide is used to create a button that the user can tap.  Returning `nil` will prevent swiping for the supplied orientation.
         */
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
    
    //MARK: - DIFFERENT FUNCTIONS
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
    
    func createNote (at indexPath: IndexPath) {
        //creates a note
    }

        
        /**
         Asks the delegate for the display options to be used while presenting the action buttons.
         
         - parameter tableView: The table view object which owns the cell requesting this information.
         
         - parameter indexPath: The index path of the row.
         
         - parameter orientation: The side of the cell requesting this information.
         
         - returns: A `SwipeTableOptions` instance which configures the behavior of the action buttons.
         
         - note: If not implemented, a default `SwipeTableOptions` instance is used.
         */
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        
        var options = SwipeTableOptions()
        
        
        //diferent expansion styles
        options.expansionStyle = orientation == .left ? .selection : .destructive
        
        return options
    }
        
        /**
         Tells the delegate that the table view is about to go into editing mode.
         
         - parameter tableView: The table view object providing this information.
         
         - parameter indexPath: The index path of the row.
         
         - parameter orientation: The side of the cell.
         */
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) {
        
    }
        
        /**
         Tells the delegate that the table view has left editing mode.
         
         - parameter tableView: The table view object providing this information.
         
         - parameter indexPath: The index path of the row.
         
         - parameter orientation: The side of the cell.
         */
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?, for orientation: SwipeActionsOrientation) {
        
    }
}
