# Uncomment this line to define a global platform for your project
platform :osx, '10.11'
# Uncomment this line if you're using Swift
use_frameworks!

def shared_pods
  pod 'CocoaLumberjack'
end

def testing_pods
  pod 'Quick', '~> 0.8'
  pod 'Nimble', '~> 3.0.0'
  pod 'OCMock', '~> 2.2'
end

target 'GitMenu' do
end

target 'GitMenuTests' do
  shared_pods
  testing_pods
end

target 'GitFinderMenu' do
end

target 'GMUDataModel' do
  shared_pods
end

target 'GMUDataModelTests' do
  shared_pods
  testing_pods
end


#  vim: set ts=8 sw=2 tw=0 ft=ruby et :
