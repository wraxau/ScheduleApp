import UIKit

final class EmptyStateView: UIView {
    
    // MARK: - UI Properties
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
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
        
        addSubview(stackView)
       
        let imageView = UIImageView(image: UIImage(systemName: "sun.max"))
        imageView.tintColor = UIColor.systemBlue
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor(red: 0.0/255.0, green: 136.0/255.0, blue: 255.0/255.0, alpha: 0.1)
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true // Обязательно, чтобы фон был круглым
        imageView.contentMode = .center
        // Задаем отступы внутри картинки (top, left, bottom, right)
        imageView.image = imageView.image?.withAlignmentRectInsets(UIEdgeInsets(top: 0.5, left: 0.5, bottom: 0.5, right: 0.5))

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true

        let titleLabel = UILabel()
        titleLabel.text = "Выходной"
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = "В этот день нет занятий. Отдыхайте и набирайтесь сил :)"
        subtitleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        subtitleLabel.textColor = UIColor(red: 60.0/255.0, green: 60.0/255.0, blue: 67.0/255.0, alpha: 0.6)
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        subtitleLabel.lineBreakMode = .byWordWrapping
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 22.0 / 17.0
        paragraphStyle.alignment = .center
        
        let attributedString = NSMutableAttributedString(string: subtitleLabel.text ?? "")
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(.kern, value: -0.43, range: NSRange(location: 0, length: attributedString.length))
        
        subtitleLabel.attributedText = attributedString
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        
        stackView.setCustomSpacing(16, after: imageView)
        stackView.setCustomSpacing(8, after: titleLabel)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -40),
            subtitleLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, constant: -40),
            titleLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, constant: -40)
        ])
    }
}
