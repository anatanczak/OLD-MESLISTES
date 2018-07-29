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
    let textField = UITextField()
    let tableView = UITableView()
    
    /// This property is used to enable or disable swipe action
    var isSwipeRightEnabled = true
    
    
    var items : Results <Item>?
    
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
        print(":=-> rightButtonAction")
        /* Make new item for table. */
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
        tableView.register(SwipeTableViewCell.self, forCellReuseIdentifier: "SwipeTableViewCell")
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

extension ItemTableViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwipeTableViewCell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        if let item = items?[indexPath.row] {
            
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
        } else {
            cell.textLabel?.text = "You haven't created an item yet"
        }
        
        // cell.backgroundColor = colorize(hex: 0xD1C5CA)
        
        return cell
    }
}

extension ItemTableViewController: SwipeTableViewCellDelegate {
    
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
    
            //MARK: - METHODS FOR SWIPE ACTIONS
    
    
        func updateModel(at indexpath: IndexPath) {
//            if let itemForDeletion = self.items?[indexpath.row] {
//                do {
//                    try self.realm.write {
//                        self.realm.delete(itemForDeletion)
//                    }
//                }catch{
//                    print("Error deleting item\(error)")
//                }
//            }
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
//            if let currentItem = self.items?[indexPath.row] {
//                do {
//                    try realm.write {
//                        currentItem.done = !currentItem.done
//                    }
//                }catch{
//                    print("error updating realm\(error)")
//                }
//
//                tableView.reloadData()
//            }
        }
    
        func createNote(at indexPath: IndexPath) {
//            selectedItem = indexPath.row
//
//            if let currentItem = self.items?[indexPath.row] {
//                if currentItem.hasNote == false {
//                    do {
//                        try realm.write {
//                            currentItem.hasNote = true
//                        }
//                    } catch {
//                        print("error updating realm\(error)")
//                    }
//                }
//                performSegue(withIdentifier: "goToNote", sender: self)
//            }
//            tableView.reloadData()
        }
    
}







//    //MARK: - GLOBAL VARIABLES
//    let realm = try! Realm()
//    var items : Results <Item>?
//    var selectedItem = 0
//    var nameOfTheSelectedListe = ""
//    var selectedItemForTheCalendar = ""
//
//    var selectedListe : Liste? {
//        didSet {
//            loadItems()
//        }
//    }
//
//    //MARK: - IBACTIONS
//    @IBAction func saveItemButton(_ sender: UIButton) {
//                userInputHandeled()
//    }
//    @IBAction func textFieldPrimaryActionTriggered(_ sender: Any) {
//        userInputHandeled()
//    }
//
//
//    //MARK: - IBOUTLETS
//    @IBOutlet weak var navigationTitle: UINavigationItem!
//
//    @IBOutlet weak var itemTextField: UITextField!
//
//
//    //MARK: - VIEW DID LOAD
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        self.itemTextField.delegate = self
//        navigationTitle.title = selectedListe?.name
//        itemTextField.placeholder = "Add a new item."
//        itemTextField.clearsOnBeginEditing = true
//        loadItems()
//        //hideKeyboardWhenTappedAround()
//    }
//
//        // MARK: - TABLE VIEW DELEGATE METHODS
//
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let currentItem = items?[indexPath.row]
//        if currentItem?.hasNote == true {
//            performSegue(withIdentifier: "goToNote", sender: self)
//        }
//    }
//
//
//    // MARK: - TABLE VIEW DATA SOURSE
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        return items?.count ?? 1
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = super.tableView(tableView, cellForRowAt: indexPath)
//
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
//
//       // cell.backgroundColor = colorize(hex: 0xD1C5CA)
//
//        return cell
//    }
//
//    //MARK: - REALM FUNCTIONS
//
//    func userInputHandeled(){
//
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
//    }
//
//    //retrieves data from the database
//    func loadItems () {
//        items = selectedListe?.items.sorted(byKeyPath: "title", ascending: true)
//        tableView.reloadData()
//    }
//
//        //MARK: - METHODS FOR SWIPE ACTIONS
//
//
//    override func updateModel(at indexpath: IndexPath) {
//        if let itemForDeletion = self.items?[indexpath.row] {
//            do {
//                try self.realm.write {
//                    self.realm.delete(itemForDeletion)
//                }
//            }catch{
//                print("Error deleting item\(error)")
//            }
//        }
//    }
//
//    override func updateModelByAddingAReminder(at indexpath: IndexPath) {
//
//        selectedItem = indexpath.row
//
//        let sb = UIStoryboard(name: "Main", bundle: nil)
//        let popup = sb.instantiateViewController(withIdentifier: "Popup")as! DatePickerPopupViewController
//
//        popup.setReminder = setReminder
//        self.present(popup, animated: true)
//        tableView.reloadData()
//    }
//
//    // sends the notification to user to remind the list
//    func setReminder (_ components: DateComponents) ->(){
//
//        let content = UNMutableNotificationContent()
//        content.title = "Don't forget!!!"
//        content.body = items![selectedItem].title
//        content.sound = UNNotificationSound.default()
//        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
//        let request = UNNotificationRequest(identifier: "TestIdentifier", content: content, trigger: trigger)
//
//        UNUserNotificationCenter.current().add(request) { (error) in
//            if let error = error {
//                print(" We had an error: \(error)")
//            }
//        }
//    }
//
//    override func addEventToCalendar(at indexpath: IndexPath) {
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
//    }
//
//    func saveEventToCalendar(_ date: Date) ->(){
//
//        let eventStore = EKEventStore()
//
//        eventStore.requestAccess(to: .event) { (granted, error) in
//            if granted {
//                let event = EKEvent(eventStore: eventStore)
//
//                event.title = self.selectedItemForTheCalendar
//                event.startDate = date
//                event.endDate = date.addingTimeInterval(3600)
//                event.calendar = eventStore.defaultCalendarForNewEvents
//                do  {
//                    try eventStore.save(event, span: .thisEvent)
//                }catch{
//                    print("error saving the event\(error)")
//                }
//
//            }else{
//                print("error getting access to calendar\(error!)")
//            }
//        }
//    }
//
//    override func strikeOut(at indexPath: IndexPath) {
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
//    }
//
//    override func createNote(at indexPath: IndexPath) {
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
//    }
//
//
//    //MARK: - DIFFERENT METHODS
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
//
//
//    //MARK: - GESTURE RECOGNITION AND TEXTFIELD METHODS
//
//    //hides the keyboard when tapped somewhere else
////    func hideKeyboardWhenTappedAround() {
////        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ListViewController.dismissKeyboard))
////        tap.cancelsTouchesInView = false
////        view.addGestureRecognizer(tap)
////        tap.delegate = self
////
////    }
//
//    @objc func dismissKeyboard() {
//        view.endEditing(true)
//
//    }
//
//    //function called by gestureRecognaizer and it returns false if it is a UIButton
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        // Don't handle button taps
//        print("false")
//        return !(touch.view is UIButton)
//
//    }
//
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//
//        itemTextField.text = ""
//        return true
//    }
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        return true
//    }

