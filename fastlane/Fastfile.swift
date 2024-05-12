// This file contains the fastlane.tools configuration
// You can find the documentation at https://docs.fastlane.tools
//
// For a list of all available actions, check out
//
//     https://docs.fastlane.tools/actions
//

import Foundation

class Fastfile: LaneFile {
	func testsLane() {
        desc("UI and Unit tests lane")
        scan(devices: .userDefined(["iPhone 11", "iPhone X"]))
	}
}
