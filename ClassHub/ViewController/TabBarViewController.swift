import UIKit

class TabBarViewController: UIViewController {

    // MARK: - Properties
    
    private var viewControllers: [UIViewController] = []
    private var currentIndex: Int = 0

    private let customTabBarContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let tabBarBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 24
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 8
        return view
    }()

    private let tabButtonsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let qrButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "qrcode")
        button.setImage(image, for: .normal)
        button.tintColor = .label
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = 24
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.1
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 8
        return button
    }()

    private let tabBarItems: [(title: String, icon: String, selectedIcon: String)] = [
        ("Расписание", "calendar", "calendar.fill"),
        ("Мой профиль", "person", "person.fill")
    ]

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupViewControllers()
        setupHierarchy()
        setupConstraints()
        
        switchTab(to: 0)
    }

    // MARK: - UI Setup
    
    private func setupHierarchy() {
        view.addSubview(customTabBarContainer)
        customTabBarContainer.addSubview(tabBarBackgroundView)
        customTabBarContainer.addSubview(qrButton)

        let scheduleButton = createTabButton(
            title: "Расписание",
            icon: "calendar",
            selectedIcon: "calendar.fill",
            index: 0
        )
        
        let profileButton = createTabButton(
            title: "Мой профиль",
            icon: "person",
            selectedIcon: "person.fill",
            index: 1
        )
        
        tabBarBackgroundView.addSubview(tabButtonsStackView)
        tabButtonsStackView.addArrangedSubview(scheduleButton)
        tabButtonsStackView.addArrangedSubview(profileButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            customTabBarContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customTabBarContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customTabBarContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            customTabBarContainer.heightAnchor.constraint(equalToConstant: 80),

            tabBarBackgroundView.leadingAnchor.constraint(equalTo: customTabBarContainer.leadingAnchor, constant: 16),
            tabBarBackgroundView.centerYAnchor.constraint(equalTo: customTabBarContainer.centerYAnchor),
            tabBarBackgroundView.heightAnchor.constraint(equalToConstant: 48),
            tabBarBackgroundView.widthAnchor.constraint(equalToConstant: 220),

            qrButton.trailingAnchor.constraint(equalTo: customTabBarContainer.trailingAnchor, constant: -16),
            qrButton.centerYAnchor.constraint(equalTo: customTabBarContainer.centerYAnchor),
            qrButton.widthAnchor.constraint(equalToConstant: 48),
            qrButton.heightAnchor.constraint(equalToConstant: 48),
            
            tabButtonsStackView.leadingAnchor.constraint(equalTo: tabBarBackgroundView.leadingAnchor),
            tabButtonsStackView.trailingAnchor.constraint(equalTo: tabBarBackgroundView.trailingAnchor),
            tabButtonsStackView.topAnchor.constraint(equalTo: tabBarBackgroundView.topAnchor),
            tabButtonsStackView.bottomAnchor.constraint(equalTo: tabBarBackgroundView.bottomAnchor)
        ])
    }

    private func createTabButton(title: String, icon: String, selectedIcon: String, index: Int) -> UIButton {
        let button = UIButton(type: .custom)
        
        let imageView = UIImageView(image: UIImage(systemName: icon))
        imageView.tintColor = .secondaryLabel
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = title
        label.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        button.addSubview(imageView)
        button.addSubview(label)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: button.topAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 24),
            imageView.heightAnchor.constraint(equalToConstant: 24),
            
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 2),
            label.leadingAnchor.constraint(equalTo: button.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: button.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: button.bottomAnchor)
        ])
        
        button.tag = index
        button.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)
        
        if index == 0 {
            setSelectedState(button, selected: true, icons: (icon, selectedIcon))
        }
        
        return button
    }

    // MARK: - Logic
    
    private func switchTab(to index: Int) {
        if currentIndex < viewControllers.count {
            viewControllers[currentIndex].willMove(toParent: nil)
            viewControllers[currentIndex].view.removeFromSuperview()
            viewControllers[currentIndex].removeFromParent()
        }
        
        let newVC = viewControllers[index]
        addChild(newVC)
        view.insertSubview(newVC.view, belowSubview: customTabBarContainer)
        newVC.didMove(toParent: self)
        
        currentIndex = index
    }

    private func setSelectedState(_ button: UIButton, selected: Bool, icons: (String, String)) {
        guard let imageView = button.subviews.first as? UIImageView,
              let label = button.subviews.last as? UILabel else { return }
        
        if selected {
            imageView.image = UIImage(systemName: icons.1)
            imageView.tintColor = .systemBlue
            label.textColor = .systemBlue
        } else {
            imageView.image = UIImage(systemName: icons.0)
            imageView.tintColor = .secondaryLabel
            label.textColor = .secondaryLabel
        }
    }

    @objc private func tabButtonTapped(_ sender: UIButton) {
        switchTab(to: sender.tag)
        
        for (index, button) in tabButtonsStackView.arrangedSubviews.enumerated() {
            if let btn = button as? UIButton,
               index < tabBarItems.count {
                setSelectedState(btn, selected: index == sender.tag, icons: (tabBarItems[index].icon, tabBarItems[index].selectedIcon))
            }
        }
    }

    private func setupViewControllers() {
        let scheduleVC = ScheduleViewController()
        viewControllers.append(scheduleVC)
        
        let profileVC = UIViewController()
        profileVC.view.backgroundColor = .systemBackground
        let label = UILabel()
        label.text = "Профиль"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        profileVC.view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: profileVC.view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: profileVC.view.centerYAnchor)
        ])
        viewControllers.append(profileVC)
    }
}

