//
//  HotKeyComboPanel.swift
//  HotKeyCapture
//
//  Created by CodeHex on 2016/02/20.
//  Copyright © 2016年 CodeHex. All rights reserved.
//

import Cocoa

class HotKeyComboPanel: NSWindowController {
    
    var mKeyName = "empty"
    var mTitleFormat = "empty"
    var mWindow = NSWindow()
    var mKeyCombo: HotKeyCombo?
    
    var currentModalDelegate: HKCAppDelegate?
    
    @IBOutlet weak var mTitleField: NSTextField!
    @IBOutlet weak var mComboField: NSTextField!
    @IBOutlet weak var mKeyCaster: HotKeyBroadcaster?
    
    var keyCombo: HotKeyCombo? {
        get {
            return mKeyCombo!
        }
        
        set(combo) {
            mKeyCombo = combo == nil ? HotKeyCombo.clearKeyCombo() : combo!
            self.refreshContents()
        }
    }
    
    var KeyBindingName: String? {
        get {
            return mKeyName
        }
        
        set(n) {
            mKeyName = n == nil ? "empty" : n!
            self.refreshContents()
        }
    }
    
    class var sharedPanel: HotKeyComboPanel {
        struct Shared {
            static let instance = HotKeyComboPanel(windowNibName: "HotKeyComboPanel")
        }
        return Shared.instance
    }

    override init(window: NSWindow!) {
        super.init(window: window)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func windowDidLoad() {
        mTitleFormat = mTitleField!.stringValue
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "noteKeyBroadcast:", name: HotKeyBroadcasterEvent, object: mKeyCaster)
    }
    
    private func refreshContents() {
        mComboField!.stringValue = mKeyCombo!.description
        mTitleField!.stringValue = String(format: mTitleFormat, mKeyName)
    }
    
    func showSheetForHotkey(hotkey: HotKeyVariable, mainWindow: NSWindow, target: HKCAppDelegate) {
        self.currentModalDelegate = target
        
        self.window?.makeFirstResponder(mKeyCaster)
        self.keyCombo = hotkey.KeyCombo
        self.KeyBindingName = hotkey.name
        mWindow = mainWindow
        mainWindow.beginSheet(self.window!, completionHandler: {
            returnCode in
            self.window!.close()
            
            if returnCode == NSModalResponseOK {
                hotkey.KeyCombo = self.mKeyCombo!
                HotKeyCaptureCenter.sharedCenter.updateHotKey(hotkey)
                self.currentModalDelegate!.respondsToSelector("keyComboPanelEnded")
                self.currentModalDelegate!.keyComboPanelEnded(self)
            }
        })
    }
    
    func runModalForHotKey(hotkey: HotKeyVariable) {
        
        self.keyCombo = hotkey.KeyCombo
        self.KeyBindingName = hotkey.name
        let resultCode = NSApp.runModalForWindow(self.window!)
        self.window?.orderOut(self)
        
        if resultCode == NSModalResponseOK {
            hotkey.KeyCombo = self.keyCombo!
            HotKeyCaptureCenter.sharedCenter.updateHotKey(hotkey)
        }
    }
    
    @IBAction func ok(sender: NSButton) {
        if mWindow.modalPanel {
            NSApp.stopModalWithCode(NSModalResponseOK)
        } else {
            mWindow.endSheet((sender as NSButton).window!, returnCode: NSModalResponseOK)
        }
    }
    
    @IBAction func cancel(sender: NSButton) {
        if mWindow.modalPanel {
            NSApp.stopModalWithCode(NSModalResponseCancel)
        } else {
            mWindow.endSheet((sender as NSButton).window!, returnCode: NSModalResponseCancel)
        }
    }
    
    @IBAction func clear(sender: NSButton) {
        self.keyCombo = HotKeyCombo.clearKeyCombo()
        if mWindow.modalPanel {
            NSApp.stopModalWithCode(NSModalResponseOK)
        }
    }
    
    func noteKeyBroadcast(notification: NSNotification) {
        self.keyCombo = notification.userInfo!["keyCombo"] as? HotKeyCombo
    }
    
}