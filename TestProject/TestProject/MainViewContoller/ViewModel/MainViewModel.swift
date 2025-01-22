//
//  MainViewModel.swift
//  TestProject
//
//  Created by Дмитрий Забиякин on 22.01.2025.
//

import UIKit

final class MainViewModel {
    
    var todos: [Todos] = []

    /// интернет запрос
    /// - Parameter completion: completion
    func request(completion: @escaping () -> Void) {
        NetworkService.shared.requestToDoList { [weak self] todos in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.todos = todos
                completion()
            }
        }
    }
    
//    кол-во задач
    func countTask() -> Int {
        todos.count
    }
    
}
