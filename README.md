# HotKeyCapture
This is a sandboxed of custom global hotkeys in Swift using HotKeyCapture
## About
HotKeyCapture is an easy to use Cocoa class for registering an application to respond to system key events, or "hotkeys".  
A global hotkey is a key combination that always executes a specific action, regardless of which app is frontmost. For example, the Mac OS X default hotkey of "command-space" shows the Spotlight search bar, even if Finder is not the frontmost application.  
##Usage
If using cocoapods, lucky!! that easy.  
To prepare Podfile and like this in Podfile:  
```
platform :osx, '10.10'
use_frameworks!

pod 'HotKeyCapture', :git => 'https://github.com/Code-Hex/HotKeyCapture.git'
```
and run  
```
pod install
```
If you don't use cocoapods, you can prepare these files. 
- HotKeyCapture.xcodeproj,
- HotKeyCapture
  - HotKeyCapture.h
  - HotKeyCapture.swift
  - HotKeyCaptureCenter.swift
  - HotKeyCombo.swift
  - HotKeyVariable.swift
  - Info.plist // Maybe unnecessary...
and these files into your project.  

###class HotKeyCapture
```
var appActivationKeyCombo: HotKeyCombo { get }
```
Get activation HotKeyCombo instance.  
```
func setAppActivationKeyCombo(aCombo: HotKeyCombo)
```
if want to active to HotKeyCombo instance, use this.  
```
func getActivationHotKey() -> HotKeyVariable
```
Get activation HotKeyVariable instance.  
```
func getActivationKeyCombo() -> HotKeyCombo
```
Get HotKeyVariable instance while set some HotKeyVariable instance variable  
```
func registerMethodWithTarget(target target: AnyObject, method: String) -> Bool
func registerMethodWithTarget(target target: AnyObject, method: String, afterDelay: NSTimeInterval) -> Bool
```
This method able to register "method called by hotkey" using target and method string.  
```
func registerBlock(block block: ()->Void) -> Bool
func registerBlock(block block: ()->Void, afterDelay: NSTimeInterval) -> Bool
```
This method able to register "method called by hotkey" using closure.  
###class HotKeyVariable

```
var name: String // registration key for hotkey
var target: AnyObject // target for performselector etc...
var action: String // method name
var KeyCombo: HotKeyCombo
var carbonHotKey: EventHotKeyRef
var delay: NSTimeInterval

var completion: () -> Void = {}
```
These variables are going to use when extension.  
```
func invoke()
```
This method is run registration method.
###class HotKeyCaptureCenter
```
class var sharedCenter: HotKeyCaptureCenter
```
If you want to use without initialization.
```
func registerHotKey(hotKey: HotKeyVariable) -> Bool
func unregisterHotKey(hotKey: HotKeyVariable)
func unregisterHotKeyForName(name: String)
func updateHotKey(hk: HotKeyVariable)
func unregisterAllHotKeys() // I don't think to use to anything
```
These methods are going to use when extension or wrapper  
###class HotKeyCombo
```
var keyCode: Int { get }
var modifiers: Int { get }
```
Get keyCode or modifiers.
```
func isValidHotKeyCombo() -> Bool
func isClearCombo() -> Bool // same is reset?
```
As the name.
```
class func clearKeyCombo() -> HotKeyCombo
```
Return cleared HotKeyCombo instance.  
```
class func keyComboWithKeyCode(keyCode keyCode: Int, modifiers: Int) -> HotKeyCombo
```
Initialized with the set parameters.  
```
class func stringForCombo(modifiers modifiers: Int, keyCode: Int) -> String
```
Return string by set combo.  
```
class var keyCodesDictionary: [String:String]
```
Return keyCodesDictionary. see source code.  
```
var description: String { get }
```
Return convert keyCode to string + modifiers to string. like "⌘⌥K" etc
