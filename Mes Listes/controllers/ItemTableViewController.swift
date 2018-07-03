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

class ItemTableViewController:SwipeTableViewController {
    
    let realm = try! Realm()
    var items : Results <Item>?
    var selectedItem = 0
    var nameOfTheSelectedListe = ""
    
    var selectedListe : Liste? {
        didSet {
            loadItems()
        }
    }

    @IBOutlet weak var navigationTitle: UINavigationItem!
   
    @IBOutlet weak var itemTextField: UITextField!
    
    @IBAction func saveItemButton(_ sender: UIButton) {
        userInputHandeled()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationTitle.title = selectedListe?.name
        itemTextField.text = "Add a new item."
        itemTextField.clearsOnBeginEditing = true
        loadItems()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = items?[indexPath.row].title ?? "You haven't created an item yet"
        cell.backgroundColor = colorize(hex: 0xD1C5CA)
        return cell
    }
    
    
    func userInputHandeled(){
        

        if let currentListe = self.selectedListe {
            if itemTextField.text != "" && itemTextField.text != "Add a new item." {
                
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = itemTextField.text!
                        currentListe.items.append(newItem)
                    }
                }catch{
                    print("Error saving item\(error)")
                }
                DispatchQueue.main.async {
                    self.itemTextField.resignFirstResponder()
                }
                itemTextField.text = "Add a new item."
                itemTextField.clearsOnBeginEditing = true
                tableView.reloadData()
            }
        }
    }

    
    //retrieves data from the database
    func loadItems () {
        items = selectedListe?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
  
        //MARK: - Methods for Swipe Actions
    
//    override func updateModelByAddingAReminder(at indexpath: IndexPath) {
//        selectedItem = indexpath.row
//        performSegue(withIdentifier: "goToDatePopupFromItems", sender: self)
//    }
    
    override func updateModel(at indexpath: IndexPath) {
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
    
    override func updateModelByAddingAReminder(at indexpath: IndexPath) {
        
        selectedItem = indexpath.row
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let popup = sb.instantiateViewController(withIdentifier: "Popup")as! DatePickerPopupViewController
        
        popup.setReminder = setReminder
        self.present(popup, animated: true)
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
    
    
    override func addEventToCalendar(at indexpath: IndexPath) {
        selectedItem = indexpath.row

    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//       
//    }

}
