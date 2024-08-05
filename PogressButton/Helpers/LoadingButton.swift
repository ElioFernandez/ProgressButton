//
//  LoadingButton.swift
//  PogressButton
//
//  Created by Elio Fernandez on 04/07/2024.
//

import SwiftUI

struct LoadingButton: View {
    @State private var progress: CGFloat = 0
    @State private var isLoading: Bool = false
    @State private var isCompleted: Bool = false
    @State private var timer = Timer.publish(every: 0.01, on: .current, in: .common).autoconnect()
    @State private var timerCount: CGFloat = 0
    @State private var showCheckmark: Bool = false
    @State private var showCompressed: Bool = false
    
    var title: String
    var duration: CGFloat = 1
    var background: Color
    var loadingTint: Color
    var shape: AnyShape = .init(.capsule)
    var action: () -> ()
    
    var body: some View {
        ZStack {
            if showCheckmark {
                Circle()
                    .fill(.green)
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: "checkmark")
                            .foregroundColor(.white)
                            .font(.system(size: 24, weight: .bold))
                    )
                    .transition(.scale)
            } else {
                Text(title)
                    .opacity(isCompleted ? 0.5 : 1)
                    .padding()
                    .frame(width: showCompressed ? 50 : 320, height: 50)
                    .background {
                        ZStack {
                            Rectangle()
                                .fill(isCompleted ? .green : background)
                            
                            GeometryReader {
                                let size = $0.size
                                
                                if !isCompleted {
                                    Rectangle()
                                        .fill(loadingTint)
                                        .frame(width: size.width * progress)
                                        .transition(.opacity)
                                }
                            }
                        }
                    }
                    .clipShape(shape)
                    .contentShape(shape)
//                    .gesture(pressGesture)
//                    .simultaneousGesture(dragGesture)
                    .onTapGesture(perform: starLoading)
                    .onReceive(timer) { _ in
                        if isLoading && progress != 1 {
                            timerCount += 0.01
                            progress = max(min(timerCount / duration, 1), 0)
                        }
                        if progress >= 1 && !isCompleted {
                            completeLoading()
                        }
                    }
                    .onAppear(perform: cancelTimer)
                    .animation(.easeInOut(duration: 0.2), value: showCompressed)
            }
        }
//        .onChange(of: isCompleted) { completed in
//            if completed {
//                withAnimation(.easeInOut(duration: 0.5)) {
//                    showCompressed = true
//                }
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                    withAnimation(.easeInOut(duration: 0.5)) {
//                        showCheckmark = true
//                    }
//                }
//            }
//        }
    }
    
    func starLoading() {
        isCompleted = false
        reset()
        isLoading = true
        addTimer()
    }
    
    func completeLoading() {
        cancelTimer()
        isLoading = false
        withAnimation(.easeInOut(duration: 0.3)) {
            showCompressed = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.easeInOut(duration: 0.3)) {
                showCheckmark = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                action()
            }
        }
        isCompleted = true
    }
    
//    var dragGesture: some Gesture {
//        DragGesture(minimumDistance: 0)
//            .onEnded { _ in
//                guard !isCompleted else { return }
//                cancelTimer()
//                withAnimation(.snappy) {
//                    reset()
//                }
//            }
//    }
    
//    var pressGesture: some Gesture {
//        LongPressGesture(minimumDuration: duration)
//            .onChanged {
//                isCompleted = false
//                reset()
//                isLoading = $0
//                addTimer()
//            }.onEnded { status in
//                cancelTimer()
//                isLoading = false
//                withAnimation(.easeInOut(duration: 0.2)) {
//                    isCompleted = status
//                }
//                action()
//            }
//    }
    
    func addTimer() {
        timer = Timer.publish(every: 0.01, on: .current, in: .common).autoconnect()
    }
    
    func cancelTimer() {
        timer.upstream.connect().cancel()
    }
    
    func reset() {
        isLoading = false
        progress = 0
        timerCount = 0
        showCheckmark = false
        showCompressed = false
    }
}

#Preview {
    ContentView()
}
