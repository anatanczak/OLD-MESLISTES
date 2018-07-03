//
//  File.swift
//  Mes Listes
//
//  Created by Anastasiia Tanczak on 16/06/2018.
//  Copyright © 2018 Ana Viktoriv. All rights reserved.
//

import Foundation
import RealmSwift

class Liste: Object {
    @objc dynamic var name: String = ""
    
    //forward relationship to item class
 let items = List<Item>()
}
