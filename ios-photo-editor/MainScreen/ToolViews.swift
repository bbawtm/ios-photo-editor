//
//  ToolViews.swift
//  ios-photo-editor
//
//  Created by Vadim Popov on 28.12.2022.
//

import SwiftUI


// MARK: - common views

struct AllToolsView: View {
    
    @Binding var toolType: ToolType
    @Binding var selectedDrawTool: Int?
    @ObservedObject var colorSet: ColorSet
    @ObservedObject var widthSet: WidthSet
    
    var body: some View {
        PenToolView(
            selectedDrawTool: $selectedDrawTool,
            selectedColor: $colorSet.pen,
            selectedWidth: $widthSet.pen
        )
        .padding(.trailing)
        BrushToolView(
            selectedDrawTool: $selectedDrawTool,
            selectedColor: $colorSet.brush,
            selectedWidth: $widthSet.brush
        )
        .padding(.trailing)
        NeonToolView(
            selectedDrawTool: $selectedDrawTool,
            selectedColor: $colorSet.neon,
            selectedWidth: $widthSet.neon
        )
        .padding(.trailing)
        PencilToolView(
            selectedDrawTool: $selectedDrawTool,
            selectedColor: $colorSet.pencil,
            selectedWidth: $widthSet.pencil
        )
        .padding(.trailing)
        LassoToolView(
            selectedDrawTool: $selectedDrawTool
        )
        .padding(.trailing)
        EraserToolView(
            selectedDrawTool: $selectedDrawTool
        )
    }
}

struct TextToolView: View {
    var body: some View {
        Button {
            print("Add text on screen")
        } label: {
            Text("Add text")
        }
        .foregroundColor(.white)
        .padding(.leading)
        .padding(.trailing)
        .padding(.top, 8)
        .padding(.bottom, 8)
        .overlay {
            RoundedRectangle(cornerRadius: 100)
                .stroke(.white, lineWidth: 1)
        }
        .cornerRadius(100)
    }
}

enum ToolType {
    case draw, text
}

class ColorSet: ObservableObject {
    
    @Published var pen: Color
    @Published var brush: Color
    @Published var neon: Color
    @Published var pencil: Color
    @Published var text: Color
    
    init(default c: Color) {
        self.pen = c
        self.brush = c
        self.neon = c
        self.pencil = c
        self.text = .black
    }
    
    func current(_ toolType: ToolType, _ selectedDrawTool: Int?) -> Color {
        if toolType == .text {
            return text
        }
        switch selectedDrawTool {
            case 0:
                return pen
            case 1:
                return brush
            case 2:
                return neon
            case 3:
                return pencil
            default:
                return Color(cgColor: CGColor(gray: 0, alpha: 0))
        }
    }
    
}

class WidthSet: ObservableObject {
    
    @Published var pen: CGFloat
    @Published var brush: CGFloat
    @Published var neon: CGFloat
    @Published var pencil: CGFloat
    @Published var text: CGFloat
    
    let minLineWidth: CGFloat = 20
    let maxLineWidth: CGFloat = 200
    
    init(default c: CGFloat) {
        self.pen = c
        self.brush = c
        self.neon = c
        self.pencil = c
        self.text = 14
    }
    
    func current(_ toolType: ToolType, _ selectedDrawTool: Int?) -> CGFloat {
        if toolType == .text {
            return text
        }
        switch selectedDrawTool {
            case 0:
                return pen
            case 1:
                return brush
            case 2:
                return neon
            case 3:
                return pencil
            default:
                return 15
        }
    }
    
}

// MARK: - each tool view

protocol ToolView: View {
    var selectedDrawTool: Int? { get set }
}

struct PenToolView: ToolView {
    @Binding var selectedDrawTool: Int?
    @Binding var selectedColor: Color
    @Binding var selectedWidth: CGFloat
    
    var body: some View {
        Button {
            selectedDrawTool = 0
        } label: {
            ZStack {
                Image("penBase")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24)
                Image("penTip")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24)
                    .colorMultiply(selectedColor)
                RoundedRectangle(cornerRadius: 2, style: .continuous)
                    .fill(selectedColor)
                    .frame(width: 20, height: 0.1 * selectedWidth)
                    .offset (x: 0, y: 6 - (20.0 - 0.1 * selectedWidth) / 2.0)
            }
            .padding(.top, selectedDrawTool == 0 ? -45 : 0)
        }
    }
}

struct BrushToolView: ToolView {
    @Binding var selectedDrawTool: Int?
    @Binding var selectedColor: Color
    @Binding var selectedWidth: CGFloat
    
    var body: some View {
        Button {
            selectedDrawTool = 1
        } label: {
            ZStack {
                Image("brushBase")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24)
                Image("brushTip")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24)
                    .colorMultiply(selectedColor)
                RoundedRectangle(cornerRadius: 2, style: .continuous)
                    .fill(selectedColor)
                    .frame(width: 20, height: 0.1 * selectedWidth)
                    .offset (x: 0, y: -5 - (20.0 - 0.1 * selectedWidth) / 2.0)
            }
            .padding(.top, selectedDrawTool == 1 ? -45 : 0)
        }
    }
}

struct NeonToolView: ToolView {
    @Binding var selectedDrawTool: Int?
    @Binding var selectedColor: Color
    @Binding var selectedWidth: CGFloat
    
    var body: some View {
        Button {
            selectedDrawTool = 2
        } label: {
            ZStack {
                Image("neonBase")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24)
                Image("neonTip")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24)
                    .colorMultiply(selectedColor)
                RoundedRectangle(cornerRadius: 2, style: .continuous)
                    .fill(selectedColor)
                    .frame(width: 20, height: 0.1 * selectedWidth)
                    .offset (x: 0, y: -5 - (20.0 - 0.1 * selectedWidth) / 2.0)
            }
            .padding(.top, selectedDrawTool == 2 ? -45 : 0)
        }
    }
}

struct PencilToolView: ToolView {
    @Binding var selectedDrawTool: Int?
    @Binding var selectedColor: Color
    @Binding var selectedWidth: CGFloat
    
    var body: some View {
        Button {
            selectedDrawTool = 3
        } label: {
            ZStack {
                Image("pencilBase")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24)
                Image("pencilTip")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24)
                    .colorMultiply(selectedColor)
                RoundedRectangle(cornerRadius: 2, style: .continuous)
                    .fill(selectedColor)
                    .frame(width: 20, height: 0.1 * selectedWidth)
                    .offset (x: 0, y: -(20.0 - 0.1 * selectedWidth) / 2.0)
            }
            .padding(.top, selectedDrawTool == 3 ? -45 : 0)
        }
    }
}

struct LassoToolView: ToolView {
    @Binding var selectedDrawTool: Int?
    
    var body: some View {
        Button {
            selectedDrawTool = 4
        } label: {
            ZStack {
                Image("lassoBase")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24)
            }
            .padding(.top, selectedDrawTool == 4 ? -45 : 0)
        }
    }
}

struct EraserToolView: ToolView {
    @Binding var selectedDrawTool: Int?
    
    var body: some View {
        Button {
            selectedDrawTool = 5
        } label: {
            ZStack {
                Image("objectEraserBase")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24)
            }
            .padding(.top, selectedDrawTool == 5 ? -45 : 0)
        }
    }
}
