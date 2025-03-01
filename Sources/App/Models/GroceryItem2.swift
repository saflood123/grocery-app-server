//
//  GroceryItem.swift
//  grocery-app-server
//
//  Created by stuart flood on 29/12/2024.
//
import Foundation
import Fluent
import Vapor

final class GroceryItem2: Model {
    static let schema = "grocery_items2"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "price")
    var price: Double
    
    @Field(key: "quantity")
    var quantity: Int
    
    @Field(key: "dateofbirth")
    var dateofbirth: String
    
    @Parent(key: "grocery_category_id")
    var groceryCategory: GroceryCategory
    
    init() {
        
    }
    
    init(id: UUID? = nil, title: String, price: Double, quantity: Int, dateofbirth: String, groceryCategoryId: UUID) {
        self.id = id
        self.title = title
        self.price = price
        self.quantity = quantity
        self.dateofbirth = dateofbirth
        self.$groceryCategory.id = groceryCategoryId
        
        
    }
    
}
