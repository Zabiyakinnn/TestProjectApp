//
//  NetworkService.swift
//  TestProject
//
//  Created by Дмитрий Забиякин on 22.01.2025.
//

import UIKit

final class NetworkService {
    
    public static let shared = NetworkService()
    
    //    запрос для получения списка задач
    func requestToDoList(completion: @escaping ([Todos]) -> Void) {
        guard let url = URL(string: "https://drive.google.com/uc?export=download&id=1MXypRbK2CS9fqPhTtPonn580h1sHUs2W") else { return }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, responce, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            guard let data = data else {
                print("Данные не возвращенны")
                return
            }
            do {
                let toDoData = try JSONDecoder().decode(Todo.self, from: data)
                if let todos = toDoData.todos {
                    completion(todos)
                } else {
                    print("Данные todos не полученны")
                }
            } catch let decodingError {
                print("Ошибка декодирования данных: -\(decodingError.localizedDescription)")
            }
        }.resume()
    }
}
