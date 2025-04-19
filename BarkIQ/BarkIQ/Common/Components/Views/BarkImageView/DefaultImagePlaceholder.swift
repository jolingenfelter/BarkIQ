//
//  DefaultImagePlaceholder.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/19/25.
//

import SwiftUI

struct DefaultImagePlaceholder: View {
    var body: some View {
        VStack {
            Image(systemName: "dog")
            ProgressView()
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .background(Color.gray.opacity(0.3))
    }
}

#Preview {
    DefaultImagePlaceholder()
}
