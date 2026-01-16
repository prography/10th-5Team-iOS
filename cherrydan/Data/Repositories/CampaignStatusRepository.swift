import Foundation

class CampaignStatusRepository {
    private let networkAPI: NetworkAPI
    
    init(networkAPI: NetworkAPI = NetworkAPI()) {
        self.networkAPI = networkAPI
    }
    
    func getMyCampaings(for subFilter: CampaignSubFilter, page: Int = 0) async throws -> PageableResponse<MyCampaignDTO> {
        let query: [String:String] = [
            "case": subFilter.rawValue,
            "page": String(page),
            "size": "20"
        ]
        let response: APIResponse<PageableResponse<MyCampaignDTO>> = try await networkAPI.request(
            CampaignStatusEndpoint.getMyCampaigns,
            queryParameters: query
        )
        return response.result
    }
    
    func createOrRecoverStatus(request: CampaignStatusRequestDTO) async throws -> MyCampaignDTO {
        let param: [String: Any] = [
            "campaignId": request.campaignId,
            "status": "\(request.status)",
            "isActive" : true
        ]
        
        let response: APIResponse<MyCampaignDTO> = try await networkAPI.request(CampaignStatusEndpoint.createOrRecoverStatus, parameters: param)
        return response.result
    }
    
    func updateStatus(request: CampaignStatusRequestDTO) async throws -> MyCampaignDTO {
        let param: [String: Any] = [
            "campaignId": request.campaignId,
            "status": "\(request.status)",
            "isActive" : true
        ]
        
        let response: APIResponse<MyCampaignDTO> = try await networkAPI.request(CampaignStatusEndpoint.updateStatus, parameters: param)
        return response.result
    }
    
    func deleteStatus(_ campaignId: Int) async throws -> Void {
        let request = DeleteRequest(campaignIds: [campaignId])
        let _: APIResponse<EmptyResult> = try await networkAPI.request(CampaignStatusEndpoint.deleteStatus, parameters: request.dictionaryFormat)
    }
    
    func getPopupStatus() async throws -> CampaignStatusPopupResponseDTO {
        let response: APIResponse<CampaignStatusPopupResponseDTO> = try await networkAPI.request(CampaignStatusEndpoint.getPopupStatus)
        return response.result
    }
    
    func getCampaignStatusCount() async throws -> CampaignStatusCountDTO {
        let response: APIResponse<CampaignStatusCountDTO> = try await networkAPI.request(CampaignStatusEndpoint.getCampaignStatusCount)
        return response.result
    }
}
