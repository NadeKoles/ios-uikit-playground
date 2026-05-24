
import UIKit

class UserCell: UITableViewCell, UserCardCell {
    weak var delegate: ButtonLikeDelegate?
    var userId: UUID?

    let avatarView = UIImageView()
    let nameLabel = UILabel()
    let statusLabel = UILabel()
    let stackView = UIStackView()
    let buttonLike = UIButton()

    static let reuseIdentifier = "cellIdentifier"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none

        contentView.addSubview(avatarView)
        contentView.addSubview(stackView)
        contentView.addSubview(buttonLike)

        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(statusLabel)

        setupCardViews()
        setupLayout()

        buttonLike.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    private func setupLayout() {
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        buttonLike.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            avatarView.widthAnchor.constraint(equalToConstant: 60),
            avatarView.heightAnchor.constraint(equalToConstant: 60),
            avatarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            avatarView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            avatarView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            stackView.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 8),
            stackView.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
            stackView.trailingAnchor.constraint(equalTo: buttonLike.leadingAnchor, constant: -8),

            buttonLike.widthAnchor.constraint(equalToConstant: 40),
            buttonLike.heightAnchor.constraint(equalToConstant: 40),
            buttonLike.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
            buttonLike.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }

    @objc private func buttonTapped(_ sender: UIButton) {
        guard let userId else { return }
        sender.isSelected.toggle()
        delegate?.setLike(for: userId, sender.isSelected)
    }

    func configure(with user: User) {
        configureCard(with: user)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
