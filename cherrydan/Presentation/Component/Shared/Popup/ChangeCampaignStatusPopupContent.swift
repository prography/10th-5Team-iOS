import SwiftUI

struct ChangeCampaignStatusPopupContent: View {
    let currentStatus: CampaignStatusType?
    let onCancel: () -> Void
    let onConfirm: (CampaignStatusType) -> Void

    @State private var selectedStatus: CampaignStatusType?

    private let topRowStatuses: [CampaignStatusType] = [.apply, .notSelected, .selected]
    private let bottomRowStatuses: [CampaignStatusType] = [.reviewing, .ended]

    var body: some View {
        VStack(spacing: 32) {
            headerSection
            statusSelectionSection
            buttonSection
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 20)
        .background(.white, in: RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(.pBeige, lineWidth: 1)
        )
        .padding(.horizontal, 16)
    }

    private var headerSection: some View {
        VStack(spacing: 4) {
            Text("해당 공고의\n변경된 상태를 선택해 주세요.")
                .font(.t2)
                .foregroundStyle(.gray9)
                .multilineTextAlignment(.center)

            if let currentStatus {
                Text("현재 공고는 '\(currentStatus.displayName)' 상태입니다.")
                    .font(.t5)
                    .foregroundStyle(.gray5)
            }
        }
        .padding(.top, 20)
    }

    private var statusSelectionSection: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                ForEach(topRowStatuses, id: \.self) { status in
                    StatusCircleButton(
                        status: status,
                        isSelected: selectedStatus == status,
                        isCurrent: currentStatus == status,
                        onTap: {
                            if currentStatus != status {
                                selectedStatus = status
                            }
                        }
                    )
                }
            }

            HStack(spacing: 12) {
                ForEach(bottomRowStatuses, id: \.self) { status in
                    StatusCircleButton(
                        status: status,
                        isSelected: selectedStatus == status,
                        isCurrent: currentStatus == status,
                        onTap: {
                            if currentStatus != status {
                                selectedStatus = status
                            }
                        }
                    )
                }
            }
        }
    }

    private var buttonSection: some View {
        HStack(spacing: 8) {
            CDButton(
                text: "취소",
                type: .largeGray,
                action: onCancel
            )

            CDButton(
                text: "완료",
                type: .largePrimary,
                isDisabled: selectedStatus == nil,
                action: {
                    if let status = selectedStatus {
                        onConfirm(status)
                    }
                }
            )
        }
    }
}

private struct StatusCircleButton: View {
    let status: CampaignStatusType
    let isSelected: Bool
    let isCurrent: Bool
    let onTap: () -> Void

    private var backgroundColor: Color {
        if isSelected {
            return .mPink2
        }
        return .gray2
    }

    private var textColor: Color {
        if isSelected {
            return .white
        }
        return .gray5
    }

    var body: some View {
        Button(action: onTap) {
            Text(status.displayName)
                .font(.m2r)
                .foregroundStyle(textColor)
                .frame(width: 80, height: 80)
                .background(backgroundColor, in: Circle())
        }
        .overlay(alignment: .top) {
            if isCurrent {
                currentChip
                    .offset(y: -12)
            }
        }
        .disabled(isCurrent)
        .frame(height: 96)
    }

    private var currentChip: some View {
        Text("현재")
            .font(.m4r)
            .foregroundStyle(.gray9)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(.white, in: RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.gray4, lineWidth: 1)
            )
    }
}

#Preview {
    ZStack {
        Color.black.opacity(0.3)
            .ignoresSafeArea()

        ChangeCampaignStatusPopupContent(
            currentStatus: .apply,
            onCancel: {},
            onConfirm: { _ in }
        )
    }
}
