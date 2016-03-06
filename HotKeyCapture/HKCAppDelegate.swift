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
    
    @IBOutlet weak var appShortcutField: NSTextField!
    
    let HotKey = HotKeyCapture(forKey: "application to foreground")
    
    @objc internal func applicationDidFinishLaunching(aNotification: NSNotification) {
        HotKey.registerMethodWithTarget(target: NSApp.delegate!, method: "myfunc")
        appShortcutField.stringValue = HotKey.getActivationKeyCombo().description
    }
    
    @objc internal func applicationShouldHandleReopen(sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        NSApp.activateIgnoringOtherApps(true)
        window.makeKeyAndOrderFront(nil)
        return true
    }

    @IBAction func setShortCut(sender: AnyObject) {
        HotKeyComboPanel.sharedPanel.showSheetForHotkey(HotKey.getActivationHotKey(), mainWindow: self.window!, target: self)
    }
    
    func keyComboPanelEnded(panel: HotKeyComboPanel) {
        let oldKeyCombo = HotKey.appActivationKeyCombo
        HotKey.setAppActivationKeyCombo(panel.mKeyCombo!)
        appShortcutField.stringValue = HotKey.getActivationKeyCombo().description
        
        if HotKey.registerMethodWithTarget(target: NSApp.delegate!, method: "myfunc") {
            HotKey.setAppActivationKeyCombo(oldKeyCombo)
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
}

