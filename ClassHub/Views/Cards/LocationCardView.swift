import UIKit
import Foundation

final class LocationCardView: UIView {
    
    private let item: ScheduleItem
    
    private let locationCard: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(item: ScheduleItem) {
        self.item = item
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupLocationCard()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLocationCard() {
        addSubview(locationCard)
        
        NSLayoutConstraint.activate([
            locationCard.topAnchor.constraint(equalTo: topAnchor),
            locationCard.leadingAnchor.constraint(equalTo: leadingAnchor),
            locationCard.trailingAnchor.constraint(equalTo: trailingAnchor),
            locationCard.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // Общие элементы
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
        
        // Онлайн класс
        if let link = item.meetingLink, !link.isEmpty {
            setupOnlineLayout(
                locationCard: locationCard,
                iconBackgroundView: iconBackgroundView,
                iconImageView: iconImageView,
                titleLabel: titleLabel,
                valueLabel: valueLabel,
                serviceName: item.meetingServiceName ?? "Онлайн-конференция"
            )
        } else {
            // Офлайн класс
            setupOfflineLayout(
                locationCard: locationCard,
                iconBackgroundView: iconBackgroundView,
                iconImageView: iconImageView,
                titleLabel: titleLabel,
                valueLabel: valueLabel
            )
        }
    }
    
    // MARK: - Online Layout
    private func setupOnlineLayout(
        locationCard: UIView,
        iconBackgroundView: UIView,
        iconImageView: UIImageView,
        titleLabel: UILabel,
        valueLabel: UILabel,
        serviceName: String
    ) {
        titleLabel.text = "Онлайн"
        iconImageView.image = UIImage(systemName: "video.fill")
        valueLabel.text = serviceName
        
        let actionButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Перейти", for: .normal)
            button.backgroundColor = .systemBlue
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
            button.layer.cornerRadius = 12
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
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
    }
    
    // MARK: - Offline Layout
    private func setupOfflineLayout(
        locationCard: UIView,
        iconBackgroundView: UIView,
        iconImageView: UIImageView,
        titleLabel: UILabel,
        valueLabel: UILabel
    ) {
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
