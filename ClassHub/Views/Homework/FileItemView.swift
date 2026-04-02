import UIKit

final class FileItemView: UIView {
    
    private let fileNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let fileSizeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let iconBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray5
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.tintColor = .systemRed
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Действие при удалении
    var onDeleteTapped: (() -> Void)?
    
    init(file: AttachedFile) {
        super.init(frame: .zero)
        setupUI(file: file)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(file: AttachedFile) {
        backgroundColor = UIColor.systemGreen.withAlphaComponent(0.05)
        layer.cornerRadius = 16
        translatesAutoresizingMaskIntoConstraints = false
        
        iconImageView.image = UIImage(systemName: "doc.fill")
        fileNameLabel.text = file.name
        fileSizeLabel.text = file.size
        
        addSubview(iconBackgroundView)
        iconBackgroundView.addSubview(iconImageView)
        addSubview(fileNameLabel)
        addSubview(fileSizeLabel)
        addSubview(deleteButton)
        
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            iconBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            iconBackgroundView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconBackgroundView.widthAnchor.constraint(equalToConstant: 40),
            iconBackgroundView.heightAnchor.constraint(equalToConstant: 40),
            
            iconImageView.centerXAnchor.constraint(equalTo: iconBackgroundView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconBackgroundView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            
            fileNameLabel.leadingAnchor.constraint(equalTo: iconBackgroundView.trailingAnchor, constant: 16),
            fileNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            fileNameLabel.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -8),
            
            fileSizeLabel.leadingAnchor.constraint(equalTo: iconBackgroundView.trailingAnchor, constant: 16),
            fileSizeLabel.topAnchor.constraint(equalTo: fileNameLabel.bottomAnchor, constant: 4),
            fileSizeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            deleteButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 24),
            deleteButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    @objc private func deleteTapped() {
        onDeleteTapped?()
    }
}
