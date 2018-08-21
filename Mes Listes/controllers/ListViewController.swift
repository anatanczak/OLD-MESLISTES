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
import SnapKit

class ListViewController: UIViewController {
    
    //MARK: - Properties
    let backgroundImageView: UIImageView = UIImageView()
    let tableView = UITableView()
    let backgroundImage = #imageLiteral(resourceName: "liste-background-image")
    
    let realm = try! Realm()
    var lists : Results <Liste>?
    var chosenRow = 0
    var chosenNameforCalendar = ""
    var isSwipeRightEnabled = true
    
    
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
       
        prepareNavigationBar()
        prepareView()
        prepareLayout()
        
        if isAppAlreadyLaunchedOnce() {
            loadLists()
        }else{
            threeHardCodedExamples()
            loadLists()
        }
    }
    
    func prepareNavigationBar () {
        
        let title = "meslistes"
        self.title = title    
        let rightNavigationButton = UIBarButtonItem(image: #imageLiteral(resourceName: "plus-icon"), style: .plain, target: self, action: #selector (rightBarButtonAction))
        rightNavigationButton.tintColor = UIColor.white
        //moves image in the item
        //rightNavigationButton.imageInsets  = .init(top: 10, left: 0, bottom: -1, right: 10)
       
        self.navigationItem.setRightBarButton(rightNavigationButton, animated: false)
    }
    
    @objc func rightBarButtonAction () {
        
        let userTextInputVC = UserTextInputViewController()
       // userTextInputVC.isListe = true
       // userTextInputVC.createListe = createListe
       self.definesPresentationContext = true
        self.present(userTextInputVC, animated: true, completion: nil)
    }
    
    func prepareView () {
        // (UIApplication.shared.value(forKey: "statusBar") as? UIView)?.backgroundColor = .clear
        let statusBarHeight: CGFloat = 20.0
        let navigationBarHeight = (self.navigationController?.navigationBar.frame.height)!
        
       // backgroundImageView
        backgroundImageView.image = backgroundImage
        backgroundImageView.contentMode = .scaleAspectFit
        view.addSubview(backgroundImageView)
        
        //tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ListeTableViewCell.self, forCellReuseIdentifier: "ListeTableViewController")
        tableView.backgroundColor = UIColor.clear
        tableView.separatorColor = UIColor.green
        tableView.separatorStyle = .singleLine
        //tableView - separator height?
        tableView.frame = CGRect(x: 0, y: statusBarHeight + navigationBarHeight, width: self.view.bounds.size.width, height: self.view.bounds.size.height - (statusBarHeight + navigationBarHeight))
        view.addSubview(tableView)
    }
    
    //MARK: - Layout
    private func prepareLayout() {
        //backgroundImageView
        backgroundImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    //MARK: - REALM FUNCTIONS
    
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
}

//MARK: - TableView DataSource and Delegate
extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    // delegate methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    // data source methhods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListeTableViewController", for: indexPath) as! ListeTableViewCell
        cell.delegate = self
        cell.fillWith(model: lists?[indexPath.row])

        return cell
    }
}

