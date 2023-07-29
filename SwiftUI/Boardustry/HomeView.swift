import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import AVFoundation

struct HomeView: View {
    @FirestoreQuery(collectionPath: "profiles", predicates: [.order(by: "rank", descending: true), .limit(to: 10)]) private var profiles: [Profile]
    @ObservedObject var model = HomeModel()
    @AppStorage("isGame") var isGame: Bool = false
    let homeIcon = ["Add","Hammer","Home","Donate","Book"]
    let homeIconStr = ["Join Game","Formation","Home","Shop","Menu"]
    var body: some View {
        ZStack {
            BackgroundView()
            if !model.isWaiting {
                VStack {
                    HStack {
                        Capsule().foregroundColor(.gray).frame(width: 150, height: 30)
                            .overlay(Image("Dollar").offset(x: 6), alignment: .leading)
                            .overlay(Text("\(model.profile.coin)").offset(x: -6), alignment: .trailing)
                        Capsule().foregroundColor(.gray).frame(width: 150, height: 30)
                            .overlay(Image("Diamond").offset(x: 6), alignment: .leading)
                            .overlay(Text("\(model.profile.diamond)").offset(x: -6), alignment: .trailing)
                    }
                    Spacer()
                    switch model.page {
                    case 1: RoomView().frame(width: shortSide*2/3).padding(50)
                    case 2: FormationView()
                    case 3:
                        RankView(size: Int(shortSide/2.5), rankTier: $model.rankTier, rankDivision: $model.rankDivision).padding(100)
                            .onTapGesture {model.tapRank()}
                        List {
                            HStack {
                                Spacer()
                                Text("LEADERBOARD")
                                Spacer()
                            }
                            ForEach(profiles) { profile in
                                HStack {
                                    PlayerView(acc: profile.id!)
                                    Spacer()
                                    Text("\(profile.rank) RP")
                                }
                            }
                        }.frame(width: shortSide).padding()
                    case 4: ShopView()
                    default: MenuView().environmentObject(model)
                    }
                    Spacer()
                    HStack {
                        ForEach(1...5, id: \.self) { i in
                            Button(action: {
                                    AVPlayer.bigBtn.playFromStart()
                                    model.page = i}) {
                                ZStack {
                                    Rectangle().fill(Color(red: 0.1137, green: 0.2078, blue: 0.3412))
                                        .frame(width: shortSide/5.7, height: 80).cornerRadius(5)
                                    VStack {
                                        Image("icon_\(homeIcon[i-1])").resizable().scaledToFit().frame(width: 40, height: 40)
                                        Text("\(homeIconStr[i-1])").foregroundColor(.white).font(.system(size: 12)).bold()
                                    }
                                }
                            }
                        }
                    }
                }
                if model.showNews {NewsView(showNews: $model.showNews)}
                if model.showSettings {SettingsView(showSettings: $model.showSettings)}
                if model.showDatabase {DatabaseView(showDatabase: $model.showDatabase)}
            }else{
                VStack {
                    RankView(size: Int(shortSide/1.5), rankTier: $model.rankTier, rankDivision: $model.rankDivision)
                        .rotation3DEffect(.degrees(model.rotationAngle), axis: (x: 0.0, y: 1.0, z: 0.0))
                        .onTapGesture {model.tapRank()}
                    Text("Matching").bold()
                }
            }
        }
        .fullScreenCover(isPresented: $isGame) {GamePage()}
    }
}
