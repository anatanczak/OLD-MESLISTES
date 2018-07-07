//
//  SwipeTableViewController.swift
//  RememberIT
//
//  Created by Anastasiia Tanczak on 13/06/2018.
//  Copyright © 2018 Ana Viktoriv. All rights reserved.
//

import UIKit
import SwipeCellKit
import UserNotifications



class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    var isSwipeRightEnabled = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
     tableView.rowHeight = 80.0
        
    }
    
    //TableView DataSource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //initializes the SwipeTableViewCell as the default cell for all of the TableView that inherit from this class
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        //makes this class delegate and enables the implementation of all the methods for a swipe cell
        cell.delegate = self

        return cell
    }
    
    //the requered delegate method
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
            
        }else{
            
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
    
    func colorize (hex: Int, alpha: Double = 1.0) -> UIColor {
        let red = Double((hex & 0xFF0000) >> 16) / 255.0
        let green = Double((hex & 0xFF00) >> 8) / 255.0
        let blue = Double((hex & 0xFF)) / 255.0
        let color: UIColor = UIColor( red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha:CGFloat(alpha) )
        return color
    }
}


