import Foundation

struct CampaignStatusPopupItem: Identifiable, Equatable {
    let id: Int
    let title: String
    let imageUrl: String
    let benefit: String
    let reviewerAnnouncementStatus: String
    
    init(
        id: Int,
        title: String,
        imageUrl: String,
        benefit: String,
        reviewerAnnouncementStatus: String
    ) {
        self.id = id
        self.title = title
        self.imageUrl = imageUrl
        self.benefit = benefit
        self.reviewerAnnouncementStatus = reviewerAnnouncementStatus
    }
}

extension CampaignStatusPopupItemDTO {
    func toDomain() -> CampaignStatusPopupItem {
        CampaignStatusPopupItem(
            id: campaignId,
            title: title,
            imageUrl: imageUrl,
            benefit: benefit,
            reviewerAnnouncementStatus: reviewerAnnouncementStatus
        )
    }
}
