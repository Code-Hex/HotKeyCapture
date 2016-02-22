//
//  HotKeyComboPanel.swift
//  HotKeyCapture
//
//  Created by CodeHex on 2016/02/20.
//  Copyright © 2016年 CodeHex. All rights reserved.
//

import Cocoa

class HotKeyComboPanel: NSWindowController {

    static private var _sharedKeyComboPanel: HotKeyComboPanel? = nil
    
    var mTitleFormat = "empty"
    var mKeyName = "empty"
    var mKeyCombo: HotKeyCombo?
    
    var currentModalDelegate: HKCAppDelegate?
    
    @IBOutlet weak var mTitleField: NSTextField?
    @IBOutlet weak var mComboField: NSTextField?
    @IBOutlet weak var mKeyCaster: HotKeyBroadcaster?
    
    var keyCombo: HotKeyCombo? {
        get {
            return mKeyCombo!
        }
        
        set(combo) {
            mKeyCombo = combo == nil ? HotKeyCombo.clearKeyCombo() : combo!
            self._refreshContents()
        }
    }
    
    var KeyBindingName: String? {
        get {
            return mKeyName
        }
        
        set(n) {
            mKeyName = n == nil ? "empty" : n!
            self._refreshContents()
        }
    }
    
    class func sharedPanel() -> HotKeyComboPanel {
        if _sharedKeyComboPanel == nil {
            _sharedKeyComboPanel = HotKeyComboPanel()
        }
        return _sharedKeyComboPanel!
    }

    override func windowDidLoad() {
        mTitleFormat = mTitleField!.stringValue
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "noteKeyBroadcast:", name: HotKeyBroadcasterEvent, object: mKeyCaster)
    }
    
    private func _refreshContents() {
        mComboField?.stringValue = mKeyCombo!.description()
        mTitleField?.stringValue = String(NSString(format: mTitleFormat, mKeyName))
    }
    
    func showSheetForHotkey(hotkey: HotKeyCapture?, mainWindow: NSWindow, target: HKCAppDelegate) {
        self.currentModalDelegate = target
        
        self.window?.makeFirstResponder(mKeyCaster)
        self.keyCombo = hotkey?.KeyCombo
        self.KeyBindingName = hotkey?.name 
        
        self.window?.beginSheet(mainWindow, completionHandler: {
            returnCode in
            
            self.window?.close()
            
            if returnCode == NSModalResponseOK {
                hotkey!.KeyCombo = self.mKeyCombo!
                HotKeyCaptureCenter.sharedCenter().updateHotKey(hotkey!)
                self.currentModalDelegate!.respondsToSelector("keyComboPanelEnded:")
                self.currentModalDelegate!.keyComboPanelEnded(self)
            }
        })
    }
    
    func runModalForHotKey(hotkey: HotKeyCapture) {
        
        self.keyCombo = hotkey.KeyCombo
        self.KeyBindingName = hotkey.name
        let resultCode = NSApp.runModalForWindow(self.window!)
        self.window?.orderOut(self)
        
        if resultCode == NSModalResponseOK {
            hotkey.KeyCombo = self.keyCombo!
            HotKeyCaptureCenter.sharedCenter().updateHotKey(hotkey)
        }
    }
    
    @IBAction func ok(sender: NSButton) {
        if self.window != nil {
            if self.window!.modalPanel {
                NSApp.stopModalWithCode(NSModalResponseOK)
            } else {
                NSApp.endSheet(self.window!, returnCode: NSModalResponseOK)
            }
        }
    }
    
    @IBAction func cancel(sender: NSButton) {
        if self.window != nil {
            if self.window!.modalPanel {
                NSApp.stopModalWithCode(NSModalResponseCancel)
            } else {
                NSApp.endSheet(self.window!, returnCode: NSModalResponseCancel)
            }
        }
    }
    
    @IBAction func clear(sender: NSButton) {
        self.keyCombo = HotKeyCombo.clearKeyCombo()
        if self.window != nil {
            if self.window!.modalPanel {
                NSApp.stopModalWithCode(NSModalResponseOK)
            }
        }
    }
    
    func noteKeyBroadcast(notification: NSNotification) {
        let kC: HotKeyCombo = notification.userInfo!["keyCombo"] as! HotKeyCombo
        self.keyCombo = kC
    }
    
}