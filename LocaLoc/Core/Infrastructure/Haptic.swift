//
//  Haptic.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 10/7/24.
//

import UIKit
import CoreHaptics
import AudioToolbox
import AVFAudio

enum HapticStyle {
    case rigid, soft, light, medium, heavy
    case error, success, warning
    case selectionChanged
}

struct Haptic {
    private static var audioSession = AVAudioSession.sharedInstance()
    
    private static let rigidImpactGenerator = UIImpactFeedbackGenerator(style: .rigid)
    private static let heavyImpactGenerator = UIImpactFeedbackGenerator(style: .heavy)
    private static let softImpactGenerator = UIImpactFeedbackGenerator(style: .soft)
    private static let lightImpactGenerator = UIImpactFeedbackGenerator(style: .light)
    private static let mediumImpactGenerator = UIImpactFeedbackGenerator(style: .medium)

    private static let notificationGenerator = UINotificationFeedbackGenerator()
    private static let selectionGenerator = UISelectionFeedbackGenerator()
    
    public static func setAllowHapticsDuringRecording(_ isAllowed: Bool) {
        try? audioSession.setAllowHapticsAndSystemSoundsDuringRecording(isAllowed)
    }
    
    public static func perform(_ style: HapticStyle = .light, intensity: CGFloat = 1.0) {
        if CHHapticEngine.capabilitiesForHardware().supportsHaptics {
            setAllowHapticsDuringRecording(true)
            switch style {
            case .rigid:
                rigidImpactGenerator.impactOccurred(intensity: intensity)
            case .soft:
                softImpactGenerator.impactOccurred(intensity: intensity)
            case .light:
                lightImpactGenerator.impactOccurred(intensity: intensity)
            case .medium:
                mediumImpactGenerator.impactOccurred(intensity: intensity)
            case .error:
                notificationGenerator.notificationOccurred(.error)
            case .success:
                notificationGenerator.notificationOccurred(.success)
            case .warning:
                notificationGenerator.notificationOccurred(.warning)
            case .selectionChanged:
                selectionGenerator.selectionChanged()
            case .heavy:
                heavyImpactGenerator.impactOccurred(intensity: intensity)
            }
        } else {
            AudioServicesPlaySystemSound(1519)
        }
    }
    
    private init() { }
}
