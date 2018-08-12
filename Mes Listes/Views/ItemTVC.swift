//
//  ItemTVC.swift
//  Mes Listes
//
//  Created by Anastasiia Tanczak on 07/08/2018.
//  Copyright © 2018 Ana Viktoriv. All rights reserved.
//

import UIKit
import Foundation
import SwipeCellKit

protocol ItemTVCDelegate: NSObjectProtocol {
    func cellDidTapOnNoteButton()
}

class ItemTVC: SwipeTableViewCell {
    
    weak var itemDelegate: ItemTVCDelegate?
    
    //MARK: - Properties
    var label = UILabel()
    var noteButton = UIButton()
    
    var isSwipeRightEnabled = true
    
    
    //MARK: - Implementations
    
    //used for code implementation
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareView()
    }
    
    //used for storyboard implementation
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepareView()
    }
    
    func prepareView () {
        
        let screen = UIScreen.main.bounds.size.width
        
        label.frame = CGRect(x: 0, y: 0, width: screen - 40, height: 40)
        label.text = "Random Text"
        contentView.addSubview(label)
        
        noteButton.backgroundColor = UIColor.cyan
        noteButton.setTitle("N", for: .normal)
        noteButton.frame = CGRect(x: screen - 40, y: 0, width: 40, height: 40)
        noteButton.addTarget(self, action: #selector(noteButtonAction), for: .touchUpInside)
        contentView.addSubview(noteButton)
    }
    
    //MARK: - Action
    @objc func noteButtonAction () {
        print(":-->noteButtonPressed")
        itemDelegate?.cellDidTapOnNoteButton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        label.text = nil
    }

}

extension ItemTVC: SwipeTableViewCellDelegate {

    //MARK: - SWIPE CELL METHODS
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
    
    //MARK: - DIFFERENT FUNCTIONS
    func updateModel(at indexpath: IndexPath){
        //Update our data model by deleting things from the database
    }
    
    
    func updateModelByAddingAReminder(at indexpath: IndexPath){
        // add time to datamodel
    }
    
    func addEventToCalendar (at indexpath: IndexPath) {
        // add events to calendar
    }
    
    func strikeOut (at indexPath: IndexPath) {
        // stike out the text in the cell
    }
    
    func createNote (at indexPath: IndexPath) {
        //creates a note
    }
    
    
}
