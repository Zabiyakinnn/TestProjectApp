//
//  CoreDataManager.swift
//  TestProject
//
//  Created by Дмитрий Забиякин on 23.01.2025.
//

import UIKit
import CoreData

final class CoreDataManager {
    
    public static let shared = CoreDataManager()
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext) {
        self.context = context
    }
    
//    MARK: - CoreData
    lazy var fetchResultController: NSFetchedResultsController<ToDoList> = {
        let fetchRequest = ToDoList.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetchResultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: appDelegate.persistentContainer.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        return fetchResultController
    }()
    
    private var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func perfomFetch() {
        try? fetchResultController.performFetch()
    }
    
    //    сохранение данных в CoreData
    func saveTodosCoreData(_ todos: [Todos]) {
        
        todos.forEach { todo in
            let toDoEntity = ToDoList(context: context)
            
            toDoEntity.todo = todo.todo
            toDoEntity.date = todo.date
            toDoEntity.completed = todo.completed ?? true
            toDoEntity.commentToDo = todo.commentToDo
        }
        
        do {
            try context.save()
            print("Данные сохраненны в CoreData")
        } catch {
            print("Ошибка сохранения данных в CoreData \(error.localizedDescription)")
        }
    }
    
    //    загрузка данных из CoreData
    func fetchTodosFromCoreData() -> [ToDoList]? {
        let fetchRequest: NSFetchRequest<ToDoList> = ToDoList.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest) // Возвращаем массив объектов ToDoList
        } catch {
            print("Ошибка загрузки данных из Core Dara: \(error.localizedDescription)")
            return nil
        }
    }
    
    /// сохранение изменного статуса задачи (выполненно/не выполненно)
    /// - Parameters:
    ///   - todo: задача
    ///   - newStatus: новый статус
    func updateTaskStatus(todo: String, newStatus: Bool) {
        let fetchRequest: NSFetchRequest<ToDoList> = ToDoList.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "todo == %@", todo)
        
        do {
            let result = try context.fetch(fetchRequest)
            if let taskToUpdate = result.first {
                taskToUpdate.completed = newStatus
                try context.save()
//                print("Статус задачи изменен и сохранен в Core Data")
            } else {
                print("Задача с указанным названием не найдена")
            }
        } catch {
            print("Ошибка обновления статуса задачи в Core Data: \(error.localizedDescription)")
        }
    }
    
    
    //    удаление задачи из CoreData
    func deleteTodosTaskCoreData(_ todos: Todos) {
        let fetchRequest: NSFetchRequest<ToDoList> = ToDoList.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "todo == %@", todos.todo ?? "")
        
        do {
            let result = try context.fetch(fetchRequest)
            if let taskToDelete = result.first {
                context.delete(taskToDelete)
                try context.save()
            } else {
                print("Задача не найденна в Core Data")
            }
        } catch {
            print("Ошибка удаления задачи из CoreData: \(error)")
        }
    }
    
    
    /// Сохранение новой задачи
    /// - Parameters:
    ///   - todo: Название задачи
    ///   - commentToDo: Комментарий задачи
    ///   - date: Дата задачи
    ///   - completion: completion
    func saveNewTask(todo: String, commentToDo: String?, date: Date?, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newTask = ToDoList(context: context)
            newTask.todo = todo
            newTask.commentToDo = commentToDo
            newTask.date = date
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure((error)))
        }
    }
    
    
    /// Сохранение отредактрованной задачи
    /// - Parameters:
    ///   - task: task
    ///   - todo: название задачи
    ///   - commentToDo: комментарий к задаче
    ///   - date: дата
    ///   - completed: статус задачи
    ///   - completion: completion
    func saveEditTask(task: ToDoList, todo: String, commentToDo: String, date: Date?, completed: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        let fetchRequest: NSFetchRequest<ToDoList> = ToDoList.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "todo == %@", task.todo ?? "")
        
        do {
            let result = try context.fetch(fetchRequest)
            if let changeTask = result.first {
                changeTask.todo = todo
                changeTask.commentToDo = commentToDo
                changeTask.date = date
                changeTask.completed = completed
                try context.save()
                completion(.success(()))
            } else {
                print("Задача не найденна")
            }
        } catch {
            completion(.failure((error)))
        }
    }
}
