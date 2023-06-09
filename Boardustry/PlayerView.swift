import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct PlayerView: View {
    @State var acc: String
    @State var rankTier: String = "Bronze"
    @State var rankDivision: String = "V"
    @State var profile: Profile = Profile()

    var body: some View {
        HStack {
            RankView(size: 20, rankTier: $rankTier, rankDivision: $rankDivision)
            Text("\(profile.name)").bold()
        }.onAppear {getProfile()}
    }

    func getProfile() {
        let db = Firestore.firestore()
        db.collection("profiles").document(self.acc).getDocument { document, error in
            guard let document = document,
                  document.exists,
                  let profile = try? document.data(as: Profile.self) else {
                return
            }
            self.profile = profile
            let rankString = self.getRankingTier(rp: self.profile.rank)
            let rankComponents = rankString.components(separatedBy: "_")
            self.rankTier = rankComponents[0]
            self.rankDivision = rankComponents[1]
        }
    }

    func getRankingTier(rp: Int) -> String {
        var tier = ""
        if rp < 1000 {
            tier = "Bronze_V"
        }
        if rp >= 1000 && rp < 3000 {
            let division = (rp - 1000) / 500 + 1
            tier = "Bronze_" + getRomanNumeral(division)
        } else if rp >= 3000 && rp < 5400 {
            let division = (rp - 3000) / 600 + 1
            tier = "Silver_" + getRomanNumeral(division)
        } else if rp >= 5400 && rp < 8200 {
            let division = (rp - 5400) / 700 + 1
            tier = "Gold_" + getRomanNumeral(division)
        } else if rp >= 8200 && rp < 11400 {
            let division = (rp - 8200) / 800 + 1
            tier = "Platinum_" + getRomanNumeral(division)
        } else if rp >= 11400 && rp < 15000 {
            let division = (rp - 11400) / 900 + 1
            tier = "Diamond_" + getRomanNumeral(division)
        } else if rp >= 15000 {
            tier = "Master_\(rp)"
        }
        return tier
    }
    
    func getRomanNumeral(_ number: Int) -> String {
        let romanNumerals: [String] = ["IV", "III", "II", "I"]
        return romanNumerals[number - 1]
    }
}
