import Foundation

@MainActor
class MyCampaignViewModel: ObservableObject {
    @Published var campaigns: [MyCampaign] = []
    @Published var focusedCampaign: MyCampaign? = nil
    
    @Published var selectedCampaignStatus: CampaignStatusCategory = .liked {
        didSet {
            guard oldValue != selectedCampaignStatus else { return }
            selectedSubFilter = selectedCampaignStatus.defaultSubFilter
            subFilterCounts = [:]
            fetchSubFilterCounts(for: selectedCampaignStatus)
        }
    }
    
    @Published var selectedSubFilter: CampaignSubFilter = CampaignStatusCategory.liked.defaultSubFilter {
        didSet {
            guard oldValue != selectedSubFilter else { return }
            fetchCampaignsForSelectedStatus()
        }
    }
    
    @Published var isLoading: Bool = false
    @Published var isCampaignActionSheetPresent: Bool = false
    @Published var isConfirmCampaignStatusSheetPresent: Bool = false
    
    @Published var campaignStatusCounts: CampaignStatusCountDTO? = nil
    
    @Published var subFilterCounts: [CampaignSubFilter: Int] = [:]
    
    var subFilters: [CampaignSubFilter] {
        selectedCampaignStatus.subFilters
    }
    
    var emptyStateMessage: String {
        selectedSubFilter.emptyStateMessage
    }
    
    private var currentPage: Int = 0
    private var hasMorePages: Bool = true
    
    private let bookmarkRepository: BookmarkRepository
    private let campaignStatusRepository: CampaignStatusRepository
    
    init(
        campaignRepository: CampaignStatusRepository = CampaignStatusRepository(),
        bookmarkRepository: BookmarkRepository = BookmarkRepository()
    ) {
        self.campaignStatusRepository = campaignRepository
        self.bookmarkRepository = bookmarkRepository
        initializeFetch()
    }
    
    func initializeFetch()  {
        fetchCampaignStatusCount()
        fetchSubFilterCounts(for: selectedCampaignStatus)
        fetchCampaignsForSelectedStatus()
    }
    
    func deleteCampaign(campaignId: Int) {
        Task {
            do {
                if [.likedOpen, .likedClosed].contains(selectedSubFilter) {
                    try await bookmarkRepository.cancelBookmark(campaignId: campaignId)
                } else {
                    try await campaignStatusRepository.deleteStatus(campaignId)
                }

                campaigns.removeAll { $0.campaignId == campaignId }
                fetchCampaignStatusCount()
                fetchSubFilterCounts(for: selectedCampaignStatus)
                isCampaignActionSheetPresent = false
                ToastManager.shared.show(.success("공고가 삭제 되었습니다.", nil))
            } catch {
                print("Error deleting campaigns: \(error)")
                ToastManager.shared.show(.errorWithMessage("삭제 중 오류가 발생했습니다."))
            }
        }
    }
    
    func changeCampaignStatus(campaignId: Int, to statusType: CampaignStatusType) {
        Task {
            do {
                let request = CampaignStatusRequestDTO(
                    campaignId: campaignId,
                    status: statusType.apiValue
                )
                _ = try await campaignStatusRepository.createOrRecoverStatus(request: request)
                
                campaigns.removeAll { $0.campaignId == campaignId }

                fetchCampaignStatusCount()
                
                fetchSubFilterCounts(for: selectedCampaignStatus)
                isConfirmCampaignStatusSheetPresent = false

                ToastManager.shared.show(.success("공고 상태가 변경되었습니다", ButtonConfig(text: "보러가기", onClick: { [weak self] in
                    self?.selectedSubFilter = statusType.campaignSubfilter
                    self?.selectedCampaignStatus = statusType.campaignSubfilter.category
                })))
            } catch {
                print("Error changing campaign status to \(statusType): \(error)")
                ToastManager.shared.show(.errorWithMessage("상태 변경 중 오류가 발생했습니다."))
            }
        }
    }
    
    func fetchCampaignsForSelectedStatus() {
        isLoading = true
        hasMorePages = true
        currentPage = 0
        campaigns = []
        
        Task {
            do {
                let response = try await fetchPage(for: selectedSubFilter, page: currentPage)
                campaigns = response.content.map { $0.toMyCampaign() }
                hasMorePages = response.hasNext
                
            } catch {
                print("Error fetching campaigns: \(error)")
            }
            isLoading = false
        }
    }
    
    func loadNextPage() {
        guard hasMorePages && !isLoading else { return }
        isLoading = true
        currentPage += 1
        
        Task {
            do {
                let response = try await fetchPage(for: selectedSubFilter, page: currentPage)
                campaigns.append(contentsOf: response.content.map { $0.toMyCampaign() })
                hasMorePages = response.hasNext
            } catch {
                print("Error loading next page: \(error)")
                currentPage -= 1
            }
            isLoading = false
        }
    }
    
    private func fetchPage(for filter: CampaignSubFilter, page: Int) async throws -> PageableResponse<MyCampaignDTO> {
        if filter == .likedClosed {
            return try await bookmarkRepository.getClosedBookmarks(page: page)
        } else if filter == .likedOpen {
            return try await bookmarkRepository.getOpenBookmarks(page: page)
        } else {
            return try await campaignStatusRepository.getMyCampaings(for: filter, page: page)
        }
    }
    
