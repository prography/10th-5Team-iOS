enum SNSEndpoint: APIEndpoint {
    case naverVerify
    case oauthCallback(platform: String)
    case oauthAuthUrl(platform: String)
    case getConnections
    case disconnect(platform: String)
    
    var path: String {
        switch self {
        case .naverVerify:
            "/v1/sns/naver/verify"
        case .oauthCallback(let platform):
            "/v1/sns/oauth/\(platform)/callback"
        case .oauthAuthUrl(let platform):
            "/v1/sns/oauth/\(platform)/auth-url"
        case .getConnections:
            "/v1/sns/connections"
        case .disconnect(let platform):
            "/v1/sns/disconnect/\(platform)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .naverVerify:
            .post
        case .oauthCallback, .oauthAuthUrl, .getConnections:
            .get
        case .disconnect:
            .delete
        }
    }
    
    var tokenType: TokenType { .accessToken }
} 
