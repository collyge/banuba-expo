import ExpoModulesCore
import BanubaVideoEditorSDK
import BanubaUtilities
import Foundation

public class ExpoBanubaReactDelegateHandler: ExpoReactDelegateHandler, MusicEditorExternalViewControllerFactory {
    var audioBrowserModule: AudioBrowserModule?
    
    public func closeAudioBrowser () {
        audioBrowserModule?.onClose()
    }
    
    public func selectAudio(selectedAudio: SelectedAudio) {
        audioBrowserModule?.selectAudio(selectedAudio: selectedAudio)
    }

    public func makeTrackSelectionViewController(selectedAudioItem: AudioItem?, isAudioPartSelectionEnabled: Bool) -> TrackSelectionViewController? {
      let module = AudioBrowserModule(nibName: nil, bundle: nil)
      audioBrowserModule = module
      return module
    }

    // Effects selection view controller. Used at Music editor screen
    public func makeEffectSelectionViewController(selectedAudioItem: AudioItem?) -> EffectSelectionViewController? {
      return nil
    }

    // Returns recorder countdown view for voice recorder screen
    public func makeRecorderCountdownAnimatableView() -> MusicEditorCountdownAnimatableView? {
      return nil
    }
}
