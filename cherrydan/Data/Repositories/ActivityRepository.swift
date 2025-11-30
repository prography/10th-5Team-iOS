import Foundation

class ActivityRepository {
    private let networkAPI: NetworkAPI
    
    init(networkAPI: NetworkAPI = NetworkAPI()) {
        self.networkAPI = networkAPI
    }
    
    // MARK: - Activity Alerts
    func getActivityNotifications(page: Int = 0) async throws -> APIResponse<PageableResponse<ActivityNotification>> {
        let query: [String:String] = [
            "page": String(page),
            "size": "20",
            "sort": "alertDate,desc"
        ]
        
        do {
            return try await networkAPI.request(ActivityEndpoint.getActivityNotification, queryParameters: query)
        } catch {
            print("NotificationRepository Error: \(error)")
            throw error
        }
    }
    
    /// 활동 알림 삭제
    func deleteActivityAlerts(alertIds: [Int]) async throws {
        let params = ["alertIds": alertIds]
        let _: EmptyResult = try await networkAPI.request(
            ActivityEndpoint.deleteActivityNotifications,
            parameters: params
        )
    }
    
    /// 활동 알림 읽음 처리
    func markActivityAlertsAsRead(alertIds: [Int]) async throws {
        let params = ["alertIds": alertIds]
        let _: EmptyResult = try await networkAPI.request(
            ActivityEndpoint.markActivityAlertsAsRead,
            parameters: params
        )
    }
    
    /// 활동 알림 개수 조회
    func getActivityNotificationCount() async throws -> Int64 {
        let response: APIResponse<Int64> = try await networkAPI.request(
            ActivityEndpoint.getActivityNotificationCount
        )
        return response.result
    }
}

