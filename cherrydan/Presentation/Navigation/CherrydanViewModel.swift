import Foundation
import SwiftUI

@MainActor
class CherrydanViewModel: ObservableObject {
    @Published var isInitializing = true
    @Published var showCampaignPopup = false
    @Published var popupCampaigns: [CampaignStatusPopupItem] = []
    
    private let myPageRepository: MyPageRepository
    private let campaignStatusRepository: CampaignStatusRepository
    
    private var currentAppVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.2"
    }
    
    init(
        myPageRepository: MyPageRepository = MyPageRepository(),
        campaignStatusRepository: CampaignStatusRepository = CampaignStatusRepository()
    ) {
        self.myPageRepository = myPageRepository
        self.campaignStatusRepository = campaignStatusRepository
        initialize()
    }
    
    private func initialize() {
        Task {
            do {
                let response = try await myPageRepository.getVersion()
                handleVersionCheck(
                    newVersion: response.latestVersion,
                    minVersion: response.minSupportedVersion
                )
                await handleAuthState()
                await fetchCampaignStatusPopup()
            } catch {
                print("Failed to get version info: \(error)")
            }
            
            isInitializing = false
        }
    }
    
    private func handleAuthState() async {
        let refreshSuccess = await TokenManager.shared.ensureValidToken()
        if refreshSuccess {
            AuthManager.shared.isLoggedIn = true
        } else {
            print("리프레시 토큰 존재 & 재발급 실패하여 자동 로그아웃")
            AuthManager.shared.logout()
        }
    }
    
    private func fetchCampaignStatusPopup() async {
        guard AuthManager.shared.isLoggedIn else { return }
        
        do {
            let response = try await campaignStatusRepository.getPopupStatus()
            let items = response.items.map { $0.toDomain() }
            if !items.isEmpty {
                popupCampaigns = items
                showCampaignPopup = true
            }
        } catch {
            print("Failed to fetch campaign status popup: \(error)")
        }
    }
    
    func dismissCampaignPopup() {
        showCampaignPopup = false
    }
    
    private func handleVersionCheck(newVersion: String, minVersion: String) {
        let moveToAppStore = {
            if let url = URL(string: "https://apps.apple.com/kr/app/%EC%B2%B4%EB%A6%AC%EB%8B%A8/id6748566686") {
                UIApplication.shared.open(url)
            }
        }
        
        // 현재 버전이 최소 지원 버전보다 낮은 경우 - 필수 업데이트
        if currentAppVersion.isVersionLower(than: minVersion) {
            PopupManager.shared.show(.updateMandatory(onClick: moveToAppStore))
        }
        
        // 현재 버전이 최신 버전보다 낮은 경우 - 선택적 업데이트
        else if currentAppVersion.isVersionLower(than: newVersion) {
            PopupManager.shared.show(.updateOptional(onClick: moveToAppStore))
        }
    }
}
