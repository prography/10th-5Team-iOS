import SwiftUI

/// - note: 캠페인의 상태를 변경하거나, 삭제하는 액션을 취하는 바텀시트입니다.
struct CampaignActionBottomSheet: View {
    @Environment(\.dismiss) private var dismiss
    let onDelete: () -> Void
    let onChangeStatus: () -> Void

    var body: some View {
        CDBottomSheet(type: .none(buttonConfig: nil), height: 180) {
            VStack(spacing: 12) {
                actionButton(
                    title: "상태 변경",
                    color: .gray9,
                    action: {
                        dismiss()
                        onChangeStatus()
                    }
                )

                actionButton(
                    title: "삭제",
                    color: .mPink3,
                    action: {
                        dismiss()
                        onDelete()
                    }
                )
            }
        }
    }

    private func actionButton(title: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.m4r)
                .foregroundStyle(color)
                .frame(maxWidth: .infinity, alignment: .center)
                .frame(height: 56)
                .background(.gray2, in: RoundedRectangle(cornerRadius: 4))
        }
    }
}


