import Foundation
import SwiftUI
import AuthenticationServices
import KakaoSDKUser
import KakaoSDKCommon
import NaverThirdPartyLogin
import GoogleSignIn

@MainActor
class OnboardingViewModel: NSObject, ObservableObject {
    @Published var isLoading: Bool = false
    @Published var recentLoggedInPlatform: LoginPlatform?
    
    let instance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    private let auth: AuthRepository
    
    override init() {
        self.auth = AuthRepository()
        super.init()
        setupNaverLogin()
        loadRecentLoggedInPlatform()
    }
    
    init(auth: AuthRepository) {
        self.auth = auth
        super.init()
        setupNaverLogin()
        loadRecentLoggedInPlatform()
    }
    
    private func setupNaverLogin() {
        instance?.delegate = self
    }
    
    private func loadRecentLoggedInPlatform() {
        recentLoggedInPlatform = AuthManager.shared.lastLoggedInPlatform
    }
    
    func performNaverLogin() async {
        isLoading = true
        
        instance?.requestThirdPartyLogin()
        
        // 네이버 로그인 웹뷰에서 뒤로가기/닫기 시 로딩 상태 해제를 위한 타이머
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            // 로그인이 진행 중이 아니라면 로딩 상태 해제
            if self.instance?.accessToken == nil && self.isLoading {
                self.isLoading = false
            }
        }
    }
    
    func performKakaoLogin() async {
        isLoading = true
        
        UserApi.shared.loginWithKakaoAccount { [weak self] (oauthToken, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Kakao login error: \(error)")
                Task { @MainActor in
                    // 취소 케이스 체크
                    if let sdkError = error as? SdkError,
                       case .ClientFailed(let reason, _) = sdkError,
                       reason == .Cancelled {
                        print("카카오 로그인 취소됨")
                    } else {
                        ToastManager.shared.show(.errorWithMessage("카카오 로그인 중 오류가 발생했습니다: \(error.localizedDescription)"))
                    }
                    self.isLoading = false
                }
            } else {
                Task { @MainActor in
                    guard let oauthToken = oauthToken else {
                        ToastManager.shared.show(.errorWithMessage("카카오 토큰을 가져올 수 없습니다."))
                        self.isLoading = false
                        return
                    }
                    
                    // 카카오 사용자 정보 수집
                    await self.fetchKakaoUserInfo(token: oauthToken.accessToken)
                }
            }
        }
    }
    
    private func fetchKakaoUserInfo(token: String) async {
        UserApi.shared.me { [weak self] (user, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Kakao user info error: \(error)")
                Task { @MainActor in
                    // 사용자 정보 수집 실패해도 토큰으로 로그인 진행
                    await self.handleSocialLogin(.kakao, token, userInfo: nil)
                }
            } else {
                Task { @MainActor in
                    let userName = user?.kakaoAccount?.profile?.nickname
                    let userEmail = user?.kakaoAccount?.email
                    
                    let userInfo = UserInfo(
                        name: userName,
                        email: userEmail,
                        platform: "kakao"
                    )
                    
                    await self.handleSocialLogin(.kakao, token, userInfo: userInfo)
                }
            }
        }
    }
    
    func performGoogleLogIn() {
        isLoading = true
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { [weak self] signInResult, error in
            guard let self else { return }
            if let error = error {
                Task { @MainActor in
                    if let error = error as? GIDSignInError {
                        switch error.code {
                        case .canceled:
                            print("구글 로그인 취소됨")
                        default:
                            ToastManager.shared.show(.errorWithMessage("구글 로그인 중 오류가 발생했습니다: \(error.localizedDescription)"))
                        }
                    } else {
                        ToastManager.shared.show(.errorWithMessage("구글 로그인 중 오류가 발생했습니다: \(error.localizedDescription)"))
                    }
                    self.isLoading = false
                }
            } else if let signInResult {
                guard let idToken = signInResult.user.idToken?.tokenString else {
                    return
                }
                
                let userName = signInResult.user.profile?.name
                let userEmail = signInResult.user.profile?.email
                
                let userInfo = UserInfo(
                    name: userName,
                    email: userEmail,
                    platform: "google"
                )
                
                Task {
                    await self.handleSocialLogin(.google, idToken, userInfo: userInfo)
                }
            }
        }
    }
    
    func performAppleLogin(_ result: ASAuthorization) async {
        isLoading = true
        
        guard let appleIDCredential = result.credential as? ASAuthorizationAppleIDCredential,
              let identityTokenData = appleIDCredential.identityToken,
              let idToken = String(data: identityTokenData, encoding: .utf8) else {
            ToastManager.shared.show(.errorWithMessage("애플 로그인 인증 정보를 가져올 수 없습니다."))
            isLoading = false
            return
        }
        
        // 애플 사용자 정보 수집
        let userName = appleIDCredential.fullName?.formatted()
        let userEmail = appleIDCredential.email
        
        let userInfo = UserInfo(
            name: userName,
            email: userEmail,
            platform: "apple"
        )
        
        await handleSocialLogin(.apple, idToken, userInfo: userInfo)
    }
    
    private func handleSocialLogin(_ platform: LoginPlatform, _ token: String, userInfo: UserInfo?) async {
        do {
            let response = try await auth.socialLogin(platform.rawValue, token, userInfo: userInfo)
            
            if response.code == 200 {
                // 사용자 닉네임 추출 (이름이 없으면 "회원"으로 설정)
                let nickname = userInfo?.name?.isEmpty == false ? userInfo?.name : "회원"
                
                AuthManager.shared.login(response.result, platform: platform, nickname: nickname)
                
                recentLoggedInPlatform = platform
                
                // 사용자 정보 로그 출력 (개발용)
                if let userInfo = userInfo {
                    print("[\(platform.title)] 사용자 정보 수집 성공")
                    print("이름: \(userInfo.name ?? "없음")")
                    print("이메일: \(userInfo.email ?? "없음")")
                    print("저장된 닉네임: \(nickname ?? "회원")")
                } else {
                    print("[\(platform.title)] 사용자 정보 수집 실패 - 기본 닉네임 '회원'으로 설정")
                }
            } else {
                ToastManager.shared.show(.errorWithMessage(response.message))
            }
        } catch {
            PopupManager.shared.show(.loginWithDuplicatedAccount(account: userInfo?.email ?? ""))
            print("\(platform.rawValue) login error: \(error)")
            isLoading = false
        }
        
        isLoading = false
    }
}

