//
//  NewTaskView.swift
//  TestProject
//
//  Created by Дмитрий Забиякин on 24.01.2025.
//

import UIKit
import SnapKit

final class NewTaskView: UIView {
    
    private var calendar = UICalendarView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.systemBackground
        
        setupLoyout()
    }
    
    //    текст укажите название
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "TextColor")
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.text = "Укажите название и комментарий"
        label.textAlignment = .center
        return label
    }()
    
    //    поле ввода текста название задачи
    lazy var textViewNameTask: UITextView = {
        let view = UITextView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.font = UIFont.systemFont(ofSize: 21)
        view.textColor = UIColor.black
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    //    поле ввода текста коментария задачи
    lazy var textViewCommentTask: UITextView = {
        let view = UITextView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.font = UIFont.systemFont(ofSize: 21)
        view.textColor = UIColor.black
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    //    текст укажите дату
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ColorText")
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.text = "Укажите дату"
        label.textAlignment = .center
        return label
    }()
    
    //    кнопка выбора даты
    var buttonDateToDo: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .systemYellow
        let calendarImage = UIImage(systemName: "calendar")?.withTintColor(UIColor.systemYellow, renderingMode: .alwaysOriginal)
        button.setImage(calendarImage, for: .normal)
        button.backgroundColor = UIColor.clear
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        button.setTitle("Дата", for: .normal)
        button.contentHorizontalAlignment = .left
        button.layer.cornerRadius = 8
        return button
    }()

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - SetupLoyout
extension NewTaskView {
    private func setupLoyout() {
        prepereView()
        setupConstraint()
    }
    private func prepereView() {
        addSubview(titleLabel)
        addSubview(textViewNameTask)
        addSubview(textViewCommentTask)
        addSubview(dateLabel)
        addSubview(buttonDateToDo)
    }
    private func setupConstraint() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(120)
            make.left.equalToSuperview().inset(20)
        }
        textViewNameTask.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.left.right.equalToSuperview()
            make.height.equalTo(54)
        }
        textViewCommentTask.snp.makeConstraints { make in
            make.top.equalTo(textViewNameTask.snp.bottom).offset(4)
            make.left.right.equalToSuperview()
            make.height.equalTo(54)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(textViewCommentTask.snp.bottom).offset(22)
            make.left.equalToSuperview().inset(20)
        }
        buttonDateToDo.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(15)
            make.left.equalToSuperview().inset(20)
        }
    }
}
