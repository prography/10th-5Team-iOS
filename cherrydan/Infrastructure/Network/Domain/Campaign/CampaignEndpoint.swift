enum CampaignEndpoint: APIEndpoint {
    case getAllCampaign
    case getCampaignByReporter
    case getCampaignByProduct
    case getCampaignByRegion
    case getCampaignBySNSPlatform
    case getCampaignByCampaignPlatform
    case getCampaignByType
    
    case getCampaignSites
    
    case searchCampaign
    case searchCampaignByCategory
    
    
    var path: String {
        switch self {
        case .getAllCampaign:
            "/campaigns"
        case .getCampaignBySNSPlatform:
            "/campaigns/sns-platforms"
        case .getCampaignByCampaignPlatform:
            "/campaigns/campaign-platforms"
        case .getCampaignByType:
            "/campaigns/types"
        case .getCampaignByReporter:
            "/campaigns/reporter"
        case .getCampaignByProduct:
            "/campaigns/product"
        case .getCampaignByRegion:
            "/campaigns/local"
            
        case .searchCampaign:
            "/campaigns/search"
        case .searchCampaignByCategory:
            "/campaigns/categories/search"
            
        case .getCampaignSites:
            "/campaigns/site"
        }
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var tokenType: TokenType {
//        if let _ = KeychainManager.shared.getAccessToken() {
//            .accessToken
//        } else {
            .none
//        }
    }
}
