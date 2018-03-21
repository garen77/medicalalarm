//
//  DatabaseManager.swift
//  MedicalAlarm
//
//  Created by Crescenzo Garofalo on 08/11/17.
//  Copyright © 2017 Crescenzo Garofalo. All rights reserved.
//

import Foundation
import CoreData

class DatabaseManager {
    
    var appDelegate: AppDelegate?
    
    static var sharedInstance: DatabaseManager?
    
    var users : [Users] = []
    
    var listController: ListTableViewController?
    
    var documentsUrl : URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    public static func initInstance(appDelegate: AppDelegate) {
        if sharedInstance == nil {
            sharedInstance = DatabaseManager(appDelegate: appDelegate)
        }
    }
    
    private init(appDelegate: AppDelegate) {
        self.appDelegate = appDelegate
    }
    
    func save(userModel: Users) -> Bool {
        var res = false
        
        if appDelegate != nil {
            let managedContext = appDelegate?.persistentContainer.viewContext
            let fetchRequest : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "User")
            if userModel.getId() != nil && userModel.getId()! > 0 {
                let userPredicate = NSPredicate(format: "id = \(userModel.getId()!)", argumentArray: nil)
                
                fetchRequest.predicate = userPredicate
                do {
                    let userListUpdate = try managedContext?.fetch(fetchRequest)
                    if userListUpdate?.count == 1 {
                        let user = userListUpdate![0] as! NSManagedObject
                        user.setValue(userModel.getName(), forKey: "name")
                        user.setValue(userModel.getAge(), forKey: "age")
                        user.setValue(userModel.getSex(), forKey: "sex")
                        user.setValue(userModel.getPhoto(), forKey: "photo")
                        user.setValue(userModel.getHasPhoto(), forKey: "hasPhoto")
                        try managedContext?.save()
                    }
                    
                } catch let fetchError as NSError {
                    print("Could not retrieve record. \(fetchError)")
                }
            } else {
                
                do {
                    
                    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
                    
                    var recordId = 1
                    let userListNew = try managedContext?.fetch(fetchRequest)
                    if !(userListNew?.isEmpty)! {
                        let userRead = userListNew![0] as! NSManagedObject
                        if let lastRecordId = userRead.value(forKey: "id") {
                            recordId = Int(lastRecordId as! Int16) + 1
                        }
                    }

                    let userEntity = NSEntityDescription.entity(forEntityName: "User", in: managedContext!)!
                    let userNew = NSManagedObject(entity: userEntity, insertInto: managedContext!)
                    userNew.setValue(recordId, forKey: "id")
                    userNew.setValue(userModel.getName(), forKey: "name")
                    userNew.setValue(userModel.getAge(), forKey: "age")
                    userNew.setValue(userModel.getSex(), forKey: "sex")
                    userNew.setValue(userModel.getPhoto(), forKey: "photo")
                    userNew.setValue(userModel.getHasPhoto(), forKey: "hasPhoto")

                    try managedContext?.save()
                    
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
                
            }
        }
        
        return res
    }
    
    func load() {
        self.users = []
        var userModelList : [NSManagedObject] = []
        
        let managedContext = appDelegate?.persistentContainer.viewContext
        let fetchRequest : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "User")
        
        do {
            userModelList = try managedContext?.fetch(fetchRequest) as! [NSManagedObject]
        } catch let fetchError as NSError {
            print("Could not retrieve record. \(fetchError)")
        }
        
        for model in userModelList {
            let id = model.value(forKeyPath: "id") as! Int
            let name = model.value(forKeyPath: "name") as! String
            let age = model.value(forKeyPath: "age") as! String
            let sex = model.value(forKeyPath: "sex") as! String
            let photo = model.value(forKeyPath: "photo") as! String
            let hasPhoto = model.value(forKeyPath: "hasPhoto") as! Bool
            let user : Users = Users(id: id, name: name, age: age, sex: sex, photo: photo, hasPhoto: hasPhoto)
            users.append(user)
        }
        self.listController?.tableView.reloadData()
    }
    
    func delete(userModel: Users) {
        
        let managedContext = appDelegate?.persistentContainer.viewContext
        let fetchRequest : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "User")
        let userPredicate = NSPredicate(format: "id == \(userModel.getId()!)", argumentArray: nil)
        fetchRequest.predicate = userPredicate
        
        do {
            let userListToDelete = try managedContext?.fetch(fetchRequest)
            
            for object in userListToDelete! {
                managedContext?.delete(object as! NSManagedObject)
            }
            try managedContext?.save()
            
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
        self.load()
        self.listController?.tableView.reloadData()
    }
}


