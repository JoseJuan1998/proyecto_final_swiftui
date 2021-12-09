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
    @Binding var uid: String
    @Binding var name: String
    @Binding var email: String
    @Binding var imageURL: String
    @State var showEdit = false
    
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
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    showEdit = true
                }
            }
        }
        .sheet(isPresented: $showEdit) {
            UpdateView(rootActive: $showEdit, name: $name, email: $email, imageURL: $imageURL)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(uid: .constant(""), name: .constant(""), email: .constant(""), imageURL: .constant(""))
    }
}
