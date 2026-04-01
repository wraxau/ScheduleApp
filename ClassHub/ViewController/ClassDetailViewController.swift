import Foundation
import UIKit

final class ClassDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private let item: ScheduleItem
    private let date: Date
    
    // MARK: - UI Elements
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let typeBadge: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentEdgeInsets = UIEdgeInsets(top: 3, left: 15, bottom: 3, right: 15)
        return button
    }()
    
    private let segmentedControl: UISegmentedControl = {
        let items = ["Информация", "Материалы", "Задание"]
        let sc = UISegmentedControl(items: items)
        sc.selectedSegmentIndex = 0
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()
    
    private let teacherCard: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let locationCard: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let topicCard: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let cancelledButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("отменено", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.backgroundColor  = .red
        button.isHidden = true
        button.contentEdgeInsets = UIEdgeInsets(top: 3, left: 15, bottom: 3, right: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    // MARK: - Initialization
    
    init(item: ScheduleItem, date: Date) {
        self.item = item
        self.date = date
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupHierarchy()
        setupConstraints()
        configureUI()
        isCancelled()
    }
    
    // MARK: - Setup
    
    private func setupNavigationBar() {
        title = "Занятие"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.isHidden = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backTapped)
        )
        navigationItem.leftBarButtonItem?.tintColor = .label
    }
    
    private func isCancelled() {
        if item.isCancelled {
            cancelledButton.isHidden = true
        } else {
            cancelledButton.isHidden = false
        }
    }
    
    private func setupHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        let subviews = [dateLabel, titleLabel, timeLabel, typeBadge, segmentedControl, teacherCard, locationCard, topicCard, cancelledButton]
        subviews.forEach { contentView.addSubview($0) }
    }
    
    // MARK: Constraints
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -16),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -16),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -32),
            
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            timeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            typeBadge.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 8),
            typeBadge.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            typeBadge.heightAnchor.constraint(equalToConstant: 26),
            
            cancelledButton.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 8),
            cancelledButton.leadingAnchor.constraint(equalTo: typeBadge.trailingAnchor, constant: 10),
            cancelledButton.widthAnchor.constraint(equalToConstant: 103),
            cancelledButton.heightAnchor.constraint(equalToConstant: 26),
            
            segmentedControl.topAnchor.constraint(equalTo: typeBadge.bottomAnchor, constant: 16),
            segmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            segmentedControl.heightAnchor.constraint(equalToConstant: 36),
            
            teacherCard.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16),
            teacherCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            teacherCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            teacherCard.heightAnchor.constraint(equalToConstant: 84),
            
            locationCard.topAnchor.constraint(equalTo: teacherCard.bottomAnchor, constant: 16),
            locationCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            locationCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            topicCard.topAnchor.constraint(equalTo: locationCard.bottomAnchor, constant: 32),
            topicCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            topicCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            topicCard.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),
            topicCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    // MARK: Configure UI
    
    private func configureUI() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMMM yyyy"
        dateLabel.text = formatter.string(from: date).capitalized
        
        titleLabel.text = item.subject
        timeLabel.text = "􀐫 \(item.startTime) – \(item.endTime)"
        typeBadge.setTitle(item.type.rawValue, for: .normal)
        typeBadge.backgroundColor = item.type.color
        
        setupTeacherCard()
        setupLocationCard()
        setupTopicCard()
    }
    
    // MARK: Teacher Card
    
    private func setupTeacherCard() {
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
    
    // MARK: Location Card
    
    private func setupLocationCard() {
        
        // Settings for both types
        locationCard.backgroundColor = .systemGray6
        
        let iconImageView = UIImageView()
        iconImageView.tintColor = .systemBlue
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let iconBackgroundView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
            view.layer.cornerRadius = 12
            view.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(iconImageView)
            
            NSLayoutConstraint.activate([
                iconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                iconImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                iconImageView.widthAnchor.constraint(equalToConstant: 24),
                iconImageView.heightAnchor.constraint(equalToConstant: 24)
            ])
            return view
        }()
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        titleLabel.textColor = .secondaryLabel
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let valueLabel = UILabel()
        valueLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        valueLabel.textColor = .label
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
    
        // Online class
        
        if let link = item.meetingLink, !link.isEmpty {
            titleLabel.text = "Онлайн"
            iconImageView.image = UIImage(systemName: "video.fill")
            let serviceName = item.meetingServiceName ?? "Онлайн-конференция"
            valueLabel.text = serviceName
            
            
            let actionButton: UIButton = {
                let btn = UIButton(type: .system)
                btn.setTitle("Перейти", for: .normal)
                btn.backgroundColor = .systemBlue
                btn.setTitleColor(.white, for: .normal)
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
                btn.layer.cornerRadius = 12
                btn.translatesAutoresizingMaskIntoConstraints = false
                btn.addTarget(self, action: #selector(joinMeetingTapped), for: .touchUpInside)
                return btn
            }()
            
            locationCard.addSubview(iconBackgroundView)
            locationCard.addSubview(titleLabel)
            locationCard.addSubview(valueLabel)
            locationCard.addSubview(actionButton)
            
            NSLayoutConstraint.activate([
                
                locationCard.heightAnchor.constraint(equalToConstant: 84),
                
                iconBackgroundView.leadingAnchor.constraint(equalTo: locationCard.leadingAnchor, constant: 16),
                iconBackgroundView.centerYAnchor.constraint(equalTo: locationCard.centerYAnchor),
                iconBackgroundView.widthAnchor.constraint(equalToConstant: 40),
                iconBackgroundView.heightAnchor.constraint(equalToConstant: 40),
                
                titleLabel.leadingAnchor.constraint(equalTo: iconBackgroundView.trailingAnchor, constant: 16),
                titleLabel.topAnchor.constraint(equalTo: locationCard.topAnchor, constant: 16),
                titleLabel.trailingAnchor.constraint(equalTo: actionButton.leadingAnchor, constant: -16),
                
                valueLabel.leadingAnchor.constraint(equalTo: iconBackgroundView.trailingAnchor, constant: 16),
                valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
                valueLabel.trailingAnchor.constraint(equalTo: actionButton.leadingAnchor, constant: -16),
                valueLabel.bottomAnchor.constraint(equalTo: locationCard.bottomAnchor, constant: -16),
                
                actionButton.trailingAnchor.constraint(equalTo: locationCard.trailingAnchor, constant: -16),
                actionButton.centerYAnchor.constraint(equalTo: locationCard.centerYAnchor),
                actionButton.widthAnchor.constraint(equalToConstant: 90),
                actionButton.heightAnchor.constraint(equalToConstant: 36)
            ])
            
        } else {
            // Offline class
            
            titleLabel.text = "Аудитория"
            iconImageView.image = UIImage(systemName: "mappin.and.ellipse")
            
            valueLabel.text = item.room
            valueLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
            
            let buildingLabel = UILabel()
            buildingLabel.text = item.buildingInfo ?? ""
            buildingLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            buildingLabel.textColor = .secondaryLabel
            buildingLabel.translatesAutoresizingMaskIntoConstraints = false
            
            locationCard.addSubview(iconBackgroundView)
            locationCard.addSubview(titleLabel)
            locationCard.addSubview(valueLabel)
            locationCard.addSubview(buildingLabel)
            
            NSLayoutConstraint.activate([
                locationCard.heightAnchor.constraint(equalToConstant: 104),
                
                iconBackgroundView.leadingAnchor.constraint(equalTo: locationCard.leadingAnchor, constant: 16),
                iconBackgroundView.centerYAnchor.constraint(equalTo: locationCard.centerYAnchor),
                iconBackgroundView.widthAnchor.constraint(equalToConstant: 52),
                iconBackgroundView.heightAnchor.constraint(equalToConstant: 52),
                
                titleLabel.leadingAnchor.constraint(equalTo: iconBackgroundView.trailingAnchor, constant: 16),
                titleLabel.topAnchor.constraint(equalTo: locationCard.topAnchor, constant: 16),
                titleLabel.trailingAnchor.constraint(equalTo: locationCard.trailingAnchor, constant: -16),
                
                valueLabel.leadingAnchor.constraint(equalTo: iconBackgroundView.trailingAnchor, constant: 16),
                valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
                valueLabel.trailingAnchor.constraint(equalTo: locationCard.trailingAnchor, constant: -16),
                
                buildingLabel.leadingAnchor.constraint(equalTo: iconBackgroundView.trailingAnchor, constant: 16),
                buildingLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 34),
                buildingLabel.trailingAnchor.constraint(equalTo: locationCard.trailingAnchor, constant: -16),
                buildingLabel.bottomAnchor.constraint(equalTo: locationCard.bottomAnchor, constant: -16)
            ])
        }
    }
    
    // MARK: Topic Card
    
    private func setupTopicCard() {
        topicCard.backgroundColor = .systemGray6
        
        let topicTitleLabel = UILabel()
        topicTitleLabel.text = "Тема урока"
        topicTitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        topicTitleLabel.textColor = .secondaryLabel
        topicTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let topicValueLabel = UILabel()
        topicValueLabel.text = item.topic ?? "Не указана"
        topicValueLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        topicValueLabel.textColor = .label
        topicValueLabel.numberOfLines = 0
        topicValueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let divider = UIView()
        divider.backgroundColor = UIColor.separator.withAlphaComponent(0.5)
        divider.translatesAutoresizingMaskIntoConstraints = false
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = item.description ?? "Описание отсутствует."
        descriptionLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        topicCard.addSubview(topicTitleLabel)
        topicCard.addSubview(topicValueLabel)
        topicCard.addSubview(divider)
        topicCard.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            topicTitleLabel.topAnchor.constraint(equalTo: topicCard.topAnchor, constant: 16),
            topicTitleLabel.leadingAnchor.constraint(equalTo: topicCard.leadingAnchor, constant: 16),
            
            topicValueLabel.topAnchor.constraint(equalTo: topicTitleLabel.bottomAnchor, constant: 8),
            topicValueLabel.leadingAnchor.constraint(equalTo: topicCard.leadingAnchor, constant: 16),
            topicValueLabel.trailingAnchor.constraint(equalTo: topicCard.trailingAnchor, constant: -16),
            
            divider.topAnchor.constraint(equalTo: topicValueLabel.bottomAnchor, constant: 16),
            divider.leadingAnchor.constraint(equalTo: topicCard.leadingAnchor, constant: 16),
            divider.trailingAnchor.constraint(equalTo: topicCard.trailingAnchor, constant: -16),
            divider.heightAnchor.constraint(equalToConstant: 1),
            
            descriptionLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: topicCard.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: topicCard.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: topicCard.bottomAnchor, constant: -16)
        ])
    }
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func joinMeetingTapped() {
        if let link = item.meetingLink, let url = URL(string: link) {
            UIApplication.shared.open(url)
        }
    }
}

