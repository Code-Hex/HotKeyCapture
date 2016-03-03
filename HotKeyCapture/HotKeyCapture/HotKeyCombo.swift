//
//  HotKeyCombo.swift
//  HotKeyCapture
//
//  Created by CodeHex on 2016/02/20.
//  Copyright © 2016年 CodeHex. All rights reserved.
//

import Carbon

class HotKeyCombo {
    
    var mKeyCode = 0
    var mModifiers = 0
    var description: String {
        get {
            return self.isValidHotKeyCombo() ? HotKeyCombo.stringForModifiers(self.modifiers()) + HotKeyCombo.stringForKeyCode(self.keyCode())
                : "(None)"
        }
    }
    
    class func clearKeyCombo() -> HotKeyCombo {
        return self.keyComboWithKeyCode(-1, modifiers: -1)
    }
    
    class func keyComboWithKeyCode(keyCode: Int, modifiers: Int) -> HotKeyCombo {
        return HotKeyCombo(keyCode: keyCode, modifiers: modifiers)
    }
    
    init(keyCode: Int, modifiers: Int) {
        self.initWithKeyCode(keyCode, modifiers: modifiers)
    }
    
    func initWithKeyCode(keyCode: Int, modifiers: Int) {
        self.mKeyCode = keyCode
        self.mModifiers = modifiers
    }
    
    func initWithPlistRepresentation(plist: AnyObject) {
        var keyCode = 0
        var modifiers = 0
        keyCode = Int((plist.objectForKey("keyCode")?.intValue)!)
        if keyCode <= 0 {
            keyCode = -1
        }
        modifiers = Int((plist.objectForKey("keyCode")?.intValue)!)
        if modifiers <= 0 {
            modifiers = -1
        }
        
    }
    
    func keyCode() -> UInt32 {
        return UInt32(mKeyCode)
    }
    
    func modifiers() -> UInt32 {
        return UInt32(mModifiers)
    }
    
    func isValidHotKeyCombo() -> Bool {
        return mKeyCode >= 0 && mModifiers > 0
    }
    
    func isClearCombo() -> Bool {
        return mKeyCode == -1 && mModifiers == -1
    }
    
    class func keyCodesDictionary() -> NSDictionary {
        return NSDictionary(contentsOfFile: NSBundle(forClass: self).pathForResource("HotKeyCodes", ofType: "plist")!)!
    }
    
    class func stringForModifiers(modifiers: UInt32) -> String {
        
        let mod = [cmdKey, optionKey, controlKey, shiftKey]
        let ToChar = ["⌘", "⌥", "⌃", "⇧"]
        
        var str = ""
        for var i = 0; i < 4; i++ {
            if Int(modifiers) & mod[i] > 0 {
                str += ToChar[i]
            }
        }
        
        return str
    }
    
    class func stringForKeyCode(keyCode: UInt32) -> String {
        let dic = self.keyCodesDictionary()
        let key = String(format: "%d", keyCode)
        let str = dic.objectForKey(key)
        return (str != nil) ? String(str!) : String(format: "%X", keyCode)
    }
    
}
