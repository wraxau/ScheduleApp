import UIKit

final class DayCell: UICollectionViewCell {
    static let reuseIdentifier = "DayCell"
    
    // MARK: - UI Elements
    
    private let dayNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dayNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let selectionCircle: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 22
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        contentView.addSubview(selectionCircle)
        contentView.addSubview(dayNumberLabel)
        contentView.addSubview(dayNameLabel)
        
        NSLayoutConstraint.activate([
            selectionCircle.centerXAnchor.constraint(equalTo: dayNumberLabel.centerXAnchor),
            selectionCircle.centerYAnchor.constraint(equalTo: dayNumberLabel.centerYAnchor),
            selectionCircle.widthAnchor.constraint(equalToConstant: 44),
            selectionCircle.heightAnchor.constraint(equalToConstant: 44),
            
            dayNameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dayNameLabel.widthAnchor.constraint(equalToConstant: 32),
            dayNameLabel.heightAnchor.constraint(equalToConstant: 18),
            dayNameLabel.bottomAnchor.constraint(equalTo: dayNumberLabel.topAnchor, constant: -8),
        ])
    }
    
    // MARK: - Configuration
    
    func configure(date: Date, isSelected: Bool, isToday: Bool, isWeekend: Bool) {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        let weekdays = ["", "ВС", "ПН", "ВТ", "СР", "ЧТ", "ПТ", "СБ"]
        
        dayNameLabel.text = weekdays[weekday]
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d"
        
        dayNumberLabel.text = formatter.string(from: date)
        dayNumberLabel.textColor = .label
        dayNameLabel.textColor = .secondaryLabel
        
        if isSelected {
            dayNumberLabel.textColor = .white
            dayNumberLabel.font = UIFont.systemFont(ofSize: 24, weight: .medium)
            selectionCircle.isHidden = false
        } else {
            dayNumberLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
            if isToday {
                dayNumberLabel.textColor = .systemBlue
            } else if isWeekend, weekday == 1 || weekday == 7 {
                dayNumberLabel.textColor = .systemRed
                dayNameLabel.textColor = .systemRed
            }
            selectionCircle.isHidden = true
        }
    }
}
