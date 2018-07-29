//
//  DatePickerPopupViewController.swift
//  Mes Listes
//
//  Created by Anastasiia Tanczak on 18/06/2018.
//  Copyright © 2018 Ana Viktoriv. All rights reserved.
//

import UIKit

class DatePickerPopupViewController: UIViewController {
    
    //MARK: - GLOBAL VARIABLES
    var dateForCalendar = false
    var setReminder: ((_ components: DateComponents) -> ())?
    var saveEventToCalendar: ((_ date: Date) ->())?

    
    //MARK: - IBOUTLETS
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var saveButtonLabel: UIButton!
    

    //MARK: - IBACTIONS
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        if dateForCalendar == true {
            saveEventToCalendar!(datePicker.date)
        }else{
            let components = datePicker.calendar.dateComponents([.day, .month, .year, .hour, .minute], from: datePicker.date)
            setReminder!(components)
        }
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        if dateForCalendar == true{
            saveButtonLabel.setTitle("Save to calendar", for: .normal)
            print("save button tapped")
        }
        
    }
}
