import Foundation

/// Preview/Test에서 사용할 Mock 데이터 모음
enum MockRepositoryData {
    static let now = Date()

    // MARK: - MyCampaign
    static let myCampaignDTO = MyCampaignDTO(
        id: 1,
        userId: 100,
        campaignId: 1001,
        campaignTitle: "[와모야] 일주일에 10kg 감량 가능! 살이 쭉쭉 빠져요! 맛있는 효소 릴스 체험",
        campaignDetailUrl: "https://example.com/campaign/1001",
        campaignImageUrl: "https://example.com/images/campaign1.jpg",
        campaignPlatformImageUrl: "https://example.com/images/platform1.jpg",
        benefit: "효소 1박스",
        applicantCount: 175,
        recruitCount: 5,
        snsPlatforms: ["인스타그램", "유튜브"],
        reviewerAnnouncementStatus: "신청 마감 7일 전",
        subStatusLabel: "waiting",
        campaignSite: "레뷰"
    )

    static let myCampaigns: [MyCampaignDTO] = [
        myCampaignDTO,
        MyCampaignDTO(
            id: 2,
            userId: 100,
            campaignId: 1002,
            campaignTitle: "건강한 다이어트 체험단 모집",
            campaignDetailUrl: "https://example.com/campaign/1002",
            campaignImageUrl: "https://example.com/images/campaign2.jpg",
            campaignPlatformImageUrl: "https://example.com/images/platform2.jpg",
            benefit: "다이어트 제품 1개월분",
            applicantCount: 89,
            recruitCount: 10,
            snsPlatforms: ["블로그", "인스타그램"],
            reviewerAnnouncementStatus: "신청 가능",
            subStatusLabel: nil,
            campaignSite: "디블"
        ),
        MyCampaignDTO(
            id: 3,
            userId: 100,
            campaignId: 1003,
            campaignTitle: "신상 화장품 체험단 모집",
            campaignDetailUrl: "https://example.com/campaign/1003",
            campaignImageUrl: "https://example.com/images/campaign3.jpg",
            campaignPlatformImageUrl: "https://example.com/images/platform3.jpg",
            benefit: "화장품 세트",
            applicantCount: 250,
            recruitCount: 20,
            snsPlatforms: ["인스타그램"],
            reviewerAnnouncementStatus: "신청 마감",
            subStatusLabel: "completed",
            campaignSite: "레뷰"
        )
    ]

    static let myCampaignPage = PageableResponse(
        content: myCampaigns,
        page: 0,
        size: 20,
        totalElements: myCampaigns.count,
        totalPages: 1,
        hasNext: false,
        hasPrevious: false
    )

    // MARK: - Campaign
    static let campaignDTO = CampaignDTO(
        id: 2001,
        title: "맛집 체험단 모집",
        detailUrl: "https://example.com/campaign/2001",
        benefit: "무료 식사권",
        reviewerAnnouncementStatus: "신청 가능",
        applicantCount: 45,
        recruitCount: 5,
        imageUrl: "https://example.com/images/food1.jpg",
        isBookmarked: false,
        campaignPlatformImageUrl: "https://example.com/images/platform1.jpg",
        campaignType: "REGION",
        competitionRate: 9.0,
        campaignSite: "레뷰",
        campaignSiteKr: "레뷰",
        campaignSiteEn: "revu",
        campaignSiteUrl: "https://revu.co.kr",
        snsPlatforms: ["인스타그램", "블로그"]
    )

    static let campaigns: [CampaignDTO] = [
        campaignDTO,
        CampaignDTO(
            id: 2002,
            title: "카페 음료 체험단",
            detailUrl: "https://example.com/campaign/2002",
            benefit: "음료 쿠폰 5장",
            reviewerAnnouncementStatus: "신청 마감 3일 전",
            applicantCount: 120,
            recruitCount: 10,
            imageUrl: "https://example.com/images/cafe1.jpg",
            isBookmarked: true,
            campaignPlatformImageUrl: "https://example.com/images/platform2.jpg",
            campaignType: "PRODUCT",
            competitionRate: 12.0,
            campaignSite: "디블",
            campaignSiteKr: "디블",
            campaignSiteEn: "dble",
            campaignSiteUrl: "https://dble.io",
            snsPlatforms: ["인스타그램"]
        )
    ]

    static let campaignPage = PageableResponse(
        content: campaigns,
        page: 0,
        size: 20,
        totalElements: campaigns.count,
        totalPages: 1,
        hasNext: false,
        hasPrevious: false
    )

    // MARK: - Campaign Platform
    static let campaignPlatforms: [CampaignPlatform] = [
        CampaignPlatform(
            siteNameKr: "레뷰",
            siteNameEn: "revu",
            cdnUrl: "https://example.com/platforms/revu.jpg"
        ),
        CampaignPlatform(
            siteNameKr: "디블",
            siteNameEn: "dble",
            cdnUrl: "https://example.com/platforms/dble.jpg"
        ),
        CampaignPlatform(
            siteNameKr: "와모야",
            siteNameEn: "wamoya",
            cdnUrl: "https://example.com/platforms/wamoya.jpg"
        )
    ]

    // MARK: - Campaign Status
    static let campaignStatusCount = CampaignStatusCountDTO(
        apply: 5,
        selected: 3,
        notSelected: 2,
        reviewing: 4,
        ended: 8
    )

    static let campaignStatusPopupItem = CampaignStatusPopupItemDTO(
        campaignId: 1001,
        title: "팝업 캠페인",
        imageUrl: "https://example.com/images/popup1.jpg",
        reviewerAnnouncementStatus: "발표 완료",
        benefit: "무료 제품"
    )

    static let campaignStatusPopup = CampaignStatusPopupResponseDTO(
        totalCount: 1,
        items: [campaignStatusPopupItem]
    )

    // MARK: - Auth
    static let socialLoginResponse = SocialLoginResponse(
        code: 200,
        message: "success",
        result: SocialLoginResult(
            tokens: SocialLoginResult.Tokens(
                accessToken: "mock_access_token_12345",
                refreshToken: "mock_refresh_token_67890"
            ),
            userId: 100
        )
    )

    // MARK: - Pageable
    static let emptyPage = PageableResponse<MyCampaignDTO>(
        content: [],
        page: 0,
        size: 20,
        totalElements: 0,
        totalPages: 0,
        hasNext: false,
        hasPrevious: false
    )
}
