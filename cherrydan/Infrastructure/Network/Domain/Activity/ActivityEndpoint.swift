enum ActivityEndpoint: APIEndpoint {
    case getActivityNotification
    case deleteActivityNotifications
    case markActivityAlertsAsRead
    case getActivityNotificationCount
    
    var path: String {
        switch self {
        case .getActivityNotification:
            "/activity/bookmark-alerts"
        case .deleteActivityNotifications:
            "/activity/bookmark-alerts"
        case .markActivityAlertsAsRead:
            "/activity/bookmark-alerts/read"
        case .getActivityNotificationCount:
            "/activity/bookmark-alerts/count"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getActivityNotification:
                .get
        case .deleteActivityNotifications:
                .delete
        case .markActivityAlertsAsRead:
                .patch
        case .getActivityNotificationCount:
                .get
        }
    }
    
    var tokenType: TokenType { .accessToken }
}
