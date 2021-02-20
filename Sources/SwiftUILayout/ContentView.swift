
import AppKit
import SwiftUI
import UI

struct ContentView: SwiftUI.View {

    let size = CGSize(width: 600, height: 400)

    var content: some UI.View {
        UI.Ellipse()
            .border(.blue, width: 2)
            .overlay(Text("Hello!"))
            .frame(width: width.rounded(), height: height.rounded(), alignment: .topLeading)
            .border(.yellow, width: 2)
    }

    @State var opacity: Double = 0.5
    @State var width: CGFloat = 300
    @State var height: CGFloat = 200

    var body: some SwiftUI.View {
        VStack {

            ZStack  {
                HostingView(content: content, size: size)
                    .opacity(1-opacity)

                content.swiftUI.frame(width: size.width, height: size.height)
                    .opacity(opacity)
            }

            VStack(spacing: 8) {

                Slider(value: $opacity,
                       in: 0...1,
                       minimumValueLabel: Text("UI"),
                       maximumValueLabel: Text("SwiftUI"),
                       label: EmptyView.init)

                Slider(value: $width,
                       in: 0...600,
                       label: { SwiftUI.Text("Width: \(width.rounded())") })

                Slider(value: $height,
                       in: 0...600,
                       label: { SwiftUI.Text("Height: \(height.rounded())") })
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
