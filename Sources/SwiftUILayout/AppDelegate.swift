
import AppKit
import SwiftUI
import UI

final class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow?

    func applicationDidFinishLaunching(_ notification: Notification) {

        window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
                          styleMask: [.closable,
                                      .fullSizeContentView,
                                      .miniaturizable,
                                      .resizable,
                                      .titled],
                          backing: .buffered,
                          defer: false)
        window?.contentView = NSHostingView(rootView: ContentView())
        window?.makeKeyAndOrderFront(nil)
        window?.titleVisibility = .hidden
        window?.titlebarAppearsTransparent = true
        window?.toolbar?.isVisible = true
    }
}
