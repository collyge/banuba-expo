import { NativeModule, requireNativeModule } from "expo-modules-core";
import { ConfigPlugin } from "@expo/config-plugins";

export type BanubaPluginProps = {
	android: {
		assetsPath: string;
	};
	ios: {
		assetsPath: string;
	};
};

declare class ExpoNativeConfigurationModule extends NativeModule {
	withBanuba(): ConfigPlugin<BanubaPluginProps>;
}

export default requireNativeModule<ExpoNativeConfigurationModule>("ExpoBanuba");
