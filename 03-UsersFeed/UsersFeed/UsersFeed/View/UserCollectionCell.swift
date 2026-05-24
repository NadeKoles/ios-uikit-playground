
import UIKit

class UserCollectionCell: UICollectionViewCell, UserCardCell {
    weak var delegate: ButtonLikeDelegate?
    var userId: UUID?

    let avatarView = UIImageView()
    let nameLabel = UILabel()
    let statusLabel = UILabel()
    let stackView = UIStackView()
    let buttonLike = UIButton()

    static let reuseIdentifier = "collectionCellIdentifier"

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.layer.cornerRadius = 12
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemGray4.cgColor
        contentView.clipsToBounds = true

        contentView.addSubview(stackView)

        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.addArrangedSubview(avatarView)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(statusLabel)
        stackView.addArrangedSubview(buttonLike)

        stackView.setCustomSpacing(2, after: nameLabel)
        stackView.setCustomSpacing(8, after: statusLabel)

        setupCardViews(avatarSize: 80)
        setupLayout()

        buttonLike.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    private func setupLayout() {
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            avatarView.heightAnchor.constraint(equalToConstant: 80),
            avatarView.widthAnchor.constraint(equalToConstant: 80),

            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            buttonLike.heightAnchor.constraint(equalToConstant: 36)
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
