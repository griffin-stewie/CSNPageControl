Pod::Spec.new do |s|
  s.name         = "CSNPageControl"
  s.version      = "0.0.1"
  s.summary      = "Drop in replace of UIPageControl"
  s.homepage     = "https://github.com/griffin-stewie/CSNPageControl"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "griffin-stewie" => "panterathefamilyguy@gmail.com" }
  s.social_media_url = "http://twitter.com/griffin_stewie"
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/griffin-stewie/CSNPageControl.git", :commit => "bd652b41a80a1b8bba30899e7eb2bb2841520612" }
  s.source_files  = "CSNPageControl"
  s.requires_arc = true
end
