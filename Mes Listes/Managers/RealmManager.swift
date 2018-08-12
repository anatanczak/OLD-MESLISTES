//
//  RealmManager.swift
//  Costless
//
//  Created by Vladyslav Tkach on 03.10.17.
//  Copyright © 2017 Sannacode. All rights reserved.
//

import Foundation
import RealmSwift


enum RealmAccessThread {
    case main
    case background
}

class RealmManager: NSObject {
    
    static let shared = RealmManager()
    static let accessThreadLabel = "com.mes.listes.background.realm"
    
    let operationQueue = DispatchQueue(label: accessThreadLabel)
    
    override init() {
        super.init()
        print("\n\nRealm DB Path: \(String(describing: Realm.Configuration.defaultConfiguration.fileURL)) \n\n")
    }
    
    //MARK: - Configuration
    internal func getRealm() -> Realm {
        let config = Realm.Configuration()
        let realm = try! Realm(configuration: config)
        return realm
    }
    
    internal func getCurrentThread(thread: RealmAccessThread) -> DispatchQueue {
        var currentThread = operationQueue
        
        if thread == .background {
            currentThread = operationQueue
        } else if thread == .main {
            currentThread = DispatchQueue.main
        }
        return currentThread
    }
    
    public func convert(models: [Object], toThread thread: RealmAccessThread, completion: @escaping ([Object]) -> ()) {
        
        // 1. Find managed object to get his realm
        // 2. Find original thread and switch to this thread
        
        var managed = [ThreadSafeReference<Object>]()
        var unmanaged = [Object]()
        
        for model in models {
            if model.realm == nil {
                unmanaged.append(model)
            } else {
                managed.append(ThreadSafeReference(to: model))
            }
        }
        
        self.getCurrentThread(thread: thread).async {
            autoreleasepool {
                let realm = self.getRealm()
                
                var resolvedModels = [Object]()
                
                for ref in managed {
                    if let m = realm.resolve(ref) {
                        resolvedModels.append(m)
                    }
                }
                
                resolvedModels.append(contentsOf: unmanaged)
                
                completion(resolvedModels)
            }
        }
    }
    
    public func convert(model: Object, toThread thread: RealmAccessThread, completion: @escaping (Object?) -> ()) {
        let modelRef = ThreadSafeReference(to: model)
        
        getCurrentThread(thread: thread).async {
            autoreleasepool {
                let realm = self.getRealm()
                
                if model.realm == nil {
                    completion(model)
                    return
                }
                
                guard let m = realm.resolve(modelRef) else {
                    completion(nil)
                    return
                }
                
                completion(m)
            }
        }
    }
}

//MARK: - Liste Objects
extension RealmManager {
    
    func createListe(name: String) {
        operationQueue.async { [weak self] in
            guard let `self` = self else { return }
            
            let liste = Liste()
            liste.name = name
            
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            
            let key = dateFormatter.string(from: date)
            
            liste.id = key
            
            let realm = self.getRealm()
            
            if realm.object(ofType: Liste.self, forPrimaryKey: key) == nil {
                realm.beginWrite()
                realm.add(liste, update: true)
                try! realm.commitWrite()
            }
        }
        }
    
    func getListes() -> [Liste] {
        let realm = self.getRealm()
        
        let array = Array(realm.objects(Liste.self))
        return array
    }
  
    }
    
    //MARK: -  Item Objects
    extension RealmManager {
        
        func createItem(title: String) {
            operationQueue.async { [weak self] in
                guard let `self` = self else { return }
                
                let item = Item()
                item.title = title
                
                let date = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                
                let key = dateFormatter.string(from: date)
                
                item.id = key
                
                let realm = self.getRealm()
                
                if realm.object(ofType: Item.self, forPrimaryKey: key) == nil {
                    realm.beginWrite()
                    realm.add(item, update: true)
                    try! realm.commitWrite()
                }
            }
        }
        
        func getAllItems() -> [Item] {
            let realm = self.getRealm()
            
            let array = Array(realm.objects(Item.self))
            return array
        }
        
        func getAllItems(forListName list: String) -> [Item] {
            
            let realm = self.getRealm()
            
            let result = Array(realm.objects(Item.self).filter("parentListName = '\(list)'"))
            return result
        }
        
        //update
        
        //delete
        
}


