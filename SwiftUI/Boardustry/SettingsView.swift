import SwiftUI
import AVFoundation

struct SettingsView: View {
    @AppStorage("music") var music: Int = 0
    @Binding var showSettings: Bool
    var body: some View {
        ZStack {
            Color(red: 0, green: 0, blue: 0, opacity: 0.8).ignoresSafeArea()
            VStack {
                Text("Settings").bold().foregroundColor(.yellow)
                Divider().frame(height: 2).background(Color.yellow)
                Spacer()
                VStack {
                    HStack {
                        Text("NCS BGM").bold().foregroundColor(.yellow)
                        Spacer()
                        Rectangle().opacity(0).frame(width: 200, height: 60)
                            .overlay(Text(songs[music]).foregroundColor(Color(red: 0.902, green: 0.224, blue: 0.275)))
                            .overlay(Image(systemName: "arrow.left.square.fill").foregroundColor(.blue)
                                        .onTapGesture {
                                            AVPlayer.tapUnit.playFromStart()
                                            if music == 0 {music = songs.count-1} else {music -= 1}
                                            let item = AVPlayerItem(url: Bundle.main.url(forResource: songs[music], withExtension: "mp3")!)
                                            AVPlayer.bgQueuePlayer.replaceCurrentItem(with: item)
                                        }, alignment: .leading)
                            .overlay(Image(systemName: "arrow.right.square.fill").foregroundColor(.blue)
                                        .onTapGesture {
                                            AVPlayer.tapUnit.playFromStart()
                                            music = (music + 1) % songs.count
                                            let item = AVPlayerItem(url: Bundle.main.url(forResource: songs[music], withExtension: "mp3")!)
                                            AVPlayer.bgQueuePlayer.replaceCurrentItem(with: item)
                                        }, alignment: .trailing)
                    }
                    HStack {
                        Text("Volume").bold().foregroundColor(.yellow)
                        Spacer()
                        SoundSlider().frame(width: 200)
                    }
                }.frame(width: 300)
                Spacer()
                Button(action: {
                        AVPlayer.crossBtn.playFromStart()
                        showSettings = false}) {
                    ZStack {
                        Rectangle().opacity(0).frame(width: 90, height: 40).cornerRadius(5)
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 4))
                        HStack {
                            Image("icon_ArrowLeft").resizable().scaledToFit().frame(width: 25, height: 25)
                            Text("Back").foregroundColor(.white).bold()
                        }
                    }
                }
            }
        }
    }
}
