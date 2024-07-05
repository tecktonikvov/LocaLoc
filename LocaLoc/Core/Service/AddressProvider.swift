//
//  AddressProvider.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 5/7/24.
//

import GoogleMaps

enum AddressProviderError: Error {
    case resultIsEmpty
    case placesIsEmpty
}

final class AddressProvider {
    private lazy var geocoder = GMSGeocoder()
    
    @MainActor
    func address(by coordinates: Coordinates) async throws -> Address {  
        return try await withCheckedThrowingContinuation { continuation in
            geocoder.reverseGeocodeCoordinate(coordinates.as2DCoordinates) { response, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                guard let places = response?.results() else {
                    continuation.resume(throwing: AddressProviderError.resultIsEmpty)
                    return
                }
                
                guard let place = places.first else {
                    continuation.resume(throwing: AddressProviderError.placesIsEmpty)
                    return
                }
                
                let address = Address(
                    streetNameAndAdress: place.thoroughfare ?? "",
                    city: place.locality ?? "",
                    country: place.country ?? "",
                    region: place.administrativeArea ?? "",
                    postCode: place.postalCode ?? "",
                    line: place.lines?.first ?? ""
                )
                
                continuation.resume(returning: address)
            }
        }
    }
}
