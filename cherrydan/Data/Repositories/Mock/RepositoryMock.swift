import Foundation

/// Preview/Test에서 네트워크 없이 빠르게 상태를 만들기 위한 Repository Mock 모음입니다.
/// 각 메서드는 주입된 `Result`를 그대로 반환하므로, 시나리오별로 값만 바꿔 끼워 넣으면 됩니다.

// MARK: - Bookmark
class BookmarkRepositoryMock: BookmarkRepository {
    var addBookmarkResult: Result<Void, Error> = .success(())
    var cancelBookmarkResult: Result<Void, Error> = .success(())
    var deleteBookmarkResult: Result<Void, Error> = .success(())
    var getOpenBookmarksResult: Result<PageableResponse<MyCampaignDTO>, Error> = .success(MockRepositoryData.myCampaignPage)
    var getClosedBookmarksResult: Result<PageableResponse<MyCampaignDTO>, Error> = .success(MockRepositoryData.myCampaignPage)

    init() {
        super.init(networkAPI: NetworkAPI())
    }

    override func addBookmark(campaignId: Int) async throws {
        try addBookmarkResult.get()
    }

    override func cancelBookmark(campaignId: Int) async throws {
        try cancelBookmarkResult.get()
    }

    override func deleteBookmark(campaignId: Int) async throws {
        try deleteBookmarkResult.get()
    }

    override func getOpenBookmarks(page: Int = 0) async throws -> PageableResponse<MyCampaignDTO> {
        try getOpenBookmarksResult.get()
    }

    override func getClosedBookmarks(page: Int = 0) async throws -> PageableResponse<MyCampaignDTO> {
        try getClosedBookmarksResult.get()
    }
}

// MARK: - Campaign Status
class CampaignStatusRepositoryMock: CampaignStatusRepository {
    var getMyCampaignsResult: Result<PageableResponse<MyCampaignDTO>, Error> = .success(MockRepositoryData.myCampaignPage)
    var createOrRecoverStatusResult: Result<MyCampaignDTO, Error> = .success(MockRepositoryData.myCampaignDTO)
    var updateStatusResult: Result<MyCampaignDTO, Error> = .success(MockRepositoryData.myCampaignDTO)
    var deleteStatusResult: Result<Void, Error> = .success(())
    var getPopupStatusResult: Result<CampaignStatusPopupResponseDTO, Error> = .success(MockRepositoryData.campaignStatusPopup)
    var getCampaignStatusCountResult: Result<CampaignStatusCountDTO, Error> = .success(MockRepositoryData.campaignStatusCount)

    init() {
        super.init(networkAPI: NetworkAPI())
    }

    override func getMyCampaings(for subFilter: CampaignSubFilter, page: Int = 0) async throws -> PageableResponse<MyCampaignDTO> {
        try getMyCampaignsResult.get()
    }

    override func createOrRecoverStatus(request: CampaignStatusRequestDTO) async throws -> MyCampaignDTO {
        try createOrRecoverStatusResult.get()
    }

    override func updateStatus(request: CampaignStatusRequestDTO) async throws -> MyCampaignDTO {
        try updateStatusResult.get()
    }

    override func deleteStatus(_ campaignId: Int) async throws -> Void {
        try deleteStatusResult.get()
    }

    override func getPopupStatus() async throws -> CampaignStatusPopupResponseDTO {
        try getPopupStatusResult.get()
    }

    override func getCampaignStatusCount() async throws -> CampaignStatusCountDTO {
        try getCampaignStatusCountResult.get()
    }
}

