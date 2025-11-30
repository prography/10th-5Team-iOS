import Foundation

enum NoticeBoardEndpoint: APIEndpoint {
    case getNoticeBoard
    case getNoticeBoardDetail(id: Int)
    case getNoticeBoardBanner
    case toggleEmpathy(id: Int)
    
    var path: String {
        switch self {
        case .getNoticeBoard:
            return "/noticeboard"
        case .getNoticeBoardDetail(let id):
            return "/noticeboard/\(id)"
        case .getNoticeBoardBanner:
            return "/noticeboard/banners"
        case .toggleEmpathy(let id):
            return "/noticeboard/\(id)/empathy"
            
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getNoticeBoard, .getNoticeBoardDetail, .getNoticeBoardBanner:
            return .get
        case .toggleEmpathy:
            return .post
        }
    }
    
    var tokenType: TokenType {
        switch self {
        case .toggleEmpathy:
            return .accessToken
        default:
            return .none
        }
    }
}
