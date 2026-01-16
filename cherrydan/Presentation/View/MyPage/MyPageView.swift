import SwiftUI

struct MyPageView: View {
    @EnvironmentObject var router: MyPageRouter
    @StateObject private var viewModel = MyPageViewModel()
    
    private var currentAppVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.1.0"
    }
    
    var body: some View {
        CDScreen(horizontalPadding: 0) {
            CDHeaderWithLeftContent {
                Text("마이페이지")
                    .font(.t1)
                    .foregroundStyle(.gray9)
            }
            .padding(.horizontal, 16)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    profileSection
                    menuSection
                    bottomButtonSection
                }
                .padding(.top, 24)
                .padding(.bottom, 120)
                .padding(.horizontal, 16)
            }
            
            Spacer()
        }
    }
    
    private var profileSection: some View {
        HStack(alignment: .center){
            Text("\(viewModel.user.name)님 안녕하세요")
                .font(.t4)
                .foregroundStyle(.gray9)
            
            Spacer()
        }
        .frame(height: 120)
        .padding(.leading, 12)
        .background(.pBeige, in: RoundedRectangle(cornerRadius: 4))
    }
    
    private var menuSection: some View {
        VStack(alignment: .leading, spacing: 0) {
//            Text("내 정보 관리")
//                .foregroundStyle(.mPink2)
//                .font(.m5b)
//            
//            if let user = viewModel.user {
//                Text(user.name)
//            }
//            
//            menuItem("내 정보") {
//                router.push(to: .profileSetting)
//            }
//            menuItem("SNS 연결") {
//                router.push(to: .manageSNS)
//            }
//            menuItem("체험단 연결"){
//                router.push(to: .mediaConnect)
//            }
//            
//            Divider()
//                .padding(.top, 4)
//                .padding(.bottom, 16)
//            
//            Text("환경 설정")
//                .foregroundStyle(.mPink2)
//                .font(.m5b)
//            
//            menuItem("알림 설정") {
//                
//            }
            
//            Divider()
//                .padding(.top, 4)
//                .padding(.bottom, 16)
            
            Text("고객 센터")
                .foregroundStyle(.mPink2)
                .font(.m5b)
            
            HStack {
                Text("버전 정보")
                    .font(.m3r)
                    .foregroundStyle(.gray9)
                
                Spacer()
                
                Text(currentAppVersion)
                    .font(.m3b)
                    .foregroundStyle(.gray5)
            }
            .padding(.vertical, 8)
            
            menuItem("개인정보 처리방침") {
                router.push(to: .myPageDetail(type: .privacyPolicy))
            }
            
            menuItem("이용약관") {
                router.push(to: .myPageDetail(type: .termsOfService))
            }
            
            menuItem("운영정책") {
                router.push(to: .myPageDetail(type: .operationalPolicy))
            }
            
            menuItem("버그제보 및 문의하기") {
                router.push(to: .myPageDetail(type: .feedback))
            }
        }
    }
    
    private var bottomButtonSection: some View {
        HStack(spacing: 8) {
            Spacer()
            
            Button(action: {
                router.push(to: .withdrawal)
            }) {
                Text("회원 탈퇴")
                    .font(.m5r)
                    .foregroundStyle(.gray5)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(.gray1)
                    .cornerRadius(2)
            }
            
            Button(action: {
                AuthManager.shared.logout()
            }) {
                Text("로그아웃")
                    .font(.m5r)
                    .foregroundStyle(.gray5)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(.gray1)
                    .cornerRadius(2)
            }
        }
    }
    
    private func menuItem(
        _ title: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Text(title)
                .font(.m3r)
                .foregroundStyle(.gray9)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    MyPageView()
        .environmentObject(MyPageRouter())
}
