import UIKit

final class ClassCardView: UIView {
    
    // MARK: - UI Elements
    private let typeBadge: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentEdgeInsets = UIEdgeInsets(top: 3, left: 11, bottom: 3, right: 11)
        return button
    }()

    private let replacementBadge: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("замена", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = UIColor(red: 1.0, green: 141.0/255.0, blue: 40.0/255.0, alpha: 1.0)
        button.contentEdgeInsets = UIEdgeInsets(top: 3, left: 11, bottom: 3, right: 11)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let numberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.backgroundColor = UIColor.systemGray5
        label.layer.cornerRadius = 14
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let roomLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subjectLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let teacherLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.tintColor = UIColor.secondaryLabel.withAlphaComponent(0.5)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Initialization
    
    init(item: ScheduleItem) {
        super.init(frame: .zero)
        setupUI()
        configure(with: item)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.97, alpha: 1.0)
        layer.cornerRadius = 16
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(numberLabel)
        addSubview(typeBadge)
        addSubview(replacementBadge)
        addSubview(timeLabel)
        addSubview(roomLabel)
        addSubview(subjectLabel)
        addSubview(teacherLabel)
        addSubview(arrowImageView)
        
        NSLayoutConstraint.activate([
            numberLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            numberLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            numberLabel.widthAnchor.constraint(equalToConstant: 28),
            numberLabel.heightAnchor.constraint(equalToConstant: 28),
               
            typeBadge.centerYAnchor.constraint(equalTo: numberLabel.centerYAnchor),
            typeBadge.leadingAnchor.constraint(equalTo: numberLabel.trailingAnchor, constant: 10),
            typeBadge.heightAnchor.constraint(equalToConstant: 20),
                
            replacementBadge.centerYAnchor.constraint(equalTo: numberLabel.centerYAnchor),
            replacementBadge.leadingAnchor.constraint(equalTo: typeBadge.trailingAnchor, constant: 8),
            replacementBadge.heightAnchor.constraint(equalToConstant: 20),
           
            arrowImageView.centerYAnchor.constraint(equalTo: numberLabel.centerYAnchor),
            arrowImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            arrowImageView.widthAnchor.constraint(equalToConstant: 14),
            arrowImageView.heightAnchor.constraint(equalToConstant: 14),
            
            // Time Label
            timeLabel.topAnchor.constraint(equalTo: numberLabel.bottomAnchor, constant: 8),
            timeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            
            // Room Label
            roomLabel.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor),
            roomLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            
            subjectLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 8),
            subjectLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            subjectLabel.trailingAnchor.constraint(equalTo: arrowImageView.leadingAnchor, constant: -8),
            
            // Teacher Label
            teacherLabel.topAnchor.constraint(equalTo: subjectLabel.bottomAnchor, constant: 4),
            teacherLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            teacherLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            teacherLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14)
        ])
    }
    
    // MARK: - Configuration
    
    private func configure(with item: ScheduleItem) {
        numberLabel.text = "\(item.number)"
        
        typeBadge.setTitle(item.type.rawValue.lowercased(), for: .normal)
        typeBadge.backgroundColor = item.type.color
        
        replacementBadge.isHidden = !item.isReplacement
        
        timeLabel.text = "\(item.startTime) – \(item.endTime)"
        roomLabel.text = item.room
        
        subjectLabel.text = item.subject
        teacherLabel.text = item.teacher
    }
}

