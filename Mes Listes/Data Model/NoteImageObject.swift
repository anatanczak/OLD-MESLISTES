//
//  NoteImageObject.swift
//  Mes Listes
//
//  Created by 1 on 22/08/2018.
//  Copyright © 2018 Ana Viktoriv. All rights reserved.
//

import Foundation

import RealmSwift

class NoteImageObject: Object {
    @objc dynamic var name          : String = ""
    @objc dynamic var pathString    : String = ""
    @objc dynamic var position      : Int = 0
    
}
