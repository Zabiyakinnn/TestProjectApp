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


}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
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
            mainView.tableView.reloadRows(at: [indexPath], with: .none)
        }
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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

