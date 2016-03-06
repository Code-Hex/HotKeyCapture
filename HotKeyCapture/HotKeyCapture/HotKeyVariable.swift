//
//  HotKeyCapture.swift
//  HotKeyCapture
//
//  Created by CodeHex on 2016/02/20.
//  Copyright © 2016年 CodeHex. All rights reserved.
//

import Carbon

class HotKeyVariable {
    private var _Name = ""
    private var _Action = ""
    private var _delay: NSTimeInterval = 0
    private var _Target: AnyObject?
    private var _KeyCombo = HotKeyCombo.clearKeyCombo()
    private var _carbonHotKey = EventHotKeyRef()
    
    var completion: () -> Void = {}

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
    
    var delay: NSTimeInterval {
        get {
            return _delay
        }
        
        set(d) {
            _delay = d
        }
    }
    
    func invoke() {
        if action == "" {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay)), dispatch_get_main_queue(), completion)
        } else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay)), dispatch_get_main_queue(), {
                self.target.performSelector(Selector(self.action), withObject: self)
            })
        }
    }
    
    
}
