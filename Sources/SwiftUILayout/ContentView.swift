
import AppKit
import SwiftUI
import UI

extension UI.View {

    var measured: some UI.View {
        overlay(UI.GeometryReader { proxy in
            NSColor.clear.overlay(Text("\(Int(proxy.size.width))"))
        })
    }
}

struct ContentView: SwiftUI.View {

    let size = CGSize(width: 600, height: 400)

    var content: some UI.View {

        UI.HStack(spacing: 0, content: [
            UI.AnyView(Rectangle().frame(minWidth: 150).foregroundColor(.blue).measured),
            UI.AnyView(Rectangle().frame(maxWidth: 100).foregroundColor(.red).measured)
        ])


//        UI.Ellipse()
//            .frame(width: 150)
//            .foregroundColor(.red)
//            .frame(
//                minWidth: minWidth,
//                maxWidth: maxWidth,
//                minHeight: minHeight,
//                maxHeight: maxHeight
//            )
//            .overlay(UI.GeometryReader { proxy in
//                UI.Text("(\(proxy.size.width), \(proxy.size.height))")
//                    .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
//                    .background(NSColor.orange)
//            })
//            .border(.blue, width: 2)
            .frame(width: width, height: height)
            .border(.yellow, width: 2)
    }

    @State var opacity: Double = 0.5
    @State var width: CGFloat? = 300
    @State var height: CGFloat? = 200
    @State var minWidth: CGFloat? = nil
    @State var maxWidth: CGFloat? = nil
    @State var minHeight: CGFloat? = nil
    @State var maxHeight: CGFloat? = nil

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

                FloatSlider(value: $width, in: 0...600, title: "width")
                FloatSlider(value: $height, in: 0...600, title: "height")
                FloatSlider(value: $minWidth, in: 0...600, title: "minWidth")
                FloatSlider(value: $maxWidth, in: 0...600, title: "maxWidth")
                FloatSlider(value: $minHeight, in: 0...600, title: "minHeight")
                FloatSlider(value: $maxHeight, in: 0...600, title: "maxHeight")
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


struct FloatSlider: SwiftUI.View {

    init(value: Binding<CGFloat?>, in range: ClosedRange<CGFloat>, title: String) {
        self.value = value
        self.range = range
        self.title = title
        self._enabled = State(initialValue: value.wrappedValue != nil)
        self._amount = State(initialValue: value.wrappedValue ?? (range.upperBound - range.lowerBound) / 2)
    }

    private var value: Binding<CGFloat?>
    private let range: ClosedRange<CGFloat>
    private let title: String

    @State private var amount: CGFloat
    @State private var enabled: Bool

    private func updateValue(id: Any? = nil) {
        value.wrappedValue = enabled ? amount.rounded() : nil
    }

    private var label: String { "\(title): \(Int(amount.rounded()))" }

    var body: some SwiftUI.View {

        HStack {
            Toggle(label, isOn: $enabled)

            Slider(value: $amount,
                   in: range)
                .disabled(!enabled)
                .onChange(of: amount, perform: updateValue)
                .onChange(of: enabled, perform: updateValue)
        }
    }
}
