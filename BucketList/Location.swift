//
//  Location.swift
//  BucketList
//
//  Created by Anthony Candelino on 2024-09-14.
//

import Foundation
import MapKit

struct Location: Codable, Equatable, Identifiable {
    var id: UUID
    var name: String
    var description: String
    var latitude: Double
    var longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    // simplified custom equality function since they'll always be unique due to id being   UUID
    static func ==(lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
    
#if DEBUG
    static let example = Location(id: UUID(), name: "CN Tower", description: "Big building", latitude: 43.6426, longitude: -79.3871)
#endif
}
