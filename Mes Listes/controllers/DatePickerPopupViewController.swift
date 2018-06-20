//
//  DatePickerPopupViewController.swift
//  Mes Listes
//
//  Created by Anastasiia Tanczak on 18/06/2018.
//  Copyright © 2018 Ana Viktoriv. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class DatePickerPopupViewController: UIViewController {
    
        let realm = try! Realm()
        var chosenItem: List?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var saveButtonLabel: UIButton!
    

    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        print("SaveButtonTapped")
        
        updateModelWithDate()
        sendNotificationToRemind()
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(chosenItem ?? "the chosen item has not been set yet")
    }
    
    // updatingModel with a date
    
    func updateModelWithDate (){
        do {
            try realm.write {
                chosenItem?.reminderDate = datePicker.date
                print(chosenItem?.reminderDate ?? "the date has not been set yet")
            }
        } catch {
            print("Error saving massage\(error)")
        }
    }
    
    func sendNotificationToRemind () {

        let content = UNMutableNotificationContent()
        content.title = "Don't forget!!!"
        content.body = chosenItem!.name
        content.sound = UNNotificationSound.default()

        let components = datePicker.calendar.dateComponents([.day, .month, .year, .hour, .minute], from: datePicker.date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: "TestIdentifier", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print(" We had an error: \(error)")
            }
        }
    }
}
