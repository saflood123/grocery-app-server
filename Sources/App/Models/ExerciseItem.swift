//
//  GroceryItem.swift
//  grocery-app-server
//
//  Created by stuart flood on 29/12/2024.
//
import Foundation
import Fluent
import Vapor

final class ExerciseItem: Model {
    static let schema = "exercise_items"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "gender")
    var gender: String
    
    @Field(key: "age")
    var age: Int
    
    @Field(key: "weight")
    var weight: Int
    
//    @Parent(key: "user_id")
//    var user: User
    @Parent(key: "grocery_category_id")
    var groceryCategory: GroceryCategory
    
    init() {
        
    }
   // init(id: UUID? = nil, gender: String, age: Int, weight: Float, groceryCategoryId: UUID) {
    init(id: UUID? = nil, gender: String, age: Int, weight: Int,groceryCategoryId: UUID) {
        self.gender = gender
        self.age = age
        self.weight = weight
        self.$groceryCategory.id = groceryCategoryId
      //  self.$user.id = userId
        
        
    }
    
}
