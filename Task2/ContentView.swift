import SwiftUI

struct ContentView: View {
    @State private var id = 0
    @State private var pressed = false
    @State private var animate = false
    private let size = 44.0
    
    var body: some View {
        Button {
            pressed = true
            animate = true
            id += 1
            Task {
                try await Task.sleep(for: .seconds(1))
                pressed = false
            }
        } label: {
            ForwardImageView(animate: $animate, size: size)
                .id(id)
                .frame(width: size * 2 + 8, height: size * 2 + 8)
                .animation(.spring(response: 0.2, dampingFraction: 0.6), value: pressed)
        }
        .contentShape(Rectangle())
        .onTapGesture { }
    }
}

struct ForwardImageView: View {
    @Binding var animate: Bool
    @State private var triger: Bool = false
    let size: CGFloat
    
    var body: some View {
        let frameWidth = size * 2 - size / 5
        
        ZStack {
            VStack {
                image()
                    .scaleEffect(triger ? 0 : 1)
                    .offset(x: triger ? size * 0.7 : 0)
                    .opacity(triger ? 0 : 1)
            }
            .frame(width: frameWidth, alignment: .trailing)
            
            VStack {
                image()
                    .scaleEffect(triger ? 1 : 0)
                    .offset(x: triger ? 0 : -size * 0.7)
            }
            .frame(width: frameWidth, alignment: .leading)
            
            VStack {
                image()
            }
            .frame(width: frameWidth, alignment: !triger ? .leading : .trailing)
        }
        .animation(.spring(response: 1.0, dampingFraction: 0.5), value: triger)
        .onAppear { if animate { triger = true } }
    }
    
    private func image() -> some View {
        Image(systemName: "arrowtriangle.forward.fill")
            .font(.system(size: size))
            .foregroundStyle(.blue)
    }
}
