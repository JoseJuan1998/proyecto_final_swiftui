//
//  SideMenuView.swift
//  ridetec
//
//  Created by jose juan alcantara rincon on 06/12/21.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase

struct SideMenuView: View {
    @Binding var rootActive: Bool
    @Binding var coreDM: CoreDataManager
    @Binding var menuActive: Bool
    @ObservedObject var mapData: MapViewModel
    @State var driverActive: Bool = false
    @Binding var uid: String
    @Binding var name: String
    @Binding var email: String
    @Binding var imageURL: String
    @State var deleteAccount = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 14) {
                WebImage(url: URL(string: imageURL ?? ""))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 65, height: 65)
                    .clipShape(Circle())
                Text(name)
                    .font(.title2.bold())
                Text(email)
                    .font(.callout)
            }
            .padding(.horizontal)
            .padding(.leading)
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 30) {
                    NavigationLink(destination: ProfileView(uid: $uid, name: $name, email: $email, imageURL: $imageURL)){
                        TabButton(title: "Profile", image: "person.crop.circle")
                    }
                    Divider()
                    NavigationLink(destination: GiveRideView(showDriver: $driverActive, mapData: mapData)){
                        TabButton(title: "Give a ride", image: "car.circle")
                    }
                    Divider()
                    NavigationLink(destination: TakeRideView(passengerActive: $driverActive, mapData: mapData)) {
                        TabButton(title: "Take a ride", image: "figure.wave.circle")
                    }
                    Spacer()
                    Spacer()
                    TabButton(title: "Logout", image: "arrowshape.turn.up.backward.circle")
                        .onTapGesture {
                            coreDM.deleteAllUsers()
                            try? Auth.auth().signOut()
                            rootActive = false
                        }
                    Divider()
                    TabButton(title: "Delete Account", image: "trash.circle")
                        .onTapGesture {
                            deleteAccount = true
                        }
                        .alert("Delete your account?", isPresented: $deleteAccount) {
                           
                            Button("Delete", role: .destructive) {
                                coreDM.deleteAllUsers()
                                mapData.clean()
                                Auth.auth().currentUser?.delete {err in
                                    print(err?.localizedDescription)
                                }
                                Firestore.firestore().collection("users").document(uid).delete { err in
                                    print(err?.localizedDescription)
                                }
                                Storage.storage().reference(withPath: uid).delete { err in
                                    print(err?.localizedDescription)
                                }
                                rootActive = false
                            }
                            Button("Cancel", role: .cancel){}
                        }
                }
                .padding()
                .padding(.leading)
                .padding(.top, 35)
            }
        }
        .padding(.vertical)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(width: getRect().width - 90)
        .frame(maxHeight: .infinity)
        .background(
            Color.primary.opacity(0.04)
                .ignoresSafeArea(.container, edges: .vertical)
        )
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    func TabButton(title: String, image: String) -> some View{
            HStack(spacing: 13) {
                Image(systemName: image)
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 30, height: 30)
                    .foregroundColor(image == "trash.circle" ? .red : .primary)
                Text(title)
                    .foregroundColor(image == "trash.circle" ? .red : .primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
    }
}

struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView(rootActive: .constant(true), coreDM: .constant(CoreDataManager()), menuActive: .constant(true),mapData: MapViewModel(), uid: .constant(""), name: .constant(""), email: .constant(""), imageURL: .constant(""))
    }
}

extension View {
    func getRect() -> CGRect {
        return UIScreen.main.bounds
    }
}
