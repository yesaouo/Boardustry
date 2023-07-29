import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

class RoomModel: ObservableObject {
    let db = Firestore.firestore()
    @Published var room: Room = Room()
    @Published var searchID: String = ""
    @Published var isCross: Bool = false
    @Published var isCreate: Bool = false
    @Published var isPublic: Bool = true
    @Published var isReady: [Bool] = [false, false]
    @AppStorage("acc") var acc: String = ""
    @AppStorage("isGame") var isGame: Bool = false
    @AppStorage("roomID") var roomID: String = "00000000"
    
    init() {
        listenRooms()
    }
    
    func enterRoom() {
        self.isCross = true
        self.isCreate = true
    }
    
    func enterGame() {
        self.isCross = false
        self.isCreate = false
        self.isGame = true
    }
    
    func listenRooms() {
        db.collection("rooms").order(by: "time", descending: true).addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {return}
            for document in documents {
                if let room = try? document.data(as: Room.self), room.roomID == self.roomID {
                    if room.count == 2, !room.isEnd {
                        if room.account[0] == self.acc {
                            self.room = room
                            self.isReady[1] = room.isReady[1]
                            if room.isReady[0], room.isReady[1] {
                                self.enterGame()
                            }
                            break
                        }
                        if room.account[1] == self.acc {
                            self.room = room
                            self.isReady[0] = room.isReady[0]
                            if room.isReady[0], room.isReady[1] {
                                self.enterGame()
                            }
                            break
                        }
                    }
                }
            }
        }
    }

    func checkAllReady() {
        let documentReference = db.collection("rooms").document(self.roomID)
        documentReference.getDocument { document, error in
            guard let document = document, document.exists, var room = try? document.data(as: Room.self) else {return}
            room.isReady = self.isReady
            do {
                try documentReference.setData(from: room)
            } catch {print(error)}
        }
    }

    func plusBtnClick() {
        if self.isCross {deleteRoom()}
        self.isCross.toggle()
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
                        self.enterRoom()
                    } catch {print(error)}
                }
            } catch {print(error)}
        }
    }
    func createRoom() {
        roomID = String(Int.random(in: 10000000...99999999))
        room = Room(roomID: self.roomID, isShow: self.isPublic, account: [self.acc,"waiting"])
        db.collection("profiles").document(self.acc).getDocument { document, error in
            guard let document = document, document.exists, let profile = try? document.data(as: Profile.self) else {return}
            do {
                self.room.units += profile.formation
                try self.db.collection("rooms").document(self.roomID).setData(from: self.room)
                self.enterRoom()
            } catch {print(error)}
        }
    }
    func deleteRoom() {
        db.collection("rooms").document(self.room.roomID).delete()
        roomID = "00000000"
        self.isCreate = false
    }
}
