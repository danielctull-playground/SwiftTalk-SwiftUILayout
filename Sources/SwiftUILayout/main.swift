
import AppKit

let app = NSApplication.shared
NSApp.setActivationPolicy(.accessory)
let delegate = AppDelegate()
app.delegate = delegate
app.run()
