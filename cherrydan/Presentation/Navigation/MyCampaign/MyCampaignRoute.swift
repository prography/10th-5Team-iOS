import Foundation

enum MyCampaignRoute: BaseRoute {
    case categoryDetail
    case campaignWeb(siteNameKr: String, campaignSiteUrl: String)
    
    var id: String {
        switch self {
        case .campaignWeb(let siteNameKr, _):
            "campaignWeb_\(siteNameKr)"
        default:
            String(describing: self)
        }
    }
    
    var analyticsName: String {
        switch self {
        case .categoryDetail:
            "category_detail_screen"
        case .campaignWeb:
            "my_campaign_web_screen"
        }
    }
    
    var disableSwipeBack: Bool {
        false
    }
}

