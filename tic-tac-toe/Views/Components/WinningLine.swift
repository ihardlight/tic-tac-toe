import SwiftUI

struct WinningLine: Shape {
    let gridSize: Int
    let start: (Int, Int)
    let end: (Int, Int)

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let size = min(rect.width, rect.height)
        let offset = abs(rect.width - rect.height) / CGFloat(gridSize)
        
        // Преобразуем клеточные индексы в координаты для начала и конца линии
        let startX = CGFloat(start.1) * size / CGFloat(gridSize) + rect.width / CGFloat(gridSize) / 2
        let startY = CGFloat(start.0) * size / CGFloat(gridSize) + rect.height / CGFloat(gridSize) / 2 + offset
        let endX = CGFloat(end.1) * size / CGFloat(gridSize) + rect.width / CGFloat(gridSize) / 2
        let endY = CGFloat(end.0) * size / CGFloat(gridSize) + rect.height / CGFloat(gridSize) / 2 + offset

        // Рисуем линию от start до end
        path.move(to: CGPoint(x: startX, y: startY))
        path.addLine(to: CGPoint(x: endX, y: endY))

        return path
    }
}
