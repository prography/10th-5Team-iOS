import Foundation

class NoticeBoardRepository {
    private let networkAPI: NetworkAPI
    
    init(networkAPI: NetworkAPI = NetworkAPI()) {
        self.networkAPI = networkAPI
    }
    
    func getNoticeBoard(page: Int = 0, size: Int = 20) async throws -> APIResponse<PageableResponse<NoticeBoardDTO>> {
        let query: [String: String] = [
            "page": String(page),
            "size": String(size),
            "sort": "updatedAt,desc"
        ]
        
        do {
            return try await networkAPI.request(
                NoticeBoardEndpoint.getNoticeBoard,
                queryParameters: query
            )
        } catch {
            print("NoticeBoardRepository Error: \(error)")
            throw error
        }
    }
    
    func getNoticeBoardDetail(id: Int) async throws -> APIResponse<NoticeBoardDTO> {
        do {
            return try await networkAPI.request(
                NoticeBoardEndpoint.getNoticeBoardDetail(id: id)
            )
        } catch {
            print("NoticeBoardRepository Detail Error: \(error)")
            throw error
        }
    }
    
    func getNoticeBoardBanner() async throws -> APIResponse<[NoticeBoardBannerDTO]> {
        do {
            return try await networkAPI.request(NoticeBoardEndpoint.getNoticeBoardBanner)
        } catch {
            print("NoticeBoardRepository Banner Error: \(error)")
            throw error
        }
    }
    
    func toggleEmpathy(id: Int, isEmpathy: Bool) async throws -> APIResponse<NoticeBoardDTO> {
        let query = ["isEmpathy": String(isEmpathy)]
        
        do {
            return try await networkAPI.request(
                NoticeBoardEndpoint.toggleEmpathy(id: id),
                queryParameters: query
            )
        } catch {
            print("NoticeBoardRepository Empathy Error: \(error)")
            throw error
        }
    }
}
