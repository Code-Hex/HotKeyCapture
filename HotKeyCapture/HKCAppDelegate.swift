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
    var appActivationHotKey: HotKeyCapture?
    var appActivationKeyCombo: HotKeyCombo?
    @IBOutlet weak var appShortcutField: NSTextField!
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        self.registerAppActivationKeystrokeWithTarget(self, selector: Selector("toggle:"))
        appShortcutField.stringValue = appActivationKeyCombo.debugDescription
        
    }
    
    func applicationShouldHandleReopen(sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        NSApp.activateIgnoringOtherApps(true)
        window.makeKeyAndOrderFront(nil)
        return true
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    @IBAction func setShortCut(sender: AnyObject) {
        HotKeyComboPanel.sharedPanel().showSheetForHotkey(self.appActivationHotKey, mainWindow: NSApp.mainWindow!, target: self)
    }
    
    func keyComboPanelEnded(panel: HotKeyComboPanel) {
        let oldKeyCombo = appActivationKeyCombo
        self.setAppActivationKeyCombo(panel.mKeyCombo!)
        appShortcutField.stringValue = (self.appActivationKeyCombo?.description())!
        
        if self.registerAppActivationKeystrokeWithTarget(NSApp.delegate!, selector: Selector("toggle:")) {
            self.setAppActivationKeyCombo(oldKeyCombo!)
            NSLog("reverting to old (hopefully working key combo");
        }
    }
    
    func toggle() {
        if (window.keyWindow) {
            window.close();
        } else {
            NSApp.activateIgnoringOtherApps(true)
            window.makeKeyAndOrderFront(nil)
        }
    }
    
    func setAppActivationKeyCombo(aCombo: HotKeyCombo) {
        appActivationKeyCombo = aCombo
        self.appActivationHotKey?.KeyCombo = appActivationKeyCombo!
        let ud = NSUserDefaults.standardUserDefaults()
        
        ud.setInteger(Int(aCombo.keyCode()), forKey: AppActivationKeyCodeKey)
        ud.setInteger(Int(aCombo.modifiers()), forKey: AppActivationModifiersKey)
    }
    
    func _appActivationHotKey() -> HotKeyCapture {
        if appActivationHotKey == nil {
            appActivationHotKey = HotKeyCapture()
            appActivationHotKey?.name = HotKeyAppToFrontName
            appActivationHotKey?.KeyCombo = appActivationKeyCombo!
        }
        return appActivationHotKey!
    }

    func _appActivationKeyCombo() -> HotKeyCombo {
        let ud = NSUserDefaults.standardUserDefaults()
        if appActivationKeyCombo == nil {
            appActivationKeyCombo = HotKeyCombo(keyCode: (ud.objectForKey(AppActivationKeyCodeKey)?.integerValue)!, modifiers: (ud.objectForKey(AppActivationModifiersKey)?.integerValue)!)
        }
        
        return appActivationKeyCombo!
    }
    
    func registerAppActivationKeystrokeWithTarget(target: AnyObject, selector: Selector) -> Bool {
        let hotkey = appActivationHotKey
        hotkey?.target = target
        hotkey?.action = selector
        HotKeyCaptureCenter.sharedCenter().unregisterHotKeyForName(HotKeyAppToFrontName)
        return HotKeyCaptureCenter.sharedCenter().registerHotKey(hotkey!)
    }

}

