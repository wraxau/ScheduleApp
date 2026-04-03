import Foundation
import UIKit

final class ClassDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private let item: ScheduleItem
    private let date: Date
    
    // массив загруженных файлов
    private var attachedFiles: [AttachedFile] = []
    
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
    
    private lazy var topicCard: TopicCardView = {
        let card = TopicCardView(item: item)
        card.translatesAutoresizingMaskIntoConstraints = false
        return card
    }()

    private lazy var teacherCard: TeacherCardView = {
        let card = TeacherCardView(item: item)
        card.translatesAutoresizingMaskIntoConstraints = false
        return card
    }()

    private lazy var locationCard: LocationCardView = {
        let card = LocationCardView(item: item)
        card.translatesAutoresizingMaskIntoConstraints = false
        return card
    }()
    
    
    private let emptyMaterialsView: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = UIImageView(image: UIImage(systemName: "folder.badge.questionmark"))
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = "Материалы еще не добавлены"
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = "Загляните позже - они появятся здесь"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, label])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(imageView)
        container.addSubview(stack)
        
        NSLayoutConstraint.activate([
            
            imageView.topAnchor.constraint(equalTo: container.topAnchor, constant: 56),
            imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 57),
            imageView.heightAnchor.constraint(equalToConstant: 38),
            
            stack.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            stack.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: stack.topAnchor),
            label.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4)
        ])
        return container
    }()
    
    private let filesListView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill      // исправлено!
        stack.spacing = 8.5
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isHidden = true
        return stack
    }()
    
    private let infoContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let materialsContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private let taskContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private let taskLabel: UILabel = {
        let task = UILabel()
        task.font = .systemFont(ofSize: 17, weight: .regular)
        task.textColor = .secondaryLabel
        task.numberOfLines = 0
        task.translatesAutoresizingMaskIntoConstraints = false
        return task
    }()
    
    private let listToDo: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let passTaskLabel: UILabel = {
        let label = UILabel()
        label.text = "Сдать задание"
        label.textColor = .label
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Контейнер-стек для файлов и кнопки
    private let filesStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // Кнопка "Прикрепить файл"
    private let attachButton: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.systemGray4.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Кнопка "Сдать задание"
    private let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Сдать задание", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.layer.cornerRadius = 18
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
        setupAttachButtonContent()
        setUpToDoList()  
        
        infoContainer.isHidden = false
        materialsContainer.isHidden = true
        taskContainer.isHidden = true
        
        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        
        scrollView.contentInset.bottom = 100
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let layer = dashedBorderLayer {
            layer.path = UIBezierPath(roundedRect: attachButton.bounds.insetBy(dx: 1, dy: 1), cornerRadius: 20).cgPath
        }
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
    
    // MARK: - Setup Hierarchy 
    private func setupHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [dateLabel, titleLabel, timeLabel, typeBadge, cancelledButton, segmentedControl].forEach {
            contentView.addSubview($0)
        }
        
        contentView.addSubview(infoContainer)
        [teacherCard, locationCard, topicCard].forEach {
            infoContainer.addSubview($0)
        }
        
        contentView.addSubview(materialsContainer)
        materialsContainer.addSubview(emptyMaterialsView)
        materialsContainer.addSubview(filesListView)

        contentView.addSubview(taskContainer)
        taskContainer.addSubview(listToDo)
        taskContainer.addSubview(filesStackView)
        taskContainer.addSubview(attachButton)
        taskContainer.addSubview(submitButton)
        
        NSLayoutConstraint.activate([
            emptyMaterialsView.topAnchor.constraint(equalTo: materialsContainer.topAnchor),
            emptyMaterialsView.leadingAnchor.constraint(equalTo: materialsContainer.leadingAnchor),
            emptyMaterialsView.trailingAnchor.constraint(equalTo: materialsContainer.trailingAnchor),
            emptyMaterialsView.bottomAnchor.constraint(equalTo: materialsContainer.bottomAnchor),
            
            filesListView.topAnchor.constraint(equalTo: materialsContainer.topAnchor),
            filesListView.leadingAnchor.constraint(equalTo: materialsContainer.leadingAnchor),
            filesListView.trailingAnchor.constraint(equalTo: materialsContainer.trailingAnchor),
        ])
    }

    // MARK: - Constraints
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
            
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 50),
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
            
            // Info Container
            infoContainer.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16),
            infoContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            infoContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            teacherCard.topAnchor.constraint(equalTo: infoContainer.topAnchor),
            teacherCard.leadingAnchor.constraint(equalTo: infoContainer.leadingAnchor),
            teacherCard.trailingAnchor.constraint(equalTo: infoContainer.trailingAnchor),
            teacherCard.heightAnchor.constraint(equalToConstant: 84),
            
            locationCard.topAnchor.constraint(equalTo: teacherCard.bottomAnchor, constant: 16),
            locationCard.leadingAnchor.constraint(equalTo: infoContainer.leadingAnchor),
            locationCard.trailingAnchor.constraint(equalTo: infoContainer.trailingAnchor),
            
            topicCard.topAnchor.constraint(equalTo: locationCard.bottomAnchor, constant: 32),
            topicCard.leadingAnchor.constraint(equalTo: infoContainer.leadingAnchor),
            topicCard.trailingAnchor.constraint(equalTo: infoContainer.trailingAnchor),
            topicCard.bottomAnchor.constraint(equalTo: infoContainer.bottomAnchor),
            
            materialsContainer.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16),
            materialsContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            materialsContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            materialsContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            taskContainer.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16),
            taskContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            taskContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            taskContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
         
            listToDo.topAnchor.constraint(equalTo: taskContainer.topAnchor),
            listToDo.leadingAnchor.constraint(equalTo: taskContainer.leadingAnchor),
            listToDo.trailingAnchor.constraint(equalTo: taskContainer.trailingAnchor),
            
            filesStackView.topAnchor.constraint(equalTo: listToDo.bottomAnchor, constant: 24),
            filesStackView.leadingAnchor.constraint(equalTo: taskContainer.leadingAnchor),
            filesStackView.trailingAnchor.constraint(equalTo: taskContainer.trailingAnchor),
            
            attachButton.topAnchor.constraint(equalTo: filesStackView.bottomAnchor, constant: 16),
            attachButton.leadingAnchor.constraint(equalTo: taskContainer.leadingAnchor),
            attachButton.trailingAnchor.constraint(equalTo: taskContainer.trailingAnchor),
            attachButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 150),
            
            submitButton.topAnchor.constraint(equalTo: attachButton.bottomAnchor, constant: 16),
            submitButton.leadingAnchor.constraint(equalTo: taskContainer.leadingAnchor),
            submitButton.trailingAnchor.constraint(equalTo: taskContainer.trailingAnchor),
            submitButton.heightAnchor.constraint(equalToConstant: 50),
            submitButton.bottomAnchor.constraint(equalTo: taskContainer.bottomAnchor)
        ])
    }

    // MARK: - Update Files List
    private func updateFilesList() {
        // Очищаем стек от старых элементов
        filesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        if attachedFiles.isEmpty {
            filesStackView.isHidden = true
            attachButton.isHidden = false
            submitButton.isEnabled = false
            submitButton.setTitleColor(.secondaryLabel, for: .normal)
            submitButton.backgroundColor  = .secondarySystemBackground
            submitButton.layer.shadowColor = UIColor.black.cgColor
            submitButton.layer.shadowOpacity = 0.2
            submitButton.layer.shadowOffset = CGSize(width: 0, height: 2)
            submitButton.layer.shadowRadius = 4
        } else {
            filesStackView.isHidden = false
            attachButton.isHidden = false
            submitButton.setTitleColor(.white, for: .normal)
            submitButton.backgroundColor  = .systemBlue
            
            for file in attachedFiles {
                let fileView = FileItemView(file: file)
                fileView.onDeleteTapped = { [weak self] in
                    guard let self = self,
                          let index = self.attachedFiles.firstIndex(where: { $0.name == file.name }) else {
                        return
                    }
                    self.attachedFiles.remove(at: index)
                    self.updateFilesList()
                }
                filesStackView.addArrangedSubview(fileView)
            }
            
            submitButton.isEnabled = true
            submitButton.alpha = 1.0
        }
        view.layoutIfNeeded()
    }
   
    
    // MARK: Configure UI
    
    private func configureUI() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMMM yyyy"
        dateLabel.text = formatter.string(from: date).capitalized
        
        titleLabel.text = item.subject
        
        let attachment = NSTextAttachment()
        attachment.image = UIImage(systemName: "clock")?.withTintColor(.secondaryLabel, renderingMode: .alwaysOriginal)
        attachment.bounds = CGRect(x: 0, y: -2, width: 16, height: 16)
        
        let attachmentString = NSAttributedString(attachment: attachment)
        let timeString = NSAttributedString(string: " \(item.startTime) – \(item.endTime)")
        
        let mutableAttributedString = NSMutableAttributedString()
        mutableAttributedString.append(attachmentString)
        mutableAttributedString.append(timeString)
        
        timeLabel.attributedText = mutableAttributedString
        
        typeBadge.setTitle(item.type.rawValue, for: .normal)
        typeBadge.backgroundColor = item.type.color
        
        taskLabel.text = item.tasks ?? "Заданий на данный момент нет"

        setUpToDoList()
    }
    
    private func updateMaterialsView() {
        if item.materials?.isEmpty ?? true {
            emptyMaterialsView.isHidden = false
            filesListView.isHidden = true
        } else {
            emptyMaterialsView.isHidden = true
            filesListView.isHidden = false
            
            filesListView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            
            for material in item.materials! {
                let card = createMaterialCard(material)
                filesListView.addArrangedSubview(card)
                card.heightAnchor.constraint(equalToConstant: 68).isActive = true
            }
        }
    }
    
    // MARK: Method - To Do List
    
    private func setUpToDoList() {
        listToDo.subviews.forEach { $0.removeFromSuperview() }
        
        let titleLabel = UILabel()
        titleLabel.text = "Что нужно сделать"
        titleLabel.textColor = .label
        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let divider = UIView()
        divider.backgroundColor = UIColor.separator.withAlphaComponent(0.5)
        divider.translatesAutoresizingMaskIntoConstraints = false
        
        listToDo.addSubview(titleLabel)
        listToDo.addSubview(divider)
        listToDo.addSubview(taskLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: listToDo.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: listToDo.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: listToDo.trailingAnchor, constant: -16),
            
            divider.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            divider.leadingAnchor.constraint(equalTo: listToDo.leadingAnchor, constant: 16),
            divider.trailingAnchor.constraint(equalTo: listToDo.trailingAnchor, constant: -16),
            divider.heightAnchor.constraint(equalToConstant: 1),
            
            taskLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 12),
            taskLabel.leadingAnchor.constraint(equalTo: listToDo.leadingAnchor, constant: 16),
            taskLabel.trailingAnchor.constraint(equalTo: listToDo.trailingAnchor, constant: -16),
            taskLabel.bottomAnchor.constraint(equalTo: listToDo.bottomAnchor, constant: -16)
        ])
    }
    
    private func setupAttachButtonContent() {
        attachButton.layer.borderWidth = 0
        attachButton.layer.borderColor = nil
        
        let iconContainer: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
            view.layer.cornerRadius = 25
            view.translatesAutoresizingMaskIntoConstraints = false
            let icon = UIImageView(image: UIImage(systemName: "icloud.and.arrow.down"))
            icon.tintColor = .systemBlue
            icon.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(icon)
            NSLayoutConstraint.activate([
                icon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                icon.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                icon.widthAnchor.constraint(equalToConstant: 28),
                icon.heightAnchor.constraint(equalToConstant: 28),
                view.widthAnchor.constraint(equalToConstant: 50),
                view.heightAnchor.constraint(equalToConstant: 50),
            ])
            return view
    }()
        
        let titleLabel = UILabel()
        titleLabel.text = "Прикрепить файл"
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = "PDF, DOCX, JPG — до 20 МБ"
        subtitleLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let stack = UIStackView(arrangedSubviews: [iconContainer, titleLabel, subtitleLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        attachButton.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: attachButton.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: attachButton.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: attachButton.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: attachButton.trailingAnchor, constant: -16),
        ])
        
        // Пунктирная рамка
        let dashedBorder = CAShapeLayer()
        dashedBorder.strokeColor = UIColor.systemGray4.cgColor
        dashedBorder.lineDashPattern = [6, 6]
        dashedBorder.fillColor = nil
        dashedBorder.lineWidth = 2
        dashedBorder.cornerRadius = 20
        attachButton.layer.addSublayer(dashedBorder)
        self.dashedBorderLayer = dashedBorder
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(attachFileTapped))
        attachButton.addGestureRecognizer(tap)
        attachButton.isUserInteractionEnabled = true
    }

    
    private var dashedBorderLayer: CAShapeLayer?
    
    @objc private func attachFileTapped() {
        // Имитация добавления файла
        let newFile = AttachedFile(name: "IMG_\(Int.random(in: 100...999)).jpeg", size: "1,7 MB", type: "jpg")
        attachedFiles.append(newFile)
        updateFilesList()
    }
    
    
    private func createMaterialCard(_ material: Material) -> UIView {
        let cardView = UIView()
        cardView.backgroundColor = UIColor.systemGray6
        cardView.layer.cornerRadius = 16
        cardView.clipsToBounds = true
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        cardView.setContentCompressionResistancePriority(.required, for: .vertical)
        cardView.setContentHuggingPriority(.required, for: .vertical)
        
        let fileExtension = getFileExtension(from: material.name)
        let (iconName, iconColor, bgColor) = getFileIconInfo(for: fileExtension)
        
        // Иконка
        let iconContainer: UIView = {
            let view = UIView()
            view.backgroundColor = bgColor
            view.layer.cornerRadius = 10
            view.translatesAutoresizingMaskIntoConstraints = false
            view.widthAnchor.constraint(equalToConstant: 44).isActive = true
            view.heightAnchor.constraint(equalToConstant: 44).isActive = true
            
            if ["jpg", "jpeg", "png", "gif", "heic"].contains(fileExtension.lowercased()) {
                let extensionLabel = UILabel()
                extensionLabel.text = fileExtension.uppercased()
                extensionLabel.font = UIFont.systemFont(ofSize: 10, weight: .bold)
                extensionLabel.textColor = iconColor
                extensionLabel.textAlignment = .center
                extensionLabel.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(extensionLabel)
                
                NSLayoutConstraint.activate([
                    extensionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    extensionLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -2)
                ])
            } else {
                // Для других файлов — иконка
                let imageView = UIImageView(image: UIImage(systemName: iconName))
                imageView.tintColor = iconColor
                imageView.contentMode = .scaleAspectFit
                imageView.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(imageView)
                
                NSLayoutConstraint.activate([
                    imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                    imageView.widthAnchor.constraint(equalToConstant: 20),
                    imageView.heightAnchor.constraint(equalToConstant: 24)
                ])
            }
            
            return view
        }()
        
        // Название файла
        let nameLabel = UILabel()
        nameLabel.text = material.name ?? "Файл"
        nameLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        nameLabel.textColor = .label
        nameLabel.numberOfLines = 1
        nameLabel.lineBreakMode = .byTruncatingTail
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        
        // Размер файла
        let sizeLabel = UILabel()
        sizeLabel.text = material.size ?? ""
        sizeLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        sizeLabel.textColor = .secondaryLabel
        sizeLabel.translatesAutoresizingMaskIntoConstraints = false
        sizeLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        
        // Кнопка скачивания
        let downloadButton: UIButton = {
            let button = UIButton(type: .system)
            button.setImage(UIImage(systemName: "arrow.down.to.line"), for: .normal)
            button.tintColor = .secondaryLabel
            button.translatesAutoresizingMaskIntoConstraints = false
            button.widthAnchor.constraint(equalToConstant: 30).isActive = true
            button.heightAnchor.constraint(equalToConstant: 30).isActive = true
            button.addTarget(self, action: #selector(downloadTapped(_:)), for: .touchUpInside)
            return button
        }()
        
        // --- Сборка ---
        cardView.addSubview(iconContainer)
        cardView.addSubview(nameLabel)
        cardView.addSubview(sizeLabel)
        cardView.addSubview(downloadButton)
        
        NSLayoutConstraint.activate([
            // Иконка: слева, центр по вертикали
            iconContainer.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            iconContainer.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            
            // Кнопка: справа, центр по вертикали
            downloadButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            downloadButton.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            
            // Название: между иконкой и кнопкой, сверху
            nameLabel.leadingAnchor.constraint(equalTo: iconContainer.trailingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: downloadButton.leadingAnchor, constant: -8),
            nameLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12.5),
            
            // Размер: под названием
            sizeLabel.leadingAnchor.constraint(equalTo: iconContainer.trailingAnchor, constant: 12),
            sizeLabel.trailingAnchor.constraint(lessThanOrEqualTo: downloadButton.leadingAnchor, constant: -8),
            sizeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            sizeLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12.5)
        ])
        
        return cardView
    }

    
    private func getFileExtension(from filename: String?) -> String {
        guard let filename = filename, let ext = filename.split(separator: ".").last else {
            return "file"
        }
        return String(ext)
    }

    private func getFileIconInfo(for `extension`: String) -> (iconName: String, iconColor: UIColor, bgColor: UIColor) {
        switch `extension`.lowercased() {
        case "jpg", "jpeg", "png", "gif", "heic":
            return ("doc.fill", .systemOrange, UIColor.systemOrange.withAlphaComponent(0.15))
        case "pdf":
            return ("doc.fill", .systemRed, UIColor.systemRed.withAlphaComponent(0.15))
        case "doc", "docx":
            return ("doc.fill", .systemBlue, UIColor.systemBlue.withAlphaComponent(0.15))
        case "xls", "xlsx":
            return ("doc.fill", .systemGreen, UIColor.systemGreen.withAlphaComponent(0.15))
        default:
            return ("doc", .systemGray, UIColor.systemGray5)
        }
    }
    
    // Обработчик нажатия на кнопку скачивания
    @objc private func downloadTapped(_ sender: UIButton) {
        print(" Нажата кнопка скачивания")
        // Тут будет логика открытия ссылки из material.link
    }
    
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func joinMeetingTapped() {
        if let link = item.meetingLink, let url = URL(string: link) {
            UIApplication.shared.open(url)
        }
    }
    
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        
        if index == 0 { // Информация
            infoContainer.isHidden = false
            materialsContainer.isHidden = true
            taskContainer.isHidden = true
        } else if index == 1 { // Материалы
            infoContainer.isHidden = true
            taskContainer.isHidden = true
            materialsContainer.isHidden = false
            updateMaterialsView()
        } else if index == 2 { // Задание
            infoContainer.isHidden = true
            materialsContainer.isHidden = true
            taskContainer.isHidden = false
            updateFilesList()
        }
    }
}

