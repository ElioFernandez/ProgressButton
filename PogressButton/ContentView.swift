//
//  ContentView.swift
//  PogressButton
//
//  Created by Elio Fernandez on 04/07/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var count: Int = 0
    
    var body: some View {
        VStack {
            Spacer()
            Text("\(count)")
                .font(.largeTitle)
            Spacer()
            bottomButton
        }
    }
    
    var bottomButton: some View {
        LoadingButton(title: "Buy ticket",
                      duration: 2,
                      background: .black,
                      loadingTint: .white.opacity(0.3)
        ) {
            count += 1
        }
        .font(.system(size: 16, weight: .black))
        .foregroundStyle(.white)
        .padding()
    }
    
}

#Preview {
    ContentView()
}
