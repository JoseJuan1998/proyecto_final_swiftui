//
//  GiveRideView.swift
//  ridetec
//
//  Created by jose juan alcantara rincon on 07/12/21.
//

import SwiftUI

struct GiveRideView: View {
    @Binding var showDriver: Bool
    @ObservedObject var mapData: MapViewModel
    @State var current = "Driver"
    var body: some View {
        VStack {
            if current == "Driver" {
                Toggle("Give a ride?", isOn: $showDriver)
                    .padding()
                    .padding(.horizontal)
                    .font(.title2)
            }
                if showDriver {
                    VStack(spacing: 0) {
                        TabView(selection: $current) {
                            VStack(spacing: 40) {
                                Text("Remember, each ride you offer helps to reduce the levels of environmental pollution, helping our beautiful city and its nature.\n\nBE PART OF THE CHANGE.")
                                    .padding(.horizontal, 23)
                                Image(systemName: "globe.americas")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 65)
                            }
                            .navigationBarTitleDisplayMode(.inline)
                            .tag("Driver")
                            VStack {
                                Text("Choose places where you can give a ride!")
                                    .padding()
                                BaseMapView(mapData: mapData)
                            }
                            .navigationBarTitleDisplayMode(.inline)
                            .tag("Map")
                        }
                        Divider()
                        HStack(spacing: 0) {
                            TabButton(image: "car", selected: "Driver")
                            TabButton(image: "map", selected: "Map")
                        }
                        .padding(.top, 15)
                    }
                } else {
                    Spacer()
                    VStack {
                        Text("You're logged as a passenger right now")
                    }
                }
            Spacer()
        }
    }
    
    @ViewBuilder
    func TabButton(image: String, selected: String) -> some View {
        Button {
            withAnimation{current = selected}
        } label: {
            Image(systemName: image)
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .frame(width: 23, height: 23)
                .foregroundColor(current == selected ? .primary : .gray)
                .frame(maxWidth: .infinity)
        }
    }
}

struct GiveRideView_Previews: PreviewProvider {
    static var previews: some View {
        GiveRideView(showDriver: .constant(false), mapData: MapViewModel())
    }
}
