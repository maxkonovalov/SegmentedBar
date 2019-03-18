Pod::Spec.new do |s|

  s.name             = 'SegmentedBar'
  s.version          = '0.1.0'
  s.summary          = 'Segmented Bar'
  s.description      = <<-DESC
Customizable UISegmentedControl-like bar.
                       DESC

  s.homepage         = 'https://github.com/maxkonovalov/SegmentedBar'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Max Konovalov' => 'konovalovmy@gmail.com' }
  s.source           = { :git => 'https://github.com/maxkonovalov/SegmentedBar.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'SegmentedBar/**/*.swift'
  
end
