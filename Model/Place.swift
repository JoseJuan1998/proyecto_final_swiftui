//
//  Place.swift
//  ridetec
//
//  Created by jose juan alcantara rincon on 08/12/21.
//

import SwiftUI
import MapKit

struct Place: Identifiable {
    var id = UUID()
    var place: CLPlacemark
}
