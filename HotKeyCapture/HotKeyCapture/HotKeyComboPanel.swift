//
//  HotKeyComboPanel.swift
//  HotKeyCapture
//
//  Created by CodeHex on 2016/02/20.
//  Copyright © 2016年 CodeHex. All rights reserved.
//

import Cocoa

class HotKeyComboPanel: NSWindowController {

    var mTitleFormat = String()
    var mKeyName = String()

    required init?(coder: NSCoder) {
        mTitleFormat = "empty"
        mKeyName = "empty"
        fatalError("init(coder:) has not been implemented")
    }
    
    override func windowDidLoad() {
        
    }
}