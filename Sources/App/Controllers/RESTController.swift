//
//  RESTController.swift
//  hello-vapor
//
//  Created by Sebastian on 5/5/18.
//

import Foundation
import Vapor
import HTTP

// Help yourself using the PostController.swift

final class RESTController: ResourceRepresentable {
    
    // Root route: htttp://localhost:8080/tasks
    // Get request that returns all
    func index(_ req:Request) throws -> ResponseRepresentable {
        return "Index"
    }
    
    // Post request
    func create(_ req:Request) throws -> ResponseRepresentable {
        return "Create"
    }
    
    // Patch request
    func update(_ req:Request, post: String) throws -> ResponseRepresentable {
        return "Update"
    }
    
    // Get request with parameters
    func show(_ req:Request, post: String) throws -> ResponseRepresentable {
        return "Show"
    }
    
    // Delete request with parameters
    func delete(_ req:Request, post: String) throws -> ResponseRepresentable {
        return "Delete"
    }
    
    // Conforming ResourceRepresentable protocol
    func makeResource() -> Resource<String> {
        // Mapping the response
        return Resource(
            index:index,
            store:create,
            show:show,
            update:update,
            destroy:delete
        )
    }
    
}

// Allowing to initialize the controller empty
extension RESTController: EmptyInitializable {}
