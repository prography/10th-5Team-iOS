import SwiftUI

enum BottomSheetType {
    case titleLeading(title: String, buttonConfig: ButtonConfig?)
    case titleCenter(title: String, buttonConfig: ButtonConfig?)
    case titleCenterWithBackButton(title: String, buttonConfig: ButtonConfig?)
    case none(buttonConfig: ButtonConfig?)
}

struct CDBottomSheet<Content: View>: View {
    @Environment(\.dismiss) var dismiss
    
    var height: CGFloat
    var horizontalPadding: CGFloat
    let type: BottomSheetType
    let onClose: (() -> Void)?
    let onBack: (() -> Void)?
    let content: Content
    
    init(
        type: BottomSheetType,
        height: CGFloat = 280,
        horizontalPadding: CGFloat = 16,
        onClose: (() -> Void)? = nil,
        onBack: (() -> Void)? = nil,
        onButtonTap: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.type = type
        self.height = height
        self.horizontalPadding = horizontalPadding
        self.onClose = onClose
        self.onBack = onBack
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            headerView
                .padding(.bottom, 24)
            content
            Spacer()
            buttonView
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.top, 28)
        .frame(maxWidth: .infinity, maxHeight: height)
        .presentationDetents([.height(height)])
        .presentationDragIndicator(hasHeader ? .hidden : .visible)
        .presentationCornerRadius(24)
        .background(.gray0)
        .presentationBackground(.gray0)
    }
    
    private var hasHeader: Bool { true }
    
    @ViewBuilder
    private var headerView: some View {
        switch type {
        case .none:
            EmptyView()
        case .titleLeading(let title, _):
            Text(title)
                .font(.m3b)
                .foregroundStyle(.gray9)
                .frame(maxWidth: .infinity, alignment: .leading)
            
        case .titleCenter(let title, _):
            ZStack {
                Text(title)
                    .font(.m3r)
                    .foregroundStyle(.gray9)
                HStack {
                    Spacer()
                    Button(action: {
                        if let onClose = onClose { onClose() } else { dismiss() }
                    }) {
                        Image("close_white_big")
                    }
                }
            }
            .padding(.horizontal, 16)
        case .titleCenterWithBackButton(let title, _):
            ZStack {
                Text(title)
                    .font(.m3b)
                    .foregroundStyle(.gray9)
                HStack {
                    Button(action: {
                        if let onBack = onBack { onBack() } else { dismiss() }
                    }) {
                        Image("close_white_big")
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                }
            }
            .padding(.horizontal, 16)
        }
    }
    
    @ViewBuilder
    private var buttonView: some View {
        let config: ButtonConfig? = {
            switch type {
            case .none(let buttonConfig):
                buttonConfig
            case .titleLeading(_, let buttonConfig):
                buttonConfig
            case .titleCenter(_, let buttonConfig):
                buttonConfig
            case .titleCenterWithBackButton(_, let buttonConfig):
                buttonConfig
            }
        }()
        
        if let config {
            CDButton(text: config.text, isDisabled: config.disabled){
                config.onClick()
            }
            .animation(.mediumSpring, value: config.disabled)
            .padding(.bottom, 16)
        }
    }
}
