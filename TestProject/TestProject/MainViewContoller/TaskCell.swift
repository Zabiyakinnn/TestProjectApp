//
//  TaskCell.swift
//  TestProject
//
//  Created by Дмитрий Забиякин on 21.01.2025.
//

import UIKit
import SnapKit

final class TaskCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.systemBackground
        
        setupLoyout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    название задачи
    lazy var todoLabel: UILabel = {
        let label = UILabel()
//        label.textColor = UIColor.systemBackground
        label.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        label.numberOfLines = 2
        return label
    }()
}

extension TaskCell {
    private func setupLoyout() {
        prepareView()
        setupConstrant()
    }
    private func prepareView() {
        contentView.addSubview(todoLabel)
    }
    private func setupConstrant() {
        todoLabel.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.left).inset(45)
            make.right.equalTo(contentView.snp.right).inset(30)
            make.top.equalTo(contentView.snp.top).inset(10)
        }

    }
}
