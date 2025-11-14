import Foundation

enum CampaignStatusType: CaseIterable, Codable {
    case apply
    case notSelected
    case selected
    case reviewing
    case ended
    
    var displayName: String {
        switch self {
        case .apply:
            "신청"
        case .notSelected:
            "미선정"
        case .selected:
            "선정"
        case .reviewing:
            "등록"
        case .ended:
            "종료"
        }
    }
    
    var apiValue: String {
        switch self {
        case .apply:
            "APPLY"
        case .selected:
            "SELECTED"
        case .notSelected:
            "NOT_SELECTED"
        case .reviewing:
            "REVIEWING"
        case .ended:
            "ENDED"
        }
    }
}

enum CampaignSubStatusLabel: String, Codable {
    case waiting
    case completed
    
    var apiValue: String { rawValue }
}

enum CampaignSubFilter: String, Identifiable, Equatable {
    case likedOpen
    case likedClosed
    case appliedWaiting
    case appliedCompleted
    case resultSelected
    case resultNotSelected
    case reviewInProgress
    case reviewCompleted
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .likedOpen:
            "신청 가능한 공고"
        case .likedClosed:
            "신청 마감된 공고"
        case .appliedWaiting:
            "발표 기다리는 중"
        case .appliedCompleted:
            "결과 발표 완료"
        case .resultSelected:
            "선정 결과"
        case .resultNotSelected:
            "선정되지 않은 공고"
        case .reviewInProgress:
            "리뷰 작성 중"
        case .reviewCompleted:
            "종료된 공고"
        }
    }
    
    var emptyStateMessage: String {
        switch self {
        case .likedOpen:
            "신청 가능한 공고가 없어요"
        case .likedClosed:
            "신청 마감된 공고가 없어요"
        case .appliedWaiting:
            "발표를 기다리는 공고가 없어요"
        case .appliedCompleted:
            "결과 발표가 완료된 공고가 없어요"
        case .resultSelected:
            "선정된 공고가 없어요"
        case .resultNotSelected:
            "선정되지 않은 공고가 없어요"
        case .reviewInProgress:
            "리뷰 작성 중인 공고가 없어요"
        case .reviewCompleted:
            "종료된 공고가 없어요"
        }
    }
    
    var filterSource: FilterSource {
        switch self {
        case .likedOpen:
            .bookmark(isOpen: true)
        case .likedClosed:
            .bookmark(isOpen: false)
        case .appliedWaiting:
            .campaignStatus(type: .apply, subStatus: .waiting)
        case .appliedCompleted:
            .campaignStatus(type: .apply, subStatus: .completed)
        case .resultSelected:
            .campaignStatus(type: .selected, subStatus: nil)
        case .resultNotSelected:
            .campaignStatus(type: .notSelected, subStatus: nil)
        case .reviewInProgress:
            .campaignStatus(type: .reviewing, subStatus: nil)
        case .reviewCompleted:
            .campaignStatus(type: .ended, subStatus: nil)
        }
    }
}

extension CampaignSubFilter {
    enum FilterSource: Equatable {
        case bookmark(isOpen: Bool)
        case campaignStatus(type: CampaignStatusType, subStatus: CampaignSubStatusLabel?)
    }
}

enum CampaignStatusCategory: CaseIterable {
    case liked
    case applied
    case result
    case writingReview
    case writingDone
    
    var displayText: String {
        switch self {
        case .liked:
            "관심 공고"
        case .applied:
            "지원한 공고"
        case .result:
            "선정 결과"
        case .writingReview:
            "리뷰 작성 중"
        case .writingDone:
            "작성 완료"
        }
    }
    
    var subFilters: [CampaignSubFilter] {
        switch self {
        case .liked:
            [.likedOpen, .likedClosed]
        case .applied:
            [.appliedWaiting, .appliedCompleted]
        case .result:
            [.resultSelected, .resultNotSelected]
        case .writingReview:
            [.reviewInProgress]
        case .writingDone:
            [.reviewCompleted]
        }
    }
    
    var defaultSubFilter: CampaignSubFilter {
        subFilters.first ?? .likedOpen
    }
}
