import UIKit
import Foundation

final class TopicCardView: UIView {
    
    private let item: ScheduleItem

    init(item: ScheduleItem) {
        self.item = item
        super.init(frame: .zero)
        setupTopicCard()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let topicCard: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    // MARK: Topic Card
    
    private func setupTopicCard() {
        
        addSubview(topicCard)
                
        NSLayoutConstraint.activate([
            topicCard.topAnchor.constraint(equalTo: topAnchor),
            topicCard.leadingAnchor.constraint(equalTo: leadingAnchor),
            topicCard.trailingAnchor.constraint(equalTo: trailingAnchor),
            topicCard.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
                
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
}


