
import AppKit
import SwiftUI
import UI

final class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {

    var window: NSWindow?

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }

    func applicationDidFinishLaunching(_ notification: Notification) {

        let content = ContentView(view: UI.Ellipse().frame(width: 100, height: 50))
//            .frame(maxWidth: .infinity, maxHeight: .infinity)

        window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
                          styleMask: [.closable,
                                      .fullSizeContentView,
                                      .miniaturizable,
                                      .resizable,
                                      .titled],
                          backing: .buffered,
                          defer: false)
        window?.center()
        window?.contentView = NSHostingView(rootView: content)
        window?.makeKeyAndOrderFront(nil)
        window?.delegate = self
        window?.titleVisibility = .hidden
        window?.titlebarAppearsTransparent = true
        window?.toolbar?.isVisible = true

        NSApp.activate(ignoringOtherApps: true)
    }
}
