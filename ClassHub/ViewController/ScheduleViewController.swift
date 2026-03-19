import UIKit

final class ScheduleViewController: UIViewController {
    
    // MARK: - UI Properties
    
    private let titleLabel: UILabel = makeTitleLabel()
    private let monthLabel: UILabel = makeMonthLabel()
    private let todayButton: UIButton = makeTodayButton()
    
    private let fadeOverlayView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 80)
        
        view.layer.mask = gradientLayer
        view.isUserInteractionEnabled = false
        return view
    }()

    private lazy var daysCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8.33
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.dataSource = self
        cv.delegate = self
        cv.register(DayCell.self, forCellWithReuseIdentifier: DayCell.reuseIdentifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private let summaryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.separator.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = .clear
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    
    private let contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var emptyStateView: EmptyStateView?
    
    // MARK: - Data
    
    private var currentMonth: Date = Date()
    private var selectedDate: Date = Date()
    private var weekDates: [Date] = []
    private var scheduleData: [Date: DaySchedule] = [:]
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupHierarchy()
        setupConstraints()
        setupActions()
        loadData()
        
        let today = Date()
        selectedDate = today
        currentMonth = today
        generateWeekDates()
        updateUI()
        
        // Отступ снизу, чтобы контент не перекрывался таббаром
        scrollView.contentInset.bottom = 100
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    // MARK: - Setup
    
    private func setupHierarchy() {
        view.addSubview(titleLabel)
        view.addSubview(monthLabel)
        view.addSubview(todayButton)
        view.addSubview(daysCollectionView)
        view.addSubview(separatorView)
        view.addSubview(summaryLabel)
        scrollView.addSubview(contentStackView)
        view.addSubview(fadeOverlayView)
        view.addSubview(scrollView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            monthLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            monthLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            todayButton.centerYAnchor.constraint(equalTo: monthLabel.centerYAnchor),
            todayButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            daysCollectionView.topAnchor.constraint(equalTo: monthLabel.bottomAnchor, constant: 14),
            daysCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            daysCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            daysCollectionView.heightAnchor.constraint(equalToConstant: 65),
            
            separatorView.topAnchor.constraint(equalTo: daysCollectionView.bottomAnchor, constant: 8),
            separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5),
            
            summaryLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 12),
            summaryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            summaryLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            scrollView.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: 8),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 0),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -16),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: 0),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -32),
            
            fadeOverlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            fadeOverlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            fadeOverlayView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            fadeOverlayView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func setupActions() {
        todayButton.addTarget(self, action: #selector(todayTapped), for: .touchUpInside)
    }
    
    // MARK: - Logic & Data
    
    private func loadData() {
        generateWeekDates()
        scheduleData = ScheduleMockData.generateSampleSchedule()
        
        selectedDate = Date()
        currentMonth = Date()
        generateWeekDates()
    }
    
    private func updateUI() {
        updateMonthLabel()
        daysCollectionView.reloadData()
        updateSummaryLabel()
        renderContent()
    }
    
    private func renderContent() {
        contentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Удаляем предыдущий empty state, если он был добавлен напрямую в scrollView
        scrollView.subviews.forEach { view in
            if view is EmptyStateView {
                view.removeFromSuperview()
            }
        }
        
        guard let day = scheduleData[selectedDate], !day.items.isEmpty else {
            showEmptyState()
            return
        }
        
        contentStackView.isHidden = false
        
        for item in day.items {
            let card = ClassCardView(item: item)
            contentStackView.addArrangedSubview(card)
            
            if let breakText = item.breakAfter {
                let breakContainer = UIView()
                breakContainer.translatesAutoresizingMaskIntoConstraints = false
                
                let breakLabel = UILabel()
                breakLabel.text = breakText
                breakLabel.font = UIFont.systemFont(ofSize: 12)
                breakLabel.textColor = UIColor.secondaryLabel.withAlphaComponent(0.8)
                breakLabel.translatesAutoresizingMaskIntoConstraints = false
                
                let timeLabel = UILabel()
                if let breakEnd = item.breakEndTime {
                    timeLabel.text = "\(item.endTime) – \(breakEnd)"
                } else {
                    timeLabel.text = item.endTime
                }
                timeLabel.font = UIFont.systemFont(ofSize: 12)
                timeLabel.textColor = UIColor.secondaryLabel.withAlphaComponent(0.6)
                timeLabel.translatesAutoresizingMaskIntoConstraints = false
                
                breakContainer.addSubview(breakLabel)
                breakContainer.addSubview(timeLabel)
                
                NSLayoutConstraint.activate([
                    breakLabel.leadingAnchor.constraint(equalTo: breakContainer.leadingAnchor, constant: 16),
                    breakLabel.centerYAnchor.constraint(equalTo: breakContainer.centerYAnchor),
                    
                    timeLabel.trailingAnchor.constraint(equalTo: breakContainer.trailingAnchor, constant: -16),
                    timeLabel.centerYAnchor.constraint(equalTo: breakContainer.centerYAnchor),
                    
                    breakContainer.heightAnchor.constraint(equalToConstant: 20)
                ])
                
                contentStackView.addArrangedSubview(breakContainer)
            }
        }
    }
    
    private func showEmptyState() {
        contentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let emptyView = EmptyStateView()
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(emptyView)
        
        NSLayoutConstraint.activate([
            emptyView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            emptyView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),
            emptyView.topAnchor.constraint(greaterThanOrEqualTo: scrollView.contentLayoutGuide.topAnchor, constant: 16),
            emptyView.bottomAnchor.constraint(lessThanOrEqualTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -16)
        ])
        
        contentStackView.isHidden = true
    }
    
    private func updateSummaryLabel() {
        guard let day = scheduleData[selectedDate], !day.items.isEmpty else {
            summaryLabel.isHidden = true
            return
        }
        
        summaryLabel.isHidden = false
        let count = day.items.count
        
        if let lastItem = day.items.last {
            summaryLabel.text = "\(count) занятий до \(lastItem.endTime)"
        } else {
            summaryLabel.text = "\(count) занятий"
        }
    }
    
    private func updateMonthLabel() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "MMMM yyyy"
        monthLabel.text = formatter.string(from: currentMonth).capitalized
    }
    
    private func generateWeekDates() {
        let calendar = Calendar.current
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: selectedDate))!
        weekDates = (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }
    }
    
    @objc private func todayTapped() {
        selectedDate = Date()
        currentMonth = Date()
        generateWeekDates()
        updateUI()
    }
}

