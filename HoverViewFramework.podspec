Pod::Spec.new do |s|
  s.name = 'HoverViewFramework'
  s.version = '1.0.3'
  s.license = 'MIT'
  s.summary = 'New revolutionnary bubble component'
  s.homepage = 'https://github.com/ndennu/HoverView'
  s.authors = { 'groupe1' => 'rjeyaksan@outlook.fr' }
  s.source = { :git => 'https://github.com/ndennu/HoverView.git', :tag => s.version }

  s.ios.deployment_target = '9.0'

  s.source_files = 'HoverView/*.swift'
end
