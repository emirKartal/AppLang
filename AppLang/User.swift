//
//  User.swift
//  AppLang
//
//  Created by cagdas on 03/06/2017.
//  Copyright © 2017 Emir Kartal. All rights reserved.
//

import Foundation

class User {
    var firstName: String?
    var lastName: String?
    var email: String?
    var image: String?
    
    init(firstName: String, lastName: String, email: String, image: String?) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.image = image
    }
}
