//
//  ContentView.swift
//  PogressButton
//
//  Created by Elio Fernandez on 04/07/2024.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        VStack {
            Spacer()
            successButton
            failureButton
            warningButton
        }
    }
    
    var successButton: some View {
        LoadingButtonOnSuccess(title: "Success",
                      duration: 2,
                      background: .black,
                      loadingTint: .white.opacity(0.3)
        ) {
            // button action
        }
        .font(.system(size: 16, weight: .black))
        .foregroundStyle(.white)
        .padding()
    }
    
    var failureButton: some View {
        LoadingButtonOnFailure(
            title: "Failure",
            duration: 2,
            background: .black,
            loadingTint: .white.opacity(0.3)
        ) {
            // button action
        }
        .font(.system(size: 16, weight: .black))
        .foregroundStyle(.white)
        .padding()
    }
    
    var warningButton: some View {
        LoadingButtonOnWarning(
            title: "Warning",
            duration: 2,
            background: .black,
            loadingTint: .white.opacity(0.3)
        ) {
            // button action
        }
        .font(.system(size: 16, weight: .black))
        .foregroundStyle(.white)
        .padding()
    }
}

#Preview {
    ContentView()
}
