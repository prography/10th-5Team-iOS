import Foundation
import FirebaseAnalytics

extension Analytics {
    /// 화면 방문을 기록하는 메서드
    /// - Parameters:
    ///   - screenName: 화면 이름 (analyticsName)
    ///   - screenClass: 화면 클래스명 (선택사항)
    static func logScreenView(screenName: String, screenClass: String? = nil) {
        var parameters: [String: Any] = [AnalyticsParameterScreenName: screenName]
        
        if let screenClass = screenClass {
            parameters[AnalyticsParameterScreenClass] = screenClass
        }
        
        Analytics.logEvent(AnalyticsEventScreenView, parameters: parameters)
    }
    
    /// 커스텀 이벤트를 기록하는 메서드
    /// - Parameters:
    ///   - name: 이벤트 이름
    ///   - parameters: 이벤트 파라미터 (선택사항)
    static func logCustomEvent(name: String, parameters: [String: Any]? = nil) {
        if let parameters = parameters {
            Analytics.logEvent(name, parameters: parameters)
        } else {
            Analytics.logEvent(name, parameters: nil)
        }
    }
} 
