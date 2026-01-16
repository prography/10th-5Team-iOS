import SwiftUI

struct MyCampaignView: View {
    @EnvironmentObject private var router: MyCampaignRouter
    @StateObject private var viewModel = MyCampaignViewModel()
    
    let onNavigateToHomeTab: () -> Void
    
    var body: some View {
        ZStack {
            CDScreen(horizontalPadding: 0, isLoading: viewModel.isLoading) {
                CDHeaderWithRightContent(title: "나의 공고"){}
                    .padding(.horizontal, 16)
                
                tabSection
                    .padding(.top, 24)
                
                subFilterSection
                    .padding(.vertical, 12)
                
                campaignListSection
            }
            .sheet(
                isPresented: $viewModel.isCampaignActionSheetPresent,
                onDismiss: { viewModel.focusedCampaign = nil }
            ) {
                CampaignActionBottomSheet(
                    onDelete: {
                        guard let campaignId = viewModel.focusedCampaign?.campaignId else { return }
                        PopupManager.shared.show(.confirmCampaignDelete {
                            viewModel.deleteCampaign(campaignId: campaignId)
                        })
                    },
                    onChangeStatus: {
                        guard let campaignId = viewModel.focusedCampaign?.campaignId else { return }
                        viewModel.isCampaignActionSheetPresent = false
                        PopupManager.shared.show(.changeCampaignStatus(
                            currentStatus: viewModel.selectedSubFilter.statusType,
                            onConfirm: { status in
                                viewModel.changeCampaignStatus(campaignId: campaignId, to: status)
                            })
                        )
                    }
                )
            }
            .sheet(
                isPresented: $viewModel.isConfirmCampaignStatusSheetPresent,
                onDismiss: { viewModel.focusedCampaign = nil }
            ) {
                ConfirmCampaignStatusBottomSheet(
                    onStatusSelected: { status in
                        if let campaign = viewModel.focusedCampaign {
                            viewModel.changeCampaignStatus(campaignId: campaign.campaignId, to: status)
                        }
                    }
                )
            }
        }
    }
    
    @ViewBuilder
    private var campaignListSection: some View {
        ScrollView(.vertical, showsIndicators: false) {
            if viewModel.campaigns.isEmpty {
                openSectionPlaceholder
            } else {
                LazyVStack(spacing: 0) {
                    if [.writingReview, .writingDone].contains(viewModel.selectedCampaignStatus) {
                        Spacer().frame(height: 16)
                    }
                    
                    ForEach(Array(zip(viewModel.campaigns.indices, viewModel.campaigns)), id: \.1.id) { index, campaign in
                        VStack(spacing: 0) {
                            MyCampaignRow(
                                myCampaign: campaign,
                                buttonConfigs: viewModel.getButtonConfigs(for: campaign, router: router),
                                onDetailTap: {
                                    viewModel.focusedCampaign = campaign
                                    viewModel.isCampaignActionSheetPresent = true
                                }
                            )
                            .onAppear {
                                if index >= viewModel.campaigns.count - 5 {
                                    viewModel.loadNextPage()
                                }
                            }
                            
                            if index < viewModel.campaigns.count - 1 {
                                Divider()
                                    .padding(.vertical, 12)
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .transition(.move(edge: .leading))
    }
    
    @ViewBuilder
    private var subFilterSection: some View {
        if viewModel.subFilters.count > 1 {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(viewModel.subFilters) { subFilter in
                        let isSelected = subFilter == viewModel.selectedSubFilter
                        Button(action: {
                            viewModel.selectedSubFilter = subFilter
                        }) {
                            HStack(spacing: 4) {
                                Text(subFilter.title)
                                if let count = viewModel.getCountForSubFilter(subFilter) {
                                    Text("\(count)")
                                }
                            }
                            .font(.m5r)
                            .foregroundStyle(isSelected ? .gray0 : .gray5)
                            .padding(.horizontal, 16)
                            .frame(height: 32, alignment: .center)
                            .background(isSelected ? .gray5 : .gray2, in: RoundedRectangle(cornerRadius: 16))
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
    
    private var openSectionPlaceholder: some View {
        VStack(spacing: 12) {
            Image("logo_placeholder")
            
            Text(viewModel.emptyStateMessage)
                .font(.t3)
                .foregroundStyle(.gray9)
                .padding(.bottom, 12)
                .multilineTextAlignment(.center)
            
            CDButton(text: "공고 구경하러 가기"){
                onNavigateToHomeTab()
            }
            .frame(width: 180)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.top, 80)
    }
    
    private var tabSection: some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 24) {
                    ForEach(CampaignStatusCategory.allCases, id: \.self) { category in
                        tabItem(category)
                    }
                }
                .padding(.horizontal, 16)
            }
            
            Divider()
        }
    }
    
    @ViewBuilder
    private func tabItem(_ category: CampaignStatusCategory) -> some View {
        let isSelected = category == viewModel.selectedCampaignStatus
        Button(action: {
            viewModel.selectedCampaignStatus = category
        }) {
            VStack(spacing: 8) {
                HStack(spacing: 4) {
                    Text(category.displayText)
                        .font(.m4b)
                        .foregroundStyle(isSelected ? .mPink3 : .gray5)
                    
                    if let count = viewModel.getCountForStatus(category) {
                        Text("\(count)")
                            .font(.m4b)
                            .foregroundStyle(isSelected ? .mPink3 : .gray5)
                    }
                }
                
                Rectangle()
                    .fill(isSelected ? .mPink3 : .clear)
                    .frame(height: 2)
            }
        }
    }
}

#Preview {
    MyCampaignView(onNavigateToHomeTab: {})
        .environmentObject(MyCampaignRouter())
}
