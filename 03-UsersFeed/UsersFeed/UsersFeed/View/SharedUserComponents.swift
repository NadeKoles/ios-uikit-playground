
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

// MARK: - Shared Logic

extension UserCardCell {
    func setupCardViews(avatarSize: CGFloat = 60) {
        avatarView.layer.cornerRadius = avatarSize / 2
        avatarView.clipsToBounds = true
        avatarView.backgroundColor = .systemGray5

        statusLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)

        buttonLike.tintColor = .systemRed
        buttonLike.setImage(UIImage(systemName: "heart"), for: .normal)
        buttonLike.setImage(UIImage(systemName: "heart.fill"), for: .selected)
    }

    func configureCard(with user: User) {
        avatarView.image = nil
        userId = user.id

        nameLabel.text = user.name
        statusLabel.text = user.status.rawValue
        buttonLike.isSelected = user.like

        switch user.status {
        case .online:  statusLabel.textColor = .systemGreen
        case .away:    statusLabel.textColor = .systemBrown
        case .offline: statusLabel.textColor = .systemGray
        }

        ImageLoader.shared.loadImage(from: user.avatarURL) { [weak self] image in
            self?.avatarView.image = image
        }
    }
}
