import SwiftUI
import WebKit

struct CampaignWebView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var router: HomeRouter
    let siteNameKr: String
    let campaignSiteUrl: String
    
    var body: some View {
        CDScreen(horizontalPadding: 0) {
            HStack(alignment: .center, spacing: 0) {
                Button(action: {
                    dismiss()
                }) {
                    Image("chevron_left")
                }
                
                Text(siteNameKr)
                    .font(.t3)
                    .foregroundStyle(.gray9)
                
                Spacer()
                
                Button(action: {
                    dismiss()
                }) {
                    Image("close")
                }
            }
            .frame(height: 52)
            .padding(.horizontal, 16)
            
            WebView(url: campaignSiteUrl)
                .ignoresSafeArea(.container, edges: .bottom)
        }
        .overlay(
            EdgeBackDragOverlay(width: 30, triggerThreshold: 80) {
                dismiss()
            },
            alignment: .leading
        )
    }
}

#Preview {
    CampaignWebView(siteNameKr: "레뷰", campaignSiteUrl: "https://example.com")
        .environmentObject(HomeRouter())
} 

// MARK: - Edge Back Drag Overlay
private struct EdgeBackDragOverlay: View {
    let width: CGFloat
    let triggerThreshold: CGFloat
    let onTrigger: () -> Void
    
    @State private var didTrigger: Bool = false
    
    var body: some View {
        Rectangle()
            .fill(Color.clear)
            .frame(width: width)
            .contentShape(Rectangle())
            .highPriorityGesture(
                DragGesture(minimumDistance: 10, coordinateSpace: .local)
                    .onChanged { value in
                        guard !didTrigger else { return }
                        // 수평 드래그가 임계값을 넘고, 수직 이동이 과도하지 않은 경우에만 트리거
                        if value.translation.width > triggerThreshold && abs(value.translation.height) < 40 {
                            didTrigger = true
                            onTrigger()
                        }
                    }
                    .onEnded { _ in
                        didTrigger = false
                    }
            )
            .accessibilityHidden(true)
    }
}
