
  Pod::Spec.new do |s|
    s.name = 'CapacitorVoip'
    s.version = '0.0.2'
    s.summary = 'Plugin to receive iOS voip notifications'
    s.license = 'MIT'
    s.homepage = 'https://github.com/okode/capacitor-voip'
    s.author = 'Okode'
    s.source = { :git => 'https://github.com/okode/capacitor-voip', :tag => s.version.to_s }
    s.source_files = 'ios/Plugin/**/*.{swift,h,m,c,cc,mm,cpp}'
    s.ios.deployment_target  = '11.0'
    s.dependency 'Capacitor'
  end