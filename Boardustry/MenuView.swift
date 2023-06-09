import SwiftUI
import AVFoundation

struct MenuView: View {
    @EnvironmentObject var model: HomeModel
    var body: some View {
        VStack(spacing: 5) {
            Button(action: {
                    AVPlayer.sysBtn.playFromStart()
                    model.showNews = true}) {
                Text("News").font(.headline).foregroundColor(.white).frame(width:250, height: 30)
                    .background(Color(red: 0.1137, green: 0.2078, blue: 0.3412)).cornerRadius(10)
            }
            Button(action: {
                    AVPlayer.sysBtn.playFromStart()
                    model.showSettings = true}) {
                Text("Settings").font(.headline).foregroundColor(.white).frame(width:250, height: 30)
                    .background(Color(red: 0.1137, green: 0.2078, blue: 0.3412)).cornerRadius(10)
            }
            Button(action: {
                    AVPlayer.sysBtn.playFromStart()
                    model.showDatabase = true}) {
                Text("Database").font(.headline).foregroundColor(.white).frame(width:250, height: 30)
                    .background(Color(red: 0.1137, green: 0.2078, blue: 0.3412)).cornerRadius(10)
            }
            Button(action: {AVPlayer.sysBtn.playFromStart()}) {
                Text("Upload Photo").font(.headline).foregroundColor(.white).frame(width:250, height: 30)
                    .background(Color(red: 0.1137, green: 0.2078, blue: 0.3412)).cornerRadius(10)
            }
            Button(action: {
                    AVPlayer.sysBtn.playFromStart()
                    model.showMail = true}) {
                Text("Report Bug").font(.headline).foregroundColor(.white).frame(width:250, height: 30)
                    .background(Color(red: 0.1137, green: 0.2078, blue: 0.3412)).cornerRadius(10)
            }
            .sheet(isPresented: $model.showMail) {
                MailView(recipient: model.recipient)
            }
            Button(action: {
                    AVPlayer.sysBtn.playFromStart()
                    if let url = URL(string: "https://medium.com/@yesaouo/swift-%E9%96%8B%E7%99%BC-3-%E7%B7%9A%E4%B8%8A%E5%B0%8D%E6%88%B0%E9%81%8A%E6%88%B2-boardustry-ace68935b7b") {UIApplication.shared.open(url)}}) {
                Text("Medium").font(.headline).foregroundColor(.white).frame(width:250, height: 30)
                    .background(Color(red: 0.1137, green: 0.2078, blue: 0.3412)).cornerRadius(10)
            }
            Button(action: {
                    AVPlayer.sysBtn.playFromStart()
                    if let url = URL(string: "https://github.com/yesaouo/Swift_Boardustry") {UIApplication.shared.open(url)}}) {
                Text("GitHub").font(.headline).foregroundColor(.white).frame(width:250, height: 30)
                    .background(Color(red: 0.1137, green: 0.2078, blue: 0.3412)).cornerRadius(10)
            }
            Button(action: {
                    AVPlayer.sysBtn.playFromStart()
                    model.logout()}) {
                Text("Log Out").font(.headline).foregroundColor(.white).frame(width:250, height: 30)
                    .background(Color(red: 0.1137, green: 0.2078, blue: 0.3412)).cornerRadius(10)
            }
        }
    }
}
