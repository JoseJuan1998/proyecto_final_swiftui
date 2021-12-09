//
//  ContentView.swift
//  ridetec
//
//  Created by jose juan alcantara rincon on 27/11/21.
//

import SwiftUI
import Firebase

struct ContentView: View {
    init() {
        FirebaseApp.configure()
    }
    var body: some View {
        LoginView(coreDM: CoreDataManager(), user: User())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
