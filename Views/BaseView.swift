//
//  BaseView.swift
//  ridetec
//
//  Created by jose juan alcantara rincon on 06/12/21.
//

import SwiftUI
import Firebase

struct BaseView: View {
    @Binding var rootActive: Bool
    @Binding var user: User
    @Binding var coreDM: CoreDataManager
    @ObservedObject var mapData: MapViewModel
    @State var current: String = "Home"
    @State var showMenu = false
    @State var uid = ""
    @State var name = ""
    @State var email = ""
    @State var imageURL = ""
    
    var body: some View {
        let sideBarWidth = getRect().width - 90
        HStack(spacing: 0) {
            SideMenuView(rootActive: $rootActive, coreDM: $coreDM ,menuActive: $showMenu, mapData: mapData, uid: $uid, name: $name, email: $email, imageURL: $imageURL)
            VStack(spacing: 0) {
                TabView(selection: $current) {
                    VStack {
                        HomeView(menuActive: $showMenu)
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarHidden(true)
                    .tag("Home")
                    VStack(spacing: 40) {
                        Text("At RIDETEC we are a group of students trying to change the world, we are committed to the entire ITM community, trying to improve our platform by providing a quality transportation service.")
                            .padding(.horizontal, 23)
                        Image(systemName: "figure.stand.line.dotted.figure.stand")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 65)
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarHidden(true)
                    .tag("What")
                }
                Divider()
                HStack(spacing: 0) {
                    TabButton(image: "house", selected: "Home")
                    TabButton(image: "magazine", selected: "What")
                }
                .padding(.top, 15)
            }
            .frame(width: getRect().width)
            .overlay(
                Rectangle()
                    .fill(
                        Color.primary
                            .opacity(showMenu ? Double(0.5) : Double(0.0))
                        )
                        .ignoresSafeArea(.container, edges: .vertical)
                        .onTapGesture {
                            showMenu.toggle()
                        }
                    
            )
        }
        .frame(width: getRect().width + sideBarWidth)
        .offset(x: showMenu ? sideBarWidth/2 : -sideBarWidth/2)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(true)
        .animation(.easeOut)
        .onAppear {
            fetchCurrentUser()
        }
    }
    
    private func fetchCurrentUser() {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("Could not find firebase uid")
            return
        }
        
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                print("Failed to fetch current user:", error)
                return
            }
            
            guard let data = snapshot?.data() else {return}
            print(data)
            self.uid = data["uid"] as? String ?? ""
            self.name = data["name"] as? String ?? ""
            self.email = data["email"] as? String ?? ""
            self.imageURL = data["profileImageUrl"] as? String ?? ""
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

struct BaseView_Previews: PreviewProvider {
    static var previews: some View {
        BaseView(rootActive: .constant(true), user: .constant(User()), coreDM: .constant(CoreDataManager()), mapData: MapViewModel())
    }
}
