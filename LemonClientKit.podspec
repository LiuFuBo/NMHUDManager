Pod::Spec.new do |s|
  s.name         = "LemonClientKit" 
  s.summary      = "LemonClientKit" 
  s.homepage     = "https://github.com/biggercoffee/ZXPAutoLayout" 
  s.license      = "MIT"  
  s.author             = { "xiaoping" => "z_xiaoping@163.com" } 
  s.social_media_url   = "http://xiaopingblog.cn/" 
  s.platform     = :ios, "8.0"   
  s.source       = { :git => "http://120.26.226.7:10101/r/LemonClientKit.git"}
  s.source_files  = "LemonClientKit/**/*"
  s.requires_arc = true 
  s.dependency 'SVProgressHUD'
  s.dependency 'ZXPAutoLayout'
  s.dependency 'MBProgressHUD'
end