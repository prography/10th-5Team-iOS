enum GuestModeEndpoint: APIEndpoint {
    case getStatus
    
    var path: String {
        switch self {
        case .getStatus:
            "/guest-mode/status"
        }
    }
    
    var method: HTTPMethod { .get }
    
    var tokenType: TokenType { .none }
}
