//
//  AppDelegate.swift
//  HotKeyCapture
//
//  Created by CodeHex on 2016/02/20.
//  Copyright © 2016年 CodeHex. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {

    @IBOutlet weak var window: NSWindow!

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        NSEvent.addGlobalMonitorForEventsMatchingMask(.KeyDownMask, handler: { (theEvent) -> Void in
            print(theEvent)
        })
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
        
    }

}

