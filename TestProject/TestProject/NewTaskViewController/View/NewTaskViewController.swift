//
//  NewTaskViewController.swift
//  TestProject
//
//  Created by Дмитрий Забиякин on 24.01.2025.
//

import UIKit

final class NewTaskViewController: UIViewController {
    
    private var newTaskView = NewTaskView()
    private var viewModel: NewTaskViewModel
    
    private var calendar = UICalendarView() //календарь
    private var selectedDate: Date?     // выбранная дата
    private var dateOfDone = String()   //преобразование даты в строку для отображения
    
    var onNewTask: (() -> Void)? // уведомление о новой задаче
    
//    MARK: Init
    init(viewModel: NewTaskViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: LoadView
    override func loadView() {
        self.view = newTaskView
    }
    
//    MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Новая задача"
        
        setupLoyout()
        setupButton()
    }
    
//    настройка кнопок
    private func setupButton() {
        newTaskView.buttonDateToDo.addTarget(self, action: #selector(buttonDateToDoTapped), for: .touchUpInside)
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
            make.top.equalTo(newTaskView.buttonDateToDo.snp.bottom).offset(20)
            make.left.equalTo(view.snp.left).inset(20)
            make.right.equalTo(view.snp.right).inset(20)
        }
    }
    
//    сохранение задачи в CoreData
    @objc func rightButtonItemTapped() {
        if let textNameTask = newTaskView.textViewNameTask.text {
            viewModel.saveNewTask(
                toDoText: textNameTask,
                toDoComment: newTaskView.textViewCommentTask.text,
                toDoDate: selectedDate)
        }
        onNewTask?()
        self.navigationController?.popViewController(animated: true)
    }
    
    //    скрытие клавиатуры
    private func dissmisKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        newTaskView.textViewNameTask.endEditing(true)
        newTaskView.textViewCommentTask.endEditing(true)
    }
}

//MARK: - SetupLoyout
extension NewTaskViewController {
    func setupLoyout() {
        dissmisKeyboard()
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Сохранить",
            style: .plain,
            target: self,
            action: #selector(rightButtonItemTapped))
        
        navigationItem.rightBarButtonItem?.tintColor = UIColor.systemYellow
        navigationController?.navigationBar.tintColor = UIColor.systemYellow
    }
}

//MARK: - UICalendarSelectionSingleDateDelegate
extension NewTaskViewController: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let dateComponents = dateComponents, let date = dateComponents.date else { return }
        
        selectedDate = date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        let selectedDate = dateFormatter.string(from: date)
        dateOfDone = selectedDate
        
        newTaskView.buttonDateToDo.setTitle(selectedDate, for: .normal)
        calendar.removeFromSuperview()
    }
}
