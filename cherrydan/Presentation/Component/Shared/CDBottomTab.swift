import SwiftUI

struct CDBottomTab: View {
    @Binding var selectedTab: Int
    
    let tabBarText = [
//        ("category","카테고리"),
//        ("notice_board","체리단 소식"),
        ("home","홈"),
        ("my_campaign","나의 공고"),
        ("my","마이페이지")
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(.pBeige)
                .frame(height:2)
            
            HStack(alignment: .center, spacing: 0) {
                ForEach(0..<tabBarText.count, id: \.self) { index in
                    let isFocused = selectedTab == index
                    
                    Button(action: {
                        if AuthManager.shared.isGuestMode, index != 0 {
                            PopupManager.shared.show(.loginNeeded(onClick: {
                                AuthManager.shared.leaveGuestMode()
                            }))
                        } else {
                            selectedTab = index
                        }
                    } ) {
                        VStack(spacing: 4) {
                            Image("\(tabBarText[index].0)\(isFocused ? "_focused": "")")
                            
                            Text(tabBarText[index].1)
                                .font(.m6r)
                                .foregroundStyle(isFocused ? .mPink3 : .mPink1)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding(.horizontal, 20)
            .frame(height: 80)
            .background(.gray0)
        }
    }
}

#Preview {
    CDBottomTab(selectedTab: .constant(0))
}
