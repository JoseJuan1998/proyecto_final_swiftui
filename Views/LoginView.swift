//
//  LoginView.swift
//  ridetec
//
//  Created by jose juan alcantara rincon on 27/11/21.
//

import SwiftUI
import Firebase

struct LoginView: View {
    @StateObject var mapData = MapViewModel()
    @State var loginWrong = false
    @State var messageError = ""
    @State var showSignup: Bool = false
    @State var email: String = ""
    @State var password: String = ""
    @State var coreDM: CoreDataManager
    @State var loginSuccess = false
    @State var user: User?
    @State var userLogged: User = User()
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: BaseView(rootActive: $loginSuccess, user: $userLogged, coreDM: $coreDM, mapData: mapData), isActive: self.$loginSuccess){
                    Spacer().fixedSize()
                }
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                VStack {
                    TextField("Email", text: $email)
                        .padding()
                        .padding(.horizontal, 30)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    SecureField("Password", text: $password)
                        .padding(.horizontal)
                        .padding(.horizontal, 30)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: {
                        loginUser()
                    }, label: {
                        Text("Login")
                            .padding()
                            .padding(.horizontal, 10)
                            .foregroundColor(.white)
                            .background(Color.init(red: 121/255, green: 29/255, blue: 35/255))
                            .cornerRadius(8)
                            .padding(.top)
                    })
                        .alert(self.messageError, isPresented: $loginWrong) {
                        Button("Close", role: .cancel) { }
                    }
                    Text("Don't you have an account? Singup here")
                        .foregroundColor(.cyan)
                        .padding(.top)
                        .font(.caption)
                        .onTapGesture {
                            showSignup = true
                        }
                        .sheet(isPresented: $showSignup, content: {
                            SignupView(rootActive: $showSignup)
                        })
                }
                Spacer()
            }
            .navigationTitle("Login")
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear{
            user = coreDM.getUser()
            if(user != nil) {
                userLogged = user!
                loginSuccess = true
            }
        }
    }
    
    private func loginUser() {
        Auth.auth().signIn(withEmail: email, password: password) {
            result, error in
            if let err = error {
                print("Failed to login user: \(err.localizedDescription)")
                messageError = err.localizedDescription
                loginWrong = true
                self.email = ""
                self.password = ""
                return
            }
            let id = result?.user.uid ?? ""
            let email = result?.user.email ?? ""
            coreDM.saveUser(id: id, email: email)
            userLogged = coreDM.getUser()!
            loginSuccess = true
            self.email = ""
            self.password = ""
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(coreDM: CoreDataManager(), user: User())
    }
}
