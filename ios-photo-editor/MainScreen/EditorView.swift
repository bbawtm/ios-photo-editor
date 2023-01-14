//
//  EditorView.swift
//  ios-photo-editor
//
//  Created by Vadim Popov on 27.12.2022.
//

import SwiftUI


struct EditorView: View {
    
    @EnvironmentObject var userData: UserData
    @StateObject private var colorSet = ColorSet(default: .cyan)
    @State private var toolType: ToolType = .draw
    @State private var selectedDrawTool: Int?
    @State private var canvasSize: CGSize?
    @State private var drawnLines: [Line] = []
    
    var editorTools: some View {
        HStack {
            VStack {
                Spacer()
                ColorPicker("Choose color", selection: getCurrentColorSetBinding())
                    .labelsHidden()
                    .frame(width: 30)
                    .padding(.bottom, 10.0)
                Button {
                    // Cancel action
                    selectedDrawTool = nil
                } label: {
                    Image("cancelToolBar")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30)
                        
                }
                .opacity(toolType == .draw && selectedDrawTool != nil ? 1 : 0.4)
                .disabled(toolType != .draw || selectedDrawTool == nil)
            }
            VStack {
                Spacer()
                HStack {
                    if toolType == .draw {
                        AllToolsView(toolType: $toolType, selectedDrawTool: $selectedDrawTool, colorSet: colorSet)
                    } else {
                        TextToolView()
                            .padding(.bottom, 50)
                    }
                }
                .padding(.bottom, -15)
                .padding(.top, 35)
                .mask {
                    Rectangle()
                        .frame(width: 1000, height: 100)
                }
                Picker("", selection: $toolType) {
                    Text("Draw")
                        .tag(ToolType.draw)
                    Text("Text")
                        .tag(ToolType.text)
                }
                .pickerStyle(.segmented)
                .background {
                    BackdropBlurView(radius: 3)
                        .frame(height: 35)
                        .padding(.top, -5)
                }
                .padding(.top, -20)
                .padding(.trailing, 20)
                .padding(.leading, 20)
            }
            VStack {
                Spacer()
                Button {
                    print("Show tool info action")
                } label: {
                    Image("addToolBar")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30)
                        .background(Blur(style: .systemUltraThinMaterial))
                        .cornerRadius(50)
                        .padding(.bottom, 10.0)
                }
                Button {
                    // Save image action
                    saveImage()
                } label: {
                    Image("downloadToolBar")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30)
                }
            }
        }
        .padding(.leading, 8)
        .padding(.trailing, 8)
    }
    
    var drawableImage: some View {
        Zoomable(zoomRange: userData.imageScreenScale...(userData.imageScreenScale * 3)) {
            Image(uiImage: userData.image)
                .resizable()
                .scaledToFill()
                .overlay {
                    CanvasToDraw(
                        toolType: $toolType,
                        selectedDrawTool: $selectedDrawTool,
                        canvasSize: $canvasSize,
                        drawnLines: $drawnLines,
                        colorSet: colorSet
                    )
                }
        }
        .clipped()
        .frame(maxWidth: UIScreen.main.bounds.size.width, maxHeight: UIScreen.main.bounds.size.height)
        .ignoresSafeArea()
    }
        
    var body: some View {
        NavigationView {
            drawableImage
                .overlay {
                    editorTools
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            _ = self.drawnLines.popLast()
                        } label: {
                            Image(systemName: "arrow.uturn.backward")
                                .foregroundColor(.white)
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Clear all") {
                            self.drawnLines = []
                        }
                        .foregroundColor(.white)
                    }
                }
        }
    }
    
    @MainActor
    private func saveImage() {
        let originUIImage = userData.image
        let originSize = originUIImage.size
        
        let drawnLines = self.drawnLines                                                   // bug if delete this line
        let scale = 1.0 * originSize.width / (self.canvasSize?.width ?? originSize.width)  // bug if delete this line
        
        let canvasImage = Image(size: originSize) { context in
            for line in drawnLines {
                var path = Path()
                let affineStretched = line.points.map { element in
                    element.applying(CGAffineTransform(scaleX: scale, y: scale))
                }
                path.addLines(affineStretched)
                context.stroke(path, with: .color(line.color), style: StrokeStyle(lineWidth: 5 * scale, lineCap: .round, lineJoin: .round))
            }
        }
        let combinedView = ZStack {
            Image(uiImage: originUIImage)
            canvasImage
        }
        let rendererCombined = ImageRenderer(content: combinedView)
        guard let resultUiImage = rendererCombined.uiImage else { return }
        
        UIImageWriteToSavedPhotosAlbum(resultUiImage, nil, nil, nil)
    }
    
    private func getCurrentColorSetBinding() -> Binding<Color> {
        if toolType == .text {
            return $colorSet.text
        }
        switch selectedDrawTool {
            case 0:
                return $colorSet.pen
            case 1:
                return $colorSet.brush
            case 2:
                return $colorSet.neon
            case 3:
                return $colorSet.pencil
            default:
                return Binding(get: {
                    Color(cgColor: CGColor(gray: 0, alpha: 0))
                }, set: { _ in })
        }
    }
    
}

extension View {
    public func addCircle(_ content: Color, width: CGFloat = 1, cornerRadius: CGFloat) -> some View {
        let roundedRect = Circle()
        return clipShape(roundedRect)
            .overlay(roundedRect.strokeBorder(content, lineWidth: width))
    }
}

struct Line {
    var points: [CGPoint]
    var color: Color
}
