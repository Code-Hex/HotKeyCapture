Pod::Spec.new do |s|
  s.name         = "HotKeyCapture"
  s.version      = "0.0.1"
  s.summary      = "This is a sandboxed of custom global hotkeys in Swift using HotKeyCapture"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.homepage     = "https://github.com/Code-Hex/HotKeyCapture"
  s.author       = { "CodeHex" => "x00.x7f@gmail.com" }
  s.source       = { :git => "https://github.com/Code-Hex/HotKeyCapture.git", :tag => s.version }
  s.platform     = :osx, '10.10'
  s.source_files = 'HotKeyCapture/**/*.{h,swift}'
end
