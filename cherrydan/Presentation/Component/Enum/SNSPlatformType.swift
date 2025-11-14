import Foundation

enum SNSPlatformType: CaseIterable, Codable {
    case youtube
    case blog
    case instagram
    case tiktok
    case thread
    case reels
    case shorts
    case clip
    case etc
    
    var imageName: String {
        switch self {
        case .blog: "blog"
        case .instagram: "insta"
        case .youtube: "youtube"
        case .tiktok: "tiktok"
        case .clip: "clip"
        case .reels: "reels"
        case .thread: "thread"
        case .shorts: "shorts"
        case .etc: ""
        }
    }
    
    var apiValue: String {
        switch self {
        case .blog: "blog"
        case .instagram: "insta"
        case .youtube: "youtube"
        case .tiktok: "tiktok"
        case .clip: "clip"
        case .reels: "reels"
        case .thread: "thread"
        case .shorts: "shorts"
        case .etc: "etc"
        }
    }
    
    var displayName: String {
        switch self {
        case .blog: "네이버 블로그"
        case .instagram: "인스타그램"
        case .youtube: "유튜브"
        case .tiktok: "틱톡"
        case .thread: "스레드"
        case .clip: "네이버 클립"
        case .reels: "인스타그램 릴스"
        case .shorts: "유튜브 쇼츠"
        case .etc: "기타"
        }
    }
    
    var connectGuideMessages: [String] {
        switch self {
        case .blog:
            [
                "네이버 블로그 내 공개 상태의 포스트를 1개 이상 보유한 전체 공개된 블로그여야 합니다.",
                "네이버에서 허용한 앱 권한 상태 시, 네이버 블로그를 다시 연결하셔야 합니다."
            ]
        case .instagram:
            [
                "인스타그램 계정 내 공개 상태의 게시물을 1개 이상 보유한 전체 공개된 계정이어야 합니다.",
                "인스타그램에서 허용한 앱 권한 상태 시, 인스타그램 계정을 다시 연결하셔야 합니다."
            ]
        case .youtube:
            [
                "유튜브 채널 내 공개 상태의 영상을 1개 이상 보유한 전체 공개된 채널이어야 합니다.",
                "유튜브에서 허용한 앱 권한 상태 시, 유튜브 채널을 다시 연결하셔야 합니다."
            ]
        case .tiktok:
            [
                "틱톡 계정 내 공개 상태의 영상을 1개 이상 보유한 전체 공개된 계정이어야 합니다.",
                "틱톡에서 허용한 앱 권한 상태 시, 틱톡 계정을 다시 연결하셔야 합니다."
            ]
        case .etc:
            [
                "기타 플랫폼 계정 내 공개 상태의 콘텐츠를 1개 이상 보유한 전체 공개된 계정이어야 합니다.",
                "해당 플랫폼에서 허용한 앱 권한 상태 시, 계정을 다시 연결하셔야 합니다."
            ]
        default:
            []
        }
    }
}
