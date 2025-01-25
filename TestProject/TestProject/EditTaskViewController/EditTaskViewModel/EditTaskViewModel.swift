//
//  EditTaskViewModel.swift
//  TestProject
//
//  Created by Дмитрий Забиякин on 25.01.2025.
//

import UIKit

final class EditTaskViewModel {
    
    var todos: Todos
    var toDoList: ToDoList?
    
    var onEditTask: (() -> Void)? // изменения задачи
    
    init(todos: Todos, toDoList: ToDoList?) {
        self.todos = todos
        self.toDoList = toDoList
    }
    
    //    передача даты в кнопку выбора даты
    func formatterDate(_ date: Date?) -> String {
        guard let date = date else { return "Дата" }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        return formatter.string(from: date)
    }
    
    
    /// Сохранение изменной задачи
    /// - Parameters:
    ///   - todos: todos
    ///   - todo: название задачи
    ///   - commentToDo: комментарий к задаче
    ///   - date: дата задачи
    ///   - completed: статус задачи (выполненно/ не выполненно)
    ///   - completion: completion
    func saveEditTask(todo: String?, commentToDo: String, date: Date?, completed: Bool) {
        guard let task = toDoList else {
            print("Задача не найденна")
            return
        }
        
        guard let textTask = todo, !textTask.isEmpty else {
            print("Название задачи не может быть пустым")
            return
        }
        CoreDataManager.shared.saveEditTask(
            task: task,
            todo: textTask,
            commentToDo: commentToDo,
            date: date,
            completed: completed) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success():
                    print("Изменная задача сохраненна в CoreData")
                    onEditTask?()
                case .failure(let error):
                    print("Ошибка сохранения задачи в CoreData \(error.localizedDescription)")
                }
            }
    }
}
