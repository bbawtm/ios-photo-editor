//
//  EditorView.swift
//  ios-photo-editor
//
//  Created by Vadim Popov on 27.12.2022.
//

import SwiftUI


struct EditorView: View {
    
    @State private var pickedColor = Color.white
    @State private var toolType: ToolType = .draw
    @State private var selectedDrawTool: Int?
    @State private var canvasSize: CGSize?
    @State private var drawnLines: [Line] = []
    
    var body: some View {
        NavigationView {
            Group {
                ZoomableImageView()
                    .overlay {
                        DrawCanvas(lines: $drawnLines, selectedColor: $pickedColor, canvasSize: $canvasSize)
                    }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
                .overlay {
                    HStack {
                        VStack {
                            Spacer()
                            ColorPicker("Choose color", selection: $pickedColor)
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
                                AllToolsView(selectedDrawTool: $selectedDrawTool)
                                    .visibility(toolType == .draw)
                                TextToolView()
                                    .visibility(toolType == .text)
                                    .padding(.bottom, 50)
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
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            // Undo action
                            _ = self.drawnLines.popLast()
                        } label: {
                            Image(systemName: "arrow.uturn.backward")
                                .foregroundColor(.white)
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Clear all") {
                            // Clear all action
                            self.drawnLines = []
                        }
                        .foregroundColor(.white)
                    }
                }
        }
    }
    
    @MainActor
    private func saveImage() {
        guard let originUIImage = UIImage(named: "ExampleMain1") else { return }
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
    
}

struct EditorView_Previews: PreviewProvider {
    static var previews: some View {
        EditorView()
            .preferredColorScheme(.dark)
    }
}

extension View {
    
    public func addCircle(_ content: Color, width: CGFloat = 1, cornerRadius: CGFloat) -> some View {
        let roundedRect = Circle()
        return clipShape(roundedRect)
            .overlay(roundedRect.strokeBorder(content, lineWidth: width))
    }
    
    @ViewBuilder
    func visibility(_ visibility: Bool) -> some View {
        if visibility {
            self
        }
    }
    
}

struct Blur: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemMaterial

    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}

struct BackdropView: UIViewRepresentable {

    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView()
        let blur = UIBlurEffect(style: .extraLight)
        let animator = UIViewPropertyAnimator()
        animator.addAnimations { view.effect = blur }
        animator.fractionComplete = 0
        animator.stopAnimation(true)
        animator.finishAnimation(at: .start)
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) { }
    
}

struct BackdropBlurView: View {
    
    let radius: CGFloat
    
    var body: some View {
        BackdropView().blur(radius: radius)
    }
    
}
