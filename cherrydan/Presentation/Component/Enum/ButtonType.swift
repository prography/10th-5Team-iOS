import SwiftUI

enum ButtonType {
    case smallPrimary
    case smallWhite
    case smallGray
    
    case middlePrimary
    
    case largeGray
    case largePrimary
    
    
    var font: Font {
        switch self {
        case .smallPrimary, .smallGray, .smallWhite:
                .m5r
        default:
                .m3r
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .smallWhite:
                .gray0
        case .smallGray:
                .gray2
        case .smallPrimary:
                .mPink2
        case .middlePrimary, .largePrimary:
                .mPink3
        case .largeGray:
                .gray0
        }
    }

    var foregroundColor: Color {
        switch self {
        case .smallWhite:
                .gray5
        case .smallGray, .largeGray:
                .gray5
        case .smallPrimary, .middlePrimary, .largePrimary:
                .gray0
        }
    }

    var strokeColor: Color? {
        switch self {
        case .largeGray:
                .gray3
        default:
                nil
        }
    }
    
    var height: CGFloat {
        switch self {
        case .smallPrimary, .smallGray, .smallWhite:
            44
        default:
            56
        }
    }
    
    var disabledBackgroundColor: Color { .mPink1 }
    var disabledForegroundColor: Color { .gray0 }
    var disabledStrokeColor: Color { .gray3 }
}
