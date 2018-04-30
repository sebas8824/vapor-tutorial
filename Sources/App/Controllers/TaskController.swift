//
//  File.swift
//  Run
//
//  Created by Sebastian on 4/30/18.
//

import Foundation
import Vapor

class TaskController {
    
    func getTaskById(request: Request) -> ResponseRepresentable {
        guard let taskId = request.parameters["taskId"]?.int else {
            fatalError("taskId not found")
        }
        
        return "taskId is \(taskId)"
    }
    
    func getAllTasks(request: Request) -> ResponseRepresentable {
        return "Get all tasks"
    }
}
