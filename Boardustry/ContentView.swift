import SwiftUI
import AVFoundation

struct ContentView: View {
    @AppStorage("isLogin") var isLogin: Bool = false
    @AppStorage("isGame") var isGame: Bool = false
    @State var signView: Bool = false
    var body: some View {
        ZStack {
            BackgroundView()
                .onTapGesture {signView = true}
                .overlay(Text("TAP TO START").bold().offset(x: 0, y: -25), alignment: .bottom)
            if signView {
                SignView().overlay(
                    Button {
                        AVPlayer.crossBtn.playFromStart()
                        signView = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .foregroundColor(Color(red: 0.902, green: 0.224, blue: 0.275))
                            .frame(width: 30, height: 30)
                            .padding(10)
                    }, alignment: .topTrailing)
            }
        }
        .onAppear {
            isLogin = false
            isGame = false
        }
        .fullScreenCover(isPresented: $isLogin) {HomeView()}
    }
}
