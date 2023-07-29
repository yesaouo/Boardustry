import SwiftUI
import FirebaseCore
import AVFoundation

let firebaseModel = FirebaseModel()
let shortSide = UIScreen.main.bounds.height>UIScreen.main.bounds.width ? UIScreen.main.bounds.width : UIScreen.main.bounds.height
let divisor = UIScreen.main.bounds.height>UIScreen.main.bounds.width*2 ? 12 : 15

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct YourApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @AppStorage("music") var music: Int = 0
    init() {
        AVPlayer.setupBgMusic(n: music)
        AVPlayer.bgQueuePlayer.play()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
