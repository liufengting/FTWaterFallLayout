
Pod::Spec.new do |s|

  s.name         = "FTWaterFallLayout"
  s.version      = "0.0.3"
  s.summary      = "Water fall layout for collection view"
  s.description  = <<-DESC
    	FTWaterFallLayout. Water fall layout for collection view.
                   DESC
  s.homepage     = "https://github.com/liufengting/FTWaterFallLayout"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author		 = { "liufengting" => "wo157121900@me.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/liufengting/FTWaterFallLayout.git", :tag => "#{s.version}" }
  s.source_files = ["FTWaterFallLayout/*.swift"]

end
