//
//  CreateGroceryItemTableMigration.swift
//  grocery-app-server
//
//  Created by stuart flood on 29/12/2024.
//
import Foundation
import Fluent

class CreateGroceryItem2TableMigration: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("grocery_items2")
            .id()
            .field("title", .string,  .required)
            .field("price", .double, .required)
            .field("quantity", .int, .required)
            .field("grocery_category_id", .uuid, .required, .references("grocery_categories","id", onDelete: .cascade))
            .create()
    }
    func revert(on database: any Database) async throws {
      try await database.schema("grocery_items2")
            .delete()
    }
}
