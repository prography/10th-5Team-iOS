import Foundation

struct NaverVerifyRequestDTO: Codable {
    let code: String
    let blogUrl: String
    
    enum CodingKeys: String, CodingKey {
        case code
        case blogUrl
    }
}

struct NaverVerifyResponseDTO: Codable {
    let success: Bool
    let message: String?
    let verificationCode: String?
    
    enum CodingKeys: String, CodingKey {
        case success
        case message
        case verificationCode = "verification_code"
    }
}

struct OAuthAuthUrlResponseDTO: Codable {
    let authUrl: String
    let state: String?
    
    enum CodingKeys: String, CodingKey {
        case authUrl = "auth_url"
        case state
    }
}

struct OAuthCallbackResponseDTO: Codable {
    let success: Bool
    let message: String?
    let accessToken: String?
    let userInfo: OAuthUserInfoDTO?
    
    enum CodingKeys: String, CodingKey {
        case success
        case message
        case accessToken = "access_token"
        case userInfo = "user_info"
    }
}

struct OAuthUserInfoDTO: Codable {
    let username: String?
    let profileUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case username
        case profileUrl = "profile_url"
    }
} 
