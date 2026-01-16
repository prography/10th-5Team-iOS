import SwiftUI
import Kingfisher

struct MyCampaignRow: View {
    let myCampaign: MyCampaign
    let buttonConfigs: [ButtonConfig]
    let onDetailTap: () -> Void

    @State private var didFailToLoadThumbnailImage: Bool = false

    init(
        myCampaign: MyCampaign,
        buttonConfigs: [ButtonConfig] = [],
        onDetailTap: @escaping () -> Void = {}
    ) {
        self.myCampaign = myCampaign
        self.buttonConfigs = buttonConfigs
        self.onDetailTap = onDetailTap
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 4) {
                thumbnailSection
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(myCampaign.reviewerAnnouncementStatus)
                        .font(.m5b)
                        .foregroundStyle(.mPink3)
                    
                    campaignTextSection
                    platformListSection
                }
                
                Spacer()
                
                
                Button(action: onDetailTap) {
                    Image("detail")
                        .frame(width: 24, height: 24)
                }
                .padding(.top, 4)
            }
            
            if !buttonConfigs.isEmpty {
                HStack(spacing: 8) {
                    ForEach(Array(buttonConfigs.enumerated()), id: \.offset) { index, config in
                        CDButton(
                            text: config.text,
                            type: config.type,
                            isDisabled: config.disabled,
                            action: config.onClick
                        )
                    }
                }
            }
        }
    }
    
    private var thumbnailSection: some View {
        Group {
            if didFailToLoadThumbnailImage {
                Image("placeholder")
                    .resizable()
            } else {
                KFImage(URL(string: myCampaign.imageUrl))
                    .resizable()
                    .placeholder {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray.opacity(0.3))
                            .overlay(
                                ProgressView()
                            )
                    }
                    .onFailure { error in
                        print("Image loading failed: \(error)")
                        didFailToLoadThumbnailImage = true
                    }
                    .onSuccess { _ in
                        didFailToLoadThumbnailImage = false
                    }
            }
        }
        .frame(width: 100, height: 100)
        .padding(.trailing, 8)
        .cornerRadius(4)
    }
    
    private var campaignTextSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(myCampaign.title)
                .font(.m5b)
                .foregroundStyle(.gray9)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            
            Text(myCampaign.benefit)
                .font(.m5r)
                .foregroundStyle(.gray9)
                .lineLimit(1)
            
            (
                Text("신청 \(myCampaign.applicantCount)/")
                    .foregroundColor(.gray9)
                +
                Text("\(myCampaign.recruitCount)명")
                    .foregroundColor(.gray4)
            )
            .font(.m5r)
        }
    }
    
    private var platformListSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(myCampaign.snsPlatforms.prefix(2), id: \.self) { platform in
                HStack(spacing: 4) {
                    if !platform.imageName.isEmpty {
                        Image(platform.imageName)
                    }
                    
                    Text(platform.displayName)
                        .font(.m5r)
                        .foregroundStyle(.gray9)
                }
            }
            
            HStack(spacing: 4) {
                KFImage(URL(string: myCampaign.campaignPlatformImageUrl))
                    .resizable()
                    .onFailure { error in
                        print("Image loading failed: \(error)")
                    }
                    .frame(width: 16, height: 16)
                    .cornerRadius(4)
                
                Text(myCampaign.campaignSite)
                    .font(.m5r)
                    .foregroundStyle(.gray9)
            }
        }
    }
}
