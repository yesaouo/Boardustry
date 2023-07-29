import SwiftUI

struct RankView: View {
    @State var size: Int
    @Binding var rankTier: String
    @Binding var rankDivision: String
    var body: some View {
        Image("rank_\(rankTier)")
            .resizable()
            .scaledToFit()
            .frame(width: CGFloat(size), height: CGFloat(size))
            .overlay(Text(rankDivision).foregroundColor(.white).font(.system(size: CGFloat(size/7))).bold().offset(x: 0, y: CGFloat(-size/16)), alignment: .bottom)
    }
}
