# Uncomment the next line to define a global platform for your project
platform :ios, '14.2'

target 'RavenTest' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for RavenTest
  pod 'ConnectionLayer', '0.0.3'
  pod 'lottie-ios', '4.2.0'
  pod 'SwiftMessages'
  target 'RavenTestTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'RavenTestUITests' do
    # Pods for testing
  end
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.2'
      end
    end
  end

end
