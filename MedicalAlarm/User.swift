//
//  User.swift
//  MedicalAlarm
//
//  Created by Crescenzo Garofalo on 09/11/17.
//  Copyright © 2017 Crescenzo Garofalo. All rights reserved.
//

import Foundation

class Users : NSObject {
    
    private var id: Int?
    private var name: String?
    private var age: String?
    private var sex: String?
    private var hasPhoto: Bool = false
    private var photo : String?
    
    init(id: Int, name: String, age: String, sex: String, photo: String, hasPhoto: Bool) {
        self.id = id
        self.name = name
        self.age = age
        self.sex = sex
        self.photo = photo
        self.hasPhoto = hasPhoto
    }

    public func getId() -> Int? {
        return id
    }
    
    public func setId(id: Int) {
        self.id = id
    }

    public func getName() -> String? {
        return name
    }
    
    public func setName(name: String) {
        self.name = name
    }

    public func getAge() -> String? {
        return age
    }
    
    public func setAge(age: String) {
        self.age = age
    }

    public func getSex() -> String? {
        return sex
    }
    
    public func setSex(sex: String) {
        self.sex = sex
    }

    public func getHasPhoto() -> Bool {
        return hasPhoto
    }
    
    public func setHasPhoto(hasPhoto: Bool) {
        self.hasPhoto = hasPhoto
    }
    
    public func getPhoto() -> String? {
        return photo
    }
    
    public func setPhoto(photo: String) {
        self.photo = photo
    }
    
    override var description: String {
        return "Name : \(name), age: \(age), sex: \(sex)"
    }
    
}
