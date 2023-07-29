import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

class GameModel: ObservableObject {
    let db = Firestore.firestore()
    let boardSize: Int = Int(shortSide)/divisor
    @AppStorage("isGame") var isGame: Bool = false
    @AppStorage("roomID") var roomID: String = "00000000"
    @AppStorage("acc") var acc: String = ""
    @Published var room: Room = Room()
    @Published var isMyTurn: Bool = false
    @Published var index: [Int] = [0,1]
    @Published var hearts: [Int] = [3,3]
    @Published var heartsTemp: [Int] = [3,3]
    @Published var units: [Unit] = []
    @Published var unitsTemp: [Unit] = []
    @Published var items: [Int] = [0,0,0,0,0]
    @Published var itemsTemp: [Int] = [0,0,0,0,0]
    @Published var canChoose: [[Int]] = [[]]
    @Published var canNotChoose: [[Int]] = [[]]
    @Published var unitChooseIndex: Int?
    @Published var pageState: Bool = false
    @Published var isEnd: Bool = false
    @Published var showMenu: Bool = false
    @Published var showDatabase: Bool = false
    @Published var showSettings: Bool = false
    @Published var newUnitChoose: UnitName = .Null
    
    init() {
        getRoom()
    }
    
    func callEnd() {
        isEnd = true
        updateGame()
    }
    
    func End() {
        roomID = "00000000"
        isGame = false
    }
    
    func rankPointAdj(_ acc: String, rp: Int) {
        
    }
    
    func gameWin() {
        if roomID.count == 9 {
            var profiles: [Profile] = []
            db.collection("profiles").document(room.account[index[0]]).getDocument { document, error in
                guard let document = document, document.exists, let profile = try? document.data(as: Profile.self) else {return}
                profiles.append(profile)
                self.db.collection("profiles").document(self.room.account[self.index[1]]).getDocument { document, error in
                    guard let document = document, document.exists, let profile = try? document.data(as: Profile.self) else {return}
                    profiles.append(profile)
                    if profiles[1].rank < 1000 || profiles[1].rank < profiles[0].rank {
                        do {
                            profiles[0].rank += 200
                            try self.db.collection("profiles").document(self.room.account[self.index[0]]).setData(from: profiles[0])
                        } catch {print(error)}
                    }else{
                        do {
                            profiles[0].rank += 200+Int(0.1*Double((profiles[1].rank - profiles[0].rank)))
                            profiles[1].rank -= Int(0.2*Double((profiles[1].rank - profiles[0].rank)))
                            try self.db.collection("profiles").document(self.room.account[self.index[0]]).setData(from: profiles[0])
                            try self.db.collection("profiles").document(self.room.account[self.index[1]]).setData(from: profiles[1])
                            self.isEnd = true
                            self.updateGame()
                        } catch {print(error)}
                    }
                }
            }
        }else{
            isEnd = true
            updateGame()
        }
    }
    
    func clearClick() {
        canChoose = []
        canNotChoose = []
        unitChooseIndex = nil
        newUnitChoose = .Null
    }
    
    func recovery() {
        clearClick()
        units = unitsTemp
        items = itemsTemp
        hearts = heartsTemp
    }
    
    func getPrice(_ name: UnitName) -> [Int] {
        switch name {
        case .unitMace:
            return [100,0,0,20]
        case .unitPulsar:
            return [100,0,20,0]
        case .unitAtrax:
            return [100,20,0,0]
        case .blockMechanical:
            return [150,0,0,0]
        case .blockPneumatic:
            return [100,100,0,0]
        case .blockSiSmelter:
            return [100,100,0,0]
        case .blockCryofluidMixer:
            return [200,0,0,200]
        default:
            return [0,0,0,0]
        }
    }
    
    func subtractArrays(arr1: [Int], arr2: [Int]) -> [Int] {
        var result = [Int]()
        for i in 0..<arr1.count {
            if i < arr2.count {result.append(arr1[i] - arr2[i])}
            else {result.append(arr1[i])}
        }
        return result
    }
    
