import SwiftUI

struct CircularTimerView: View {
    @ObservedObject var timer: GameTimer
    var duration: TimeInterval
    
    private var progress: CGFloat {
        CGFloat(timer.remainingTime / duration)
    }
    
    private var timerColor: Color {
        switch timer.remainingTime {
        case ...5:
            return .red
        case ...10:
            return .yellow
        default:
            return .green
        }
    }
    
    private var formattedTime: String {
        if timer.remainingTime <= 5 {
            return String(format: "%.2f", timer.remainingTime)
        } else {
            return "\(Int(timer.remainingTime))"
        }
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 10)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(timerColor, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.linear, value: progress)
            Text(formattedTime)
                .foregroundColor(timerColor)
        }
        .padding()
        .aspectRatio(1, contentMode: .fit)
    }
}

private func previewTimer(remainingTime: TimeInterval) -> GameTimer {
    let timer = GameTimer()
    timer.remainingTime = remainingTime
    return timer
}

#Preview("Full Time Remaining") {
    CircularTimerView(timer: previewTimer(remainingTime: 30), duration: 30)
        .frame(width: 150, height: 150)
        .font(.system(size: 40))
}

#Preview("Mid Time Remaining") {
    CircularTimerView(timer: previewTimer(remainingTime: 10), duration: 30)
        .frame(width: 150, height: 150)
        .font(.system(size: 40))
    
}

#Preview("Low Time Remaining") {
    CircularTimerView(timer: previewTimer(remainingTime: 3), duration: 30)
        .frame(width: 150, height: 150)
        .font(.system(size: 40))
}
