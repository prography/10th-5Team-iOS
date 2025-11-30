enum UserEndpoint: APIEndpoint {
    case getUser
    case deleteUser
    case updateUser
    case patchFcmToken
    case getFcmTokens
    case restoreUser(userId: Int)
    
    var path: String {
        switch self {
        case .getUser:
            "/user/me"
        case .deleteUser:
            "/user/me"
        case .updateUser:
            "/user/me"
        case .patchFcmToken:
            "/user/fcm-token"
        case .getFcmTokens:
            "/user/fcm-tokens"
        case .restoreUser(let userId):
            "/user/admin/restore/\(userId)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getUser:
                .get
        case .deleteUser:
                .delete
        case .updateUser:
                .patch
        case .patchFcmToken:
                .patch
        case .getFcmTokens:
                .get
        case .restoreUser:
                .post
        }
    }
    
    var tokenType: TokenType { .accessToken }
}
