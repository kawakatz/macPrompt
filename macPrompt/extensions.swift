import Foundation
import Cocoa

extension NSView {

    @IBInspectable var backgroundColor: NSColor? {
        get {
            guard let layer = layer, let backgroundColor = layer.backgroundColor else {return nil}
            return NSColor(cgColor: backgroundColor)
        }
        set {
            wantsLayer = true
            layer?.backgroundColor = newValue?.cgColor
        }
    }

}

extension NSWindow {
    func shakeWindow(){
        let numberOfShakes          = 4
        let durationOfShake         = 0.5
        let vigourOfShake : CGFloat = 0.06
        let frame : CGRect = self.frame
        let shakeAnimation :CAKeyframeAnimation  = CAKeyframeAnimation()
        
        let shakePath = CGMutablePath()
        shakePath.move( to: CGPoint(x:NSMinX(frame), y:NSMinY(frame)))
        
        for _ in 0...numberOfShakes-1 {
            shakePath.addLine(to: CGPoint(x:NSMinX(frame) - frame.size.width * vigourOfShake, y:NSMinY(frame)))
            shakePath.addLine(to: CGPoint(x:NSMinX(frame) + frame.size.width * vigourOfShake, y:NSMinY(frame)))
        }
        
        shakePath.closeSubpath()
        shakeAnimation.path = shakePath
        shakeAnimation.duration = durationOfShake
        
        self.animations = ["frameOrigin":shakeAnimation]
        self.animator().setFrameOrigin(self.frame.origin)
    }
}

final class EditableNSTextField: NSTextField {

    private let commandKey = NSEvent.ModifierFlags.command.rawValue
    private let commandShiftKey = NSEvent.ModifierFlags.command.rawValue | NSEvent.ModifierFlags.shift.rawValue

    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        if event.type == NSEvent.EventType.keyDown {
            if (event.modifierFlags.rawValue & NSEvent.ModifierFlags.deviceIndependentFlagsMask.rawValue) == commandKey {
                switch event.charactersIgnoringModifiers! {
                case "x":
                    if NSApp.sendAction(#selector(NSText.cut(_:)), to: nil, from: self) { return true }
                case "c":
                    if NSApp.sendAction(#selector(NSText.copy(_:)), to: nil, from: self) { return true }
                case "v":
                    if NSApp.sendAction(#selector(NSText.paste(_:)), to: nil, from: self) { return true }
                case "z":
                    if NSApp.sendAction(Selector(("undo:")), to: nil, from: self) { return true }
                case "a":
                    if NSApp.sendAction(#selector(NSResponder.selectAll(_:)), to: nil, from: self) { return true }
                default:
                    break
                }
            } else if (event.modifierFlags.rawValue & NSEvent.ModifierFlags.deviceIndependentFlagsMask.rawValue) == commandShiftKey {
                if event.charactersIgnoringModifiers == "Z" {
                    if NSApp.sendAction(Selector(("redo:")), to: nil, from: self) { return true }
                }
            }
        }
        return super.performKeyEquivalent(with: event)
    }
}

extension UserDefaults {
    func removeAll() {
        dictionaryRepresentation().forEach { removeObject(forKey: $0.key) }
    }
}
