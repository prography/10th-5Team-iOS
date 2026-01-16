import SwiftUI

struct ManageSNSView: View {
    @StateObject private var viewModel = ManageSNSViewModel()
    
    var body: some View {
        CDScreen(horizontalPadding: 0, isLoading: viewModel.isLoading) {
            CDBackHeaderWithTitle(title: "SNS 자동로그인")
                .padding(.horizontal, 16)
            
            ScrollView {
                VStack(spacing: 24) {
                    mediaItemSection
                }
                .padding(.horizontal, 16)
                .padding(.top, 24)
                .padding(.bottom, 120)
            }
            
            Spacer()
        }
        .sheet(isPresented: $viewModel.showNaverBottomSheet) {
            NaverSNSBottomSheet(onConnect: { blogUrl, verificationCode in
                viewModel.connectNaverBlog(blogUrl: blogUrl, verificationCode: verificationCode)
            })
        }
        .sheet(isPresented: $viewModel.showSNSBottomSheet) {
            SNSBottomSheet(
                platformType: viewModel.selectedPlatformType,
                onConnect: { url in
//                    viewModel.connectSNS(platformType: viewModel.selectedPlatformType, url: url)
                }
            )
        }
    }
    
    private var mediaItemSection: some View {
        VStack(spacing: 24) {
            mediaItem(platformType: .blog)
            mediaItem(platformType: .instagram)
            mediaItem(platformType: .youtube)
            mediaItem(platformType: .tiktok)
        }
    }
    
    private func mediaItem(platformType: SNSPlatformType) -> some View {
        let isConnected = viewModel.isConnected(for: platformType)
        let url = viewModel.getURL(for: platformType)
        
        return VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 4) {
                if !platformType.imageName.isEmpty {
                    Image(platformType.imageName)
                }
                
                Text(platformType.displayName)
                    .font(.m5r)
                    .foregroundStyle(.gray9)
            }
            
            VStack {
                if let url = url {
                    Text(url)
                        .font(.m2r)
                        .foregroundStyle(.gray9)
                        .lineLimit(1)
                } else {
                    Text("연결해 주세요!")
                        .font(.m2r)
                        .foregroundStyle(.gray4)
                }
            }
            .frame(height: 44, alignment: .center)
            
            CDRoundButton(
                isConnected ? "연결 해제" : "연결하기",
                type: isConnected ? .gray : .primary
            ) {
//                viewModel.handleButtonTap(for: platformType)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.bottom, 12)
            
            Divider()
        }
        .padding(.bottom, 8)
    }
}

#Preview {
    ManageSNSView()
} 
