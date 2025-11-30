enum BookmarkEndpoint: APIEndpoint {
    case addBookmark(campaignId: Int)
    case cancelBookmarks
    case deleteBookmarks
    case getBookmarks

    var path: String {
        switch self {
        case .addBookmark(let campaignId):
            "/campaigns/\(campaignId)/bookmark"
        case .cancelBookmarks, .deleteBookmarks:
            "/campaigns/bookmark"
        case .getBookmarks:
            "/campaigns/bookmarks"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .addBookmark:
            .post
        case .cancelBookmarks:
            .patch
        case .deleteBookmarks:
            .delete
        case .getBookmarks:
            .get
        }
    }
    
    var tokenType: TokenType {
        .accessToken
    }
}
