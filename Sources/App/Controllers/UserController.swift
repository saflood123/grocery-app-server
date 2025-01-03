//
//  File.swift
//  grocery-app-server
//
//  Created by stuart flood on 22/12/2024.
//

import Foundation
import Fluent
import Vapor
import GroceryAppShareDTO

// /api/register
// /api/login

class UserController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        
        let api = routes.grouped("api")
        
        // /api/register
        api.post("register", use: register)
        
        // api/login
        api.post("login", use: login)
    }
    
    func login(req: Request) async throws -> LoginResponseDTO {
        
        //decode the request
       let user = try req.content.decode(User.self)
        
        //check is user exists in the database
        guard let existingUser = try await User.query(on: req.db)
            .filter(\.$username == user.username)
            .first() else {
            return LoginResponseDTO(error: true, reason: "username not found")
            }
        
        //validate the password
        let result = try await req.password.async.verify(user.password, created: existingUser.password)
        
        if !result {
            return LoginResponseDTO(error: true, reason: "Password incorrect")
        }
            
            //generate the token and return it to the user
        let authPayload = try AuthPayload(expiration: .init(value: .distantFuture), userId: existingUser.requireID())
        return try LoginResponseDTO(error: false, token: req.jwt.sign(authPayload), userId: existingUser.requireID())

    }
    
    func register(req: Request) async throws -> RegisterResponseDTO {
        //validate the user //validations
        try User.validate(content: req)
        
        let user =  try req.content.decode(User.self)
        
        //find if user already exists using username
        if let _ = try await User.query(on: req.db)
            .filter(\.$username == user.username)
            .first() {
            throw Abort(.conflict, reason: "Username already exists")
        }
        //hash the password
        user.password = try await req.password.async.hash(user.password)
        
        //save the user
        try await user.save(on: req.db)
        
        
        return RegisterResponseDTO(error: false)
        
    }
        
    
}
