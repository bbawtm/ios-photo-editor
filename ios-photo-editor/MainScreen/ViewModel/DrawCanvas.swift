//
//  DrawCanvas.swift
//  ios-photo-editor
//
//  Created by Vadim Popov on 05.01.2023.
//

import SwiftUI


struct Line {
    var points: [CGPoint]
    var color: Color
}

struct DrawCanvas: View {
    
    @Binding var lines: [Line]
    @Binding var selectedColor: Color
    @Binding var canvasSize: CGSize?
    
    var body: some View {
        Canvas { context, size in
            self.canvasSize = size
            for line in self.lines {
                var path = Path()
                path.addLines(line.points)
                context.stroke(path, with: .color(line.color), style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
            }
        }
        .gesture(
            DragGesture(minimumDistance: 0, coordinateSpace: .local)
                .onChanged { value in
                    let position = value.location
                    
                    if value.translation == .zero {
                        lines.append(Line(points: [position], color: selectedColor))
                    } else {
                        guard let lastIdx = lines.indices.last else { return }
                        
                        lines[lastIdx].points.append(position)
                    }
                }
        )
    }
    
}
