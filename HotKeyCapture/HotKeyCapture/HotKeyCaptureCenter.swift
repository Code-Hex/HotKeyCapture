//
//  HotKeyCaptureCenter.swift
//  HotKeyCapture
//
//  Created by CodeHex on 2016/02/20.
//  Copyright © 2016年 CodeHex. All rights reserved.
//

import Carbon

class HotKeyCaptureCenter {
    
    var mHotKeys = NSMutableDictionary()
    var mHotKeyMap = NSMutableDictionary()
    var mNextKeyID: UInt32 = 1
    
    var EventHandlerInstalled = false
    
    class var sharedCenter: HotKeyCaptureCenter {
        struct Shared {
            static let instance = HotKeyCaptureCenter()
        }
        return Shared.instance
    }
    
    // Attention
    // if this method is success, return false
    func registerHotKey(hotKey: HotKeyVariable) -> Bool {
        var hotKeyID = EventHotKeyID()
        var carbonHotKey = EventHotKeyRef()
        
        if hotKey.KeyCombo.isValidHotKeyCombo() == false {
            return false
        }
        
        hotKeyID.signature = UTGetOSTypeFromString("PTHk")
        hotKeyID.id = mNextKeyID
        let err = RegisterEventHotKey(UInt32(hotKey.KeyCombo.keyCode), UInt32(hotKey.KeyCombo.modifiers), hotKeyID, GetEventDispatcherTarget(), 0, &carbonHotKey)
        
        if err != 0 {
            return true
        }

        let kid = UInt(mNextKeyID)
        mHotKeyMap.setObject(hotKey, forKey: kid)
        mNextKeyID++
       
        hotKey.carbonHotKey = carbonHotKey

        mHotKeys.setObject(hotKey, forKey: hotKey.name)
        self.updateEventHandler()
        
        return false
    }
    
    func unregisterHotKey(hotKey: HotKeyVariable) {
        if (mHotKeys.objectForKey(hotKey.name) != nil) {
            let carbonHotKey = hotKey.carbonHotKey
            assert(carbonHotKey != nil, "");
            UnregisterEventHotKey(carbonHotKey)
            mHotKeys.removeObjectForKey(hotKey.name)
            
            let allKeys = mHotKeyMap.allKeysForObject(hotKey)
            if allKeys.count > 0 {
                mHotKeyMap.removeObjectsForKeys(allKeys)
            }
            
            self.updateEventHandler()
        }
    }
    
    func unregisterHotKeyForName(name: String) {
        self.unregisterHotKey(hotKeyForName(name))
    }
    
    func updateHotKey(hk: HotKeyVariable) {
        self.unregisterHotKey(hotKeyForName(hk.name))
        self.registerHotKey(hk)
    }
    
    private func unregisterAllHotKeys() {
        let enu = mHotKeys.objectEnumerator()
        while let thing = enu.nextObject() {
            self.unregisterHotKey(thing as! HotKeyVariable)
        }
    }
    
    private func setHotKeyRegistrationForName(name: String, ok: Bool) {
        if ok {
            self.registerHotKey(hotKeyForName(name))
        } else {
            self.unregisterHotKey(hotKeyForName(name))
        }
    }
    
    private func hotKeyForName(name: String) -> HotKeyVariable {
        return mHotKeys.objectForKey(name) != nil ?
            mHotKeys.objectForKey(name) as! HotKeyVariable
            : HotKeyVariable()
    }
    
    private func updateEventHandler() {
        if EventHandlerInstalled == false {
            var eventType = EventTypeSpec()
            eventType.eventClass = OSType(kEventClassKeyboard)
            eventType.eventKind = OSType(kEventHotKeyPressed)
            InstallEventHandler(GetEventDispatcherTarget(), {
                (nextHanlder, inEvent, userData) -> OSStatus in
                return HotKeyCaptureCenter.sharedCenter.sendCarbonEvent(inEvent)
            }, 1, &eventType, nil, nil)
            
            EventHandlerInstalled = true
        }
    }
    
    
    private func sendCarbonEvent(event: EventRef) -> OSStatus {
        
        assert(Int(GetEventClass(event)) == kEventClassKeyboard, "HotKeyCaptureCenter: Unknown event class")
        var hotkeyID = EventHotKeyID()
        let err = GetEventParameter(event, EventParamName(kEventParamDirectObject), EventParamType(typeEventHotKeyID), nil, sizeof(EventHotKeyID), nil, &hotkeyID)
        
        if err != 0 {
            return err
        }

        assert(hotkeyID.signature == UTGetOSTypeFromString("PTHk"), "HotKeyCaptureCenter: Invalid hot key id")
        let kid = UInt(hotkeyID.id)
        let hotkey = mHotKeyMap.objectForKey(kid) as? HotKeyVariable

        switch(GetEventKind(event)) {
            case EventParamName(kEventHotKeyPressed):
                self.hotkeyDown(hotkey!)
                break;
            default:
                assert(false, "HotKeyCaptureCenter: Unknown event kind");
        }
        return noErr
    }
    
    private func hotkeyDown(hotkey: HotKeyVariable) {
        hotkey.invoke()
    }
    
}
