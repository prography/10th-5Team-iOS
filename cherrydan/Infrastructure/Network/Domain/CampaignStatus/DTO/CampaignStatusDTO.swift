import Foundation

// MARK: - Request DTOs
struct CampaignStatusRequestDTO: Codable {
    let campaignId: Int
    let status: String
}

struct DeleteRequest: Codable {
    let campaignIds: [Int]
}

struct CampaignStatusListResponseDTO: Codable {
    let apply: [MyCampaignDTO]
    let selected: [MyCampaignDTO]
    let notSelected: [MyCampaignDTO]
    let registered: [MyCampaignDTO]
    let ended: [MyCampaignDTO]
    let count: [String: Int]
}

struct CampaignStatusPopupItemDTO: Codable {
    let campaignId: Int
    let title: String
    let imageUrl: String
    let reviewerAnnouncementStatus: String
    let benefit: String
}

struct CampaignStatusPopupResponseDTO: Codable {
    let totalCount: Int
    let items: [CampaignStatusPopupItemDTO]
}

struct CampaignStatusCountDTO: Codable {
    let apply: Int
    let selected: Int
    let notSelected: Int
    let reviewing: Int
    let ended: Int
}
