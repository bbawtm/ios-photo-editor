//
//  ToolViews.swift
//  ios-photo-editor
//
//  Created by Vadim Popov on 28.12.2022.
//

import SwiftUI


protocol ToolView: View {
    
    var selectedDrawTool: Int? { get set }
    
}

struct PenToolView: ToolView {
    @Binding var selectedDrawTool: Int?
    
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
                    .colorMultiply(.cyan)
                RoundedRectangle(cornerRadius: 2, style: .continuous)
                    .fill(.cyan)
                    .frame(width: 20, height: 20)
                    .offset (x: 0, y: 6)
            }
            .padding(.top, selectedDrawTool == 0 ? -45 : 0)
        }
    }
}

struct BrushToolView: ToolView {
    @Binding var selectedDrawTool: Int?
    
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
                    .colorMultiply(.cyan)
                RoundedRectangle(cornerRadius: 2, style: .continuous)
                    .fill(.cyan)
                    .frame(width: 20, height: 20)
                    .offset (x: 0, y: -5)
            }
            .padding(.top, selectedDrawTool == 1 ? -45 : 0)
        }
    }
}

struct NeonToolView: ToolView {
    @Binding var selectedDrawTool: Int?
    
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
                    .colorMultiply(.cyan)
                RoundedRectangle(cornerRadius: 2, style: .continuous)
                    .fill(.cyan)
                    .frame(width: 20, height: 20)
                    .offset (x: 0, y: -5)
            }
            .padding(.top, selectedDrawTool == 2 ? -45 : 0)
        }
    }
}

struct PencilToolView: ToolView {
    @Binding var selectedDrawTool: Int?
    
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
                    .colorMultiply(.cyan)
                RoundedRectangle(cornerRadius: 2, style: .continuous)
                    .fill(.cyan)
                    .frame(width: 20, height: 20)
                    .offset (x: 0, y: 0)
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
