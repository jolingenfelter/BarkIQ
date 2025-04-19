//
//  HomeView.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/14/25.
//

import SwiftUI

struct HomeView: View {
    @State private var isShowingSetupSheet = false
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 44) {
                    Text("BarkIQ")
                        .font(.system(.largeTitle, design: .monospaced))
                        .foregroundColor(.barkText)
                        .fontWeight(.semibold)
                    
                    VStack(spacing: 16) {
                        Button("Start quiz") {
                            isShowingSetupSheet = true
                        }
                        .buttonStyle(.primary)
                        
                        Button("Stats") {
                            
                        }
                        .buttonStyle(.primary)
                    }
                }
                .scenePadding()
                .frame(
                    minWidth: geometry.size.width,
                    minHeight: geometry.size.height,
                    alignment: .center
                )
            }
        }
        .background(.barkBackground)
        .sheet(isPresented: $isShowingSetupSheet) {
            QuizFlow()
        }
    }
}

#Preview {
    HomeView()
}
