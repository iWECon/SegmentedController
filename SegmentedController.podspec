Pod::Spec.new do |s|

    s.name = 'SegmentedController'
    s.version = '2.1.2'
    s.license = { :type => 'MIT' }
    s.homepage = 'https://github.com/iWECon/SegmentedController'
    s.authors = 'iWw'
    s.ios.deployment_target = '10.0'
    s.summary = 'SegmentedController'
    s.source = { :git => 'https://github.com/iWECon/SegmentedController.git', :tag => s.version }
    s.source_files = [
        'Sources/**/*.swift',
    ]
    
    s.cocoapods_version = '>= 1.10.0'
    s.swift_version = ['5.3']
    
    # dependencies
    # for https://github.com/iWECon
    s.dependency 'Pager'
    s.dependency 'Segmenter'
    
end


