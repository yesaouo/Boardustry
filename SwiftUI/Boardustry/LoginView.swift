import SwiftUI
import AVFoundation

struct LoginView: View {
    @ObservedObject var fbModel = firebaseModel
    var body: some View {
        VStack {
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
            Button("Log In") {
                AVPlayer.bigBtn.playFromStart()
                fbModel.login()
            }
            .padding(10)
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(5.0)
        }
        .padding()
    }
}
