
import Foundation

struct User {
    let id: UUID
    let avatarURL: URL
    let name: String
    let status: StatusType
    var like: Bool
}

enum StatusType: String, CaseIterable {
    case online = "online"
    case away = "away"
    case offline = "offline"
}
