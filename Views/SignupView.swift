//
//  SignupView.swift
//  ridetec
//
//  Created by jose juan alcantara rincon on 27/11/21.
//

import SwiftUI
import Firebase

struct SignupView: View {
    @Binding var rootActive: Bool
    @State var name: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var passwordConfirmation: String = ""
    @State var passWrong = false
    @State var messageError = ""
    @State var showImage = false
    @State var image: UIImage?
    @State var imageURL: String = "https://www.pngall.com/wp-content/uploads/5/Profile-PNG-File.png"
    
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
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
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
                    TextField("Email", text: $email)
                        .padding(.horizontal)
                        .padding(.horizontal, 30)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    SecureField("Password", text: $password)
                        .padding(.horizontal)
                        .padding(.horizontal, 30)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    SecureField("Confirm password", text: $passwordConfirmation)
                        .padding(.horizontal)
                        .padding(.horizontal, 30)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: {
                        createNewAccount()
                    }, label: {
                        Text("Signup")
                            .padding()
                            .padding(.horizontal, 10)
                            .foregroundColor(.white)
                            .background(Color.init(red: 121/255, green: 29/255, blue: 35/255))
                            .cornerRadius(8)
                            .padding(.top)
                    })
                        .alert(self.messageError, isPresented: $passWrong) {
                        Button("Close", role: .cancel) { }
                    }
                }
                Spacer()
            }
            .navigationTitle("Signup")
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .fullScreenCover(isPresented: $showImage, onDismiss: nil) {
            ImagePicker(image: $image)
        }
    }
    
    private func createNewAccount() {
        if(password == passwordConfirmation){
            Auth.auth().createUser(withEmail: self.email, password: self.password) {
                result, error in
                if let err = error {
                    print("Failed to create user:", err.localizedDescription)
                    messageError = err.localizedDescription
                    passWrong = true
                    email = ""
                    return
                }
                
                print("Successfully created user: \(result?.user.uid ?? "")")
                rootActive = false
                
                self.persistImageToStorage()
                print(messageError)
            }
        }
        else {
            messageError = "Passwords does not match"
            passWrong = true
            password = ""
            passwordConfirmation = ""
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
                    self.messageError = "\(err.localizedDescription)"
                    return
                }
                
                print("Suuccess")
            }
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView(rootActive: .constant(true))
    }
}
