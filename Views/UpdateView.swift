//
//  UpdateView.swift
//  ridetec
//
//  Created by jose juan alcantara rincon on 09/12/21.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct UpdateView: View {
    @Binding var rootActive: Bool
    @Binding var name: String
    @Binding var email: String
    @Binding var imageURL: String
    @State var showImage = false
    @State var image: UIImage?
    
    var body: some View {
        NavigationView {
            VStack {
                if let image = self.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 200, height: 200)
                        .padding(.top, 20)
                        .padding(.bottom, 20)
                        .clipShape(Circle())
                        .onTapGesture {
                            showImage = true
                        }
                } else {
                    WebImage(url: URL(string: imageURL ?? ""))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 200, height: 200)
                        .padding(.top, 20)
                        .padding(.bottom, 20)
                        .clipShape(Circle())
                        .onTapGesture {
                            showImage = true
                        }
                }
                VStack {
                    TextField("Name", text: $name)
                        .padding(.horizontal)
                        .padding(.horizontal, 30)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: {
                        persistImageToStorage()
                    }, label: {
                        Text("Update")
                            .padding()
                            .padding(.horizontal, 10)
                            .foregroundColor(.white)
                            .background(Color.init(red: 121/255, green: 29/255, blue: 35/255))
                            .cornerRadius(8)
                            .padding(.top)
                    })
                }
                Spacer()
            }
            .navigationTitle("Update")
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .fullScreenCover(isPresented: $showImage, onDismiss: nil) {
            ImagePicker(image: $image)
        }
    }
    
    private func persistImageToStorage() {
        let filename = UUID().uuidString
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Storage.storage().reference(withPath: uid)
        guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else {
            self.storeUserInformation(imageProfile: imageURL)
            return
        }
        ref.putData(imageData, metadata: nil) { metadata, err in
            if let err = err {
                print("Failed to push image to storage: \(err.localizedDescription)")
                return
            }
            
            ref.downloadURL{ url, err in
                if let err = err {
                    print("Failed to retrieve downloadURL: \(err.localizedDescription)")
                    return
                }
                
                print("Successfully stored image with url \(url?.absoluteString ?? "")")
                
                guard let url = url else { return }
                imageURL = url.absoluteString
                self.storeUserInformation(imageProfile: url.absoluteString)
            }
        }
    }
    
    private func storeUserInformation(imageProfile: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let userData = ["name": self.name, "email": self.email, "uid": uid, "profileImageUrl": imageProfile]
        Firestore.firestore().collection("users")
            .document(uid).setData(userData){ err in
                if let err = err {
                    print(err.localizedDescription)
                    return
                }
                rootActive = false
                print("Suuccess")
            }
    }
}

struct UpdateView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateView(rootActive: .constant(true), name: .constant(""), email: .constant(""), imageURL: .constant(""))
    }
}
