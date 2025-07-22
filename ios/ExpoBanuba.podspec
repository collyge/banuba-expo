require 'json'

package = JSON.parse(File.read(File.join(__dir__, '..', 'package.json')))

Pod::Spec.new do |s|
  s.name           = 'ExpoBanuba'
  s.version        = package['version']
  s.summary        = package['description']
  s.description    = package['description']
  s.license        = package['license']
  s.author         = package['author']
  s.homepage       = package['homepage']
  s.platform       = :ios, '14.0'
  s.swift_version  = '5.4'
  s.source         = { git: 'https://github.com/collyge/banuba-expo' }
  s.static_framework = true

  s.source_files = "**/*.{h,m,swift}"

  # Swift/Objective-C compatibility
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'SWIFT_COMPILATION_MODE' => 'wholemodule'
  }

  # Dependencies
  s.dependency 'ExpoModulesCore'

  sdk_version = '1.45.1'
  s.dependency 'BanubaVideoEditorSDK', sdk_version
  s.dependency 'BanubaSDKSimple', sdk_version
  s.dependency 'BanubaSDK', sdk_version
  s.dependency 'BanubaARCloudSDK', sdk_version      # optional
  s.dependency 'BanubaAudioBrowserSDK', sdk_version # optional

  s.dependency 'BanubaPhotoEditorSDK', '1.2.9'
end