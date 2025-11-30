import SwiftUI
import FirebaseAnalytics
import Combine

struct CherrydanView: View {
    @StateObject private var viewModel = CherrydanViewModel()
    @StateObject private var authManager = AuthManager.shared
    @StateObject private var popupManager = PopupManager.shared
    @StateObject private var toastManager = ToastManager.shared
    
    @StateObject private var homeRouter = HomeRouter()
    @StateObject private var categoryRouter = CategoryRouter()
    @StateObject private var noticeBoardRouter = NoticeBoardRouter()
    @StateObject private var myCampaignRouter = MyCampaignRouter()
    @StateObject private var myPageRouter = MyPageRouter()
    
    @State private var selectedTab = 0
    @State private var cancellables = Set<AnyCancellable>()
    
    var body: some View {
        VStack {
            if viewModel.isInitializing {
                ZStack {
                    Color.pBeige
                    
                    Image("logo_img")
                    
                    ProgressView()
                        .offset(y: 96)
                }
                .ignoresSafeArea()
            } else if authManager.isLoggedIn {
                VStack(spacing: 0) {
                    switch(selectedTab) {
                    case 0:
                        HomeNavigationStack(selectedTab: $selectedTab)
                            .environmentObject(homeRouter)
                    case 1:
                        MyCampaignNavigationStack(selectedTab: $selectedTab)
                            .environmentObject(myCampaignRouter)
                    case 2:
                        MyPageNavigationStack(selectedTab: $selectedTab)
                            .environmentObject(myPageRouter)
                    default:
                        MyPageNavigationStack(selectedTab: $selectedTab)
                            .environmentObject(myPageRouter)
                    }
                }
            } else {
                OnboardingView()
            }
        }
        .background(.gray0)
        .ignoresSafeArea(.container, edges: .bottom)
        .presentPopup(
            isPresented: $popupManager.popupPresented,
            data: popupManager.currentPopupType
        )
        .presentToast(
            isPresented: $toastManager.toastPresented,
            data: toastManager.currentToastType
        )
        .overlay {
            if viewModel.showCampaignPopup {
                ZStack {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture {
                            viewModel.dismissCampaignPopup()
                        }
                    
                    CDCampaignPopup(
                        campaigns: viewModel.popupCampaigns,
                        onConfirm: {
                            selectedTab = 1
                            viewModel.dismissCampaignPopup()
                        }
                    )
                }
            }
        }
        .onChange(of: authManager.isLoggedIn) { _, isLoggedIn in
            if !isLoggedIn {
                homeRouter.reset()
                noticeBoardRouter.reset()
                myPageRouter.reset()
                
                selectedTab = 0
            }
        }
        .onChange(of: selectedTab) { _, newTab in
            logTabChange(newTab)
        }
        .onAppear {
            NotificationCenter.default.publisher(for: .didTapPushNotification)
                .receive(on: RunLoop.main)
                .sink { notification in
                    guard let tab = notification.userInfo?[PushRouteUserInfoKey.targetTab] as? NotificationType else { return }
                    selectedTab = 0
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        homeRouter.replace(with: .notification(tab: tab))
                    }
                }
                .store(in: &cancellables)
        }
        
    }

    private func logTabChange(_ tab: Int) {
        let screenName: String
        switch tab {
        case 0:
            screenName = "home_main_screen"
        case 1:
            screenName = "my_campaign_screen"
        case 2:
            screenName = "my_page_main_screen"
        default:
            screenName = "unknown_tab_screen"
        }
        Analytics.logScreenView(screenName: screenName)
    }
}

#Preview {
    CherrydanView()
}
