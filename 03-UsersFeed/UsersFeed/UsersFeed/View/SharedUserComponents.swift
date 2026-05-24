
import UIKit

// MARK: - Delegate

protocol ButtonLikeDelegate: AnyObject {
    func setLike(for id: UUID, _ isLiked: Bool)
}

// MARK: - Protocol

protocol UserCardCell: AnyObject {
    var avatarView: UIImageView { get }
    var nameLabel: UILabel { get }
    var statusLabel: UILabel { get }
    var buttonLike: UIButton { get }
    var userId: UUID? { get set }
    var delegate: ButtonLikeDelegate? { get set }
}

// MARK: - Colors

extension UIColor {
    static let likeRed = UIColor(red: 0.85, green: 0.20, blue: 0.32, alpha: 1)
    static let likeBackground = UIColor(red: 0.85, green: 0.20, blue: 0.32, alpha: 0.08)
    static let statusOnline = UIColor(red: 0.15, green: 0.68, blue: 0.38, alpha: 1)
    static let statusAway = UIColor(red: 0.98, green: 0.66, blue: 0.10, alpha: 1)
}

// MARK: - Shared Logic

extension UserCardCell {
    func setupCardViews(avatarSize: CGFloat = 60) {
        avatarView.layer.cornerRadius = avatarSize / 2
        avatarView.clipsToBounds = true
        avatarView.backgroundColor = .systemGray5

        statusLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)

        buttonLike.setImage(UIImage(systemName: "heart")?.withTintColor(.systemGray3, renderingMode: .alwaysOriginal), for: .normal)
        buttonLike.setImage(UIImage(systemName: "heart.fill")?.withTintColor(.likeRed, renderingMode: .alwaysOriginal), for: .selected)
        buttonLike.backgroundColor = .systemBackground
        buttonLike.layer.cornerRadius = 8
        buttonLike.layer.borderWidth = 1
        buttonLike.layer.borderColor = UIColor.systemGray4.cgColor
    }

    func updateLikeButtonAppearance(isLiked: Bool) {
        buttonLike.backgroundColor = isLiked ? .likeBackground : .systemBackground
        buttonLike.layer.borderColor = isLiked
            ? UIColor.likeRed.withAlphaComponent(0.4).cgColor
            : UIColor.systemGray4.cgColor
    }

    func configureCard(with user: User) {
        avatarView.image = nil
        userId = user.id

        nameLabel.text = user.name
        buttonLike.isSelected = user.like
        updateLikeButtonAppearance(isLiked: user.like)

        switch user.status {
        case .online:
            statusLabel.text = "online"
            statusLabel.textColor = .statusOnline
        case .away:
            statusLabel.text = "away"
            statusLabel.textColor = .statusAway
        case .offline:
            statusLabel.text = "offline"
            statusLabel.textColor = .systemGray
        }

        ImageLoader.shared.loadImage(from: user.avatarURL) { [weak self] image in
            self?.avatarView.image = image
        }
    }
}
