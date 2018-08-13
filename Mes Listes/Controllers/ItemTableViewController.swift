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
    

    ///This property is used to transfer current liste.id
    var currentListeId: String? {
        didSet {
            //load items with this liste id
            let sortedItems = RealmManager.shared.getAllItems(forListName: currentListeId!)
            itemsArray = sortedItems
        }
    }

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
      
        saveItem()
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
        textField.backgroundColor = UIColor.white
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
        cell.delegate = self
        
        
           let item = itemsArray[indexPath.row]

            if item.done == true {
                let attributedString = NSMutableAttributedString.init(string: item.title)
                attributedString.addAttribute(.strikethroughStyle, value: 2, range: NSRange.init(location: 0, length: item.title.count))
                attributedString.addAttribute(.foregroundColor, value: UIColor.lightGray , range: NSRange.init(location: 0, length: item.title.count))
                cell.textLabel?.attributedText = attributedString

            } else {
                let attributedString = NSMutableAttributedString.init(string: item.title)
                attributedString.addAttribute(.strikethroughStyle, value: 0, range: NSRange.init(location: 0, length: item.title.count))
                cell.textLabel?.attributedText = attributedString
            }

        // cell.backgroundColor = colorize(hex: 0xD1C5CA)
        
        return cell
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

extension ItemTableViewController: SwipeTableViewCellDelegate {
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
            
        }else{
            
            let createNote = SwipeAction(style: .default, title: "Note") { (action, indexPath) in
                self.createNote(at: indexPath)
            }
            
            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                
                self.deleteItem(at: indexPath)
                
            }
            // customize the action appearance
            deleteAction.image = UIImage(named: "delete-icon")
            return [deleteAction, createNote]
        }
        
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        
        var options = SwipeTableOptions()
        
        
        //diferent expansion styles
        options.expansionStyle = orientation == .left ? .selection : .destructive
        
        return options
    }
    
    //MARK: - METHODS FOR SWIPE ACTIONS
    
    
     func deleteItem(at indexpath: IndexPath) {
//        if let itemForDeletion = self.items?[indexpath.row] {
//            do {
//                try self.realm.write {
//                    self.realm.delete(itemForDeletion)
//                }
//            }catch{
//                print("Error deleting item\(error)")
//            }
//        }
    }
    
func updateModelByAddingAReminder(at indexpath: IndexPath) {
//
//        selectedItem = indexpath.row
//
//        let sb = UIStoryboard(name: "Main", bundle: nil)
//        let popup = sb.instantiateViewController(withIdentifier: "Popup")as! DatePickerPopupViewController
//
//        popup.setReminder = setReminder
//        self.present(popup, animated: true)
//        tableView.reloadData()
    }
    
    // sends the notification to user to remind the list
    func setReminder (_ components: DateComponents) ->(){
        
        let content = UNMutableNotificationContent()
        content.title = "Don't forget!!!"
        content.body = itemsArray[selectedItem].title
        content.sound = UNNotificationSound.default()
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: "TestIdentifier", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print(" We had an error: \(error)")
            }
        }
    }
    
func addEventToCalendar(at indexpath: IndexPath) {
//
//        selectedItem = indexpath.row
//        selectedItemForTheCalendar = items![indexpath.row].title
//
//        let sb = UIStoryboard(name: "Main", bundle: nil)
//        let popup = sb.instantiateViewController(withIdentifier: "Popup")as! DatePickerPopupViewController
//
//        popup.dateForCalendar = true
//        popup.saveEventToCalendar = saveEventToCalendar
//
//        self.present(popup, animated: true)
//        tableView.reloadData()
    }
    
    func saveEventToCalendar(_ date: Date) ->(){
        
        let eventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event) { (granted, error) in
            if granted {
                let event = EKEvent(eventStore: eventStore)
                
                event.title = self.selectedItemForTheCalendar
                event.startDate = date
                event.endDate = date.addingTimeInterval(3600)
                event.calendar = eventStore.defaultCalendarForNewEvents
                do  {
                    try eventStore.save(event, span: .thisEvent)
                }catch{
                    print("error saving the event\(error)")
                }
                
            }else{
                print("error getting access to calendar\(error!)")
            }
        }
    }
    
    func strikeOut(at indexPath: IndexPath) {
//        if let currentItem = self.items?[indexPath.row] {
//            do {
//                try realm.write {
//                    currentItem.done = !currentItem.done
//                }
//            }catch{
//                print("error updating realm\(error)")
//            }
//
//            tableView.reloadData()
//        }
    }
    
    func createNote(at indexPath: IndexPath) {
//        selectedItem = indexPath.row
//
//        if let currentItem = self.items?[indexPath.row] {
//            if currentItem.hasNote == false {
//                do {
//                    try realm.write {
//                        currentItem.hasNote = true
//                    }
//                }catch{
//                    print("error updating realm\(error)")
//                }
//            }
//            performSegue(withIdentifier: "goToNote", sender: self)
//        }
//        tableView.reloadData()
    }

}

extension ItemTableViewController {
    //MARK: - DIFFERENT METHODS
    func saveItem () {
        if let text = textField.text, text != "" {
            RealmManager.shared.createListe(name: text, completion: { [weak self] in
                guard let `self` = self else { return }
                
                DispatchQueue.main.async { [weak self] in

                    let itemojects = RealmManager.shared.getAllItems(forListName: (self?.currentListeId)!)
                    self?.itemsArray = itemojects
                    self?.tableView.reloadData()
                }

            })
        }
    }
}
