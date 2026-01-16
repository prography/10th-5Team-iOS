import SwiftUI

struct CDButton: View {
    let text: String
    let type: ButtonType
    var isLoading: Bool = false
    var isDisabled: Bool = false
    var cornerRadius: CGFloat = 4
    let action: () -> Void
    
    init(
        text: String,
        type: ButtonType = .largePrimary,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        cornerRadius: CGFloat = 4,
        action: @escaping () -> Void
    ) {
        self.text = text
        self.type = type
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.cornerRadius = cornerRadius
        self.action = action
    }
    
    private var backgroundColor: Color {
        isDisabled ? type.disabledBackgroundColor : type.backgroundColor
    }
    
    private var foregroundColor: Color {
        isDisabled ? type.disabledForegroundColor : type.foregroundColor
    }

    private var strokeColor: Color {
        if isDisabled {
            if type == .middlePrimary || type == .largePrimary {
                return .gray3
            }
            return type.disabledStrokeColor
        }
        return type.strokeColor ?? .clear
    }

    var body: some View {
        Button(action: action) {
            if isLoading {
                ProgressView()
                    .scaleEffect(1.2)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .tint(.gray5)
            } else {
                Text(text)
                    .font(type.font)
                    .frame(maxWidth: .infinity)
                    .frame(height: type.height)
                    .foregroundStyle(foregroundColor)
                    .background(backgroundColor, in: RoundedRectangle(cornerRadius: cornerRadius))
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(strokeColor, lineWidth: 1)
                    )
            }
        }
        .disabled(isDisabled)
        .animation(.mediumSpring, value: isDisabled)
    }
}
