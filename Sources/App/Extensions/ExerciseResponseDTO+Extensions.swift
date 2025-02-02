//
//  GroceryItemResponseDTO+Extensions.swift
//  grocery-app-server
//
//  Created by stuart flood on 29/12/2024.
//

import Foundation
import GroceryAppShareDTO
import Vapor

extension ExerciseResponseDTO: Content {
    
    init?(_ exerciseItem: ExerciseItem) {
        
        guard let exerciseItemId = exerciseItem.id else {
            return nil
            }
        self.init(id: exerciseItemId, gender: exerciseItem.gender,age: exerciseItem.age, weight: exerciseItem.weight)
    }
}
