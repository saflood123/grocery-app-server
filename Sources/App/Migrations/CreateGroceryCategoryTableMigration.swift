//
//  File.swift
//  grocery-app-server
//
//  Created by stuart flood on 28/12/2024.
//

import Foundation
import Fluent

class CreateGroceryCategoryTableMigration: AsyncMigration {
    
    func prepare(on database: Database) async throws {
        try await database.schema("grocery_categories")
            .id()
            .field("title", .string, .required)
            .field("color_code", .string, .required)
            .field("user_id", .uuid, .required, .references("users","id"))
            .create()
    }
    func revert(on database: Database) async throws {
        try await database.schema("grocery_categories")
            .delete()
    }
}
