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
    private lazy var fetchResultController: NSFetchedResultsController<ToDoList> = {
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
    func fetchTodosFromCoreData() -> [Todos]? {
        let fetchRequest: NSFetchRequest<ToDoList> = ToDoList.fetchRequest()
        
        do {
            let coreDataTodos = try context.fetch(fetchRequest)
//            конвертируем объекты из CoreDara в модель 'Todos'
            return coreDataTodos.map { coreDataTodo in
                Todos(
                    todo: coreDataTodo.todo,
                    completed: coreDataTodo.completed,
                    commentToDo: coreDataTodo.commentToDo,
                    date: coreDataTodo.date
                )
            }
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
}
