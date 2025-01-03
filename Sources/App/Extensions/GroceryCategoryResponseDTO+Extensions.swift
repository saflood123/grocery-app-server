//
//  GroceryCategoryResponseDTO+Extensions.swift
//  grocery-app-server
//
//  Created by stuart flood on 28/12/2024.
//
import Foundation
import GroceryAppShareDTO
import Vapor

extension GroceryCategoryResponseDTO: Content {
    
    init?(_ groceryCategory: GroceryCategory) {
        
        guard let id = groceryCategory.id
        else {
            return nil
            }
        self.init(id: id, title: groceryCategory.title, colorCode: groceryCategory.colorCode)
    }
}
