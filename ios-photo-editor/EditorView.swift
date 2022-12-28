//
//  EditorView.swift
//  ios-photo-editor
//
//  Created by Vadim Popov on 27.12.2022.
//

import SwiftUI

// MARK: - Main screen

struct EditorView: View {
    
    @State private var bgColor = Color.white
    @State private var toolType = 0
    
    var body: some View {
        NavigationView {
            VStack {
                Image("ExampleMain2")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipped()
                    
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .overlay {
                HStack {
                    VStack {
                        Spacer()
                        ColorPicker("Choose color", selection: $bgColor)
                            .labelsHidden()
                            .frame(width: 30)
                            .padding(.bottom, 10.0)
                        Image("cancelToolBar")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                    }
                    VStack {
                        Spacer()
                        HStack {
                            PenToolView()
                                .padding(.trailing)
                            BrushToolView()
                                .padding(.trailing)
                            NeonToolView()
                                .padding(.trailing)
                                .padding(.top, -45)
                            PencilToolView()
                                .padding(.trailing)
                            LassoToolView()
                                .padding(.trailing)
                            EraserToolView()
                        }
                        .padding(.bottom, -15)
                        .padding(.top, 35)
                        .mask {
                            Rectangle()
                                .frame(width: 1000, height: 100)
                        }
                        Picker("", selection: $toolType) {
                            Text("Tool1")
                                .tag(0)
                            Text("Tool2")
                                .tag(1)
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
                        Image("addToolBar")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                            .background(Blur(style: .systemUltraThinMaterial))
                            .cornerRadius(50)
                            .padding(.bottom, 10.0)
                        Image("downloadToolBar")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                    }
                }
                .padding(.leading, 8)
                .padding(.trailing, 8)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        print("Undo action")
                    } label: {
                        Image(systemName: "arrow.uturn.backward")
                            .foregroundColor(.yellow)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Clear all") {
                        print("Clear all action")
                    }
                    .foregroundColor(.yellow)
                }
            }
        }
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

/// A View which content reflects all behind it
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

/// A transparent View that blurs its background
struct BackdropBlurView: View {
    
    let radius: CGFloat
    
//    @ViewBuilder
    var body: some View {
        BackdropView().blur(radius: radius)
    }
    
}

// MARK: - Tools

//struct ToolsGroupView: View {
//    var body: some View {
//        HStack {
//            PenToolView()
//            BrushToolView()
//            NeonToolView()
//            PencilToolView()
//            LassoToolView()
//            EraserToolView()
//        }
//    }
//}

protocol ToolView: View {
    
}

struct PenToolView: ToolView {
    var body: some View {
        ZStack {
            Image("penBase")
                .resizable()
                .scaledToFit()
                .frame(width: 24)
            Image("penTip")
                .resizable()
                .scaledToFit()
                .frame(width: 24)
                .colorMultiply(.cyan)
            RoundedRectangle(cornerRadius: 2, style: .continuous)
                .fill(.cyan)
                .frame(width: 20, height: 20)
                .offset (x: 0, y: 6)
        }
    }
}

struct BrushToolView: ToolView {
    var body: some View {
        ZStack {
            Image("brushBase")
                .resizable()
                .scaledToFit()
                .frame(width: 24)
            Image("brushTip")
                .resizable()
                .scaledToFit()
                .frame(width: 24)
                .colorMultiply(.cyan)
            RoundedRectangle(cornerRadius: 2, style: .continuous)
                .fill(.cyan)
                .frame(width: 20, height: 20)
                .offset (x: 0, y: -5)
        }
    }
}

struct NeonToolView: ToolView {
    var body: some View {
        ZStack {
            Image("neonBase")
                .resizable()
                .scaledToFit()
                .frame(width: 24)
            Image("neonTip")
                .resizable()
                .scaledToFit()
                .frame(width: 24)
                .colorMultiply(.cyan)
            RoundedRectangle(cornerRadius: 2, style: .continuous)
                .fill(.cyan)
                .frame(width: 20, height: 20)
                .offset (x: 0, y: -5)
        }
    }
}

struct PencilToolView: ToolView {
    var body: some View {
        ZStack {
            Image("pencilBase")
                .resizable()
                .scaledToFit()
                .frame(width: 24)
            Image("pencilTip")
                .resizable()
                .scaledToFit()
                .frame(width: 24)
                .colorMultiply(.cyan)
            RoundedRectangle(cornerRadius: 2, style: .continuous)
                .fill(.cyan)
                .frame(width: 20, height: 20)
                .offset (x: 0, y: 0)
        }
    }
}

struct LassoToolView: ToolView {
    var body: some View {
        ZStack {
            Image("lassoBase")
                .resizable()
                .scaledToFit()
                .frame(width: 24)
        }
    }
}

struct EraserToolView: ToolView {
    var body: some View {
        ZStack {
            Image("objectEraserBase")
                .resizable()
                .scaledToFit()
                .frame(width: 24)
        }
    }
}
