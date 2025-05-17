//
//  GroceryItem.swift
//  grocery-app-server
//
//  Created by stuart flood on 29/12/2024.
//
import Foundation
import Fluent
import Vapor

final class GroceryItem: Model {
    static let schema = "grocery_items"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "price")
    var price: Double
    
    @Field(key: "reps")
    var reps: Int
    
    @Field(key: "quantity")
    var quantity: Int
    
    @Field(key: "dateofbirth")
    var dateofbirth: String
    
    @Field(key: "date_updated")
    var date_updated: String
    
    @Parent(key: "grocery_category_id")
    var groceryCategory: GroceryCategory
    
    init() {
        
    }
    
    init(id: UUID? = nil, title: String, price: Double, reps: Int, quantity: Int, groceryCategoryId: UUID,dateofbirth: String,date_updated: String) {
        self.id = id
        self.title = title
        self.price = price
        self.reps = reps
        self.quantity = quantity
        self.$groceryCategory.id = groceryCategoryId
        self.dateofbirth = dateofbirth
        self.date_updated = date_updated
        
        
    }
    
}
