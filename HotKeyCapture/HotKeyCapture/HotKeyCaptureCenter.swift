//
//  HotKeyCaptureCenter.swift
//  HotKeyCapture
//
//  Created by CodeHex on 2016/02/20.
//  Copyright © 2016年 CodeHex. All rights reserved.
//

import Carbon

class HotKeyCaptureCenter: NSObject {
    
    var mHotKeys = NSMutableDictionary()
    var mHotKeyMap = NSMutableDictionary()
    var mNextKeyID: UInt32 = 1
    
    var mEventHandlerInstalled = false
    
    class var sharedCenter: HotKeyCaptureCenter {
        struct Shared {
            static let instance = HotKeyCaptureCenter()
        }
        return Shared.instance
    }
    
    override init() {
        super.init()
        mNextKeyID = 1
    }
    
    func registerHotKey(hotKey: HotKeyCapture) -> Bool {
        var err: OSStatus?
        var hotKeyID = EventHotKeyID()
        var carbonHotKey = EventHotKeyRef()
        
        if hotKey.KeyCombo.isValidHotKeyCombo() == false {
            return true
        }
        
        hotKeyID.signature = UTGetOSTypeFromString("PTHk")
        hotKeyID.id = mNextKeyID
        err = RegisterEventHotKey(hotKey.KeyCombo.keyCode(), hotKey.KeyCombo.modifiers(), hotKeyID,GetEventDispatcherTarget(), 0, &carbonHotKey)
        
        if err != 0 {
            return false
        }
        
        let kid = UInt(mNextKeyID)
        mHotKeyMap.setObject(hotKey, forKey: kid)
        mNextKeyID++
       
        hotKey.carbonHotKey = carbonHotKey
        NSLog(hotKey.name)
        mHotKeys.setObject(hotKey, forKey: hotKey.name)
        self.updateEventHandler()
        
        return true
    }
    
    func unregisterHotKey(hotKey: HotKeyCapture) {
        if (mHotKeys.objectForKey(hotKey.name) == nil) {
            let carbonHotKey = hotKey.carbonHotKey

            UnregisterEventHotKey(carbonHotKey)
            mHotKeys.removeObjectForKey(hotKey.name)
            
            let a = mHotKeyMap.allKeysForObject(hotKey)
            if a.count > 0 {
                mHotKeyMap.removeObjectsForKeys(a)
            }
            
            self.updateEventHandler()
        }
    }
    
    func unregisterHotKeyForName(name: String) {
        self.unregisterHotKey(hotKeyForName(name))
    }
    
    func unregisterAllHotKeys() {
        let enu = mHotKeys.objectEnumerator()
        while let thing = enu.nextObject() {
            self.unregisterHotKey(thing as! HotKeyCapture)
        }
    }
    
    func setHotKeyRegistrationForName(name: String, ok: Bool) {
        if ok {
            self.registerHotKey(hotKeyForName(name))
        } else {
            self.unregisterHotKey(hotKeyForName(name))
        }
    }
    
    func updateHotKey(hk: HotKeyCapture) {
        self.unregisterHotKey(hotKeyForName(hk.name))
        self.registerHotKey(hk)
    }
    
    private func hotKeyForName(name: String) -> HotKeyCapture {
        return mHotKeys.objectForKey(name) != nil ?
            mHotKeys.objectForKey(name) as! HotKeyCapture
            : HotKeyCapture()
    }
    
    func updateEventHandler() {
        if mHotKeyMap.count == 0 && mEventHandlerInstalled == false {
            var eventType = EventTypeSpec()
            eventType.eventClass = OSType(kEventClassKeyboard)
            eventType.eventKind = OSType(kEventHotKeyPressed)
            InstallEventHandler(GetEventDispatcherTarget(), {
                (nextHanlder, inEvent, userData) -> OSStatus in
                return HotKeyCaptureCenter.sharedCenter.sendCarbonEvent(inEvent)
            }, 1, &eventType, nil, nil)
            
            mEventHandlerInstalled = true
        }
    }
    
    
    func sendCarbonEvent(event: EventRef) -> OSStatus {
        var hotkey: HotKeyCapture?
        
        assert(Int(GetEventClass(event)) == kEventClassKeyboard, "Unknown event class")
        var hotkeyID = EventHotKeyID()
        let err = GetEventParameter(event, EventParamName(kEventParamDirectObject), EventParamType(typeEventHotKeyID), nil, sizeof(EventHotKeyID), nil, &hotkeyID)
        
        if err != 0 {
            return err
        }
        
        assert(hotkeyID.signature == UTGetOSTypeFromString("PTHk"), "Invalid hot key id")
        let kid = UInt(hotkeyID.id)
        hotkey = mHotKeyMap.objectForKey(kid) as? HotKeyCapture

        switch(GetEventKind(event)) {
            case EventParamName(kEventHotKeyPressed):
                self.hotkeyDown(hotkey!)
                break;
            default:
                assert(false, "Unknown event kind");
        }
        return noErr
    }
    
    private func hotkeyDown(hotkey: HotKeyCapture) {
        hotkey.invoke()
    }
    
}
