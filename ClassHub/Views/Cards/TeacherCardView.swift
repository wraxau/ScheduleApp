import UIKit
import Foundation

final class TeacherCardView: UIView {
    // MARK: Teacher Card
    
    private let item: ScheduleItem

    init(item: ScheduleItem) {
        self.item = item
        super.init(frame: .zero)
        setupTeacherCard()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let teacherCard: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private func setupTeacherCard() {
        
        addSubview(teacherCard)
        NSLayoutConstraint.activate([
            teacherCard.topAnchor.constraint(equalTo: topAnchor),
            teacherCard.leadingAnchor.constraint(equalTo: leadingAnchor),
            teacherCard.trailingAnchor.constraint(equalTo: trailingAnchor),
            teacherCard.bottomAnchor.constraint(equalTo: bottomAnchor),
            teacherCard.heightAnchor.constraint(equalToConstant: 84)  
        ])
        
        teacherCard.backgroundColor = .systemGray6

        let teacherLabel = UILabel()
        teacherLabel.text = item.teacher
        teacherLabel.textColor = .label
        teacherLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        teacherLabel.numberOfLines = 2
        teacherLabel.translatesAutoresizingMaskIntoConstraints = false

        let avatarView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor.systemGray5
            view.layer.cornerRadius = 26
            view.clipsToBounds = true
            view.translatesAutoresizingMaskIntoConstraints = false

            let label = UILabel()
            label.text = String(item.teacher.prefix(1)).uppercased()
            label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            label.textColor = .secondaryLabel
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(label)

            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
            return view
        }()

        let titleLabel = UILabel()
        titleLabel.text = "Преподаватель"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .secondaryLabel
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        teacherCard.addSubview(avatarView)
        teacherCard.addSubview(titleLabel)
        teacherCard.addSubview(teacherLabel)

        NSLayoutConstraint.activate([
            avatarView.leadingAnchor.constraint(equalTo: teacherCard.leadingAnchor, constant: 16),
            avatarView.centerYAnchor.constraint(equalTo: teacherCard.centerYAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: 52),
            avatarView.heightAnchor.constraint(equalToConstant: 52),

            titleLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: teacherCard.topAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: teacherCard.trailingAnchor, constant: -16),

            teacherLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 16),
            teacherLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            teacherLabel.trailingAnchor.constraint(equalTo: teacherCard.trailingAnchor, constant: -16),
            teacherLabel.bottomAnchor.constraint(equalTo: teacherCard.bottomAnchor, constant: -16)
        ])
    }
}
