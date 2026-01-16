import SwiftUI

struct NaverSNSBottomSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var blogUrl: String = ""
    @State private var verificationCode: String = "sjk43hdjk"
    
    let onConnect: (String, String) -> Void
    
    var body: some View {
        CDBottomSheet(
            type: .titleLeading(title: "네이버 연결 가이드", buttonConfig: ButtonConfig(
                text: "연동 완료",
                disabled: blogUrl.isEmpty,
                onClick: {
                    onConnect(blogUrl, verificationCode)
                    dismiss()
                }
            )),
            height: 540,
            horizontalPadding: 16
        ) {
            VStack(alignment: .leading, spacing: 20) {
                // 가이드 단계
                VStack(alignment: .leading, spacing: 12) {
                    guideStepView(number: "1.", text: "인증코드를 클립보드에 복사해 주세요.")
                    guideStepView(number: "2.", text: "연동할 네이버 블로그 소개글이나 댓글에 코드를 추가해 주세요.")
                    guideStepView(number: "3.", text: "블로그 주소를 입력 후, 연동 확인 버튼을 눌러주세요.")
                    guideStepView(number: "4.", text: "인증이 완료되면 소개글의 코드는 제거해도 됩니다.")
                }
                
                // 온라인 허가 텍스트
                HStack {
                    Text("1.1 온라인허가")
                        .font(.m5r)
                        .foregroundStyle(.red)
                    Spacer()
                }
                
                // 인증코드 섹션
                VStack(alignment: .leading, spacing: 8) {
                    Text("인증코드")
                        .font(.m4r)
                        .foregroundStyle(.gray9)
                    
                    HStack {
                        Text(verificationCode)
                            .font(.m4r)
                            .foregroundStyle(.gray9)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(.gray1, in: RoundedRectangle(cornerRadius: 4))
                        
                        CDButton(
                            text: "복사",
                            type: .middlePrimary,
                            action: {
                                UIPasteboard.general.string = verificationCode
                            }
                        )
                        .frame(width: 60)
                    }
                }
                
                // 블로그 주소 섹션
                VStack(alignment: .leading, spacing: 8) {
                    Text("블로그 주소")
                        .font(.m4r)
                        .foregroundStyle(.gray9)
                    
                    TextField("블로그 주소 url을 입력해 주세요", text: $blogUrl)
                        .font(.m4r)
                        .foregroundStyle(.gray9)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(.gray1, in: RoundedRectangle(cornerRadius: 4))
                        .textInputAutocapitalization(.never)
                        .keyboardType(.URL)
                }
                
                Spacer()
            }
        }
    }
    
    private func guideStepView(number: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text(number)
                .font(.m4r)
                .foregroundStyle(.gray9)
                .frame(width: 20, alignment: .leading)
            
            Text(text)
                .font(.m4r)
                .foregroundStyle(.gray9)
                .multilineTextAlignment(.leading)
            
            Spacer()
        }
    }
}

#Preview {
    NaverSNSBottomSheet(onConnect: { _, _ in })
}
