import SwiftUI

struct CDCampaignPopup: View {
    let campaigns: [CampaignStatusPopupItem]
    let onConfirm: () -> Void
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
            Image("close_white_big")
            
            VStack(alignment: .leading, spacing: 0) {
                Text("선정 여부를 확인해 보세요!")
                    .font(.t2)
                    .foregroundStyle(.gray9)
                    .padding(.bottom, 10)
                
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 20) {
                        ForEach(campaigns) { campaign in
                            campaignRow(campaign)
                        }
                    }
                    .padding(.vertical, 10)
                }
                .frame(height: 296)
                .padding(.bottom, 16)
                
                CDButton(text: "확인하러 가기"){ onConfirm() }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
            .background(.pBeige, in: RoundedRectangle(cornerRadius: 8))
        }
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    private func campaignRow(_ campaign: CampaignStatusPopupItem) -> some View {
        HStack(alignment: .center, spacing: 12) {
            AsyncImage(url: URL(string: campaign.imageUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(1, contentMode: .fill)
            } placeholder: {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray2)
            }
            .frame(width: 80, height: 80)
            .cornerRadius(4)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(campaign.reviewerAnnouncementStatus)
                    .font(.m5b)
                    .foregroundStyle(.mPink3)
                
                Text(campaign.title)
                    .font(.m5b)
                    .foregroundStyle(.gray9)
                    .lineLimit(2)
                
                Text(campaign.benefit)
                    .font(.m5r)
                    .foregroundStyle(.gray9)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
