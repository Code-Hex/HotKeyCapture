//
//  HKCAppDelegate.swift
//  HotKeyCapture
//
//  Created by CodeHex on 2016/02/20.
//  Copyright © 2016年 CodeHex. All rights reserved.
//

import Cocoa

@NSApplicationMain
class HKCAppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {

    @IBOutlet weak var window: NSWindow!

    let HotKeyAppToFrontName = "application to foreground"
    let AppActivationKeyCodeKey = "AppActivationKeyCode"
    let AppActivationModifiersKey = "AppActivationModifiers"
    
    var appActivationHotKey = HotKeyCapture()
    var appActivationKeyCombo = HotKeyCombo.clearKeyCombo()
    
    @IBOutlet weak var appShortcutField: NSTextField!
    
    @objc internal func applicationDidFinishLaunching(aNotification: NSNotification) {
        self.registerAppActivationKeystrokeWithTarget(target: self, selector: Selector("myfunc"))
        appShortcutField.stringValue = self.getActivationKeyCombo().description
    }
    
    @objc internal func applicationShouldHandleReopen(sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        NSApp.activateIgnoringOtherApps(true)
        window.makeKeyAndOrderFront(nil)
        return true
    }

    @IBAction func setShortCut(sender: AnyObject) {
        HotKeyComboPanel.sharedPanel().showSheetForHotkey(self.getActivationHotKey(), mainWindow: self.window!, target: self)
    }
    
    func keyComboPanelEnded(panel: HotKeyComboPanel) {
        let oldKeyCombo = appActivationKeyCombo
        self.setAppActivationKeyCombo(panel.mKeyCombo!)
        appShortcutField.stringValue = self.getActivationKeyCombo().description
        
        if self.registerAppActivationKeystrokeWithTarget(target: NSApp.delegate!, selector: Selector("myfunc")) {
            self.setAppActivationKeyCombo(oldKeyCombo)
            print("reverting to old (hopefully working key combo)");
        }
    }
    
    func myfunc() {
        if (window.keyWindow) {
            let alert = NSAlert()
            alert.messageText = "Hello, World"
            alert.runModal()
        } else {
            NSApp.activateIgnoringOtherApps(true)
            self.window.makeKeyAndOrderFront(nil)
        }
    }
    
    func setAppActivationKeyCombo(aCombo: HotKeyCombo) {
        appActivationKeyCombo = aCombo
        self.getActivationHotKey().KeyCombo = self.getActivationKeyCombo()
        let ud = NSUserDefaults.standardUserDefaults()

        ud.setInteger(Int(aCombo.keyCode()), forKey: AppActivationKeyCodeKey)
        ud.setInteger(Int(aCombo.modifiers()), forKey: AppActivationModifiersKey)
    }
    
    func getActivationHotKey() -> HotKeyCapture {
        appActivationHotKey.name = HotKeyAppToFrontName
        appActivationHotKey.KeyCombo = self.getActivationKeyCombo()
        return appActivationHotKey
    }

    func getActivationKeyCombo() -> HotKeyCombo {
        let ud = NSUserDefaults.standardUserDefaults()
        appActivationKeyCombo = HotKeyCombo(keyCode: ud.integerForKey(AppActivationKeyCodeKey), modifiers: ud.integerForKey(AppActivationModifiersKey))
        
        return appActivationKeyCombo
    }
    
    func registerAppActivationKeystrokeWithTarget(target target: AnyObject, selector: Selector) -> Bool {
        let hotkey = self.getActivationHotKey()
        hotkey.target = target
        hotkey.action = selector
        HotKeyCaptureCenter.sharedCenter.unregisterHotKeyForName(HotKeyAppToFrontName)
        return HotKeyCaptureCenter.sharedCenter.registerHotKey(hotkey)
    }

}
