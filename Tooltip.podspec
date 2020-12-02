
Pod::Spec.new do |spec|

  spec.name         = "Tooltip"
  spec.version      = "1.0.2"
  spec.summary      = "Tooltip is a customized version of EasyTipView"
  spec.description  = "This is a customized tooltip which used in Rivers.im app"
  spec.homepage     = "https://github.com/shayanaghajan/Tooltip.git"
  spec.license      = "MIT"
  spec.author       = "Shayan Aghajan"
  spec.platform     = :ios, "11.0"
  spec.source       = { :git => "https://github.com/shayanaghajan/Tooltip.git", :tag => "spec.version" }
  spec.source_files  = "Tooltip"
  spec.dependency    "EasyTipView", "~> 2.0.4"
  spec.swift_version = "5" 

end
