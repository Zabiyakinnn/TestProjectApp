//
//  MainViewModel.swift
//  TestProject
//
//  Created by Дмитрий Забиякин on 22.01.2025.
//

import UIKit

final class MainViewModel {
    
    var todos: [Todos] = []
    var filtredTodos: [Todos] = []
    var isSearching: Bool = false // состояние поиска по задачам через seacrhBar
    
    
    /// Поиск
    /// - Parameter search: строка поиска
    func filtredTodos(search: String) {
        isSearching = true
        filtredTodos = todos.filter({ task in
            let todoText = task.todo?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let commentText = task.commentToDo?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

            // Если поле commentToDo пустое (или nil)
            if commentText.isEmpty {
                return todoText.contains(search.lowercased())
            } else {
                return todoText.contains(search.lowercased()) || commentText.contains(search.lowercased())
            }
        })
    }
    
//    сброс поиска
    func resetSarch() {
        isSearching = false
        filtredTodos = []
    }

    /// Запрос и сохранение данных в CoreData
    /// - Parameter completion: completion
    func request(completion: @escaping () -> Void) {
        // Проверяем, есть ли данные в Core Data
        if let coreDataTodos = CoreDataManager.shared.fetchTodosFromCoreData(), !coreDataTodos.isEmpty {
            // Преобразование объектов ToDoList в Todos
            self.todos = coreDataTodos.map { coreDataTodo in
                Todos(
                    todo: coreDataTodo.todo,
                    completed: coreDataTodo.completed,
                    commentToDo: coreDataTodo.commentToDo,
                    date: coreDataTodo.date
                )
            }
            completion()
        } else {
            // Если данных нет, выполняем сетевой запрос
            NetworkService.shared.requestToDoList { [weak self] todos in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    
                    // Сохраняем данные в Core Data
                    CoreDataManager.shared.saveTodosCoreData(todos)
                    
                    // Обновляем локальные данные
                    self.todos = todos
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
    
    
    /// Удаление задачи
    /// - Parameter indexPath: indexPath
    func deleteTask(at indexPath: IndexPath) {
        let taskToDelete = todos[indexPath.row]
        CoreDataManager.shared.deleteTodosTaskCoreData(taskToDelete)
        todos.remove(at: indexPath.row)
    }
    
    
//    кол-во задач
    func countTask() -> Int {
        todos.count
    }
}
