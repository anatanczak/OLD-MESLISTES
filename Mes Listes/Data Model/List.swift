//
//  File.swift
//  Mes Listes
//
//  Created by Anastasiia Tanczak on 16/06/2018.
//  Copyright © 2018 Ana Viktoriv. All rights reserved.
//

import Foundation
import RealmSwift

class List: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var reminderDate: Date?
    
    //forvad relationship to item class
    
}
