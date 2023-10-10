import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            VStack {
                ButtonView()
                    .buttonStyle(ButtonStyle())
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
            }
        }
        .fixedSize()
    }
}

struct ButtonView: View {
    @State private var animate = false

    var body: some View {
        Button {
            if !animate {
                withAnimation(.interpolatingSpring(stiffness: 200, damping: 14)) {
                    animate = true
                } completion: {
                    animate = false
                }
            }
        } label: {
            GeometryReader { proxy in
                let width = proxy.size.width / 2
                let systemName = "play.fill"

                HStack(alignment: .center, spacing: 0) {
                    Image(systemName: systemName)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: animate ? width : .zero)
                        .opacity(animate ? 1 : .zero)

                    Image(systemName: systemName)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: width)

                    Image(systemName: systemName)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: animate ? 0.5 : width)
                        .opacity(animate ? .zero : 1)
                }
                .frame(maxHeight: .infinity, alignment: .center)
            }
        }
    }
}

struct ButtonStyle: PrimitiveButtonStyle {
    let scale = 0.86
    let duration = 0.22
    
    @State private var animate: Bool = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(animate ? scale : 1)
            .overlay {
                Circle()
                    .foregroundColor(.black)
                    .opacity(animate ? 0.1 : 0)
                    .padding(-12)
            }
            .animation(.spring(duration: duration), value: animate)
            .onTapGesture {
                guard !animate else { return }
                animate.toggle()
                configuration.trigger()
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    animate = false
                }
            }
    }
}