// MARK: - Helpers

extension ScheduleViewController {
    static func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.text = "Расписание"
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    static func makeMonthLabel() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    static func makeTodayButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Сегодня >", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}

// MARK: - UICollectionViewDataSource & Delegate

extension ScheduleViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weekDates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayCell.reuseIdentifier, for: indexPath) as! DayCell
        let date = weekDates[indexPath.item]
        let isSelected = Calendar.current.isDate(date, inSameDayAs: selectedDate)
        let isToday = Calendar.current.isDate(date, inSameDayAs: Date())
        
        let weekday = Calendar.current.component(.weekday, from: date)
        let isWeekend = (weekday == 1 || weekday == 7)
        
        cell.configure(date: date, isSelected: isSelected, isToday: isToday, isWeekend: isWeekend)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item < weekDates.count else { return }
        
        selectedDate = weekDates[indexPath.item]
        
        let calendar = Calendar.current
        let selectedComponents = calendar.dateComponents([.month, .year], from: selectedDate)
        let currentComponents = calendar.dateComponents([.month, .year], from: currentMonth)
        
        if selectedComponents.month != currentComponents.month {
            currentMonth = selectedDate
            updateMonthLabel()
        }
        
        daysCollectionView.reloadData()
        updateUI()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 44, height: 44)
    }
}

