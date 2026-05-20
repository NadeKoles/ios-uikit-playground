import UIKit

class ViewController: UIViewController {
    private lazy var avatarView = UIView()
    private lazy var initialsLabel = UILabel()
    private lazy var nameLabel = UILabel()
    private lazy var bioLabel = UILabel()
    private lazy var editButton = UIButton()
    private lazy var layoutControl = UISegmentedControl(items: ["Compact", "Full"])

    private var compactConstraints: [NSLayoutConstraint] = []
    private var fullConstraints: [NSLayoutConstraint] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupActions()
        layoutControlChanged(layoutControl)
    }

    // MARK: - Setup

    private func setupViews() {
        view.backgroundColor = .systemBackground
        title = "Profile Card"

        avatarView.backgroundColor = UIColor(red: 0.22, green: 0.54, blue: 0.87, alpha: 1)
        avatarView.clipsToBounds = true

        initialsLabel.textColor = .white
        initialsLabel.textAlignment = .center

        nameLabel.text = "Nadia Kolesnikova"
        nameLabel.textColor = .label

        if let savedName = UserDefaults.standard.string(forKey: "nameBio") {
            nameLabel.text = savedName
        }

        initialsLabel.text = makeInitials(from: nameLabel.text ?? "")

        bioLabel.text = "iOS developer, St.Petersburg"
        bioLabel.numberOfLines = 0
        bioLabel.textAlignment = .center

        editButton.setTitle("Edit", for: .normal)
        editButton.setTitleColor(.label, for: .normal)
        editButton.layer.borderWidth = 1
        editButton.layer.cornerRadius = 8
        editButton.layer.borderColor = UIColor.secondaryLabel.cgColor

        layoutControl.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 16)], for: .normal)

        [avatarView, initialsLabel, nameLabel, bioLabel, editButton, layoutControl]
            .forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        view.addSubview(layoutControl)
        view.addSubview(avatarView)
        avatarView.addSubview(initialsLabel)
        view.addSubview(nameLabel)
        view.addSubview(bioLabel)
        view.addSubview(editButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            layoutControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            layoutControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            layoutControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            layoutControl.heightAnchor.constraint(equalToConstant: 40),

            initialsLabel.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            initialsLabel.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor)
        ])

        compactConstraints = [
            avatarView.widthAnchor.constraint(equalToConstant: 60),
            avatarView.heightAnchor.constraint(equalToConstant: 60),
            avatarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            avatarView.topAnchor.constraint(equalTo: layoutControl.bottomAnchor, constant: 24),

            nameLabel.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: editButton.leadingAnchor, constant: -8),

            editButton.heightAnchor.constraint(equalToConstant: 40),
            editButton.widthAnchor.constraint(equalToConstant: 70),
            editButton.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
            editButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ]

        fullConstraints = [
            avatarView.widthAnchor.constraint(equalToConstant: 120),
            avatarView.heightAnchor.constraint(equalToConstant: 120),
            avatarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarView.topAnchor.constraint(equalTo: layoutControl.bottomAnchor, constant: 30),

            nameLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),

            bioLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            bioLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            bioLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),

            editButton.heightAnchor.constraint(equalToConstant: 40),
            editButton.widthAnchor.constraint(equalToConstant: 70),
            editButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            editButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40)
        ]
    }

    private func setupActions() {
        layoutControl.addTarget(self, action: #selector(layoutControlChanged), for: .valueChanged)
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
    }

    // MARK: - Actions

    @objc private func layoutControlChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            NSLayoutConstraint.deactivate(fullConstraints)
            NSLayoutConstraint.activate(compactConstraints)
            bioLabel.isHidden = true
            avatarView.layer.cornerRadius = 30
            nameLabel.font = .boldSystemFont(ofSize: 20)
            nameLabel.textAlignment = .left
            initialsLabel.font = .systemFont(ofSize: 16)
        } else {
            NSLayoutConstraint.deactivate(compactConstraints)
            NSLayoutConstraint.activate(fullConstraints)
            bioLabel.isHidden = false
            avatarView.layer.cornerRadius = 60
            nameLabel.font = .boldSystemFont(ofSize: 30)
            nameLabel.textAlignment = .center
            initialsLabel.font = .systemFont(ofSize: 40)
        }
    }

    @objc private func editButtonTapped() {
        let alert = UIAlertController(title: "Edit Name", message: nil, preferredStyle: .alert)

        alert.addTextField { [weak self] textField in
            textField.text = self?.nameLabel.text
            NotificationCenter.default.addObserver(
                forName: UITextField.textDidChangeNotification,
                object: textField,
                queue: .main
            ) { _ in
                alert.actions.first?.isEnabled = !(textField.text?
                    .trimmingCharacters(in: .whitespaces).isEmpty ?? true)
            }
        }

        alert.addAction(UIAlertAction(title: "Save", style: .default) { [weak self, weak alert] _ in
            guard let text = alert?.textFields?.first?.text else { return }
            self?.nameLabel.text = text
            self?.initialsLabel.text = self?.makeInitials(from: text)
            UserDefaults.standard.set(text, forKey: "nameBio")
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(alert, animated: true)
    }

    // MARK: - Helpers

    private func makeInitials(from name: String) -> String {
        let parts = name.split(separator: " ")
        if parts.count >= 2 {
            return String(parts[0].prefix(1)) + String(parts[1].prefix(1))
        }
        return String(name.prefix(1))
    }
}
