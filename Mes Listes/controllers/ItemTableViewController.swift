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
    //MARK: - Constants
    let textFieldPlaceholderText = "Type your item here..."
    let textFieldHeight: CGFloat = 40
    let textFieldAndPlusButtonPadding: CGFloat = 20
    let distanceBetweenTextfieldAndTableView: CGFloat = 10
    let borderSubView: CGFloat = 1
    
    //MARK: - Properties
    let realm = try! Realm()
    var items : Results <Item>?
    var selectedItem = 0
    var nameOfTheSelectedListe = ""
    var selectedItemForTheCalendar = ""
    var isSwipeRightEnabled = true
    let backgroundImage = #imageLiteral(resourceName: "background-image")

    
    let backgroundImageView = UIImageView()
    let subviewForTextFieldAndPlusButton = UIView()
    let textFieldItems = UITextField()
    let plusButton = UIButton()
    let tableView = UITableView()
    
    var selectedListe : Liste? {
        didSet {
            loadItems()
        }
    }

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupViews()
        setupLayout()
        
//        tableView.estimatedRowHeight = 100
//        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        subviewForTextFieldAndPlusButton.addTopBorderWithColor(color: .white, width: borderSubView)
        subviewForTextFieldAndPlusButton.addBottomBorderWithColor(color: .white, width: borderSubView)
    }
    private func setupNavigationBar () {
        
        let title = selectedListe?.name.uppercased() ?? "meslistes"
        self.title = title
        
      let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 19, weight: .light), NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = attributes
        
//        var rightImage = UIImage(named: "plus-icon")
//        rightImage = rightImage?.withRenderingMode(.alwaysOriginal)
//        let rightNavigationButton = UIBarButtonItem(image: rightImage, style: .plain, target: self, action: #selector (rightBarButtonAction))
//        rightNavigationButton.tintColor = UIColor.white
//
//        self.navigationItem.setRightBarButton(rightNavigationButton, animated: false)
        
        let leftNavigationButton = UIBarButtonItem(image: #imageLiteral(resourceName: "back-button-icon") , style: .plain, target: self, action: #selector(leftBarButtonAction))
        leftNavigationButton.tintColor = .black
        
        leftNavigationButton.imageInsets  = .init(top: 0, left: -4, bottom: 0, right: 0)
        self.navigationItem.setLeftBarButton(leftNavigationButton, animated: false)

    }
    
    private func setupViews () {
        
        
        // backgroundImageView
        backgroundImageView.image = backgroundImage
        backgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView)
        
        //subviewForTextField
        subviewForTextFieldAndPlusButton.backgroundColor = .clear

        view.addSubview(subviewForTextFieldAndPlusButton)
        
        //textField
        textFieldItems.backgroundColor = .clear
        textFieldItems.placeholder = textFieldPlaceholderText
        self.textFieldItems.delegate = self
//        textField.layer.borderColor = UIColor.white.cgColor
//        textField.layer.borderWidth = borderTextFieldAndPlusBotton

        textFieldItems.becomeFirstResponder()
        subviewForTextFieldAndPlusButton.addSubview(textFieldItems)
        
        //plusButton
        plusButton.setImage(#imageLiteral(resourceName: "plus-icon"), for: .normal)
        plusButton.addTarget(self, action: #selector(plusButtonAction), for: .touchUpInside)
//        plusButton.layer.borderColor = UIColor.white.cgColor
//        plusButton.layer.borderWidth = borderTextFieldAndPlusBotton
        
        subviewForTextFieldAndPlusButton.addSubview(plusButton)
        
        //tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ItemTableViewCell.self, forCellReuseIdentifier: "ItemTableViewCell")
        tableView.backgroundColor = UIColor.clear
        tableView.separatorColor = UIColor.white
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = .init(top: 0, left: 0, bottom: 0, right: 0)

        view.addSubview(tableView)
    }
    
    private func setupLayout() {
        
        backgroundImageView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
        //subViewTextField
        subviewForTextFieldAndPlusButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            subviewForTextFieldAndPlusButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            subviewForTextFieldAndPlusButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            subviewForTextFieldAndPlusButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            subviewForTextFieldAndPlusButton.heightAnchor.constraint(equalToConstant: textFieldHeight + 2 * borderSubView)
            ])
        
        
        //textField
        textFieldItems.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textFieldItems.topAnchor.constraint(equalTo: subviewForTextFieldAndPlusButton.topAnchor, constant: borderSubView),
            textFieldItems.leadingAnchor.constraint(equalTo: subviewForTextFieldAndPlusButton.leadingAnchor, constant: textFieldAndPlusButtonPadding),
            textFieldItems.heightAnchor.constraint(equalToConstant: textFieldHeight)
            ])
        
        //plusButton
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            plusButton.topAnchor.constraint(equalTo: textFieldItems.topAnchor),
            plusButton.bottomAnchor.constraint(equalTo: textFieldItems.bottomAnchor),
            plusButton.leadingAnchor.constraint(equalTo: textFieldItems.trailingAnchor),
            plusButton.widthAnchor.constraint(equalTo: plusButton.heightAnchor),
            plusButton.trailingAnchor.constraint(equalTo: subviewForTextFieldAndPlusButton.trailingAnchor, constant: -textFieldAndPlusButtonPadding),
            ])
        
        //tableView
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: subviewForTextFieldAndPlusButton.bottomAnchor, constant: distanceBetweenTextfieldAndTableView),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
            ])
        
    }
    
    //MARK: - ACTIONS
    @objc func plusButtonAction () {
print("plusButtonAction")
        createItem()
    }
    
    @objc func leftBarButtonAction () {
        let attributes = [NSAttributedString.Key.font: UIFont(name: "Zing Sans Rust Regular", size: 28.5)!, NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = attributes
        _ = navigationController?.popToRootViewController(animated: true)
        
    }
    
    //MARK: - Different Methods REALM
    
    func createItem (){
        userInputHandeled()
        tableView.reloadData()
    }
    func userInputHandeled(){
        if textFieldItems.text != "" && textFieldItems.text != nil {
            
            if let currentListe = self.selectedListe {
                
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textFieldItems.text!
                        currentListe.items.append(newItem)
                    }
                }catch{
                    print("Error saving item\(error)")
                }
            }
            textFieldItems.text = ""
            
        }else if textFieldItems.text == "" && textFieldItems.text != nil{
            //TODO: - Textfield empty
            
        }else{
            print("text field is nill")
        }
    }
        
    
    //retrieves data from the database
    func loadItems () {
        items = selectedListe?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    

    
}
// MARK: - TABLE VIEW DELEGATE METHODS DATA SOURCE
extension ItemTableViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //textFieldItems.resignFirstResponder()
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
        cell.delegate = self
        cell.fillWith(model: items?[indexPath.row])
        cell.titleLabel.font = UIFont.preferredFont(forTextStyle: .body)
        cell.titleLabel.adjustsFontForContentSizeCategory = true
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

    return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

