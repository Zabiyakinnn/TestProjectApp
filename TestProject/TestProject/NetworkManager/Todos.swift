//
//  Todos.swift
//  TestProject
//
//  Created by Дмитрий Забиякин on 22.01.2025.
//

import Foundation

struct Todo: Codable {
    var todos: [Todos]?
}

struct Todos: Codable {
    var id: Int?
    var todo: String?
    var completed: Bool?
    var userId: Int?
    var commentToDo: String?
    var date: Date?
}
