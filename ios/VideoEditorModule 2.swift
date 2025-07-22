import AVKit
import BanubaAudioBrowserSDK
import BanubaPhotoEditorSDK
import BanubaVideoEditorCore
import BanubaVideoEditorSDK
import BanubaUtilities
import Foundation
import ExpoModulesCore
import React
import UIKit

// Adopting CountdownView to use in BanubaVideoEditorSDK
extension CountdownView: MusicEditorCountdownAnimatableView {}

class VideoEditorModule: NSObject, BanubaVideoEditorDelegate {

  var videoEditorSDK: BanubaVideoEditor?

  var isVideoEditorInitialized: Bool { videoEditorSDK != nil }
  var viewControllerFactory = ViewControllerFactory()

  init(token: String, giphyApiKey: String) {
    super.init()
    let config = createVideoEditorConfiguration(giphyApiKey: giphyApiKey)

    videoEditorSDK = BanubaVideoEditor(
      token: token,
      arguments: [.useEditorV2: true],
      configuration: config,
      externalViewControllerFactory: viewControllerFactory
    )

    // Set delegate
    videoEditorSDK?.delegate = self
  }

  func presentVideoEditor(with launchConfig: VideoEditorLaunchConfig) {
    guard let editor = videoEditorSDK else {
      print("BanubaVideoEditor is not initialized!")
      return
    }
    editor.presentVideoEditor(
      withLaunchConfiguration: launchConfig,
      completion: nil
    )
  }

  func createExportConfiguration(destFile: URL) -> ExportConfiguration {
    let exportVideoConfigurations: [ExportVideoConfiguration] = [
      ExportVideoConfiguration(
        fileURL: destFile,
        quality: .auto,
        useHEVCCodecIfPossible: true,
        watermarkConfiguration: nil
      )
    ]

    let exportConfiguration = ExportConfiguration(
      videoConfigurations: exportVideoConfigurations,
      isCoverEnabled: true,
      gifSettings: GifSettings(duration: 0.3)
    )

    return exportConfiguration
  }

  func createProgressViewController() -> ProgressViewController {
    let progressViewController = ProgressViewController.makeViewController()
    progressViewController.message = "Exporting"
    return progressViewController
  }

  static func createVideoEditorConfiguration(giphyApiKey: String) -> VideoEditorConfig {
    var config = VideoEditorConfig()
    config.gifPickerConfiguration.giphyAPIKey = giphyApiKey
    config.musicEditorConfiguration.mainMusicViewControllerConfig.tracksLimit = 1

    config.setupColorsPalette(
      VideoEditorColorsPalette(
        primaryColor: .white,
        secondaryColor: .black,
        accentColor: .white,
        effectButtonColorsPalette: EffectButtonColorsPalette(
          defaultIconColor: .white,
          defaultBackgroundColor: .clear,
          selectedIconColor: .black,
          selectedBackgroundColor: .white
        ),
        addGalleryItemBackgroundColor: .white,
        addGalleryItemIconColor: .black,
        timelineEffectColorsPalette: TimelineEffectColorsPalette.default
      )
    )

    var featureConfiguration = config.featureConfiguration
    featureConfiguration.supportsTrimRecordedVideo = true
    featureConfiguration.isMuteCameraAudioEnabled = true
    config.updateFeatureConfiguration(featureConfiguration: featureConfiguration)

    return config
  }

  func videoEditorDone(_ videoEditor: BanubaVideoEditor) {
    videoEditor.dismissVideoEditor(animated: true)
  }

  func videoEditorDidCancel(_ videoEditor: BanubaVideoEditor) {
    print("Editor canceled")
    videoEditor.dismiss(animated: true, completion: nil)
  }

  func videoEditor(_ videoEditor: BanubaVideoEditor, didFinishWithVideoAt url: URL) {
    print("Saved in: \(url)")
    videoEditor.dismiss(animated: true, completion: nil)
  }
}

class AudioBrowserModule: UIViewController, TrackSelectionViewController, RCTBridgeModule {
  weak var trackSelectionDelegate: TrackSelectionViewControllerDelegate?

  static func moduleName() -> String! {
    return "expo_banuba_audio_browser"
  }

  static func requiresMainQueueSetup() -> Bool {
    return true
  }

  func onClose() {
    DispatchQueue.main.async {
      self.trackSelectionDelegate?.trackSelectionViewControllerDidCancel(viewController: self)
    }
  }

  func selectAudio(selectedAudio: SelectedAudio) {
    let uuid = UUID()
    let asset = AVURLAsset(url: selectedAudio.url)
    DispatchQueue.main.async {
      self.trackSelectionDelegate?.trackSelectionViewController(
        viewController: self,
        didSelectFile: selectedAudio.url,
        coverURL: nil,
        timeRange: CMTimeRange(
          start: .zero,
          duration: asset.duration
        ),
        isEditable: true,
        title: selectedAudio.musicName,
        additionalTitle: selectedAudio.artistName,
        uuid: uuid)
    }
    print("Audio track is applied!")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    let bridge = RCTBridge.current()
    if let bridge = bridge {
      self.view = RCTRootView(
        bridge: bridge,
        moduleName: AudioBrowserModule.moduleName(),
        initialProperties: nil
      )
    }
  }
}

class ViewControllerFactory: ExternalViewControllerFactory {
  var musicEditorFactory: MusicEditorExternalViewControllerFactory? = ExpoBanubaReactDelegateHandler()
  var countdownTimerViewFactory: CountdownTimerViewFactory?
  var exposureViewFactory: AnimatableViewFactory?
}
