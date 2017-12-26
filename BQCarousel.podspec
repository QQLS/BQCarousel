Pod::Spec.new do |s|
  s.name         = "BQCarousel"
  s.version      = "0.0.1"
  s.summary      = "A infinite carousel control use three UIImageView only."
  s.homepage     = "https://github.com/QQLS/BQCarousel"
  s.license      = "MIT"
  s.author             = { "QQLS" => "702166055@qq.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/QQLS/BQCarousel.git", :tag => s.version }
  s.source_files  = "BQCarousel"
  s.requires_arc = true
  s.dependency "SDWebImage"
end
