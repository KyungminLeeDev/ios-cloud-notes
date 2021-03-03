//
//  NotesTableViewCell.swift
//  CloudNotes
//
//  Created by Jinho Choi on 2021/02/15.
//

import UIKit

class NotesTableViewCell: UITableViewCell {
    static var identifier: String {
        return "\(self)"
    }
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        return titleLabel
    }()
    private let lastModifiedDateLabel: UILabel = {
        let lastModifiedDateLabel = UILabel()
        lastModifiedDateLabel.translatesAutoresizingMaskIntoConstraints = false
        lastModifiedDateLabel.font = .preferredFont(forTextStyle: .caption1)
        return lastModifiedDateLabel
    }()
    private let bodyLabel: UILabel = {
        let bodyLabel = UILabel()
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyLabel.font = .preferredFont(forTextStyle: .caption1)
        bodyLabel.textColor = .gray
        return bodyLabel
    }()
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale.current
        return dateFormatter
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
        configureConstraints()
    }
    
    private func configureConstraints() {
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(lastModifiedDateLabel)
        self.contentView.addSubview(bodyLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: UIConstants.layout.notesCellTitleLabelTopOffset),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UIConstants.layout.notesCellTitleLabelLeadingOffset),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: UIConstants.layout.notesCellTitleLabelTrailingOffset),
            
            lastModifiedDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: UIConstants.layout.notesCellDateLabelTopOffset),
            lastModifiedDateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: UIConstants.layout.notesCellDateLabelLeadingOffset),
            lastModifiedDateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: UIConstants.layout.notesCellDateLabelBottomOffset),
            
            bodyLabel.centerYAnchor.constraint(equalTo: lastModifiedDateLabel.centerYAnchor),
            bodyLabel.leadingAnchor.constraint(equalTo: lastModifiedDateLabel.trailingAnchor, constant: UIConstants.layout.notesCellBodyLabelLeadingOffset),
            bodyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: UIConstants.layout.notesCellBodyLabelTrailingOffset)
        ])
        titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        lastModifiedDateLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        bodyLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        lastModifiedDateLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        bodyLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    func configureCell(index: Int) {
        let memo = CoreDataManager.shared.memoList[index]
        titleLabel.text = memo.title
        bodyLabel.text = memo.body
        bodyLabel.textColor = .gray
        if let lastModifiedDate = memo.lastModifiedDate {
            lastModifiedDateLabel.text = dateFormatter.string(from: lastModifiedDate)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = UIConstants.strings.textInitalizing
        lastModifiedDateLabel.text = UIConstants.strings.textInitalizing
        bodyLabel.text = UIConstants.strings.textInitalizing
        bodyLabel.textColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
