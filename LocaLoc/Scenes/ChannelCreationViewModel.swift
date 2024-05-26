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

final class ChannelCreationViewModel: ObservableObject {
    @Published var image = UIImage() {
        didSet {
            DispatchQueue.main.async {
                self.isImageSelected = true
            }
        }
    }
        
    @Published var isImageSelected: Bool = false
    
    let editingPermissionAvailableOption: [ChannelSettings.EditingPermissionType] = [.onlyOwner, .ownerAndUsers(ids: []), .everyone]

    @Published var isRequestJoinRequired = false

    @Published var name: String = ""
    @Published var description: String = ""
    @Published var identificator: String = ""

    @Published var selectedEditingPermission: ChannelSettings.EditingPermissionType = .onlyOwner
    
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
