//
//  File.swift
//  grocery-app-server
//
//  Created by stuart flood on 22/12/2024.
//

import Foundation
import Fluent

struct CreateExerciseTypeTableMigration: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("exercise_items")
            .id()
            .field("gender", .string, .required)//.unique(on: "exerciseName")
            .field("age", .string, .required)
            .field("weight", .string, .required)
            .field("user_id", .uuid, .required, .references("users","id"))
            .create()
    }
    //undo
    func revert(on database: Database) async throws {
        try await database.schema("exercise_items")
            .delete()
    }
}
