//
//  MainViewModel.swift
//  TestProject
//
//  Created by Дмитрий Забиякин on 22.01.2025.
//

import UIKit

final class MainViewModel {
    
    var todos: [Todos] = []

    /// Запрос и сохранение данных в CoreData
    /// - Parameter completion: completion
    func request(completion: @escaping () -> Void) {
        if let coreDataTodos = CoreDataManager.shared.fetchTodosFromCoreData(), !coreDataTodos.isEmpty {
            self.todos = coreDataTodos
            completion()
        } else {
            NetworkService.shared.requestToDoList { [weak self] todos in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.todos = todos
                    CoreDataManager.shared.saveTodosCoreData(todos)
                    completion()
                }
            }
        }
    }
    
    /// Сохранение изменного статуса задачи (выполненно/ не выполненно)
    /// - Parameters:
    ///   - indexPath: indexPath выбранной задачи
    ///   - newStatus: новый статус задачи
    func updateStatusTask(indexPath: IndexPath, newStatus: Bool) {
        let taskName = todos[indexPath.row].todo ?? ""
        todos[indexPath.row].completed = newStatus
        CoreDataManager.shared.updateTaskStatus(todo: taskName, newStatus: newStatus)
    }
    
//    кол-во задач
    func countTask() -> Int {
        todos.count
    }
    
}
