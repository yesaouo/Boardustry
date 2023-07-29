import AVFoundation

let songs = ["On & On","Invincible","My Heart","Heroes Tonight","Mortals"]
extension AVPlayer {
    static var bgQueuePlayer = AVQueuePlayer()
    static var bgPlayerLooper: AVPlayerLooper!
    static func setupBgMusic(n: Int) {
        let item = AVPlayerItem(url: Bundle.main.url(forResource: songs[n], withExtension: "mp3")!)
        bgPlayerLooper = AVPlayerLooper(player: bgQueuePlayer, templateItem: item)
    }
    static let tapUnit: AVPlayer = {
        return AVPlayer(url: Bundle.main.url(forResource: "zapsplat_multimedia_button_click_fast_wooden_organic_005_78839", withExtension: "mp3")!)
    }()
    static let sysBtn: AVPlayer = {
        return AVPlayer(url: Bundle.main.url(forResource: "zapsplat_multimedia_button_click_bright_001_92098", withExtension: "mp3")!)
    }()
    static let crossBtn: AVPlayer = {
        let url = Bundle.main.url(forResource: "multimedia_button_click_019", withExtension: "mp3")!
        return AVPlayer(url: url)
    }()
    static let bigBtn: AVPlayer = {
        return AVPlayer(url: Bundle.main.url(forResource: "multimedia_button_click_017", withExtension: "mp3")!)
    }()
    static let dataBtn: AVPlayer = {
        return AVPlayer(url: Bundle.main.url(forResource: "zapsplat_multimedia_button_click_bright_002_92099", withExtension: "mp3")!)
    }()
    
    func playFromStart() {
        seek(to: .zero)
        play()
    }
}

import SwiftUI

struct SoundSlider: View {
    @AppStorage("volume") var volume: Double = 0.5
    var body: some View {
        Slider(value: $volume, in: 0...1, step: 0.01)
            .onChange(of: volume, perform: { value in
                AVPlayer().volume = Float(value)
            })
    }
}
