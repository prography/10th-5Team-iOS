import SwiftUI

/// - note: 캠페인의 상태를 변경하거나, 삭제하는 액션을 취하는 바텀시트입니다.
struct ConfirmCampaignStatusBottomSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedType: CampaignStatusType? = nil
    
    let onStatusSelected: (CampaignStatusType) -> Void

    var body: some View {
        CDBottomSheet(type: .none( buttonConfig: nil), height: 320) {
            VStack(alignment: .center, spacing: 8) {
                Text("해당 공고의 상태를 선택해 주세요.")
                    .font(.m3r)
                    .foregroundStyle(.gray9)
                    .padding(.bottom, 4)
                
                actionButton(type: .notSelected)
                actionButton(type: .selected)
                
                Spacer()
                
                buttonSection
            }
        }
    }
    
    private var buttonSection: some View {
        HStack(spacing: 8) {
            CDButton(
                text: "취소",
                type: .largeGray,
                action: { dismiss() }
            )

            CDButton(
                text: "완료",
                type: .largePrimary,
                isDisabled: selectedType == nil
            ) {
                if let selectedType {
                    onStatusSelected(selectedType)
                }
            }
        }
    }
    
    private func actionButton(type: CampaignStatusType) -> some View {
        Button(action: { selectedType = type }) {
            let isSelected = selectedType == type
            
            Text(type.displayName)
                .font(.m3r)
                .foregroundStyle(isSelected ? .gray0 : .gray5)
                .frame(maxWidth: .infinity, alignment: .center)
                .frame(height: 56)
                .background(isSelected ? .mPink2 : .gray2, in: RoundedRectangle(cornerRadius: 32))
        }
    }
}