    func addUnit() {
        unitChooseIndex = nil
        canChoose = index[0] == 0 ? [[3,14],[5,14],[3,13],[5,13],[4,13]] : [[3,0],[5,0],[3,1],[5,1],[4,1]]
        canNotChoose = []
        var unitsMatch: [Unit] {
            units.filter { unitFilter in canChoose.contains {$0 == unitFilter.getPos()} }
        }
        for unitMatch in unitsMatch {
            canNotChoose.append(unitMatch.getPos())
        }
    }
    
    func updateGame() {
        do {
            room.saveGame(turn: room.turn+1, units: self.units, hearts: self.hearts, items: self.items, isEnd: self.isEnd)
            try db.collection("rooms").document(roomID).setData(from: room)
            self.clearClick()
        } catch {print(error)}
    }
    
    func tapUnit(_ unitIndex: Int) {
        if units[unitIndex].isPoly, isMyTurn, units[unitIndex].player == index[0], unitIndex == unitChooseIndex {
            units[unitIndex].isPoly = false
            clearClick()
            return
        }
        if isMyTurn, items[4]>0 {
            if units[unitIndex].player == index[0] {
                if unitIndex != unitChooseIndex {
                    canChoose = units[unitIndex].canMoveTo()
                    canNotChoose = []
                    var unitsMatch: [Unit] {
                        units.filter { unitFilter in canChoose.contains {$0 == unitFilter.getPos()} }
                    }
                    for unitMatch in unitsMatch {
                        if unitMatch.player == index[0] || !(units[unitIndex].getWinType().contains(unitMatch.name)) {
                            canNotChoose.append(unitMatch.getPos())
                        }
                    }
                    unitChooseIndex = unitIndex
                }
            }
            if units[unitIndex].player == index[1] {
                if unitChooseIndex != nil,
                   units[unitChooseIndex!].canMoveTo().contains(units[unitIndex].getPos()),
                   units[unitChooseIndex!].getWinType().contains(units[unitIndex].name) {
                    if units[unitIndex].name == UnitName.blockCore {
                        units[unitChooseIndex!] = Unit(name: .Null, position: [-1,-1], player: -1)
                        unitChooseIndex = nil
                        hearts[index[1]] -= 1
                        if hearts[index[1]] == 0 {
                            gameWin()
                        }
                    }else{
                        units[unitChooseIndex!].moveTo(units[unitIndex].getPos())
                        units[unitIndex] = Unit(name: .Null, position: [-1,-1], player: -1)
                    }
                    items[4] -= 1
                    clearClick()
                }
            }
        }
    }
    
    func getRoom() {
        db.collection("rooms").document(roomID).getDocument { document, error in
            guard let document = document, document.exists, let room = try? document.data(as: Room.self) else {
                self.isGame = false
                return
            }
            self.room = room
            if self.acc == room.account[1] {
                self.index[0] = 1
                self.index[1] = 0
            }
            self.listenGameChange()
        }
    }
    
    func listenGameChange() {
        db.collection("rooms").document(roomID).addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else { return }
            guard let room = try? snapshot.data(as: Room.self) else {return}
            self.room = room
            self.units = room.units
            self.items = room.getMyItems(self.index[0])
            self.hearts = room.hearts
            self.unitsTemp = self.units
            self.itemsTemp = self.items
            self.heartsTemp = self.hearts
            if room.isEnd, !self.isEnd {
                self.isEnd = true
            }else if (room.turn+1)%2 == self.index[0] {
                self.isMyTurn = true
                self.items[4] = 5
                for unit in self.units {
                    if unit.player == self.index[0] {
                        self.items = zip(self.items, unit.getTurnEarn()).map {$0 + $1}
                        if self.items[2] < 0 {
                            self.items[2] += 30
                            self.items[4] -= 1
                        }
                    }
                }
                self.itemsTemp = self.items
            }else{
                self.isMyTurn = false
            }
        }
    }
}
