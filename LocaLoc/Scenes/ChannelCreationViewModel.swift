//
//  ChannelCreationViewModel.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 25/5/24.
//

import UIKit
import Foundation

enum ChanelIndicatorValidationResult {
    case ok
    case error(text: String)
}

@Observable final class ChannelCreationViewModel {
    var image = UIImage() {
        didSet {
            DispatchQueue.main.async {
                self.isImageSelected = true
            }
        }
    }
        
    var isImageSelected: Bool = false
    
    let editingPermissionAvailableOption: [ChannelSettings.EditingPermissionType] = [.onlyOwner, .ownerAndUsers(ids: []), .everyone]

    var isRequestJoinRequired = false

    var name: String = ""
    var description: String = ""
    var identificator: String = ""

    var selectedEditingPermission: ChannelSettings.EditingPermissionType = .onlyOwner
    
    private func isIdentifierBusy() async -> Bool {
        true
    }
    
    func validateChanelIndicator() async -> ChanelIndicatorValidationResult {
        if identificator.count < 4 {
            return .error(text: "At least 3 character")
        } else if await isIdentifierBusy() {
            return .error(text: "ID is busy")
        } else {
            return .ok
        }
    }
}
