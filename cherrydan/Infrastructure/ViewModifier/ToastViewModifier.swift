import SwiftUI

extension View {
    func presentToast(isPresented: Binding<Bool>, data: ToastType?) -> some View {
        return modifier(ToastViewModifier(isPresented: isPresented, toastType: data))
    }
}

struct ToastViewModifier: ViewModifier {
    @Binding var isPresented: Bool
    @State private var isAnimating: Bool = false
    
    let toastType: ToastType?
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottom) {
                if isPresented, let toastType {
                    CDToast(toastType: toastType)
                        .padding(.bottom, 40)
                        .padding(.horizontal, 16)
                        .opacity(isAnimating ? 1 : 0)
                        .offset(y: isAnimating ? 0 : -80)
                        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: isAnimating)
                        .onAppear {
                            withAnimation { isAnimating = true }
                            
                            withAnimation(.spring.delay(2)) {
                                isAnimating = false
                                isPresented = false
                            }
                        }
                }
            }
    }
}