//MARK: - METHODS FOR SWIPE ACTIONS
extension ListViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        //guard orientation == .right else { return nil }
        
        if orientation == .left {
            guard isSwipeRightEnabled else { return nil }
            
            //STRIKE OUT
            let strikeOut = SwipeAction(style: .default, title: "Strike Out") { (action, indexPath) in
                self.strikeOut(at: indexPath)
            }
            
            //REMINDER
            let setReminder = SwipeAction(style: .default, title: "Reminder") { action, indexPath in
                self.updateModelByAddingAReminder(at: indexPath)
            }
            setReminder.image = UIImage(named: "reminder-icon")
            
            //CALENDAR
            let addEventToCalendar = SwipeAction(style: .default, title: "Calendar") { (action, indexPath) in
                self.addEventToCalendar(at: indexPath)
            }
            addEventToCalendar.image = #imageLiteral(resourceName: "calendar-icon")
            
            return[strikeOut, setReminder, addEventToCalendar]
            
        }else{
            //DELETE
            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                self.deleteListe(at: indexPath)
            }
            deleteAction.image = #imageLiteral(resourceName: "trash-icon")
            
            return [deleteAction]
        }
        
    }
    //makes different expansion styles possible (such as deleting by swiping till it disappears)
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        
        var options = SwipeTableOptions()
        
        
        //diferent expansion styles
        options.expansionStyle = orientation == .left ? .selection : .destructive
        
        return options
    }
    
    func updateModelByAddingAReminder(at indexpath: IndexPath) {
        
        chosenRow = indexpath.row
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let popup = sb.instantiateViewController(withIdentifier: "Popup")as! DatePickerPopupViewController
        
        popup.setReminder = setReminder
        self.present(popup, animated: true)
        tableView.reloadData()
    }
    
    //sends the notification to user to remind the list
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
    func deleteListe (at indexpath: IndexPath) {
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
    
    func addEventToCalendar(at indexpath: IndexPath) {
        
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
    
    func strikeOut(at indexPath: IndexPath) {
        
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
    
    //MARK: - DIFFERENT METHODS
    
    ///creates a liste and saves it in Realm
    func createListe (_ liste: Liste) ->() {

        save(list: liste)
        tableView.reloadData()
    }
//    ///adds icon to a liste and saves iconName in Realm
//    func addIconNameToListe (_ iconName: String)->() {
//        let newListe = Liste()
//        newListe.iconName = iconName
//        sa
//    }

    
    
    func threeHardCodedExamples () {
        let fisrtListe = Liste()
        fisrtListe.name = "SHOPPING LIST"
        fisrtListe.iconName = "shopping-icon"
        save(list: fisrtListe)
        
        let secondListe = Liste()
        secondListe.name = "TO DO"
        secondListe.iconName = "todo-icon"
        save(list: secondListe)
        
        let thirdListe = Liste()
        thirdListe.name = "TRAVELPACK"
        thirdListe.iconName = "airplane-icon"
        save(list: thirdListe)
        
    }
    
    //Checks if the app is being launched for the first time
    func isAppAlreadyLaunchedOnce()->Bool{
        let defaults = UserDefaults.standard
        
        if let isAppAlreadyLaunchedOnce = defaults.string(forKey: "isAppAlreadyLaunchedOnce"){
            print("App already launched : \(isAppAlreadyLaunchedOnce)")
            return true
        }else{
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            print("App launched first time")
            return false
        }
    }
}


//gets userInput from the textField
//    func userInputHandeled(){
//
//        if listTextField.text != "" {
//            let newList = Liste()
//            newList.name = listTextField.text!
//            self.save(list: newList)
//
//            DispatchQueue.main.async {
//                self.listTextField.resignFirstResponder()
//            }
//            listTextField.clearsOnBeginEditing = true
//            listTextField.text = ""
//            tableView.reloadData()

//        }









//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "goToItem" {
//            let destinationVC = segue.destination as! ItemTableViewController
//
//            if let indexPath = tableView.indexPathForSelectedRow {
//                destinationVC.selectedListe = lists?[indexPath.row]
//            }
//
//        }
//    }

//MARK: - GESTURE RECOGNIZER ADN TEXTFIELD METHODS
//hides the keyboard when tapped somewhere else
//    func hideKeyboardWhenTappedAround() {
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ListViewController.dismissKeyboard))
//        tap.cancelsTouchesInView = false
//        view.addGestureRecognizer(tap)
//        tap.delegate = self
//    }
//
//    @objc func dismissKeyboard() {
//        view.endEditing(true)
//    }

//function called by gestureRecognaizer and it returns false if it is a UIButton
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        // Don't handle button taps
//        print("false")
//        return !(touch.view is UIButton)
//
//    }
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//
//        listTextField.text = ""
//        return true
//    }
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//
//        return true
//    }