//MARK: - Cell Delegate
extension ItemTableViewController: ItemTableViewCellDelegate {
    func cellDidTapOnNoteButton(cell: ItemTableViewCell) {
        //create an alert to ask if user wants to create a note to this item
        guard let indexPath = self.tableView.indexPath(for: cell) else {
            // Note, this shouldn't happen - how did the user tap on a button that wasn't on screen?
            return
        }
        
        let noteVC = NoteViewController()
        if let selectedCurrentItem = items?[indexPath.row] {
            noteVC.currentItem = selectedCurrentItem
        }
        self.show(noteVC, sender: self)
        
        tableView.reloadData()
    }
    }
    
    //MARK: - METHODS FOR SWIPE ACTIONS
extension ItemTableViewController: SwipeTableViewCellDelegate {

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {

        if orientation == .left {
            guard isSwipeRightEnabled else { return nil }
            
            let strikeOut = SwipeAction(style: .default, title: nil) { (action, indexPath) in
                
                self.strikeOut(at: indexPath)
            }
            strikeOut.image = #imageLiteral(resourceName: "strikeout-item-icon")
            
            strikeOut.backgroundColor = self.colorize(hex: 0xF0D6E2)
            
            let setReminder = SwipeAction(style: .default, title: nil) { action, indexPath in
                
                self.updateModelByAddingAReminder(at: indexPath)
                
            }
            setReminder.image = #imageLiteral(resourceName: "reminder-item-icon")
            setReminder.backgroundColor = self.colorize(hex: 0xF0D6E2)
            
            let addEventToCalendar = SwipeAction(style: .default, title: nil) { (action, indexPath) in
                
                self.addEventToCalendar(at: indexPath)
            }
            addEventToCalendar.image = #imageLiteral(resourceName: "calendar-item-icon")
            addEventToCalendar.backgroundColor = self.colorize(hex: 0xF0D6E2)
            
            return[strikeOut, setReminder, addEventToCalendar]
            
        }else{
            
            let deleteAction = SwipeAction(style: .destructive, title: nil) { action, indexPath in
                
                self.updateModel(at: indexPath)
                
            }
            // customize the action appearance
            deleteAction.image = #imageLiteral(resourceName: "delete-item-icon")
            deleteAction.backgroundColor = self.colorize(hex: 0xF25D61)
            
            
            return [deleteAction]
        }
        
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        
        var options = SwipeTableOptions()

        
        //diferent expansion styles
        options.expansionStyle = orientation == .left ? .selection : .destructive
        options.minimumButtonWidth = 45.0
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
        content.sound = UNNotificationSound.default
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

//MARK: - TextField Method

extension ItemTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textFieldItems {
            createItem()
            return true
        }
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        //or if you have just one textView
        self.textFieldItems.resignFirstResponder()
    }
}

extension ItemTableViewController {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.textFieldItems.resignFirstResponder()
        self.textFieldItems.text = ""
    }
}
