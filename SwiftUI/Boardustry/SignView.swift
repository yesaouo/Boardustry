import SwiftUI
import AVFoundation

struct SignView: View {
    enum Mode {case login, registration}
    @State var mode: Mode = .login
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(Color(red: 0.945, green: 0.98, blue: 0.933))
            .frame(width: shortSide/3*2, height: 360, alignment: .center)
            .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color(red: 0.1137, green: 0.2078, blue: 0.3412), lineWidth: 10))
            .overlay(
                VStack {
                    ZStack {
                        Color(red: 0.1137, green: 0.2078, blue: 0.3412)
                            .frame(width: shortSide/3*2-8, height: 50)
                        HStack {
                            Spacer()
                            Image("TGDY")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                            Text("TGDY")
                                .foregroundColor(.white)
                                .bold()
                            Spacer()
                        }
                    }
                    HStack(spacing: 0) {
                        Button(action: {
                                AVPlayer.sysBtn.playFromStart()
                                mode = .registration}, label: {
                            Text("SignUp")
                        }).frame(width: 100).background(mode == .login ? Color.white : Color.yellow)
                        Button(action: {
                                AVPlayer.sysBtn.playFromStart()
                                mode = .login}, label: {
                            Text("SignIn")
                        }).frame(width: 100).background(mode == .login ? Color.yellow : Color.white)
                    }.background(Color.white).overlay(Rectangle().stroke(Color(red: 0.2706, green: 0.4824, blue: 0.6157), lineWidth: 3))
                    Spacer()
                    if mode == .login {
                        LoginView()
                    }else{
                        RegistrationView()
                    }
                    Spacer()
                }
            )
    }
}
