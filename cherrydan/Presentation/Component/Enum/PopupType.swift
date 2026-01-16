import SwiftUI

enum PopupType {
    case updateMandatory(onClick:() -> Void)
    case updateOptional(onClick:() -> Void)
    case loginNeeded(onClick:() -> Void)
    case loginWithDuplicatedAccount(account: String)
    case cancelZzim(onClick:() -> Void)
    case confirmStatusChange(status: String, onClick:() -> Void)
    case visitCompletion(onVisitCompleted: () -> Void, onVisitIncomplete: () -> Void)
    case reviewWritingCompletion(onConfirm: () -> Void)
    case confirmCampaignDelete(onConfirm: () -> Void)
    case changeCampaignStatus(currentStatus: CampaignStatusType?, onConfirm: (CampaignStatusType) -> Void)
    case custom(PopupConfig)
    
    var config: PopupConfig {
        switch self {
        case .updateMandatory(let onClick):
            PopupConfig(
                image: nil,
                title: "새로운 버전 안내",
                description: "더 나은 서비스 제공을 위해\n새로운 기능과 개선사항이 추가되었어요",
                isDismissNeeded: false,
                buttons: [
                    ButtonConfig(text: "지금 업데이트하기", type: .largePrimary, onClick: onClick)
                ],
                buttonLayout: .horizontal
            )
        case .updateOptional(let onClick):
            PopupConfig(
                image: nil,
                title: "새로운 버전 안내",
                description: "더 나은 서비스 제공을 위해\n새로운 기능과 개선사항이 추가되었어요",
                buttons: [
                    ButtonConfig(text: "닫기", type: .largeGray, onClick: {}),
                    ButtonConfig(text: "업데이트하기", type: .largePrimary, onClick: onClick)
                ],
                buttonLayout: .horizontal
            )
        case .loginNeeded(let onClick):
            PopupConfig(
                image: nil,
                title: "로그인 필요",
                description: "로그인이 필요한 기능입니다!",
                buttons: [
                    ButtonConfig(text: "닫기", type: .largeGray, onClick: {}),
                    ButtonConfig(text: "로그인", type: .largePrimary, onClick: onClick)
                ],
                buttonLayout: .horizontal
            )
        case .loginWithDuplicatedAccount(let account):
            PopupConfig(
                image: nil,
                title: "이미 가입된 계정이 있습니다.\n로그인 해주세요.",
                description: account,
                buttons: [
                    ButtonConfig(text: "확인", type: .largePrimary, onClick: {})
                ],
                buttonLayout: .horizontal
            )
        case .cancelZzim(let onClick):
            PopupConfig(
                image: nil,
                title: "찜 목록에서 제거할까요?",
                description: "이후 홈화면에서 다시 추가할 수 있어요.",
                buttons: [
                    ButtonConfig(text: "취소", type: .largeGray, onClick: {}),
                    ButtonConfig(text: "제거", type: .largePrimary, onClick: onClick)
                ],
                buttonLayout: .horizontal
            )
        case .confirmStatusChange(_, let onConfirm):
            PopupConfig(
                image: nil,
                title: "상태 변경 안내",
                description: "지원 완료로 상태를 변경하시겠습니까?",
                buttons: [
                    ButtonConfig(text: "취소", type: .largeGray, onClick: {}),
                    ButtonConfig(text: "확인", type: .largePrimary, onClick: onConfirm)
                ],
                buttonLayout: .horizontal
            )
        case .visitCompletion(let onVisitCompleted, let onVisitIncomplete):
            PopupConfig(
                image: nil,
                title: "방문 완료 여부",
                description: "방문을 완료하셨나요?",
                buttons: [
                    ButtonConfig(text: "방문 미완료", type: .largeGray, onClick: onVisitIncomplete),
                    ButtonConfig(text: "방문 완료", type: .largePrimary, onClick: onVisitCompleted)
                ],
                buttonLayout: .horizontal
            )
        case .reviewWritingCompletion(let onConfirm):
            PopupConfig(
                image: nil,
                title: "리뷰 작성 완료",
                description: "리뷰 작성을 완료하시겠습니까?",
                buttons: [
                    ButtonConfig(text: "취소", type: .largeGray, onClick: {}),
                    ButtonConfig(text: "확인", type: .largePrimary, onClick: onConfirm)
                ],
                buttonLayout: .horizontal
            )
        case .confirmCampaignDelete(let onConfirm):
            PopupConfig(
                image: nil,
                title: "정말 삭제할까요?",
                description: "삭제한 공고는 되돌릴 수 없어요.",
                buttons: [
                    ButtonConfig(text: "취소", type: .largeGray, onClick: {}),
                    ButtonConfig(text: "삭제", type: .largePrimary, onClick: onConfirm)
                ],
                buttonLayout: .horizontal
            )
        case .changeCampaignStatus:
            PopupConfig(
                image: nil,
                title: "",
                description: "",
                buttons: [],
                buttonLayout: .horizontal
            )
        case .custom(let config):
            config
        }
    }
}

struct PopupConfig {
    let image: String?
    let title: String
    let description: String
    let isDismissNeeded: Bool
    let buttons: [ButtonConfig]
    let buttonLayout: ButtonLayout
    
    init(
        image: String? = nil,
        title: String,
        description: String,
        isDismissNeeded: Bool = true,
        buttons: [ButtonConfig],
        buttonLayout: ButtonLayout = .vertical
    ) {
        self.image = image
        self.title = title
        self.description = description
        self.isDismissNeeded = isDismissNeeded
        self.buttons = buttons
        self.buttonLayout = buttonLayout
    }
}

enum ButtonLayout {
    case vertical
    case horizontal
}
