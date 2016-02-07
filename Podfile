# Uncomment this line to define a global platform for your project
platform :osx, '10.11'
# Uncomment this line if you're using Swift
use_frameworks!

abstract_target 'Git' do
  pod 'CocoaLumberjack', inhibit_warnings: true

  target 'GitMenu' do
  end

  target 'GitMenuTests' do
    inherit! :search_paths
    pod 'Quick', '~> 0.8'
    pod 'Nimble', '~> 3.0.0'
    pod 'OCMock', '~> 2.2'
  end

  target 'GMUDataModelTests' do
    inherit! :search_paths
    pod 'Quick', '~> 0.8'
    pod 'Nimble', '~> 3.0.0'
    pod 'OCMock', '~> 2.2'
  end

  target 'GitFinderMenu' do
  end

  target 'GMUDataModel' do
  end
end

#  vim: set ts=8 sw=2 tw=0 ft=ruby et :
