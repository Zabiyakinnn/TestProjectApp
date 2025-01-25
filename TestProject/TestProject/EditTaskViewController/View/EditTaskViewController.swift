//
//  EditTaskViewController.swift
//  TestProject
//
//  Created by Дмитрий Забиякин on 25.01.2025.
//

import UIKit

final class EditTaskViewController: UIViewController {
    
    private var editTaskView = EditTaskView()
    private var viewModel: EditTaskViewModel
    
    private var calendar = UICalendarView() //календарь
    private var selectedDate: Date?     // выбранная дата
    private var dateOfDone = String()   //преобразование даты в строку для отображения
    
    init(viewModel: EditTaskViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = editTaskView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Редактировать задачу"
        
        setupLoyout()
        setupBinding()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let dateToSave = selectedDate ?? viewModel.todos.date
        if let completedTask = viewModel.todos.completed {
            viewModel.saveEditTask(
                todo: editTaskView.textViewNameTask.text,
                commentToDo: editTaskView.textViewCommentTask.text,
                date: dateToSave,
                completed: completedTask)
        }
    }
    
//    настройка привязок
    private func setupBinding() {
        editTaskView.contentView(
            nameTask: viewModel.todos.todo ?? "",
            commentTask: viewModel.todos.commentToDo ?? ""
        )
        
        let dateString = viewModel.formatterDate(viewModel.todos.date)
        editTaskView.buttonDateToDo.setTitle(dateString, for: .normal)
        
        editTaskView.buttonDateToDo.addTarget(self, action: #selector(buttonDateToDoTapped), for: .touchUpInside)
    }
    
    @objc func buttonDateToDoTapped() {
        calendar.calendar = .current
        calendar.locale = .current
        calendar.backgroundColor = UIColor.systemBackground
        calendar.layer.cornerRadius = 10
        view.addSubview(calendar)

        
        let selection = UICalendarSelectionSingleDate(delegate: self)
        calendar.selectionBehavior = selection
        
        calendar.snp.makeConstraints { make in
            make.top.equalTo(editTaskView.buttonDateToDo.snp.bottom).offset(20)
            make.left.equalTo(view.snp.left).inset(20)
            make.right.equalTo(view.snp.right).inset(20)
        }
    }
}

//MARK: - SetupLoyout
extension EditTaskViewController {
    private func setupLoyout() {
        navigationController?.navigationBar.tintColor = UIColor.systemYellow
    }
}

//MARK: - UICalendarSelectionSingleDateDelegate
extension EditTaskViewController: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let dateComponents = dateComponents, let date = dateComponents.date else { return }
        
        selectedDate = date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        let selectedDate = dateFormatter.string(from: date)
        dateOfDone = selectedDate
        
        editTaskView.buttonDateToDo.setTitle(selectedDate, for: .normal)
        calendar.removeFromSuperview()
    }
}
