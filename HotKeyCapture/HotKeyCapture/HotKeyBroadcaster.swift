//
//  HotKeyBroadcaster.swift
//  HotKeyCapture
//
//  Created by CodeHex on 2016/02/20.
//  Copyright © 2016年 CodeHex. All rights reserved.
//

import Cocoa
import Carbon

let HotKeyBroadcasterEvent = "HotKeyBroadcasterEvent"

class HotKeyBroadcaster: NSButton {
    
    func bcastKeyCode(keyCode: UInt16, modifiers: Int) {
        let keyCombo = HotKeyCombo.keyComboWithKeyCode(Int(keyCode), modifiers: modifiers)
        let userinfo = NSDictionary(objects: [keyCombo], forKeys: ["keyCombo"])
        NSNotificationCenter.defaultCenter().postNotificationName(HotKeyBroadcasterEvent, object: self, userInfo: userinfo as [NSObject: AnyObject])
    }
    
    func bcastEvent(event: NSEvent) {
        let KeyCode = event.keyCode
        let modifiers = event.modifierFlags
        let carbon_modifiers = cocoaModifiersAsCarbonModifiers(modifiers)
        bcastKeyCode(KeyCode, modifiers: carbon_modifiers)
    }
    
    override func keyDown(theEvent: NSEvent) {
        self.bcastEvent(theEvent)
    }
    
    override func performKeyEquivalent(key: NSEvent) -> Bool {
        self.bcastEvent(key)
        return true
    }
    
    override func resignFirstResponder() -> Bool {
        return false
    }
    
    func cocoaModifiersAsCarbonModifiers(cocoaModifiers: NSEventModifierFlags) -> Int {
        let cocoaTo = [
            NSEventModifierFlags.CommandKeyMask,
            NSEventModifierFlags.AlternateKeyMask,
            NSEventModifierFlags.ControlKeyMask,
            NSEventModifierFlags.ShiftKeyMask,
            NSEventModifierFlags.FunctionKeyMask,
            // [NSEventModifierFlags.AlphaShiftKeyMask, alphaLock], // Ignore?
        ]
        
        let ToCarbon = [
            cmdKey,
            optionKey,
            controlKey,
            shiftKey,
            rightControlKey
        ]
        
        var carbonModifiers = 0
        
        for var i = 0; i < 5; i++ {
            if cocoaModifiers.contains(cocoaTo[i]) {
                carbonModifiers += ToCarbon[i]
            }
        }
        return carbonModifiers
    }
}
