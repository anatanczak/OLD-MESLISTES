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
import SwipeCellKit

class ItemTableViewController: UIViewController {
    
    //MARK: - Properties
    let realm = try! Realm()
    var items : Results <Item>?
    var selectedItem = 0
    var nameOfTheSelectedListe = ""
    var selectedItemForTheCalendar = ""
    var isSwipeRightEnabled = true
    
    let backgoundImageView = UIImageView()
    let tableView = UITableView()
    
    var selectedListe : Liste? {
        didSet {
            loadItems()
        }
    }
    
    //MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func userInputHandeled(){
        
        //        if let currentListe = self.selectedListe {
        //            if itemTextField.text != "" && itemTextField.text != "Add a new item." {
        //
        //                do {
        //                    try self.realm.write {
        //                        let newItem = Item()
        //                        newItem.title = itemTextField.text!
        //                        currentListe.items.append(newItem)
        //                    }
        //                }catch{
        //                    print("Error saving item\(error)")
        //                }
        //                DispatchQueue.main.async {
        //                    self.itemTextField.resignFirstResponder()
        //                }
        //                itemTextField.text = "Add a new item."
        //                itemTextField.clearsOnBeginEditing = true
        //                tableView.reloadData()
        //            }
        //        }
    }
    
    //retrieves data from the database
    func loadItems () {
        items = selectedListe?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
}

extension ItemTableViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - TABLE VIEW DELEGATE METHODS DATA SOURCE
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let currentItem = items?[indexPath.row]
        //        if currentItem?.hasNote == true {
        //            performSegue(withIdentifier: "goToNote", sender: self)
        //        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableViewCell", for: indexPath) as! ItemTableViewCell
        
        //        if let item = items?[indexPath.row] {
        //
        //            if item.done == true {
        //                let attributedString = NSMutableAttributedString.init(string: item.title)
        //                attributedString.addAttribute(.strikethroughStyle, value: 2, range: NSRange.init(location: 0, length: item.title.count))
        //                attributedString.addAttribute(.foregroundColor, value: UIColor.lightGray , range: NSRange.init(location: 0, length: item.title.count))
        //                cell.textLabel?.attributedText = attributedString
        //
        //            }else{
        //                let attributedString = NSMutableAttributedString.init(string: item.title)
        //                attributedString.addAttribute(.strikethroughStyle, value: 0, range: NSRange.init(location: 0, length: item.title.count))
        //                cell.textLabel?.attributedText = attributedString
        //            }
        //        }else{
        //            cell.textLabel?.text = "You haven't created an item yet"
        //        }
        
        // cell.backgroundColor = colorize(hex: 0xD1C5CA)
        
        return cell
    }
}
    //MARK: - REALM FUNCTIONS
    

extension ItemTableViewController: SwipeTableViewCellDelegate {
    //MARK: - METHODS FOR SWIPE ACTIONS
    
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
                
                self.updateModel(at: indexPath)
                
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
    
    func updateModel(at indexpath: IndexPath) {
        if let itemForDeletion = self.items?[indexpath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            }catch{
                print("Error deleting item\(error)")
            }
        }
    }
    
    func updateModelByAddingAReminder(at indexpath: IndexPath) {
        
        selectedItem = indexpath.row
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let popup = sb.instantiateViewController(withIdentifier: "Popup")as! DatePickerPopupViewController
        
        popup.setReminder = setReminder
        self.present(popup, animated: true)
        tableView.reloadData()
    }
    
    // sends the notification to user to remind the list
    func setReminder (_ components: DateComponents) ->(){
        
        let content = UNMutableNotificationContent()
        content.title = "Don't forget!!!"
        content.body = items![selectedItem].title
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
        
        selectedItem = indexpath.row
        selectedItemForTheCalendar = items![indexpath.row].title
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let popup = sb.instantiateViewController(withIdentifier: "Popup")as! DatePickerPopupViewController
        
        popup.dateForCalendar = true
        popup.saveEventToCalendar = saveEventToCalendar
        
        self.present(popup, animated: true)
        tableView.reloadData()
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
        if let currentItem = self.items?[indexPath.row] {
            do {
                try realm.write {
                    currentItem.done = !currentItem.done
                }
            }catch{
                print("error updating realm\(error)")
            }
            
            tableView.reloadData()
        }
    }
    
    func createNote(at indexPath: IndexPath) {
        selectedItem = indexPath.row
        
        if let currentItem = self.items?[indexPath.row] {
            if currentItem.hasNote == false {
                do {
                    try realm.write {
                        currentItem.hasNote = true
                    }
                }catch{
                    print("error updating realm\(error)")
                }
            }
            performSegue(withIdentifier: "goToNote", sender: self)
        }
        tableView.reloadData()
    }
}
    
    
    //MARK: - DIFFERENT METHODS
//    func createItem (_ itemTitle: String)->() {
//
//    }
//    func addIconNameToItem (_ iconName: String) ->() {
//
//    }
//
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "goToNote" {
//
//            let destinationVC = segue.destination as! NoteViewController
//
//            destinationVC.currentItem = items?[selectedItem]
//            print(destinationVC.currentItem ?? "fuck")
//        }
//    }


