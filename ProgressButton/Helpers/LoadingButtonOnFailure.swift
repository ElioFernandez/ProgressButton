//
//  LoadingButtonOnFailure.swift
//  PogressButton
//
//  Created by Elio Fernandez on 19/11/2024.
//

import SwiftUI
import Combine

struct LoadingButtonOnFailure: View {
    @State private var loadingState = LoadingState()
    @State private var timer: AnyCancellable?
    
    var title: String
    var duration: CGFloat = 1
    var background: Color
    var loadingTint: Color
    var shape: AnyShape = .init(.capsule)
    var action: () -> ()
    
    var body: some View {
        ZStack {
            if loadingState.showCheckmark {
                XmarkView()
                    .transition(.scale)
            } else {
                LoadingBar(
                    title: title,
                    isCompleted: loadingState.isCompleted,
                    progress: loadingState.progress,
                    showCompressed: loadingState.showCompressed,
                    background: background,
                    loadingTint: loadingTint,
                    shape: shape,
                    onTap: starLoading
                )
                .animation(.easeInOut(duration: 0.2), value: loadingState.showCompressed)
            }
        }
        .onAppear { resetTimer() }
    }
    
    // MARK: - Actions
    func starLoading() {
        reset()
        loadingState.isLoading = true
        timer = Timer
            .publish(every: 0.01, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                guard loadingState.isLoading else { return }
                loadingState.timerCount += 0.01
                loadingState.progress = min(loadingState.timerCount / duration, 1)
                if loadingState.progress >= 1 && !loadingState.isCompleted {
                    completeLoading()
                }
            }
    }
    
    func completeLoading() {
        loadingState.isLoading = false
        timer?.cancel()
        withAnimation(.easeInOut(duration: 0.3)) {
            loadingState.showCompressed = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.easeInOut(duration: 0.3)) {
                loadingState.showCheckmark = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                action()
                reset()
            }
        }
        loadingState.isCompleted = true
    }
    
    func reset() {
        loadingState = LoadingState()
    }
    
    func resetTimer() {
        timer?.cancel()
    }
}

#Preview {
    ContentView()
}

// MARK: - Subviews
private struct XmarkView: View {
    var body: some View {
        Circle()
            .fill(.red)
            .frame(width: 50, height: 50)
            .overlay(
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .font(.system(size: 24, weight: .bold))
            )
    }
}

private struct LoadingBar: View {
    var title: String
    var isCompleted: Bool
    var progress: CGFloat
    var showCompressed: Bool
    var background: Color
    var loadingTint: Color
    var shape: AnyShape
    var onTap: () -> ()
    
    var body: some View {
        Text(title)
            .opacity(isCompleted ? 0.5 : 1)
            .padding()
            .frame(width: showCompressed ? 50 : 320, height: 50)
            .background {
                ZStack {
                    Rectangle()
                        .fill(isCompleted ? .red : background)
                    
                    GeometryReader { geo in
                        if !isCompleted {
                            Rectangle()
                                .fill(loadingTint)
                                .frame(width: geo.size.width * progress)
                                .transition(.opacity)
                        }
                    }
                }
            }
            .clipShape(shape)
            .contentShape(shape)
            .onTapGesture(perform: onTap)
    }
}

// MARK: - State Struct
private struct LoadingState {
    var progress: CGFloat = 0
    var isLoading: Bool = false
    var isCompleted: Bool = false
    var timerCount: CGFloat = 0
    var showCheckmark: Bool = false
    var showCompressed: Bool = false
}
