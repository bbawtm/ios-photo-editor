//
//  CanvasToDraw.swift
//  ios-photo-editor
//
//  Created by Vadim Popov on 08.01.2023.
//

import SwiftUI


struct CanvasToDraw: View {
    
    @Binding var toolType: ToolType
    @Binding var selectedDrawTool: Int?
    @Binding var canvasSize: CGSize?
    @Binding var drawnLines: [Line]
    @Binding var currentColor: Color
    
    var body: some View {
        Canvas { context, size in
            self.canvasSize = size
            for line in self.drawnLines {
                var path = Path()
                path.addLines(line.points)
                context.stroke(path, with: .color(line.color), style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
            }
        }.if(self.toolType != .draw || self.selectedDrawTool != nil) {
            $0.gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged { value in
                        let position = value.location

                        if value.translation == .zero {
                            self.drawnLines.append(Line(points: [position], color: currentColor))
                        } else {
                            guard let lastIdx = self.drawnLines.indices.last else { return }

                            self.drawnLines[lastIdx].points.append(position)
                        }
                    }
            )
        }
    }
    
}
