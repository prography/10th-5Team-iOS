enum AlertEndpoint: APIEndpoint {
    case getUnreadCount
    
    var path: String {
        switch self {
        case .getUnreadCount:
            "/alerts/unread-count"
        }
    }
    
    var method: HTTPMethod { .get }
    
    var tokenType: TokenType { .accessToken }
}
