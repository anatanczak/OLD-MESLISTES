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
    static let accessThreadLabel = "com.costless.background.realm"
    
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
