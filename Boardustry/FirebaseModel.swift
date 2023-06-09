import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirebaseModel: ObservableObject {
    @AppStorage("acc") var acc: String = ""
    @AppStorage("pas") var pas: String = ""
    @AppStorage("name") var name: String = ""
    @AppStorage("isLogin") var isLogin: Bool = false
    @Published var errorMessage: String = ""
    @Published var profile: Profile = Profile()
    
    init() {
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                self.errorMessage = ""
                self.isLogin = true
                print("\(user.uid) login")
            } else {
                print("not login")
            }
        }
        
    }

    func getProfile(id: String) {
        let db = Firestore.firestore()
        db.collection("profiles").document(id).getDocument { document, error in
            
            guard let document = document,
                  document.exists,
                  let profile = try? document.data(as: Profile.self) else {
                return
            }
            self.profile = profile
            print(self.profile)
        }
    }
    
    func createProfile() {
        let db = Firestore.firestore()
        profile.name = self.name
        do {
            try db.collection("profiles").document(self.acc).setData(from: profile)
            self.getProfile(id: self.acc)
            self.isLogin = true
            print("register success")
        } catch {
            self.errorMessage = error.localizedDescription ?? ""
            print(self.errorMessage)
        }
    }

    func register() {
        Auth.auth().createUser(withEmail: acc, password: pas) { result, error in
            guard let user = result?.user, error == nil else {
                self.errorMessage = error?.localizedDescription ?? ""
                print(self.errorMessage)
                return
            }
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = self.name
            changeRequest?.commitChanges(completion: { error in
                guard error == nil else {
                    self.errorMessage = error?.localizedDescription ?? ""
                    print(self.errorMessage)
                    return
                }
                print(user.email, user.uid, user.displayName)
                self.createProfile()
            })
        }
    }

    func login() {
        Auth.auth().signIn(withEmail: acc, password: pas) { result, error in
            guard error == nil else {
                self.errorMessage = error?.localizedDescription ?? ""
                print(self.errorMessage)
                return
            }
            self.getProfile(id: self.acc)
            print("login success")
            self.isLogin = true
        }
    }
}
