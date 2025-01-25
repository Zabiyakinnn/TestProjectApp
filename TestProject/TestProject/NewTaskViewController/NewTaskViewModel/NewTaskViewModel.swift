//
//  NewTaskViewModel.swift
//  TestProject
//
//  Created by Дмитрий Забиякин on 24.01.2025.
//

import UIKit

final class NewTaskViewModel {
    
    var onNewTask: (() -> Void)? // уведомление о новой задаче
    
    /// Сохранение новой задачи
    /// - Parameters:
    ///   - toDoText: название задачи
    ///   - toDoComment: комментарий к задаче
    ///   - toDoDate: дата задачи
    ///   - completion: completion
    func saveNewTask(toDoText: String?, toDoComment: String?, toDoDate: Date?) {
        guard let toDoText = toDoText, !toDoText.isEmpty else {
            print("Имя задачи не может быть пустым")
            return
        }
        CoreDataManager.shared.saveNewTask(
            todo: toDoText,
            commentToDo: toDoComment,
            date: toDoDate) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success():
                    self.onNewTask?()
                case .failure(let error):
                    print("Ошибка сохранения задачи в CoreData: - \(error.localizedDescription)")
                }
            }
    }
}
