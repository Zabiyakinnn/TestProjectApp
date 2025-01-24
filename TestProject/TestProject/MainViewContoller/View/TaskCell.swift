//
//  TaskCell.swift
//  TestProject
//
//  Created by Дмитрий Забиякин on 21.01.2025.
//

import UIKit
import SnapKit

final class TaskCell: UITableViewCell {
    
    let formatter = DateFormatter()
    
    var onStatusChange: ((Bool) -> Void)? // новый статус задачи
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.systemBackground
        
        setupLoyout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    название задачи
    private lazy var todoLabel: UILabel = {
        let label = UILabel()
//        label.textColor = UIColor.systemBackground
        label.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        label.numberOfLines = 2
        return label
    }()
    
    //    commentToDo label
    private lazy var commentLabel: UILabel = {
        let label = UILabel()
//        label.textColor = UIColor(named: "ColorTextBlackAndWhite")
        label.font = UIFont.systemFont(ofSize: 17, weight: .light)
        label.numberOfLines = 1
        return label
    }()
    
    //    date ToDo label
    private lazy var dateTodoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    //    кнопка изменения статуса задачи выполненно/не выполненно
    private lazy var statusButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
        button.imageView?.layer.transform = CATransform3DMakeScale(1.3, 1.3, 1.3)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = UIColor.systemYellow
        button.addTarget(self, action: #selector(statusButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func statusButtonTapped() {
        statusButton.isSelected.toggle()
        updateToDoLabel(isCompleted: statusButton.isSelected)
        onStatusChange?(statusButton.isSelected)
    }
    
    func configure(_ todos: Todos) {
        todoLabel.text = todos.todo
        commentLabel.text = todos.commentToDo
        
        formatter.dateFormat = "dd.MM.yy"
        if let dateTask = todos.date {
            dateTodoLabel.text = formatter.string(from: dateTask)
        }
        
        if let completedTask = todos.completed {
            statusButton.isSelected = completedTask
            updateToDoLabel(isCompleted: statusButton.isSelected)
        }
    }
    
    /// обновление текста в зависимости от статуса задачи
    /// - Parameter isCompleted: выполненно/ не выполненно
    private func updateToDoLabel(isCompleted: Bool) {
        if isCompleted {
//            задача заверешена
            let attributedString = NSAttributedString(
                string: todoLabel.text ?? "",
                attributes: [
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                    .foregroundColor: UIColor.gray
                ]
            )
            todoLabel.attributedText = attributedString
        } else {
//            задача не заверешена
            let attrattributedString = NSAttributedString(
                string: todoLabel.text ?? "",
                attributes: [
                    .strikethroughStyle: 0,
                    .foregroundColor: UIColor(named: "TextColor") ?? UIColor.gray
                ]
            )
            todoLabel.attributedText = attrattributedString
        }
    }
}

//MARK: - TaskCell
extension TaskCell {
    private func setupLoyout() {
        prepareView()
        setupConstrant()
    }
    private func prepareView() {
        contentView.addSubview(todoLabel)
        contentView.addSubview(commentLabel)
        contentView.addSubview(dateTodoLabel)
        contentView.addSubview(statusButton)
    }
    private func setupConstrant() {
        statusButton.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).inset(10)
            make.left.equalTo(contentView.snp.left).inset(5)
            make.width.height.equalTo(30)
        }
        todoLabel.snp.makeConstraints { make in
            make.left.equalTo(statusButton.snp.left).inset(45)
            make.right.equalTo(contentView.snp.right).inset(30)
            make.top.equalTo(contentView.snp.top).inset(10)
        }
        commentLabel.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.left).inset(50)
            make.right.equalTo(contentView.snp.right).inset(30)
            make.top.equalTo(todoLabel.snp.bottom).inset(-7)
        }
        dateTodoLabel.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.left).inset(50)
            make.top.equalTo(commentLabel.snp.bottom).inset(-7)
            make.bottom.equalTo(contentView.snp.bottom).inset(10)
        }
    }
}
