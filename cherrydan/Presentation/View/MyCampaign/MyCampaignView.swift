import SwiftUI

struct MyCampaignView: View {
    @EnvironmentObject private var router: MyCampaignRouter
    @StateObject private var viewModel = MyCampaignViewModel()
    
    @State private var isShowingChangeStatusBottomSheet = false
    @State private var selectedStatusForChange: CampaignStatusType? = nil
    
    var body: some View {
        CDScreen(
            horizontalPadding: 0,
            isLoading: viewModel.isLoading
        ) {
            CDHeaderWithRightContent(title: "내 체험단"){
                if !viewModel.isDeleteMode {
                    Button(action: {
                        viewModel.isDeleteMode = true
                    }){
                        Image("trash")
                    }
                }
            }
            .padding(.horizontal, 16)
            
            tabSection
                .padding(.top, 24)
            
            subFilterSection
                .padding(.vertical, 12)
            
            campaignListSection
        }
        .sheet(isPresented: $isShowingChangeStatusBottomSheet) {
            ChangeCampaignStatusBottomSheet(
                isPresented: $isShowingChangeStatusBottomSheet,
                selectedStatus: $selectedStatusForChange,
                onStatusSelected: { status in
                    viewModel.updateSelectedCampaignsStatus(to: status)
                    isShowingChangeStatusBottomSheet = false
                    selectedStatusForChange = nil
                }
            )
        }
    }
    
    @ViewBuilder
    private var campaignListSection: some View {
        openSection
    }
    
    @ViewBuilder
    private var subFilterSection: some View {
        if viewModel.subFilters.count > 1 {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(viewModel.subFilters) { subFilter in
                        let isSelected = subFilter == viewModel.selectedSubFilter
                        Button(action: {
                            viewModel.selectSubFilter(subFilter)
                        }) {
                            Text(subFilter.title)
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
        Text(viewModel.emptyStateMessage)
            .font(.m4r)
            .foregroundStyle(.gray5)
            .padding(.vertical, 120)
            .frame(maxWidth: .infinity, alignment: .center)
    }
    
    private var openSection: some View {
        ScrollView(.vertical, showsIndicators: false) {
            if viewModel.campaigns.isEmpty {
                openSectionPlaceholder
            } else {
                LazyVStack(spacing: 0) {
                    ForEach(Array(zip(viewModel.campaigns.indices, viewModel.campaigns)), id: \.1.id) { index, campaign in
                        VStack(spacing: 0) {
                            MyCampaignRow(
                                myCampaign: campaign,
                                buttonConfigs: viewModel.getButtonConfigs(for: campaign, router: router),
                                isDeleteMode: viewModel.isDeleteMode,
                                isSelected: viewModel.selectedCampaignIds.contains(campaign.campaignId),
                                onSelectionToggle: {
                                    viewModel.toggleCampaignSelection(campaignId: campaign.campaignId)
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
    MyCampaignView()
} 
