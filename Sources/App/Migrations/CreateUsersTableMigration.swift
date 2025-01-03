//
//  File.swift
//  grocery-app-server
//
//  Created by stuart flood on 22/12/2024.
//

import Foundation
import Fluent

struct CreateUsersTableMigration: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("users")
            .id()
            .field("username", .string, .required).unique(on: "username")
            .field("password", .string, .required)
            .field("email", .string, .required)
            .create()
    }
    //undo
    func revert(on database: Database) async throws {
        try await database.schema("users")
            .delete()
    }
}