// MARK: - NaverThirdPartyLoginConnectionDelegate
extension OnboardingViewModel: NaverThirdPartyLoginConnectionDelegate {
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("네이버 로그인 성공 - 인증 코드")
        handleNaverLoginSuccess()
    }
    
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        print("네이버 로그인 성공 - 리프레시 토큰으로 액세스 토큰 갱신")
        handleNaverLoginSuccess()
    }
    
    func oauth20ConnectionDidFinishDeleteToken() {
        print("네이버 로그아웃 완료")
    }
    
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("네이버 로그인 실패: \(error.localizedDescription)")
        Task { @MainActor in
            if error.localizedDescription.contains("cancelled") || error.localizedDescription.contains("사용자") {
                print("네이버 로그인 취소됨")
            } else {
                ToastManager.shared.show(.errorWithMessage("네이버 로그인 중 오류가 발생했습니다: \(error.localizedDescription)"))
            }
            
            self.isLoading = false
        }
    }
    
    private func handleNaverLoginSuccess() {
        Task { @MainActor in
            do {
                guard let accessToken = instance?.accessToken else {
                    ToastManager.shared.show(.errorWithMessage("네이버 액세스 토큰을 가져올 수 없습니다."))
                    self.isLoading = false
                    return
                }
                
                await self.fetchNaverUserInfo(token: accessToken)
            }
        }
    }
    
    private func fetchNaverUserInfo(token: String) async {
        guard let url = URL(string: "https://openapi.naver.com/v1/nid/me") else {
            await handleSocialLogin(.naver, token, userInfo: nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let response = json["response"] as? [String: Any] {
                
                let userName = response["name"] as? String
                let userEmail = response["email"] as? String
                
                let userInfo = UserInfo(
                    name: userName,
                    email: userEmail,
                    platform: "naver"
                )
                
                await handleSocialLogin(.naver, token, userInfo: userInfo)
            } else {
                await handleSocialLogin(.naver, token, userInfo: nil)
            }
        } catch {
            print("Naver user info error: \(error)")
            await handleSocialLogin(.naver, token, userInfo: nil)
        }
    }
}
