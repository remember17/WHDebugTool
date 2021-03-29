
    Pod::Spec.new do |s|

    s.name        = "WHDebugTool"

    s.version      = "2.2"

    s.summary      = "Debug tool for iOS"

    s.homepage    = "https://github.com/remember17/WHDebugTool"

    s.license      = "MIT"

    s.author      = { "wuhao" => "503007958@qq.com" }

    s.platform    = :ios, "8.0"

    s.source      = { :git => "https://github.com/remember17/WHDebugTool.git", :tag => s.version }

    s.source_files  = "WHDebugTool", "WHDebugTool/*.{h,m}"

    s.framework  = "UIKit"

    s.requires_arc = true

    end
