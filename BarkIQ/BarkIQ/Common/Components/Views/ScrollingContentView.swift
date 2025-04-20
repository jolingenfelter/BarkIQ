//
//  ScrollingContentView.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/19/25.
//

import SwiftUI

struct ScrollingContentView<Content: View>: View {
    @ViewBuilder let content: (_ geometry: GeometryProxy) -> Content
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                content(geometry)
            }
        }
    }
}

#Preview {
    ScrollingContentView { geometry in
        Color.blue
            .frame(height: geometry.size.height * 2)
    }
}
