import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class HomeModel: ObservableObject {
    let db = Firestore.firestore()
    let recipient = "ethan147852369@gmail.com"
    @AppStorage("acc") var acc: String = ""
    @AppStorage("isLogin") var isLogin: Bool = false
    @AppStorage("isGame") var isGame: Bool = false
    @AppStorage("roomID") var roomID: String = "00000000"
    @Published var rankTier: String = "Bronze"
    @Published var rankDivision: String = "V"
    @Published var profile: Profile = Profile()
    @Published var page: Int = 3
    @Published var showMail = false
    @Published var showNews = false
    @Published var showSettings = false
    @Published var showDatabase = false
    @Published var isWaiting: Bool = false
    @Published var rotationAngle: Double = 0.0
    @Published var timer: Timer?
    @Published var rankID: String?

    init() {
        getProfile()
        db.collection("rooms").document(roomID).getDocument { document, error in
            guard let document = document, document.exists, let room = try? document.data(as: Room.self) else {return}
            if room.isEnd { return }
            self.isGame = true
        }
    }
    func listenRoom() {
        db.collection("rooms").document(roomID).addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else { return }
            guard let room = try? snapshot.data(as: Room.self) else {return}
            if room.count == 2 {
                self.rankID = nil
                self.isWaiting = false
                self.timer?.invalidate()
                self.isGame = true
            }
        }
    }
    func joinRoom(_ id: String) {
        let roomsRef = db.collection("rooms").document(id)
        let profilesRef = db.collection("profiles").document(self.acc)
        roomsRef.getDocument { document, error in
            guard let document = document, document.exists, var room = try? document.data(as: Room.self) else {return}
            room.account[1] = self.acc
            room.count = 2
            do {
                try roomsRef.setData(from: room)
                profilesRef.getDocument { document, error in
                    guard let document = document, document.exists, var profile = try? document.data(as: Profile.self) else {return}
                    for (index, _) in profile.formation.enumerated() {
                        profile.formation[index].changePlayer()
                    }
                    room.units += profile.formation
                    do {
                        try roomsRef.setData(from: room)
                        self.roomID = room.roomID
                        self.isWaiting = false
                        self.timer?.invalidate()
                        self.isGame = true
                    } catch {print(error)}
                }
            } catch {print(error)}
        }
    }
    func createRoom() {
        db.collection("profiles").document(self.acc).getDocument { document, error in
            guard let document = document, document.exists, let profile = try? document.data(as: Profile.self) else {return}
            do {
                self.roomID = String(Int.random(in: 100000000...999999999))
                var room = Room(roomID: self.roomID, isShow: false, account: [self.acc,"waiting"])
                room.units += profile.formation
                try self.db.collection("rooms").document(self.roomID).setData(from: room)
                self.rankID = try self.db.collection("ranks").addDocument(from: ["roomID": self.roomID]).documentID
                self.listenRoom()
            } catch {print(error)}
        }
    }
    func waittingRank() {
        db.collection("ranks").limit(to: 1).getDocuments {querySnapshot, error in
            if let querySnapshot = querySnapshot {
                if querySnapshot.documents.count == 0 {
                    self.createRoom()
                }else{
                    self.roomID = querySnapshot.documents[0].data()["roomID"] as! String
                    self.db.collection("ranks").document(querySnapshot.documents[0].documentID).delete()
                    self.db.collection("rooms").document(self.roomID).getDocument { document, error in
                        guard let document = document, document.exists,
                              let room = try? document.data(as: Room.self),
                              room.count == 1, room.account[0] != self.acc else {return}
                        self.joinRoom(room.roomID)
                    }
                }
            }
        }
    }
    func tapRank() {
        if !isWaiting {
            isWaiting = true
            waittingRank()
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                withAnimation(.linear(duration: 1)) {self.rotationAngle += 360}
            }
        }else{
            if rankID != nil {
                db.collection("ranks").document(rankID!).delete()
                db.collection("rooms").document(roomID).delete()
                rankID = nil
            }
            isWaiting = false
            timer?.invalidate()
        }
    }

    func logout() {
        do {
            try Auth.auth().signOut()
            isLogin = false
        } catch {print(error)}
    }
    
    func getProfile() {
        db.collection("profiles").document(self.acc).getDocument { document, error in
            guard let document = document, document.exists,
                  let profile = try? document.data(as: Profile.self) else {return}
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

import MessageUI

struct MailView: UIViewControllerRepresentable {
    var recipient: String
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.setToRecipients([recipient])
        mailComposeVC.setSubject("Boardustry - Report Bug")
        mailComposeVC.setMessageBody("", isHTML: false)
        mailComposeVC.mailComposeDelegate = context.coordinator
        return mailComposeVC
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true, completion: nil)
        }
    }
}
