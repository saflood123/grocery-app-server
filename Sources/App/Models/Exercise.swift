//
//  File.swift
//  grocery-app-server
//
//  Created by stuart flood on 22/12/2024.
//

import Foundation
import Fluent
import Vapor

final class Exercise: Model, Content {
    
    static let schema = "exercise_items"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "exercisename")
    var exercisename: String
    
    @Field(key: "category")
    var category: String
    
    init() {}
    
    init(id: UUID? = nil, exercisename: String, category: String) {
        self.id = id
        self.exercisename = exercisename
        self.category = category
        
    }
//    static func validations(_ validations: inout Validations) {
//        validations.add("username", as: String.self, is: !.empty,customFailureDescription: "Username must not be empty")
//        validations.add("password", as: String.self, is: !.empty,customFailureDescription: "Password must not be empty")
//        
//        //between 6 and 10 characters
//        validations.add("password", as: String.self, is: .count(6...10),customFailureDescription: "Password must be between 6 and 10 characters")
//   
//    }
}
