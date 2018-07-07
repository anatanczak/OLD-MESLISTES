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

class ListViewController: SwipeTableViewController, UITextFieldDelegate {
    
    let realm = try! Realm()
    var lists : Results <Liste>?
    var chosenRow = 0
    var chosenNameforCalendar = ""
    
    @IBAction func textFieldPrimaryActionTriggered(_ sender: Any) {
        userInputHandeled()
    }
    
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        userInputHandeled()
        
    }
    
    @IBOutlet weak var listTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        self.listTextField.delegate = self
        
        listTextField.text = "Add a new list."
        listTextField.clearsOnBeginEditing = true
        loadLists()
    }
    
    // MARK: - Table view delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return lists?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let liste = lists?[indexPath.row] {

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
        }else{
            cell.textLabel?.text = "You haven't created a list yet"
        }

       // cell.backgroundColor = colorize(hex: 0xD1C5CA)
        return cell
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItem" {
            let destinationVC = segue.destination as! ItemTableViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedListe = lists?[indexPath.row]
            }

        }
    }

    
    //gets userInput from the textField
    func userInputHandeled(){
        
        if listTextField.text != "" && listTextField.text != "Add a new list." {
            let newList = Liste()
            newList.name = listTextField.text!
            self.save(list: newList)
            
            DispatchQueue.main.async {
                self.listTextField.resignFirstResponder()
            }
            listTextField.text = "Add a new list."
            listTextField.clearsOnBeginEditing = true
            tableView.reloadData()
        }
    }
    
    //saves data into database
    func save(list: Liste) {
        
        do {
            try realm.write {
                realm.add(list)
            }
        } catch {
            print("Error saving massage\(error)")
        }
    }
    
    //retrieves data from the database
    func loadLists () {
        lists = realm.objects(Liste.self)
        lists = lists?.sorted(byKeyPath: "name", ascending: true)
        tableView.reloadData()
    }
    
    //MARK: - Methods for Swipe Actions
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
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
            
            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                
                self.updateModel(at: indexPath)
                
            }
            // customize the action appearance
            deleteAction.image = UIImage(named: "delete-icon")
            return [deleteAction]
        }
        
    }
    
    override func updateModelByAddingAReminder(at indexpath: IndexPath) {
    
        chosenRow = indexpath.row
        
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
        content.body = lists![chosenRow].name
        content.sound = UNNotificationSound.default()
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: "TestIdentifier", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print(" We had an error: \(error)")
            }
        }
    }
    
    //deletes the list
    override func updateModel(at indexpath: IndexPath) {
        if let listForDeletion = self.lists?[indexpath.row]{
            do {
                try self.realm.write {
                    self.realm.delete(listForDeletion)
                }
            } catch{
                print("Error deleting category\(error)")
            }
        }
    }
    
    override func addEventToCalendar(at indexpath: IndexPath) {

        chosenRow = indexpath.row
        chosenNameforCalendar = lists![indexpath.row].name
        
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

                    event.title = self.chosenNameforCalendar
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
    
    //strikes out the text
    
    override func strikeOut(at indexPath: IndexPath) {
        
        if let itemForUpdate = self.lists?[indexPath.row] {
            
            //changing the done property
            do {
                try realm.write {
                    itemForUpdate.done = !itemForUpdate.done
                }
            }catch{
                print("error updating relm\(error)")
            }
          tableView.reloadData()
        }
    }
}
