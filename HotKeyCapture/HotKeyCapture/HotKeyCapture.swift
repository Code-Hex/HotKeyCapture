//
//  HotKeyCapture.swift
//  HotKeyCapture
//
//  Created by CodeHex on 2016/02/20.
//  Copyright © 2016年 CodeHex. All rights reserved.
//

import Carbon

class HotKeyCapture: NSObject {
    var mName = String()
    var mTarget: AnyObject?
    var mAction = String()
    var mKeyCombo: HotKeyCombo?
    var _carbonHotKey: EventHotKeyRef?
    
    override init() {
        super.init()
        self.KeyCombo = HotKeyCombo.clearKeyCombo()
    }

    
    var name: String {
        get {
            return mName
        }
        
        set(n) {
            mName = n
        }
    }
    
    var target: AnyObject {
        get {
            return mTarget!
        }
        
        set(t) {
            mTarget = t
        }
        
    }
    var action: String {
        get {
            return mAction
        }
        
        set(a) {
            mAction = a
        }
    }
    
    var KeyCombo: HotKeyCombo {
        get {
            return mKeyCombo!
        }
        
        set(combo) {
            mKeyCombo = combo
        }
    }
    
    var carbonHotKey: EventHotKeyRef {
        get {
            return _carbonHotKey!
        }
        
        set(chkey) {
            _carbonHotKey = chkey
        }
    }
    
    func invoke() {
        mTarget?.performSelector(Selector(mAction), withObject: self)
    }
    
    
}
