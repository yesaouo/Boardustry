import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import AVFoundation

struct NewsView: View {
    @FirestoreQuery(collectionPath: "news", predicates: [.order(by: "time", descending: true)]) private var news: [News]
    @Binding var showNews: Bool
    @State var chooseNews: News?
    var body: some View {
        ZStack {
            Color(red: 0, green: 0, blue: 0, opacity: 0.8).ignoresSafeArea()
            VStack {
                Text("\(chooseNews == nil ? "News" : chooseNews!.title)").bold().foregroundColor(.yellow)
                Divider().frame(height: 2).background(Color.yellow)
                Spacer()
                if chooseNews == nil {
                    ScrollView {
                        VStack {
                            ForEach(news) {new in
                                Button(action: {
                                        AVPlayer.bigBtn.playFromStart()
                                        chooseNews = new}) {
                                    ZStack {
                                        Rectangle().foregroundColor(Color(red: 0.5529, green: 0.6, blue: 0.6824))
                                            .frame(width: 240, height: 70).cornerRadius(5)
                                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.black, lineWidth: 4))
                                        Text("\(new.title)").foregroundColor(.white).font(.title3)
                                    }
                                }
                            }
                        }
                    }
                }else{
                    VStack {
                        Rectangle()
                            .frame(width: 280).opacity(0)
                            .overlay(Text(chooseNews!.content).foregroundColor(.yellow))
                        HStack {
                            Spacer()
                            Text(chooseNews!.time, style: .date).foregroundColor(.yellow)
                            Text(chooseNews!.time, style: .time).foregroundColor(.yellow)
                            Spacer()
                        }
                    }
                }
                Spacer()
                Button(action: {
                    AVPlayer.crossBtn.playFromStart()
                    if chooseNews == nil {
                        showNews = false
                    }else{chooseNews = nil}
                }) {
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
