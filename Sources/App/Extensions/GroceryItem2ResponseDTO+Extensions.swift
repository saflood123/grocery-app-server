//
//  GroceryItemResponseDTO+Extensions.swift
//  grocery-app-server
//
//  Created by stuart flood on 29/12/2024.
//

import Foundation
import GroceryAppShareDTO
import Vapor

extension GroceryItem2ResponseDTO: Content {
    
    init?(_ groceryItem: GroceryItem2) {
        
        guard let groceryItemId = groceryItem.id else {
            return nil
            }
        self.init(id: groceryItemId, title: groceryItem.title,price: groceryItem.price, quantity: groceryItem.quantity, calories: groceryItem.calories, steps: groceryItem.steps, dateofbirth: groceryItem.dateofbirth, date_updated: groceryItem.date_updated)
    }
}
