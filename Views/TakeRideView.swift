//
//  TakeRideView.swift
//  ridetec
//
//  Created by jose juan alcantara rincon on 07/12/21.
//

import SwiftUI
import CoreLocation

struct TakeRideView: View {
    @Binding var passengerActive: Bool
    @ObservedObject var mapData: MapViewModel
    @State var locationManager = CLLocationManager()
    @State var activeRoute: Bool = false
    var body: some View {
        if !passengerActive {
            VStack {
                Text("Choose the place where you can take your ride!")
                    .padding()
                MapView()
                    .environmentObject(mapData)
                    .ignoresSafeArea(.all, edges: .all)
            }
            .onAppear(perform: {
                locationManager.delegate = mapData
                locationManager.requestWhenInUseAuthorization()
            })
        } else {
            VStack {
                Text("You're logged as a driver right now")
            }
        }
    }
}

struct TakeRideView_Previews: PreviewProvider {
    static var previews: some View {
        TakeRideView(passengerActive: .constant(false), mapData: MapViewModel())
    }
}
