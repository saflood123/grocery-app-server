//
//  File.swift
//  grocery-app-server
//
//  Created by stuart flood on 28/12/2024.
//

import Foundation
import GroceryAppShareDTO
import Vapor
import Fluent

class GroceryController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        
        // /api/users/:userId [Protected route]
        let api = routes.grouped("api", "users", ":userId").grouped(JSONWebTokenAuthenticator())
        
        
        // post: saving a grocerycategory
        // /api/users/:userId/grocery-categories
        api.post("grocery-categories", use: saveGroceryCategory)
        
        // get: /api/users/:userId/grocery-categories
        api.get("grocery-categories", use: getGroceryCategoriesByUser)
        
        // delete /api/users/:userId/grocery-categories/:groceryCategoryId
        api.delete("grocery-categories", ":groceryCategoryId", use: deleteGroceryCategory)
        
        // post: /api/users/:userid/grocery_categories/:groceryCategoryId/grocery-items
        api.post("grocery-categories", ":groceryCategoryId", "grocery-items", use: saveGroceryItem)
        
        // put: /api/users/:userid/grocery_categories/:groceryCategoryId/grocery-items2
        api.put("grocery-categories", ":groceryCategoryId", "grocery-items2", use: updateGroceryItem2)
        
        // put: /api/users/:userid/grocery_categories/:groceryCategoryId/grocery-items
        api.put("grocery-categories", ":groceryCategoryId", "grocery-items", use: updateGroceryItem)
        
        // post: /api/users/:userid/grocery_categories/:groceryCategoryId/grocery-items2
        api.post("grocery-categories", ":groceryCategoryId", "grocery-items2", use: saveGroceryItem2)
        
        // post: /api/users/:userid/grocery_categories/:groceryCategoryId/grocery-items3
        api.post("grocery-categories", ":groceryCategoryId", "grocery-items3", use: saveGroceryItem3)
     
        // post: /api/users/:userid/grocery_categories/:groceryCategoryId/grocery-items3
        api.post("grocery-categories", ":groceryCategoryId", "grocery-items4", use: saveGroceryItem4)
     
        // get: /api/users/:userid/grocery_categories/:groceryCategoryId/grocery-items
        api.get("grocery-categories", ":groceryCategoryId", "grocery-items", use: getGroceryItemsByGroceryCategory)
        
        // get: /api/users/:userid/grocery_categories/:groceryCategoryId/grocery-items
        api.get("grocery-categories", ":groceryCategoryId", "grocery-items2", use: getGroceryItems2ByGroceryCategory)
        
        // DELETE /api/users/:userid/grocery_categories/:groceryCategoryId/grocery-items/"groceryitemId
        api.delete("grocery-categories", ":groceryCategoryId", "grocery-items", ":groceryItemId", use: deleteGroceryItem)
        
        api.delete("grocery-categories", ":groceryCategoryId", "grocery-items2", ":groceryItemId", use: deleteGroceryItem2)
        
        // post: /api/users/:userid/grocery_categories/:groceryCategoryId/exercise-items
        api.post("grocery-categories", ":groceryCategoryId", "exercise-items", use: saveExercise)
        
        func saveGroceryItem(req: Request) async throws -> GroceryItemResponseDTO {
            
            guard let userId = req.parameters.get("userId", as: UUID.self),
                  let groceryCategoryId = req.parameters.get("groceryCategoryId", as: UUID.self)   else {
                throw Abort(.badRequest)
            }
            //find the user
            guard let _ = try await User.find(userId, on: req.db) else {
                throw Abort(.notFound)
            }
            //find the grocery category
            guard let groceryCategory = try await GroceryCategory.query(on: req.db)
                .filter(\.$user.$id == userId)
                .filter(\.$id == groceryCategoryId)
                .first() else {
                throw Abort(.notFound)
            }
            //decoding // groceryItemRequestDTo
            let groceryItemRequestDTO = try req.content.decode(GroceryItemRequestDTO.self)
            let groceryItem = GroceryItem(title: groceryItemRequestDTO.title, price: groceryItemRequestDTO.price, quantity: groceryItemRequestDTO.quantity, groceryCategoryId: groceryCategory.id!)
            
            try await groceryItem.save(on: req.db)
            
            guard let groceryItemResponseDTO = GroceryItemResponseDTO(groceryItem) else {
                throw Abort(.internalServerError)
            }
            return groceryItemResponseDTO
        }
        
        func updateGroceryItem(req: Request) async throws -> GroceryItemResponseDTO {
            guard let userId = req.parameters.get("userId", as: UUID.self),
                  let groceryCategoryId = req.parameters.get("groceryCategoryId", as: UUID.self)   else {
                throw Abort(.badRequest)
            }
            //find the user
            guard let _ = try await User.find(userId, on: req.db) else {
                throw Abort(.notFound)
            }
            //find the grocery category
            guard let groceryCategory = try await GroceryCategory.query(on: req.db)
                .filter(\.$user.$id == userId)
                .filter(\.$id == groceryCategoryId)
                .first() else {
                throw Abort(.notFound)
            }
            
            guard let groceryItem = try await GroceryItem.find(groceryCategoryId, on: req.db) else
            {
                throw Abort(.notFound)
            }
            
            let updateGroceryItem = try req.content.decode(GroceryItem.self)
            
            groceryItem.title = updateGroceryItem.title
            
            try await groceryItem.update(on: req.db)
            //  return groceryItem
            
            //            guard let groceryItemResponseDTO = GroceryItemResponseDTO(groceryItem) else {
            //                throw Abort(.internalServerError)
            //            }
            //            return groceryItemResponseDTO
            guard let groceryItem = GroceryItemResponseDTO(groceryItem) else {
                throw Abort(.internalServerError)
            }
            return groceryItem
        }
        
        func updateGroceryItem2(req: Request) async throws -> GroceryItem2ResponseDTO {
            guard let userId = req.parameters.get("userId", as: UUID.self),
                  let groceryCategoryId = req.parameters.get("groceryCategoryId", as: UUID.self)   else {
                throw Abort(.badRequest)
            }
            //find the user
            guard let _ = try await User.find(userId, on: req.db) else {
                throw Abort(.notFound)
            }
            //find the grocery category
            guard let groceryCategory = try await GroceryCategory.query(on: req.db)
                .filter(\.$user.$id == userId)
                .filter(\.$id == groceryCategoryId)
                    //.sort(\.$date_updated, .descending)
                .first() else {
                throw Abort(.notFound)
            }
            //decoding // groceryItemRequestDTo
            let groceryItem2RequestDTO = try req.content.decode(GroceryItem2RequestDTO.self)
            let groceryItem2 = GroceryItem2(title: groceryItem2RequestDTO.title, price: groceryItem2RequestDTO.price, quantity: groceryItem2RequestDTO.quantity, calories: groceryItem2RequestDTO.calories, steps: groceryItem2RequestDTO.steps,dateofbirth: groceryItem2RequestDTO.dateofbirth, groceryCategoryId: groceryCategory.id!,date_updated: groceryItem2RequestDTO.date_updated)
            
            try await groceryItem2.update(on: req.db)
            
            guard let groceryItem2ResponseDTO = GroceryItem2ResponseDTO(groceryItem2) else {
                throw Abort(.internalServerError)
            }
            return groceryItem2ResponseDTO
        }
        
        func saveGroceryItem2(req: Request) async throws -> GroceryItem2ResponseDTO {
            
            guard let userId = req.parameters.get("userId", as: UUID.self),
                  let groceryCategoryId = req.parameters.get("groceryCategoryId", as: UUID.self)   else {
                throw Abort(.badRequest)
            }
            //find the user
            guard let _ = try await User.find(userId, on: req.db) else {
                throw Abort(.notFound)
            }
            //find the grocery category
            guard let groceryCategory = try await GroceryCategory.query(on: req.db)
                .filter(\.$user.$id == userId)
                .filter(\.$id == groceryCategoryId)
                .first() else {
                throw Abort(.notFound)
            }
            //decoding // groceryItemRequestDTo
            let groceryItem2RequestDTO = try req.content.decode(GroceryItem2RequestDTO.self)
            let groceryItem2 = GroceryItem2(title: groceryItem2RequestDTO.title, price: groceryItem2RequestDTO.price, quantity: groceryItem2RequestDTO.quantity, calories: groceryItem2RequestDTO.calories,steps: groceryItem2RequestDTO.steps,dateofbirth: groceryItem2RequestDTO.dateofbirth, groceryCategoryId: groceryCategory.id!,date_updated: groceryItem2RequestDTO.date_updated)
            
            try await groceryItem2.save(on: req.db)
            
            guard let groceryItem2ResponseDTO = GroceryItem2ResponseDTO(groceryItem2) else {
                throw Abort(.internalServerError)
            }
            return groceryItem2ResponseDTO
        }
        func saveGroceryItem3(req: Request) async throws -> GroceryItem3ResponseDTO {
            
            guard let userId = req.parameters.get("userId", as: UUID.self),
                  let groceryCategoryId = req.parameters.get("groceryCategoryId", as: UUID.self)   else {
                throw Abort(.badRequest)
            }
            //find the user
            guard let _ = try await User.find(userId, on: req.db) else {
                throw Abort(.notFound)
            }
            //find the grocery category
            guard let groceryCategory = try await GroceryCategory.query(on: req.db)
                .filter(\.$user.$id == userId)
                .filter(\.$id == groceryCategoryId)
                .first() else {
                throw Abort(.notFound)
            }
            //decoding // groceryItemRequestDTo
            let groceryItem3RequestDTO = try req.content.decode(GroceryItem3RequestDTO.self)
            let groceryItem3 = GroceryItem3(title: groceryItem3RequestDTO.title, price: groceryItem3RequestDTO.price, quantity: groceryItem3RequestDTO.quantity,foodtype: groceryItem3RequestDTO.foodtype, groceryCategoryId: groceryCategory.id!)
            
            try await groceryItem3.save(on: req.db)
            
            guard let groceryItem3ResponseDTO = GroceryItem3ResponseDTO(groceryItem3) else {
                throw Abort(.internalServerError)
            }
            return groceryItem3ResponseDTO
        }
        func saveGroceryItem4(req: Request) async throws -> GroceryItem4ResponseDTO {
            
            guard let userId = req.parameters.get("userId", as: UUID.self),
                  let groceryCategoryId = req.parameters.get("groceryCategoryId", as: UUID.self)   else {
                throw Abort(.badRequest)
            }
            //find the user
            guard let _ = try await User.find(userId, on: req.db) else {
                throw Abort(.notFound)
            }
            //find the grocery category
            guard let groceryCategory = try await GroceryCategory.query(on: req.db)
                .filter(\.$user.$id == userId)
                .filter(\.$id == groceryCategoryId)
                .first() else {
                throw Abort(.notFound)
            }
            //decoding // groceryItemRequestDTo
            let groceryItem4RequestDTO = try req.content.decode(GroceryItem4RequestDTO.self)
            let groceryItem4 = GroceryItem4(title: groceryItem4RequestDTO.title, price: groceryItem4RequestDTO.price, quantity: groceryItem4RequestDTO.quantity, groceryCategoryId: groceryCategory.id!)
            
            try await groceryItem4.save(on: req.db)
            
            guard let groceryItem4ResponseDTO = GroceryItem4ResponseDTO(groceryItem4) else {
                throw Abort(.internalServerError)
            }
            return groceryItem4ResponseDTO
        }
        func saveExercise(req: Request) async throws -> ExerciseResponseDTO {
            
            guard let userId = req.parameters.get("userId", as: UUID.self),
                  let groceryCategoryId = req.parameters.get("groceryCategoryId", as: UUID.self)   else {
                throw Abort(.badRequest)
            }
            //find the user
            guard let _ = try await User.find(userId, on: req.db) else {
                throw Abort(.notFound)
            }
            //find the grocery category
            guard let groceryCategory = try await GroceryCategory.query(on: req.db)
                .filter(\.$user.$id == userId)
                .filter(\.$id == groceryCategoryId)
                .first() else {
                throw Abort(.notFound)
            }
            //decoding // groceryItemRequestDTo
            let exerciseRequestDTO = try req.content.decode(ExerciseRequestDTO.self)
            let exerciseItem = ExerciseItem(gender: exerciseRequestDTO.gender,age: exerciseRequestDTO.age, weight: exerciseRequestDTO.weight, groceryCategoryId: groceryCategory.id!)
            
            try await exerciseItem.save(on: req.db)
            
            guard let exerciseResponseDTO = ExerciseResponseDTO(exerciseItem) else {
                throw Abort(.internalServerError)
            }
            return exerciseResponseDTO
        }
        func deleteGroceryItem(req: Request) async throws -> GroceryItemResponseDTO {
            
            guard let userId = req.parameters.get("userId", as: UUID.self),
                  let groceryCategoryId = req.parameters.get("groceryCategoryId", as: UUID.self),
                  let groceryItemId = req.parameters.get("groceryItemId", as: UUID.self)
            else {
                throw Abort(.badRequest)
            }
            guard let groceryCategory = try await GroceryCategory.query(on: req.db)
                .filter(\.$user.$id == userId)
                .filter(\.$id == groceryCategoryId)
                .first() else {
                throw Abort(.notFound)
            }
            guard let groceryItem = try await GroceryItem.query(on: req.db)
                .filter(\.$id == groceryItemId)
                .filter(\.$groceryCategory.$id == groceryCategory.id!)
                .first() else {
                throw Abort(.notFound)
            }
            try await groceryItem.delete(on: req.db)
            
            guard let groceryItemResponseDTO = GroceryItemResponseDTO(groceryItem) else {
                throw Abort(.internalServerError)
            }
            return groceryItemResponseDTO
        }
        func deleteGroceryItem2(req: Request) async throws -> GroceryItem2ResponseDTO {
            
            guard let userId = req.parameters.get("userId", as: UUID.self),
                  let groceryCategoryId = req.parameters.get("groceryCategoryId", as: UUID.self),
                  let groceryItemId = req.parameters.get("groceryItemId", as: UUID.self)
            else {
                throw Abort(.badRequest)
            }
            guard let groceryCategory = try await GroceryCategory.query(on: req.db)
                .filter(\.$user.$id == userId)
                .filter(\.$id == groceryCategoryId)
                .first() else {
                throw Abort(.notFound)
            }
            guard let groceryItem = try await GroceryItem2.query(on: req.db)
                .filter(\.$id == groceryItemId)
                .filter(\.$groceryCategory.$id == groceryCategory.id!)
                .first() else {
                throw Abort(.notFound)
            }
            try await groceryItem.delete(on: req.db)
            
            guard let groceryItem2ResponseDTO = GroceryItem2ResponseDTO(groceryItem) else {
                throw Abort(.internalServerError)
            }
            return groceryItem2ResponseDTO
        }
        func getGroceryItemsByGroceryCategory(req: Request) async throws -> [GroceryItemResponseDTO] {
            
            guard let userId = req.parameters.get("userId", as: UUID.self),
                  let groceryCategoryId = req.parameters.get("groceryCategoryId", as: UUID.self)
            else {
                throw Abort(.badRequest)
            }
            // validate the userId
            guard let _ = try await User.find(userId, on: req.db) else {
                throw Abort(.notFound)
            }
            //find the grocery category
            guard let groceryCategory = try await GroceryCategory.query(on: req.db)
                .filter(\.$user.$id == userId)
                .filter(\.$id == groceryCategoryId)
                .first() else {
                throw Abort(.notFound)
            }
            return try await GroceryItem.query(on: req.db)
                .filter(\.$groceryCategory.$id == groceryCategory.id!)
                .all()
                .compactMap(GroceryItemResponseDTO.init)
            
        }
        func getGroceryItems2ByGroceryCategory(req: Request) async throws -> [GroceryItem2ResponseDTO] {
            
            guard let userId = req.parameters.get("userId", as: UUID.self),
                  let groceryCategoryId = req.parameters.get("groceryCategoryId", as: UUID.self)
            else {
                throw Abort(.badRequest)
            }
            // validate the userId
            guard let _ = try await User.find(userId, on: req.db) else {
                throw Abort(.notFound)
            }
            //find the grocery category
            guard let groceryCategory = try await GroceryCategory.query(on: req.db)
                .filter(\.$user.$id == userId)
                .filter(\.$id == groceryCategoryId)
                    //  .sort(\.$date_updated, .descending)
                .first() else {
                throw Abort(.notFound)
            }
            return try await GroceryItem2.query(on: req.db)
                .filter(\.$groceryCategory.$id == groceryCategory.id!)
                .all()
                .compactMap(GroceryItem2ResponseDTO.init)
            
        }
        
        
        
        
        
        
        
        func deleteGroceryCategory(req: Request) async throws -> GroceryCategoryResponseDTO {
            
            //get the userid, grocerycategoryId
            guard let userId = req.parameters.get("userId", as: UUID.self),
                  let groceryCategoryId = req.parameters.get("groceryCategoryId", as: UUID.self) else {
                throw Abort(.badRequest)
            }
            
            guard let groceryCategory = try await GroceryCategory.query(on: req.db)
                .filter(\.$user.$id == userId)
                .filter(\.$id == groceryCategoryId)
                .first() else {
                throw Abort(.notFound)
            }
            try await groceryCategory.delete(on: req.db)
            
            guard let groceryCategoryResponseDTO = GroceryCategoryResponseDTO(groceryCategory) else {
                throw Abort(.internalServerError)
            }
            
            return groceryCategoryResponseDTO
        }
        
        func getGroceryCategoriesByUser(req: Request) async throws -> [GroceryCategoryResponseDTO] {
            
            //get the userId
            guard let userId = req.parameters.get("userId", as: UUID.self) else {
                throw Abort(.badRequest)
            }
            return try await GroceryCategory.query(on: req.db)
                .filter(\.$user.$id == userId)
                .all()
                .compactMap(GroceryCategoryResponseDTO.init)
            
        }
        
        func saveGroceryCategory(req: Request) async throws -> GroceryCategoryResponseDTO {
            // get the userId
            guard let userId = req.parameters.get("userId", as: UUID.self) else {
                throw Abort(.badRequest)
            }
            // DTO for the request
            let groceryCategoryRequestDTO = try req.content.decode(GroceryCategoryRequestDTO.self)
            
            let groceryCategory = GroceryCategory(title: groceryCategoryRequestDTO.title, colorCode:
                                                    groceryCategoryRequestDTO.colorCode, userId: userId)
            
            try await groceryCategory.save(on: req.db)
            
            guard let groceryCategoryResponseDTO = GroceryCategoryResponseDTO(groceryCategory) else {
                throw Abort(.internalServerError)
            }
            
            return groceryCategoryResponseDTO
        }
        
        //        func saveExercise(req: Request) async throws -> ExerciseResponseDTO {
        //            // get the userId
        //            guard let userId = req.parameters.get("userId", as: UUID.self) else {
        //                throw Abort(.badRequest)
        //            }
        //
        //            // validate the user exists
        //                guard let _ = try await User.find(userId, on: req.db) else {
        //                throw Abort(.notFound)
        //            }
        //
        //            // decode the request
        //            let exerciseRequestDTO = try req.content.decode(ExerciseItem.self)
        //
        //            // create the exercise item
        //            let exerciseItem = ExerciseItem(
        //                gender: exerciseRequestDTO.gender,
        //                age: exerciseRequestDTO.age,
        //                weight: exerciseRequestDTO.weight,
        //                userId: userId
        //            )
        //
        //            try await exerciseItem.save(on: req.db)
        //
        //            guard let exerciseResponseDTO = ExerciseResponseDTO(exerciseItem) else {
        //                throw Abort(.internalServerError)
        //            }
        //
        //            return exerciseResponseDTO
        //        }
        //    }
      
    }
}
