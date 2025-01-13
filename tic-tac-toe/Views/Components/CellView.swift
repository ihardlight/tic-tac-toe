import SwiftUI

struct CellView: View {
    let content: String
    let foregroundColor: Color?
    let fontSize: CGFloat
    let cellSize: CGFloat
    let disabled: Bool
    let onAction: () -> Void
    
    var body: some View {
        Button(action: onAction) {
            Text(content)
                .font(.system(size: fontSize))
                .frame(maxWidth: cellSize, maxHeight: cellSize)
                .aspectRatio(1, contentMode: .fit)
                .background(Color(UIColor.systemGray5))
                .cornerRadius(10)
                .foregroundColor(foregroundColor ?? .gray)
        }
        .disabled(disabled)
    }
}

#Preview {
    CellView(content: "X", foregroundColor: .red, fontSize: 50, cellSize: UIScreen.main.bounds.width * 0.3, disabled: false, onAction: {})
}
