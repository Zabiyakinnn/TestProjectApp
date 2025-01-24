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
        mainView.searchBar.searchBar.delegate = self

        setupBinding()
        setupButton()
    }
    
    //    настройка привязок
    private func setupBinding() {
        mainView.searchBar.navigationItem.searchController = mainView.searchBar
        mainView.searchBar.navigationItem.hidesSearchBarWhenScrolling = false
        
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

//    настройка нажатия кнопки
    private func setupButton() {
        mainView.buttonNewTask.addTarget(self, action: #selector(buttonNewTaskTapped), for: .touchUpInside)
    }

    @objc func buttonNewTaskTapped() {
        let newTaskVC = NewTaskViewController()
        newTaskVC.onNewTask = { [weak self] in
            guard let self = self else { return }
            viewModel.request {
                self.mainView.tableView.reloadData()
                self.mainView.labelCountTask.text = "Кол-во задач: \(self.viewModel.countTask())"
            }
        }
        navigationController?.pushViewController(newTaskVC, animated: true)
    }
}

//MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.countTask()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: taskCell, for: indexPath) as? TaskCell
        let todos = viewModel.todos[indexPath.row]
        
        cell?.configure(todos)
        
        cell?.onStatusChange = { [weak self] newStatus in
            guard let self = self else { return }
            self.viewModel.updateStatusTask(indexPath: indexPath, newStatus: newStatus)
            mainView.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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

//MARK: - UISearchBarDelegate
extension MainViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        mainView.updateTableViewTopInset(0)
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        mainView.updateTableViewTopInset(110)
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

