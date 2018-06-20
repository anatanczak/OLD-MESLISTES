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

class ItemViewController: UITableViewController {
    
    let realm = try! Realm()
    var lists : Results <List>?
    var selectedRow = 0

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        userInputHandeled()
        
    }
    
    @IBOutlet weak var listTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        listTextField.text = "Add a new item."
        listTextField.clearsOnBeginEditing = true
        loadLists()
    }
    
    // MARK: - Table view delegate methods
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let setReminder = setReminderAction(at: indexPath)
        let delete = deleteAction(at: indexPath)
        
        return UISwipeActionsConfiguration(actions: [delete, setReminder])
    }
    
    func setReminderAction (at indexpath: IndexPath) -> UIContextualAction {
        
        let action = UIContextualAction(style: .normal, title: "setReminder") { (action, view, completion) in
            self.selectedRow = indexpath.row
            self.performSegue(withIdentifier: "goToPopup", sender: self)
            
            completion(true)
        }
        action.image = UIImage(named: "reminder-icon")
        action.backgroundColor = UIColor.lightGray
        return action
    }
    
    func deleteAction (at indexpath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            //code
        }
        
        action.backgroundColor = UIColor.red
        return action
    }
    
    // preparation for the segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPopup"{
            let destinationVC = segue.destination as! DatePickerPopupViewController
            destinationVC.chosenItem = lists![selectedRow]
        }
    }


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return lists?.count ?? 1
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "List", for: indexPath)
        cell.textLabel?.text = lists?[indexPath.row].name ?? "You haven't created a list yet"
        return cell
    }

//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    //gets userInput from the textField
    func userInputHandeled(){
        
        if listTextField.text != "" && listTextField.text != "Add a new item." {
            let newList = List()
            newList.name = listTextField.text!
            self.save(list: newList)
            DispatchQueue.main.async {
                self.listTextField.resignFirstResponder()
            }
            listTextField.text = "Add a new item."
            tableView.reloadData()
        }
        
        
        
    }
    
    //saves data into database
    func save(list: List) {
        
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
        lists = realm.objects(List.self)
        lists = lists?.sorted(byKeyPath: "name", ascending: true)
        tableView.reloadData()
    }
}
