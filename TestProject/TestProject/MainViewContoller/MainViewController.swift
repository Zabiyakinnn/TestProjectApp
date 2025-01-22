//
//  ViewController.swift
//  TestProject
//
//  Created by Дмитрий Забиякин on 21.01.2025.
//

import UIKit

final class MainViewController: UIViewController {
    
    private var taskView = MainView()
    private var taskCell = "taskCell"

//    MARK: - LoadView
    override func loadView() {
        self.view = taskView
    }
        
//    MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskView.tableView.delegate = self
        taskView.tableView.dataSource = self
//        taskView.searchBar.delegate = self
        taskView.searchBar.searchBar.delegate = self
        
        setupBinding()
    }
    
//    настройка привязок
    private func setupBinding() {
        taskView.searchBar.navigationItem.searchController = taskView.searchBar
        taskView.searchBar.navigationItem.hidesSearchBarWhenScrolling = false
                
        let customView = taskView.labelHeadline
        let leftBarButtonItem = UIBarButtonItem(customView: customView)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        self.navigationItem.searchController = taskView.searchBar
        
    }

}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: taskCell, for: indexPath) as? TaskCell
        cell?.todoLabel.text = "Задачи"
        
        return cell ?? UITableViewCell()
    }
    
}

//MARK: - UISearchBarDelegate
extension MainViewController: UISearchBarDelegate /*UISearchControllerDelegate*/ {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        taskView.updateTableViewTopInset(0)
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        taskView.updateTableViewTopInset(110)
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

