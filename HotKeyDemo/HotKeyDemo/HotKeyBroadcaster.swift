//
//  HotKeyBroadcaster.swift
//  HotKeyCapture
//
//  Created by CodeHex on 2016/02/20.
//  Copyright © 2016年 CodeHex. All rights reserved.
//

import Cocoa
import Carbon
import HotKeyCapture

let HotKeyBroadcasterEvent = "HotKeyBroadcasterEvent"

class HotKeyBroadcaster: NSButton {
    
    func bcastKeyCode(keyCode: Int, modifiers: Int) {
        let keyCombo = HotKeyCombo.keyComboWithKeyCode(keyCode: keyCode, modifiers: modifiers)
        let userinfo = NSDictionary(objects: [keyCombo], forKeys: ["keyCombo"])
        NSNotificationCenter.defaultCenter().postNotificationName(HotKeyBroadcasterEvent, object: self, userInfo: userinfo as [NSObject:AnyObject])
    }
    
    func bcastEvent(event: NSEvent) {
        let KeyCode = Int(event.keyCode)
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
        let cocoaToCarbon = [
            cmdKey : NSEventModifierFlags.CommandKeyMask,
            optionKey : NSEventModifierFlags.AlternateKeyMask,
            controlKey : NSEventModifierFlags.ControlKeyMask,
            shiftKey : NSEventModifierFlags.ShiftKeyMask,
            rightControlKey : NSEventModifierFlags.FunctionKeyMask,
            //alphaLock : NSEventModifierFlags.AlphaShiftKeyMask // Ignore?
        ]
        
        var carbonModifiers = 0
        for (ToCarbon, cocoaTo) in cocoaToCarbon {
            if cocoaModifiers.contains(cocoaTo) {
                carbonModifiers += ToCarbon
            }
        }
        return carbonModifiers
    }
}
