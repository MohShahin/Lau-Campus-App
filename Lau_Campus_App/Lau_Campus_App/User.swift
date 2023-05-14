//
//  User.swift
//  Lau_Campus_App
//
//  Created by Guest User on 5/2/23.
//

import UIKit

class User {
    var email: String
    var password: String
    var name: String
    var major: String
    var currentCourses: [String]
    var gpa: Float
    
    init(email: String, password: String, name: String, major: String, currentCourses: [String], gpa: Float) {
        self.email = email
        self.password = password
        self.name = name
        self.major = major
        self.currentCourses = currentCourses
        self.gpa = gpa
    }
}

