//
//  NewTaskViewModel.swift
//  TestProject
//
//  Created by Дмитрий Забиякин on 24.01.2025.
//

import UIKit

final class NewTaskViewModel {
    
    private var todos: [Todos] = []
        
    /// Сохранение новой задачи
    /// - Parameter toDoText: название задачи
    func saveNewTask(toDoText: String?, toDoComment: String?, toDoDate: Date?, completion: @escaping(Result<Void, Error>) -> Void) {
        guard let toDoText = toDoText, !toDoText.isEmpty else {
            print("Имя задачи не может быть пустым")
            return
        }
        CoreDataManager.shared.saveNewTask(
            todo: toDoText,
            commentToDo: toDoComment,
            date: toDoDate,
            completion: completion)
    }
    
    func reloadTask() {
        CoreDataManager.shared.perfomFetch()
    }
    
    func reloadToDoFromCoreData() {
        if let coreDataTodos = CoreDataManager.shared.fetchTodosFromCoreData() {
            self.todos = coreDataTodos
        }
    }
}
