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
        try await database.schema("exercise")
            .id()
            .field("exercise", .string, .required).unique(on: "exercise")
            .field("category", .string, .required)
            //.field("email", .string, .required)
            .create()
    }
    //undo
    func revert(on database: Database) async throws {
        try await database.schema("exercise")
            .delete()
    }
}
