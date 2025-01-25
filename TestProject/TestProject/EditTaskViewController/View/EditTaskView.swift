//
//  EditTaskView.swift
//  TestProject
//
//  Created by Дмитрий Забиякин on 25.01.2025.
//

import UIKit
import SnapKit

final class EditTaskView: UIView {
    
//    MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.systemBackground
        
        setupLoyout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: - layoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
        dinamicHeight(textViewNameTask)
        dinamicHeight(textViewCommentTask)
    }
    
    //    поле ввода текста название задачи
    lazy var textViewNameTask: UITextView = {
        let view = UITextView()
        view.delegate = self
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.font = UIFont.systemFont(ofSize: 29, weight: .bold)
        view.textColor = UIColor(named: "TextColor")
        view.backgroundColor = UIColor.clear
        view.isScrollEnabled = false
        return view
    }()
    
    //    поле ввода текста коментария задачи
    lazy var textViewCommentTask: UITextView = {
        let view = UITextView()
        view.delegate = self
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.font = UIFont.systemFont(ofSize: 20)
        view.textColor = UIColor(named: "TextColor")
        view.backgroundColor = UIColor.clear
        view.isScrollEnabled = false
        return view
    }()
    
    //    кнопка выбора даты
    var buttonDateToDo: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .systemYellow
        button.backgroundColor = UIColor.clear
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        button.setTitle("Дата", for: .normal)
        button.contentHorizontalAlignment = .left
        button.layer.cornerRadius = 8
        return button
    }()
    
//    передача данных
    func contentView(nameTask: String, commentTask: String) {
        textViewNameTask.text = nameTask
        textViewCommentTask.text = commentTask
    }
    
}

//MARK: - SetupLoyout
extension EditTaskView {
    private func setupLoyout() {
        prepereView()
        setupConstraint()
    }
    private func prepereView() {
        addSubview(textViewNameTask)
        addSubview(textViewCommentTask)
        addSubview(buttonDateToDo)
    }
    private func setupConstraint() {
        textViewNameTask.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(106)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        buttonDateToDo.snp.makeConstraints { make in
            make.top.equalTo(textViewNameTask.snp.bottom).offset(15)
            make.left.equalToSuperview().inset(5)
        }
        textViewCommentTask.snp.makeConstraints { make in
            make.top.equalTo(buttonDateToDo.snp.bottom).offset(15)
            make.left.right.equalToSuperview()
            make.height.equalTo(54)
        }
    }
}

//MARK: - UITextViewDelegate
extension EditTaskView: UITextViewDelegate {
//    обновление textView во время ввода данных
    func textViewDidChange(_ textView: UITextView) {
        let size = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        
        textView.snp.updateConstraints { make in
            make.height.equalTo(size.height)
        }
        
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
    }
    //    обновление высоты textView в зависимости от содержащего текста
    private func dinamicHeight(_ textView: UITextView) {
        let size = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        
        textView.snp.updateConstraints { make in
            make.height.equalTo(size.height)
        }
    }
}

