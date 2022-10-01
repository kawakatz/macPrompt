import Cocoa

class MainAppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow?
    var breakWindowController: NSWindowController!
    var welcomeWindowController: NSWindowController!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        Bundle.main.loadNibNamed("MainMenu", owner: self, topLevelObjects: nil)
    
        NSApp.activate(ignoringOtherApps: true)
        
        let welcomeStoryboard = NSStoryboard(name : "Welcome", bundle: nil)
        let welcomeWindowController = welcomeStoryboard.instantiateController(withIdentifier: "WelcomeWindowController") as? NSWindowController
        let welcomeViewController = welcomeStoryboard.instantiateController(withIdentifier: "WelcomeViewControllerID") as? WelcomeViewController
        welcomeWindowController!.window?.contentViewController = welcomeViewController
        welcomeWindowController!.window?.orderFront(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
}

