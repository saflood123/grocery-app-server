//
//  JSONWebTokenAuthenticator.swift
//  grocery-app-server
//
//  Created by stuart flood on 02/01/2025.
//
import Foundation
import Vapor

struct JSONWebTokenAuthenticator: AsyncRequestAuthenticator {
    func authenticate(request: Request) async throws {
        try request.jwt.verify(as: AuthPayload.self)
        }
}