    func fetchCampaignStatusCount() {
        Task {
            do {
                let count = try await campaignStatusRepository.getCampaignStatusCount()
                campaignStatusCounts = count
            } catch {
                print("Error fetching campaign status count: \(error)")
            }
        }
    }

    func fetchSubFilterCounts(for category: CampaignStatusCategory) {
        Task {
            do {
                var counts: [CampaignSubFilter: Int] = [:]
                for subFilter in category.subFilters {
                    let response = try await fetchPage(for: subFilter, page: 0)
                    counts[subFilter] = response.totalElements
                }
                subFilterCounts = counts
            } catch {
                print("Error fetching sub filter counts: \(error)")
            }
        }
    }
    
    func getCountForStatus(_ category: CampaignStatusCategory) -> Int? {
        guard let counts = campaignStatusCounts else { return nil }

        switch category {
        case .liked:
            return nil
        case .applied:
            return counts.apply
        case .result:
            return counts.selected + counts.notSelected
        case .writingReview:
            return counts.reviewing
        case .writingDone:
            return counts.ended
        }
    }

    func getCountForSubFilter(_ subFilter: CampaignSubFilter) -> Int? {
        subFilterCounts[subFilter]
    }

    func getButtonConfigs(for campaign: MyCampaign, router: MyCampaignRouter) -> [ButtonConfig] {
        switch selectedSubFilter {
        case .likedOpen:
            return [
                ButtonConfig(
                    text: "공고 보기",
                    type: .smallGray,
                    onClick: {
                        router.push(to: .campaignWeb(
                            siteNameKr: campaign.campaignSite,
                            campaignSiteUrl: campaign.detailUrl
                        ))
                    }
                ),
                ButtonConfig(
                    text: "지원 완료로 변경",
                    type: .smallPrimary,
                    onClick: { [weak self] in
                        self?.changeCampaignStatus(campaignId: campaign.campaignId, to: .apply)
                    }
                )
            ]
            
        case .likedClosed:
            return [
                ButtonConfig(
                    text: "공고 보기",
                    type: .smallGray,
                    onClick: {
                        router.push(to: .campaignWeb(
                            siteNameKr: campaign.campaignSite,
                            campaignSiteUrl: campaign.detailUrl
                        ))
                    }
                )
            ]
            
        case .appliedWaiting:
            return [
                ButtonConfig(
                    text: "공고 보기",
                    type: .smallGray,
                    onClick: {
                        router.push(to: .campaignWeb(
                            siteNameKr: campaign.campaignSite,
                            campaignSiteUrl: campaign.detailUrl
                        ))
                    }
                )
            ]
            
        case .appliedCompleted:
            return [
                ButtonConfig(
                    text: "공고 보기",
                    type: .smallGray,
                    onClick: {
                        router.push(to: .campaignWeb(
                            siteNameKr: campaign.campaignSite,
                            campaignSiteUrl: campaign.detailUrl
                        ))
                    }
                ),
                ButtonConfig(
                    text: "선정/미선정 입력",
                    type: .smallPrimary,
                    onClick: { [weak self] in
                        self?.focusedCampaign = campaign
                        self?.isConfirmCampaignStatusSheetPresent = true
                    }
                )
            ]
            
        case .resultSelected:
            return [
                ButtonConfig(
                    text: "공고 보기",
                    type: .smallGray,
                    onClick: {
                        router.push(to: .campaignWeb(
                            siteNameKr: campaign.campaignSite,
                            campaignSiteUrl: campaign.detailUrl
                        ))
                    }
                ),
                ButtonConfig(
                    text: "방문 완료로 변경",
                    type: .smallPrimary,
                    onClick: { [weak self] in
                        self?.changeCampaignStatus(campaignId: campaign.campaignId, to: .reviewing)
                    }
                )
            ]
            
        case .resultNotSelected:
            return [
                ButtonConfig(
                    text: "공고 보기",
                    type: .smallGray,
                    onClick: {
                        router.push(to: .campaignWeb(
                            siteNameKr: campaign.campaignSite,
                            campaignSiteUrl: campaign.detailUrl
                        ))
                    }
                )
            ]
            
        case .reviewInProgress:
            return [
                ButtonConfig(
                    text: "공고 보기",
                    type: .smallGray,
                    onClick: {
                        router.push(to: .campaignWeb(
                            siteNameKr: campaign.campaignSite,
                            campaignSiteUrl: campaign.detailUrl
                        ))
                    }
                ),
                ButtonConfig(
                    text: "리뷰 작성 완료",
                    type: .smallPrimary,
                    onClick: { [weak self] in
                        PopupManager.shared.show(.reviewWritingCompletion(
                            onConfirm: {
                                self?.changeCampaignStatus(campaignId: campaign.campaignId, to: .ended)
                            }
                        ))
                    }
                )
            ]

        case .reviewCompleted:
            return [
                ButtonConfig(
                    text: "공고 보기",
                    type: .smallGray,
                    onClick: {
                        router.push(to: .campaignWeb(
                            siteNameKr: campaign.campaignSite,
                            campaignSiteUrl: campaign.detailUrl
                        ))
                    }
                )
            ]
        }
    }
}
