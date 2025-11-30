import Foundation

@MainActor
class MyCampaignViewModel: ObservableObject {
    @Published var campaigns: [MyCampaign] = []
    @Published var selectedCampaignStatus: CampaignStatusCategory = .liked {
        didSet {
            guard oldValue != selectedCampaignStatus else { return }
            selectedCampaignIds.removeAll()
            isDeleteMode = false
            selectedSubFilter = selectedCampaignStatus.defaultSubFilter
        }
    }
    @Published var selectedSubFilter: CampaignSubFilter = CampaignStatusCategory.liked.defaultSubFilter {
        didSet {
            guard oldValue != selectedSubFilter else { return }
            selectedCampaignIds.removeAll()
            fetchCampaignsForSelectedStatus()
        }
    }
    @Published var isLoading: Bool = false
    @Published var campaignStatusCounts: CampaignStatusCountDTO? = nil
    @Published var isDeleteMode: Bool = false
    @Published var selectedCampaignIds: Set<Int> = []
    
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
        fetchCampaignsForSelectedStatus()
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
        switch filter.filterSource {
        case .bookmark(let isOpen):
            if isOpen {
                return try await bookmarkRepository.getOpenBookmarks(page: page)
            } else {
                return try await bookmarkRepository.getClosedBookmarks(page: page)
            }
        case .campaignStatus(let type, let subStatus):
            return try await campaignStatusRepository.getMyCampaings(for: filter, page: page)
        }
    }
    
    func selectSubFilter(_ filter: CampaignSubFilter) {
        selectedSubFilter = filter
    }
    
    func cancelBookmark(for campaignId: Int) {
        Task {
            do {
                try await bookmarkRepository.cancelBookmark(campaignId: campaignId)
                campaigns.removeAll { $0.campaignId == campaignId }
            } catch {
                print("북마크 토글 오류: \(error)")
                ToastManager.shared.show(.errorWithMessage("북마크 처리 중 오류가 발생했습니다."))
            }
        }
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
                    onClick: {
                        PopupManager.shared.show(.confirmStatusChange(status: "지원 완료") {
                            self.changeCampaignStatus(campaignId: campaign.campaignId, to: .apply)
                        })
                    }
                )
            ]
            
        case .likedClosed:
            return [
                ButtonConfig(
                    text: "공고 보기",
                    type: .smallWhite,
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
                    text: "합격/불합격 입력",
                    type: .smallPrimary,
                    onClick: {
                        PopupManager.shared.show(.passFailSelection(
                            onPass: {
                                self.changeCampaignStatus(campaignId: campaign.campaignId, to: .selected)
                            },
                            onFail: {
                                self.changeCampaignStatus(campaignId: campaign.campaignId, to: .notSelected)
                            }
                        ))
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
                    onClick: {
                        PopupManager.shared.show(.visitCompletion(
                            onVisitCompleted: {
                                self.changeCampaignStatus(campaignId: campaign.campaignId, to: .reviewing)
                            },
                            onVisitIncomplete: {
                                // 방문 미완료 시 아무 동작 없음
                            }
                        ))
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
                    onClick: {
                        PopupManager.shared.show(.reviewWritingCompletion(
                            onConfirm: {
                                self.changeCampaignStatus(campaignId: campaign.campaignId, to: .ended)
                            }
                        ))
                    }
                )
            ]
            
        case .reviewCompleted:
            return [
                ButtonConfig(
                    text: "공고 보기",
                    type: .smallWhite,
                    onClick: {
                        router.push(to: .campaignWeb(
                            siteNameKr: campaign.campaignSite,
                            campaignSiteUrl: campaign.detailUrl
                        ))
                    }
                ),
                ButtonConfig(
                    text: "리뷰 결과 확인",
                    type: .smallPrimary,
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
    
    func toggleCampaignSelection(campaignId: Int) {
        if selectedCampaignIds.contains(campaignId) {
            selectedCampaignIds.remove(campaignId)
        } else {
            selectedCampaignIds.insert(campaignId)
        }
    }
    
    func toggleSelectAll() {
        let allCampaignIds = Set(campaigns.map { $0.campaignId })
        if selectedCampaignIds == allCampaignIds {
            selectedCampaignIds.removeAll()
        } else {
            selectedCampaignIds = allCampaignIds
        }
    }
    
    var isAllSelected: Bool {
        let allCampaignIds = Set(campaigns.map { $0.campaignId })
        return !allCampaignIds.isEmpty && selectedCampaignIds == allCampaignIds
    }
    
    var isSelectionValid: Bool {
        !selectedCampaignIds.isEmpty
    }
    
    func updateSelectedCampaignsStatus(to newStatus: CampaignStatusType) {
        Task {
            do {
                for campaignId in selectedCampaignIds {
                    let request = CampaignStatusRequestDTO(
                        campaignId: campaignId,
                        status: newStatus.apiValue
                    )
                    _ = try await campaignStatusRepository.createOrRecoverStatus(request: request)
                }
                
                selectedCampaignIds.removeAll()
                fetchCampaignStatusCount()
                fetchCampaignsForSelectedStatus()
                
                ToastManager.shared.show(.success("상태가 성공적으로 변경되었습니다."))
            } catch {
                print("Error updating campaign status: \(error)")
                ToastManager.shared.show(.errorWithMessage("상태 변경 중 오류가 발생했습니다."))
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
                
                let successMessage = getSuccessMessage(for: statusType)
                ToastManager.shared.show(.success(successMessage))
            } catch {
                print("Error changing campaign status to \(statusType): \(error)")
                ToastManager.shared.show(.errorWithMessage("상태 변경 중 오류가 발생했습니다."))
            }
        }
    }
    
    private func getSuccessMessage(for statusType: CampaignStatusType) -> String {
        switch statusType {
        case .apply:
            return "상태가 성공적으로 변경되었습니다."
        case .reviewing:
            return "리뷰 작성 중으로 상태가 변경되었습니다."
        case .ended:
            return "리뷰 작성이 완료되었습니다."
        case .selected:
            return "선정으로 상태가 변경되었습니다."
        case .notSelected:
            return "미선정으로 상태가 변경되었습니다."
        }
    }
    
    func deleteSelectedCampaigns() {
        Task {
            do {
                switch selectedSubFilter.filterSource {
                case .bookmark:
                    for campaignId in selectedCampaignIds {
                        try await bookmarkRepository.cancelBookmark(campaignId: campaignId)
                    }
                case .campaignStatus:
                    try await campaignStatusRepository.deleteStatus(request: DeleteRequest(campaignIds: Array(selectedCampaignIds)))
                }
                
                campaigns.removeAll { selectedCampaignIds.contains($0.campaignId) }
                ToastManager.shared.show(.success("선택된 항목이 삭제되었습니다."))
                selectedCampaignIds.removeAll()
                isDeleteMode = false
                fetchCampaignStatusCount()
                
            } catch {
                print("Error deleting campaigns: \(error)")
                ToastManager.shared.show(.errorWithMessage("삭제 중 오류가 발생했습니다."))
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
}
