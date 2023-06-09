import SwiftUI
import AVFoundation

struct RegistrationView: View {
    @ObservedObject var fbModel = firebaseModel
    var body: some View {
        VStack {
            TextField("Username", text: fbModel.$name)
                .padding(10)
                .border(Color.gray, width: 1)
                .cornerRadius(5.0)
            TextField("Account", text: fbModel.$acc)
                .padding(10)
                .border(Color.gray, width: 1)
                .cornerRadius(5.0)
            SecureField("Password", text: fbModel.$pas)
                .padding(10)
                .border(Color.gray, width: 1)
                .cornerRadius(5.0)
            Text(fbModel.errorMessage).font(.system(size: 10)).foregroundColor(.red)
            Spacer()
            Button("Register") {
                AVPlayer.bigBtn.playFromStart()
                fbModel.register()
            }
            .padding(10)
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(5.0)
        }
        .padding()
    }
}
