//
//  HomeView.swift
//  ridetec
//
//  Created by jose juan alcantara rincon on 28/11/21.
//

import SwiftUI

struct HomeView: View {
    @Binding var menuActive: Bool
    var body: some View {
        VStack {
            HStack {
                Button {
                  menuActive = true
                } label: {
                    Image(systemName: "equal")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                        .foregroundColor(menuActive ? .primary.opacity(Double(0)) : .primary)
                }
                .padding(.leading)
                Spacer()
            }
            Spacer()
            VStack(spacing: 50) {
                Image(systemName: "network")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                Text("Welcome to the BEST APP for the BEST COMMUNNITY \n\nRIDETEC")
                    .padding(.horizontal, 23)
                    .font(.title.bold())
            }
            Spacer()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(menuActive: .constant(false))
    }
}
