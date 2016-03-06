//
//  HotKeyCapture.swift
//  HotKeyCapture
//
//  Created by CodeHex on 2016/03/07.
//  Copyright © 2016年 CodeHex. All rights reserved.
//

import Cocoa

class HotKeyCapture {
    private let AppActivationKeyCodeKey = "AppActivationKeyCode"
    private let AppActivationModifiersKey = "AppActivationModifiers"
    
    private var HotKeyAppToFrontName = ""
    private var appActivationHotKey = HotKeyVariable()
    
    private var _appActivationKeyCombo = HotKeyCombo.clearKeyCombo()
    
    init(forKey: String) {
        self.HotKeyAppToFrontName = forKey
    }
    
    var appActivationKeyCombo: HotKeyCombo {
        get {
            return _appActivationKeyCombo
        }
    }
    
    func setAppActivationKeyCombo(aCombo: HotKeyCombo) {
        _appActivationKeyCombo = aCombo
        self.getActivationHotKey().KeyCombo = self.getActivationKeyCombo()
        let ud = NSUserDefaults.standardUserDefaults()
        
        ud.setInteger(Int(aCombo.keyCode), forKey: AppActivationKeyCodeKey)
        ud.setInteger(Int(aCombo.modifiers), forKey: AppActivationModifiersKey)
    }
    
    func getActivationHotKey() -> HotKeyVariable {
        appActivationHotKey.name = HotKeyAppToFrontName
        appActivationHotKey.KeyCombo = self.getActivationKeyCombo()
        return appActivationHotKey
    }
    
    func getActivationKeyCombo() -> HotKeyCombo {
        let ud = NSUserDefaults.standardUserDefaults()
        _appActivationKeyCombo = HotKeyCombo(keyCode: ud.integerForKey(AppActivationKeyCodeKey), modifiers: ud.integerForKey(AppActivationModifiersKey))
        return _appActivationKeyCombo
    }
    
    func registerMethodWithTarget(target target: AnyObject, method: String) -> Bool {
        let hotkey = self.getActivationHotKey()
        hotkey.target = target
        hotkey.action = method
        HotKeyCaptureCenter.sharedCenter.unregisterHotKeyForName(HotKeyAppToFrontName)
        return HotKeyCaptureCenter.sharedCenter.registerHotKey(hotkey)
    }
    
    func registerMethodWithTarget(target target: AnyObject, method: String, afterDelay: NSTimeInterval) -> Bool {
        let hotkey = self.getActivationHotKey()
        hotkey.target = target
        hotkey.action = method
        hotkey.delay = afterDelay
        HotKeyCaptureCenter.sharedCenter.unregisterHotKeyForName(HotKeyAppToFrontName)
        return HotKeyCaptureCenter.sharedCenter.registerHotKey(hotkey)
    }
    
    func registerBlock(block block: ()->Void) -> Bool {
        let hotkey = self.getActivationHotKey()
        hotkey.completion = block
        HotKeyCaptureCenter.sharedCenter.unregisterHotKeyForName(HotKeyAppToFrontName)
        return HotKeyCaptureCenter.sharedCenter.registerHotKey(hotkey)
    }
    
    func registerBlock(block block: ()->Void, afterDelay: NSTimeInterval) -> Bool {
        let hotkey = self.getActivationHotKey()
        hotkey.completion = block
        hotkey.delay = afterDelay
        HotKeyCaptureCenter.sharedCenter.unregisterHotKeyForName(HotKeyAppToFrontName)
        return HotKeyCaptureCenter.sharedCenter.registerHotKey(hotkey)
    }
}
