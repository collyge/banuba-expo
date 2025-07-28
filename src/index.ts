import { Platform } from "react-native";
import type { FeaturesConfig } from "./FeaturesConfig";
import type { ExportData } from "./ExportData";

export * from "./FeaturesConfig";
export * from "./ExportData";

import ExpoBanubaModule from './ExpoBanubaModule'

export async function openFromCamera(
	licenseToken: String,
	featuresConfig: FeaturesConfig,
	exportData?: ExportData | null
): Promise<Map<String, String>> {
	const inputParams = {
		screen: "camera",
		featuresConfig: JSON.stringify(featuresConfig),
		exportData: JSON.stringify(exportData),
	};
	return Platform.OS === "ios"
		? ExpoBanubaModule.openVideoEditor(
				licenseToken,
				inputParams
		  )
		: ExpoBanubaModule.openVideoEditor(licenseToken, inputParams);
}