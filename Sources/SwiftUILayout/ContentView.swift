
import AppKit
import SwiftUI
import UI

struct ContentView<View: UI.View>: SwiftUI.View {

    let view: View
    @State var opacity: Double = 0.5

    var body: some SwiftUI.View {
        VStack {
            ZStack  {
                HostingView(content: view)
                    .opacity(1-opacity)

                view.swiftUI
                    .opacity(opacity)
            }
            Slider(value: $opacity,
                   in: 0...1,
                   minimumValueLabel: Text("UI"),
                   maximumValueLabel: Text("SwiftUI"),
                   label: EmptyView.init)
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
