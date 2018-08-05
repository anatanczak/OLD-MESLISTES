//
//  DatePickerPopupViewController.swift
//  Mes Listes
//
//  Created by Anastasiia Tanczak on 18/06/2018.
//  Copyright © 2018 Ana Viktoriv. All rights reserved.
//

import UIKit

class DatePickerPopupViewController: UIViewController {
    //MARK: - Properties
    let label = UILabel()
    let saveButton = UIButton()
    let datePicker = UIDatePicker()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareview()
    }
    
    func prepareview () {
            
        let labelHeight: CGFloat = 40.0
        let labelWidth = self.view.bounds.size.width
        let labelY = self.view.bounds.size.height / 3
            
        view.isOpaque = false
        
        let saveButtonHeight: CGFloat = 40.0
        let saveButtonWidth = self.view.bounds.size.width
        let saveButtonY = 2 * (self.view.bounds.size.height / 3) - saveButtonHeight
        
        let datePickerHeight = labelY - labelHeight - saveButtonHeight
        let datePickerWidth = self.view.bounds.size.width
        let datePickerY = labelY + labelHeight
        
        label.backgroundColor = UIColor.red
        label.text = "Select date and time"
        label.textAlignment = NSTextAlignment.center
        label.frame = CGRect(x: 0, y: labelY, width: labelWidth, height: labelHeight)
        
        saveButton.backgroundColor = UIColor.red
        saveButton.setTitle("Save", for: .normal)
        saveButton.frame = CGRect(x: 0, y: saveButtonY, width: saveButtonWidth, height: saveButtonHeight)
        saveButton.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
        
        datePicker.backgroundColor = UIColor.red
        datePicker.frame = CGRect(x: 0, y: datePickerY, width: datePickerWidth, height: datePickerHeight)
        
        self.view.addSubview(label)
        self.view.addSubview(saveButton)
        self.view.addSubview(datePicker)
    }
    
    //MARK: - Actions:
    @objc func saveButtonAction() {
        /* logic for saving date...*/
        
        /* close picker... */
        self.dismiss(animated: true, completion: nil)
    }
}

//class DatePickerPopupViewController: UIViewController {
//
//    //MARK: - GLOBAL VARIABLES
//    var dateForCalendar = false
//    var setReminder: ((_ components: DateComponents) -> ())?
//    var saveEventToCalendar: ((_ date: Date) ->())?
//
//
//    //MARK: - IBOUTLETS
//    @IBOutlet weak var titleLabel: UILabel!
//    @IBOutlet weak var datePicker: UIDatePicker!
//
//    @IBOutlet weak var saveButtonLabel: UIButton!
//
//
//    //MARK: - IBACTIONS
//    @IBAction func saveButtonTapped(_ sender: UIButton) {
//        if dateForCalendar == true {
//            saveEventToCalendar!(datePicker.date)
//        }else{
//            let components = datePicker.calendar.dateComponents([.day, .month, .year, .hour, .minute], from: datePicker.date)
//            setReminder!(components)
//        }
//        dismiss(animated: true, completion: nil)
//    }
//
//    //MARK: - VIEW DID LOAD
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        if dateForCalendar == true{
//            saveButtonLabel.setTitle("Save to calendar", for: .normal)
//            print("save button tapped")
//        }
//
//    }
//}
