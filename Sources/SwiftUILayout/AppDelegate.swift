
import AppKit
import SwiftUI
import UI

final class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow?

    func applicationDidFinishLaunching(_ notification: Notification) {

        let content = UI.Text("Hello!")
            .frame(width: 200, height: 100)
            .border(.blue, width: 2)
            .frame(width: 300, height: 300, alignment: .topLeading)
            .border(.yellow, width: 2)

        window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
                          styleMask: [.closable,
                                      .fullSizeContentView,
                                      .miniaturizable,
                                      .resizable,
                                      .titled],
                          backing: .buffered,
                          defer: false)
        window?.center()
        window?.contentView = NSHostingView(rootView: ContentView(view: content))
        window?.makeKeyAndOrderFront(nil)
        window?.titleVisibility = .hidden
        window?.titlebarAppearsTransparent = true
        window?.toolbar?.isVisible = true
    }
}
