enum MyPageEndpoint: APIEndpoint {
    case getVersion
    case getPushSettings
    case updatePushSettings
    case togglePushEnabled
    case getUserTos
    case updateUserTos
    case getInquiries
    case createInquiry
    case getInquiryDetail(id: Int)
    
    
    var path: String {
        switch self {
        case .getVersion:
            "/mypage/version"
        case .getPushSettings, .updatePushSettings:
            "/mypage/push-settings"
        case .togglePushEnabled:
            "/mypage/push-settings/toggle"
        case .getUserTos, .updateUserTos:
            "/mypage/tos"
        case .getInquiries, .createInquiry:
            "/mypage/inquiries"
        case .getInquiryDetail(let id):
            "/mypage/inquiries/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getVersion:
            .get
        case .getPushSettings, .getUserTos, .getInquiries, .getInquiryDetail:
            .get
        case .updatePushSettings, .updateUserTos:
            .put
        case .togglePushEnabled:
            .patch
        case .createInquiry:
            .post
        }
    }
    
    var tokenType: TokenType {
        switch self {
        case .getVersion:
            .none
        default:
            .accessToken
        }
    }
}
