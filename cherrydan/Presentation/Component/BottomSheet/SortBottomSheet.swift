import SwiftUI

struct SortBottomSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var isPresented: Bool
    @Binding var selectedSortType: SortType
    let onSortTypeSelected: (SortType) -> Void
    
    private let sortTypes: [SortType] = [.popular, .latest, .deadline, .lowCompetition]
    
    var body: some View {
        CDBottomSheet(type: .titleLeading(title: "정렬", buttonConfig: nil)) {
            VStack(spacing: 4) {
                ForEach(sortTypes, id: \.self) { sortType in
                    sortOptionRow(sortType)
                }
            }
        }
    }
    
    private func sortOptionRow(_ sortType: SortType) -> some View {
        Button(action: {
            onSortTypeSelected(sortType)
            dismiss()
        }) {
            HStack(spacing: 0) {
                Image("check_circle\(selectedSortType == sortType ? "_filled" : "_empty")")
                
                Text(sortType.displayName)
                    .font(.m4r)
                    .foregroundStyle(.gray9)
                
                Spacer()
            }
            .padding(.vertical, 8)
        }
    }
}

// RoundedRectangle corner extension
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    SortBottomSheet(
        isPresented: .constant(true),
        selectedSortType: .constant(.popular),
        onSortTypeSelected: { _ in }
    )
} 
