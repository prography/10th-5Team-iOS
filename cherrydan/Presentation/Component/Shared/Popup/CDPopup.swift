import SwiftUI

struct CDPopup: View {
    let hidePopup: () -> Void
    let type: PopupType
    
    var body: some View {
        if case .changeCampaignStatus(let currentStatus, let onConfirm) = type {
            ChangeCampaignStatusPopupContent(
                currentStatus: currentStatus,
                onCancel: hidePopup,
                onConfirm: { status in
                    onConfirm(status)
                    hidePopup()
                }
            )
        } else {
            defaultPopupContent
        }
    }

    private var defaultPopupContent: some View {
        let config = type.config

        return VStack(spacing: 4) {
            if let image = config.image, !image.isEmpty {
                Image(image)
                    .padding(.bottom, 8)
            } else {
                Spacer().frame(height: 8)
            }

            Text(config.title)
                .font(.t2)
                .foregroundColor(.gray9)
                .multilineTextAlignment(.center)
            if case .loginWithDuplicatedAccount(let account) = type {
                Text(account)
                    .font(.m3r)
                    .foregroundColor(.gray9)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 56)
                    .padding(.leading, 16)
                    .background(.gray0, in: RoundedRectangle(cornerRadius: 4))
                    .padding(.vertical, 20)
            } else {
                Text(config.description)
                    .font(.t5)
                    .foregroundColor(.gray5)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 20)
            }

            buttonSection
        }
        .padding(16)
        .background(.pBeige, in: RoundedRectangle(cornerRadius: 8))
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    private var buttonSection: some View {
        let config = type.config
        
        switch config.buttonLayout {
        case .horizontal:
            HStack(spacing: 4) {
                ForEach(Array(config.buttons.enumerated()), id: \.offset) { index, buttonConfig in
                    CDButton(
                        text: buttonConfig.text,
                        type: buttonConfig.type
                    ) {
                        buttonConfig.onClick()
                        if type.config.isDismissNeeded {
                            hidePopup()
                        }
                    }
                }
            }
        case .vertical:
            VStack(spacing: 8) {
                ForEach(Array(config.buttons.enumerated()), id: \.offset) { index, buttonConfig in
                    CDButton(
                        text: buttonConfig.text,
                        type: buttonConfig.type
                    ) {
                        buttonConfig.onClick()
                        if type.config.isDismissNeeded {
                            hidePopup()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    Preview_wrapper()
}

struct Preview_wrapper: View {
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
                .opacity(0.3)
            
            CDPopup(
                hidePopup: {},
                type: .updateOptional(){}
            )
        }
    }
} 
