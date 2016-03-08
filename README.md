# HotKeyCapture
This is a sandboxed of custom global hotkeys in Swift using HotKeyCapture
## About
HotKeyCapture is an easy to use Cocoa class for registering an application to respond to system key events, or "hotkeys".  
A global hotkey is a key combination that always executes a specific action, regardless of which app is frontmost. For example, the Mac OS X default hotkey of "command-space" shows the Spotlight search bar, even if Finder is not the frontmost application.  
##Usage
###class HotKeyCapture
```
var appActivationKeyCombo: HotKeyCombo { get }

Discussion
Get activation HotKeyCombo instance.

func setAppActivationKeyCombo(aCombo: HotKeyCombo)

Discussion
if want to active to HotKeyCombo instance, use this.

func getActivationHotKey() -> HotKeyVariable

Discussion
Get activation HotKeyVariable instance.

func getActivationKeyCombo() -> HotKeyCombo

Discussion
Get HotKeyVariable instance while set some HotKeyVariable instance variable

func registerMethodWithTarget(target target: AnyObject, method: String) -> Bool
func registerMethodWithTarget(target target: AnyObject, method: String, afterDelay: NSTimeInterval) -> Bool

Discussion
This method able to register "method called by hotkey" using target and method string.

func registerBlock(block block: ()->Void) -> Bool
func registerBlock(block block: ()->Void, afterDelay: NSTimeInterval) -> Bool

Discussion
This method able to register "method called by hotkey" using closure.
```
