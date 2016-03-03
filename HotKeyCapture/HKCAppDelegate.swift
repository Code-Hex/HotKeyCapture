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
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        self.registerAppActivationKeystrokeWithTarget(target: self, selector: Selector("toggle"))
        appShortcutField.stringValue = self.getActivationKeyCombo().description
    }
    
    func applicationShouldHandleReopen(sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        NSApp.activateIgnoringOtherApps(true)
        window.makeKeyAndOrderFront(nil)
        return true
    }

    @IBAction func setShortCut(sender: AnyObject) {
        HotKeyComboPanel.sharedPanel().showSheetForHotkey(self.setActivationHotKey(), mainWindow: self.window!, target: self)
    }
    
    func keyComboPanelEnded(panel: HotKeyComboPanel) {
        let oldKeyCombo = appActivationKeyCombo
        self.setAppActivationKeyCombo(panel.mKeyCombo!)
        appShortcutField.stringValue = self.getActivationKeyCombo().description
        
        if self.registerAppActivationKeystrokeWithTarget(target: NSApp.delegate!, selector: Selector("toggle")) {
            self.setAppActivationKeyCombo(oldKeyCombo)
            NSLog("reverting to old (hopefully working key combo");
        }
    }
    
    private func toggle() {
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
        self.setActivationHotKey().KeyCombo = self.getActivationKeyCombo()
        let ud = NSUserDefaults.standardUserDefaults()

        ud.setInteger(Int(aCombo.keyCode()), forKey: AppActivationKeyCodeKey)
        ud.setInteger(Int(aCombo.modifiers()), forKey: AppActivationModifiersKey)
    }
    
    func setActivationHotKey() -> HotKeyCapture {
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
        let hotkey = self.setActivationHotKey()
        hotkey.target = target
        hotkey.action = selector
        HotKeyCaptureCenter.sharedCenter().unregisterHotKeyForName(HotKeyAppToFrontName)
        return HotKeyCaptureCenter.sharedCenter().registerHotKey(hotkey)
    }

}

