//
//  ViewController.swift
//  TestProject
//
//  Created by Дмитрий Забиякин on 21.01.2025.
//

import UIKit

final class MainViewController: UIViewController {
    
    private var mainView = MainView()
    private var viewModel = MainViewModel()
    private var taskCell = "taskCell"
    
    
    //    MARK: - LoadView
    override func loadView() {
        self.view = mainView
    }
    
    //    MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self

        setupBinding()
        setupButton()
        
        mainView.searchBar.searchResultsUpdater = self
        mainView.searchBar.obscuresBackgroundDuringPresentation = false
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        
        // Обновляем отступы таблицы для searchBar
        let safeArea = view.safeAreaInsets.top
        mainView.updateTableViewTopInset(safeArea + 0)
    }
    
    //    настройка привязок
    private func setupBinding() {
        navigationItem.searchController = mainView.searchBar
        self.navigationItem.hidesSearchBarWhenScrolling = true
        
        let customView = mainView.labelHeadline
        let leftBarButtonItem = UIBarButtonItem(customView: customView)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        self.navigationItem.searchController = mainView.searchBar
        
        viewModel.request { [weak self] in
            guard let self = self else { return }
            mainView.labelCountTask.text = "Кол-во задач: \(viewModel.countTask())"
            mainView.tableView.reloadData()
        }
    }

//    MARK: Button
//    настройка нажатия кнопки
    private func setupButton() {
        mainView.buttonNewTask.addTarget(self, action: #selector(buttonNewTaskTapped), for: .touchUpInside)
    }

//    обработка нажатия
    @objc func buttonNewTaskTapped() {
        let newTaskViewModel = NewTaskViewModel()
        let newTaskVC = NewTaskViewController(viewModel: newTaskViewModel)
        newTaskViewModel.onNewTask = { [weak self] in
            guard let self = self else { return }
            viewModel.request {
                self.mainView.tableView.reloadData()
                self.mainView.labelCountTask.text = "Кол-во задач: \(self.viewModel.countTask())"
            }
        }
        navigationController?.pushViewController(newTaskVC, animated: true)
    }
}

//MARK: - UISearchResultsUpdating
extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let search = searchController.searchBar.text, !search.isEmpty else {
            //если строка пустая
            viewModel.resetSarch()
            mainView.tableView.reloadData()
            return
        }
        //если есть ввод
        viewModel.filtredTodos(search: search)
        mainView.tableView.reloadData()
    }
}

//MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.isSearching ? viewModel.filtredTodos.count : viewModel.todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: taskCell, for: indexPath) as? TaskCell
        let task = viewModel.isSearching ? viewModel.filtredTodos[indexPath.row] : viewModel.todos[indexPath.row]
        
        cell?.configure(task)
        
        cell?.onStatusChange = { [weak self] newStatus in
            guard let self = self else { return }
            self.viewModel.updateStatusTask(indexPath: indexPath, newStatus: newStatus)
            mainView.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
//        редактирование задачи
        cell?.onEditTaskVC = { [weak self] in
            guard let self = self else { return }
            let selectedToDo = viewModel.todos[indexPath.row]
            let selectedToDoList = CoreDataManager.shared.fetchTodosFromCoreData()?.first(where: { $0.todo == selectedToDo.todo })
            let editTaskViewModel = EditTaskViewModel(todos: selectedToDo, toDoList: selectedToDoList)
            let editTaskVC = EditTaskViewController(viewModel: editTaskViewModel)
            editTaskViewModel.onEditTask = {
                self.mainView.tableView.reloadData()
            }
            self.navigationController?.pushViewController(editTaskVC, animated: true)
        }
        
//        удаление задачи
        cell?.onDeleteTask = { [weak self] in
            guard let self = self else { return }
            viewModel.deleteTask(at: indexPath)
            mainView.tableView.reloadData()
            mainView.labelCountTask.text = "Кол-во задач: \(viewModel.countTask())"
        }
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedToDo = viewModel.todos[indexPath.row]
        
        let selectedToDoList = CoreDataManager.shared.fetchTodosFromCoreData()?.first(where: { $0.todo == selectedToDo.todo })
        let editTaskViewModel = EditTaskViewModel(todos: selectedToDo, toDoList: selectedToDoList)
        editTaskViewModel.onEditTask = { [weak self] in
            guard let self = self else { return }
            viewModel.request {
                self.mainView.tableView.reloadData()
            }
        }
        
        let editTaskVC = EditTaskViewController(viewModel: editTaskViewModel)
        
        self.navigationController?.pushViewController(editTaskVC, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

//MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteTask(at: indexPath)
            mainView.tableView.reloadData()
            mainView.labelCountTask.text = "Кол-во задач: \(viewModel.countTask())"
        }
    }
}


