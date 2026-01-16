import SwiftUI
import Foundation

struct CDToast: View {
    let toastType: ToastType
    
    var body: some View {
        HStack(spacing: 12) {
            Text(toastType.text)
                .font(.m3r)
                .foregroundStyle(.gray9)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if case .success(_, let btnConfig) = toastType,
               let btnConfig {
                Button(action: btnConfig.onClick) {
                    Text(btnConfig.text)
                        .font(.m3r)
                        .foregroundStyle(.mPink3)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(.pBlue)
                .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 2)
        )
    }
}
