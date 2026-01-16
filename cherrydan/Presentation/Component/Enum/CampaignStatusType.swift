import Foundation

/// - note: 변경이 가능한 공고의 상태입니다.
enum CampaignStatusType: CaseIterable, Codable, Equatable {
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
    
    var campaignSubfilter: CampaignSubFilter {
        switch self {
        case .apply:
                .appliedCompleted
        case .notSelected:
                .resultNotSelected
        case .selected:
                .resultSelected
        case .reviewing:
                .reviewInProgress
        case .ended:
                .reviewCompleted
        }
    }
}

enum CampaignSubStatusLabel: String, Codable {
    case waiting
    case completed
    
    var apiValue: String { rawValue }
}

enum CampaignSubFilter: String, Identifiable, Equatable, Hashable {
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
        case .likedOpen, .likedClosed:
            "찜한 공고가 없네요.\n마음에 드는 공고를 찜해두면,\n언제든 쉽게 확인할 수 있어요."
        case .appliedWaiting, .appliedCompleted:
            "아직 신청한 공고가 없네요.\n체리단의 특별한 경험은\n공고신청에서 시작됩니다."
        case .resultSelected, .resultNotSelected:
            "아직 선정결과가 나온 공고가 없네요.\n체리단의 특별한 경험은\n공고신청에서 시작됩니다."
        case .reviewInProgress:
            "공고 미션과 유의사항을 잘 살펴보면\n콘텐츠 작성에 많은 도움이 됩니다."
        case .reviewCompleted:
            "시작이 없으면 끝도 없습니다.\n공고 신청이 체리단 활동의 시작입니다."
        }
    }
    
    var category: CampaignStatusCategory {
        switch self {
        case .likedOpen,. likedClosed:
                .liked
        case .appliedWaiting, .appliedCompleted:
                .applied
        case .resultSelected, .resultNotSelected:
                .result
        case .reviewInProgress:
                .writingReview
        case .reviewCompleted:
                .writingDone
        }
    }
    
    var statusType: CampaignStatusType? {
        switch self {
        case .likedOpen, .likedClosed:
                nil
        case .appliedWaiting, .appliedCompleted:
                .apply
        case .resultSelected:
                .selected
        case .resultNotSelected:
                .notSelected
        case .reviewInProgress:
                .reviewing
        case .reviewCompleted:
                .ended
        }
    }
}

/// - note: 내 캠페인 탭 내부 보이는 상단 탭 내용입니다.
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
