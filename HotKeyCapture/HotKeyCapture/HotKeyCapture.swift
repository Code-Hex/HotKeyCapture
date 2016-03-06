//
//  HotKeyCapture.swift
//  HotKeyCapture
//
//  Created by CodeHex on 2016/02/20.
//  Copyright © 2016年 CodeHex. All rights reserved.
//

import Carbon

class HotKeyCapture {
    private var _Name = ""
    private var _Action = ""
    private var _Target: AnyObject?
    private var _KeyCombo = HotKeyCombo.clearKeyCombo()

    var _carbonHotKey = EventHotKeyRef()

    var name: String {
        get {
            return _Name
        }
        
        set(n) {
            _Name = n
        }
    }
    
    var target: AnyObject {
        get {
            return _Target!
        }
        
        set(t) {
            _Target = t
        }
        
    }
    var action: String {
        get {
            return _Action
        }
        
        set(a) {
            _Action = a
        }
    }
    
    var KeyCombo: HotKeyCombo {
        get {
            return _KeyCombo
        }
        
        set(combo) {
            _KeyCombo = combo
        }
    }
    
    var carbonHotKey: EventHotKeyRef {
        get {
            return _carbonHotKey
        }
        
        set(chkey) {
            _carbonHotKey = chkey
        }
    }
    
    func invoke() {
        target.performSelector(Selector(action), withObject: self)
    }
    
    
}
