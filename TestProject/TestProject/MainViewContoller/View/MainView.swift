//
//  MainView.swift
//  TestProject
//
//  Created by Дмитрий Забиякин on 21.01.2025.
//

import UIKit
import SnapKit

final class MainView: UIView {
    private var tableViewTopConstraint: Constraint? // top constraint
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        setupLoyout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: - Content
//    заголовок
    lazy var labelHeadline: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textAlignment = .left
        label.text = "Задачи"
        return label
    }()
    
//    поиск (searchBar)
    lazy var searchBar: UISearchController = {
       let searchBar = UISearchController(searchResultsController: nil)
        searchBar.obscuresBackgroundDuringPresentation = false
        searchBar.searchBar.placeholder = "Поиск"
        searchBar.searchBar.searchTextField.leftView?.tintColor = .lightGray
        searchBar.searchBar.searchTextField.textColor = .lightGray
        searchBar.searchBar.searchTextField.backgroundColor = UIColor.systemBackground
        searchBar.searchBar.isTranslucent = false

        return searchBar
    }()
    
//    UIView
    private lazy var buttomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "ColorViewNewTaskAndCountTask")
        return view
    }()
    
//    кнопка добавления задачи
    lazy var buttonNewTask: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        button.tintColor = UIColor.systemYellow
        return button
    }()
    
    //    текст "Подсчет кол-ва задач"
    lazy var labelCountTask: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.text = "Подсчет кол-ва задач.."
        return label
    }()
    
    //     таблица с данными
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.backgroundColor = UIColor.systemBackground
        tableView.separatorColor = .gray
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.register(TaskCell.self, forCellReuseIdentifier: "taskCell")
        return tableView
    }()
}

//MARK: - SetupLoyout
extension MainView {
    private func setupLoyout() {
        prepareView()
        setupConstraint()
    }
    
    private func prepareView() {
        addSubview(buttomView)
        buttomView.addSubview(buttonNewTask)
        buttomView.addSubview(labelCountTask)
        addSubview(tableView)
    }
    
    private func setupConstraint() {
        buttomView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(0)
            make.left.right.equalToSuperview()
            make.height.equalTo(84)
        }
        buttonNewTask.snp.makeConstraints { make in
            make.right.equalTo(buttomView.snp.right).inset(20)
            make.bottom.equalTo(buttomView.snp.bottom).inset(30)
            make.height.width.equalTo(40)
        }
        labelCountTask.snp.makeConstraints { make in
            make.centerY.equalTo(buttonNewTask)
            make.centerX.equalToSuperview()
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(buttomView.snp.top)
        }
    }
    
    // Метод для изменения отступа
    func updateTableViewTopInset(_ inset: CGFloat) {
        tableViewTopConstraint?.update(inset: inset)
        layoutIfNeeded()
    }
}