// MARK: - Campaign
class CampaignRepositoryMock: CampaignRepository {
    var getAllCampaignResult: Result<PageableResponse<CampaignDTO>, Error> = .success(MockRepositoryData.campaignPage)
    var getCampaignByRegionResult: Result<PageableResponse<CampaignDTO>, Error> = .success(MockRepositoryData.campaignPage)
    var getCampaignByReporterResult: Result<PageableResponse<CampaignDTO>, Error> = .success(MockRepositoryData.campaignPage)
    var getCampaignByProductResult: Result<PageableResponse<CampaignDTO>, Error> = .success(MockRepositoryData.campaignPage)
    var getCampaignBySNSPlatformResult: Result<PageableResponse<CampaignDTO>, Error> = .success(MockRepositoryData.campaignPage)
    var getCampaignByCampaignPlatformResult: Result<PageableResponse<CampaignDTO>, Error> = .success(MockRepositoryData.campaignPage)
    var getCampaignSitesResult: Result<[CampaignPlatform], Error> = .success(MockRepositoryData.campaignPlatforms)
    var searchCampaignResult: Result<[CampaignDTO], Error> = .success(MockRepositoryData.campaigns)
    var searchCampaignsByCategoryResult: Result<PageableResponse<CampaignDTO>, Error> = .success(MockRepositoryData.campaignPage)

    init() {
        super.init(networkAPI: NetworkAPI())
    }

    override func getAllCampaign(sort: SortType = .popular, page: Int = 0) async throws -> PageableResponse<CampaignDTO> {
        try getAllCampaignResult.get()
    }

    override func getCampaignByRegion(
        regionGroups: [RegionGroup] = [],
        subRegions: [SubRegion] = [],
        local: [LocalCategory] = [],
        sort: SortType = .popular,
        page: Int = 0
    ) async throws -> PageableResponse<CampaignDTO> {
        try getCampaignByRegionResult.get()
    }

    override func getCampaignByReporter(sort: SortType = .popular, page: Int = 0) async throws -> PageableResponse<CampaignDTO> {
        try getCampaignByReporterResult.get()
    }

    override func getCampaignByProduct(
        _ product: [ProductCategory] = [],
        sort: SortType = .popular,
        page: Int = 0
    ) async throws -> PageableResponse<CampaignDTO> {
        try getCampaignByProductResult.get()
    }

    override func getCampaignBySNSPlatform(
        _ snsPlatform: [SNSPlatformType] = [],
        sort: SortType = .popular,
        page: Int = 0
    ) async throws -> PageableResponse<CampaignDTO> {
        try getCampaignBySNSPlatformResult.get()
    }

    override func getCampaignByCampaignPlatform(
        _ campaignPlatform: [CampaignPlatform] = [],
        sort: SortType = .popular,
        page: Int = 0
    ) async throws -> PageableResponse<CampaignDTO> {
        try getCampaignByCampaignPlatformResult.get()
    }

    override func getCampaignSites() async throws -> [CampaignPlatform] {
        try getCampaignSitesResult.get()
    }

    override func searchCampaign(_ keyword: String) async throws -> [CampaignDTO] {
        try searchCampaignResult.get()
    }

    override func searchCampaignsByCategory(
        query: String? = nil,
        regionGroups: [RegionGroup] = [],
        subRegions: [SubRegion] = [],
        local: [LocalCategory] = [],
        product: [ProductCategory] = [],
        snsPlatform: [SNSPlatformType] = [],
        campaignPlatform: [CampaignPlatform] = [],
        applyStart: String? = nil,
        applyEnd: String? = nil,
        sort: SortType = .popular,
        page: Int = 0,
        isReporter: Bool = false
    ) async throws -> PageableResponse<CampaignDTO> {
        try searchCampaignsByCategoryResult.get()
    }
}

// MARK: - Auth
class AuthRepositoryMock: AuthRepository {
    var socialLoginResult: Result<SocialLoginResponse, Error> = .success(MockRepositoryData.socialLoginResponse)
    var refreshTokenResult: Result<Data?, Error> = .success(Data())
    var logoutResult: Result<Data?, Error> = .success(Data())

    init() {
        super.init(networkAPI: NetworkAPI())
    }

    override func socialLogin(_ provider: String, _ token: String, userInfo: UserInfo?) async throws -> SocialLoginResponse {
        try socialLoginResult.get()
    }

    override func refreshToken() async throws -> Data? {
        try refreshTokenResult.get()
    }

    override func logout() async throws -> Data? {
        try logoutResult.get()
    }
}
