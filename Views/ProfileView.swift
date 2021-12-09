//
//  ProfileView.swift
//  ridetec
//
//  Created by jose juan alcantara rincon on 07/12/21.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct ProfileView: View {
    @State var uid = ""
    @State var name = ""
    @State var email = ""
    @State var imageURL = ""
    
    var body: some View {
        VStack(spacing: 30) {
            WebImage(url: URL(string: imageURL ?? ""))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 200, height: 200)
                .clipShape(Circle())
            Text(name)
                .font(.largeTitle)
            Text(email)
                .font(.title2)
        }
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
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
