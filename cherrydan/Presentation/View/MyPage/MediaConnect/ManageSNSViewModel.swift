import Foundation

@MainActor
class ManageSNSViewModel: ObservableObject {
    @Published var naverBlogConnected = false
    @Published var instagramConnected = false
    @Published var youtubeConnected = false
    @Published var tiktokConnected = false
    
    @Published var isLoading: Bool = false
    
    // 바텀시트 표시 상태
    @Published var showNaverBottomSheet = false
    @Published var showSNSBottomSheet = false
    @Published var selectedPlatformType: SNSPlatformType = .instagram
    
    private let snsRepository: SNSRepository
    
    init(snsRepository: SNSRepository = SNSRepository()) {
        self.snsRepository = snsRepository
        loadConnections()
    }
    
    /// 연결 상태 정보를 로드
    private func loadConnections() {
        isLoading = true
        
        Task {
            do {
                let connections = try await snsRepository.getSNSConnections()
                
                // 각 플랫폼별 연결 상태 업데이트
                for connection in connections {
                    switch connection.platform {
                    case "naver":
                        naverBlogConnected = connection.isConnected
                    case "instagram":
                        instagramConnected = connection.isConnected
                    case "youtube":
                        youtubeConnected = connection.isConnected
                    case "tiktok":
                        tiktokConnected = connection.isConnected
                    default:
                        break
                    }
                }
                
                isLoading = false
            } catch {
                print("SNS 연결 상태 로드 실패: \(error)")
                ToastManager.shared.show(.errorWithMessage("SNS 연결 상태를 불러오는 중 오류가 발생했습니다."))
                isLoading = false
            }
        }
    }
//    
//    /// 버튼 탭 처리 (연결/해제)
//    func handleButtonTap(for platformType: SNSPlatformType) {
//        switch platformType {
//        case .blog:
//            if naverBlogConnected {
//                // 네이버 블로그 연결 해제
//                disconnectSNS(platformType: .blog)
//            } else {
//                // 네이버 블로그 연결 바텀시트 표시
//                showNaverBottomSheet = true
//            }
//        case .instagram:
//            if instagramConnected {
//                // 인스타그램 연결 해제
//                disconnectSNS(platformType: .instagram)
//            } else {
//                // 인스타그램 연결 바텀시트 표시
//                selectedPlatformType = .instagram
//                showSNSBottomSheet = true
//            }
//        case .youtube:
//            if youtubeConnected {
//                // 유튜브 연결 해제
//                disconnectSNS(platformType: .youtube)
//            } else {
//                // 유튜브 연결 바텀시트 표시
//                selectedPlatformType = .youtube
//                showSNSBottomSheet = true
//            }
//        case .tiktok:
//            if tiktokConnected {
//                // 틱톡 연결 해제
//                disconnectSNS(platformType: .tiktok)
//            } else {
//                // 틱톡 연결 바텀시트 표시
//                selectedPlatformType = .tiktok
//                showSNSBottomSheet = true
//            }
//        default:
//            break
//        }
//    }
//    
    /// 네이버 블로그 연결 처리
    func connectNaverBlog(blogUrl: String, verificationCode: String) {
        isLoading = true
        
        Task {
            do {
                let result = try await snsRepository.verifyNaverBlog(
                    blogUrl: blogUrl,
                    verificationCode: verificationCode
                )
                
                if result.success {
                    naverBlogConnected = true
                    print("네이버 블로그 연결 성공: \(result.message ?? "")")
                } else {
                    ToastManager.shared.show(.errorWithMessage(result.message ?? "네이버 블로그 연결에 실패했습니다."))
                }
                
                isLoading = false
            } catch {
                print("네이버 블로그 연결 실패: \(error)")
                ToastManager.shared.show(.errorWithMessage("네이버 블로그 연결 중 오류가 발생했습니다."))
                isLoading = false
            }
        }
    }
    
    /// 일반 SNS 연결 처리
//    func connectSNS(platformType: SNSPlatformType, url: String) {
//        isLoading = true
//        errorMessage = nil
//        
//        Task {
//            do {
//                // OAuth 인증 URL 생성
//                let authUrlResponse = try await snsRepository.getOAuthAuthUrl(for: platformType)
//                
//                // 실제 앱에서는 웹뷰나 사파리를 열어 OAuth 인증 진행
//                // 현재는 임시로 연결 성공 처리
//                updateConnectionStatus(for: platformType, isConnected: true)
//                
//                print("\(platformType.rawValue) OAuth 인증 URL: \(authUrlResponse.authUrl)")
//                
//                isLoading = false
//            } catch {
//                print("\(platformType.rawValue) 연결 실패: \(error)")
//                errorMessage = "\(platformType.rawValue) 연결 중 오류가 발생했습니다."
//                isLoading = false
//            }
//        }
//    }
//    
//    /// SNS 연결 해제 처리
//    private func disconnectSNS(platformType: SNSPlatformType) {
//        isLoading = true
//        errorMessage = nil
//        
//        Task {
//            do {
//                let success = try await snsRepository.disconnect(platformType: platformType)
//                
//                if success {
//                    updateConnectionStatus(for: platformType, isConnected: false)
//                    print("\(platformType.rawValue) 연결 해제 성공")
//                } else {
//                    errorMessage = "\(platformType.rawValue) 연결 해제에 실패했습니다."
//                }
//                
//                isLoading = false
//            } catch {
//                print("\(platformType.rawValue) 연결 해제 실패: \(error)")
//                errorMessage = "\(platformType.rawValue) 연결 해제 중 오류가 발생했습니다."
//                isLoading = false
//            }
//        }
//    }
//    
    /// 플랫폼별 연결 상태 업데이트
    private func updateConnectionStatus(for platformType: SNSPlatformType, isConnected: Bool) {
        switch platformType {
        case .blog:
            naverBlogConnected = isConnected
        case .instagram:
            instagramConnected = isConnected
        case .youtube:
            youtubeConnected = isConnected
        case .tiktok:
            tiktokConnected = isConnected
        default:
            break
        }
    }
    
    /// 특정 플랫폼의 연결 상태 반환
    func isConnected(for platformType: SNSPlatformType) -> Bool {
        switch platformType {
        case .blog:
            return naverBlogConnected
        case .instagram:
            return instagramConnected
        case .youtube:
            return youtubeConnected
        case .tiktok:
            return tiktokConnected
        default:
            return false
        }
    }
    
    /// 특정 플랫폼의 URL 반환 (임시 구현)
    func getURL(for platformType: SNSPlatformType) -> String? {
        guard isConnected(for: platformType) else { return nil }
        
        switch platformType {
        case .blog:
            return "https://blog.naver.com/example"
        case .instagram:
            return "https://www.instagram.com/example"
        case .youtube:
            return "https://www.youtube.com/channel/example"
        case .tiktok:
            return "https://www.tiktok.com/@example"
        default:
            return nil
        }
    }
}
