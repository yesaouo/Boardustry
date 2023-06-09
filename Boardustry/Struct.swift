import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct News: Codable, Identifiable {
    @DocumentID var id: String?
    let time: Date
    let title: String
    let content: String
}

struct Profile: Codable, Identifiable {
    @DocumentID var id: String?
    var name: String = ""
    var photo: String = ""
    var rank: Int = 0
    var coin: Int = 0
    var diamond: Int = 0
    var formation: [Unit] = [
        Unit(name: .unitMace, position: [4,11]),
        Unit(name: .unitPulsar, position: [2,11]),
        Unit(name: .unitPulsar, position: [6,11]),
        Unit(name: .unitAtrax, position: [3,12]),
        Unit(name: .unitAtrax, position: [5,12])
    ]
}

struct Room: Codable, Identifiable {
    @DocumentID var id: String?
    var roomID: String = "00000000"
    var time: Date = Date()
    var isShow: Bool = true
    var count: Int = 1
    var account: [String] = ["waiting", "waiting"]
    var isReady: [Bool] = [false, false]
    var turn: Int = 1
    var units: [Unit] = [
        Unit(name: .blockCore, position: [4,14]),
        Unit(name: .blockCore, position: [4,0], player: 1),
        Unit(name: .blockMechanical, position: [1,14], isPoly: false),
        Unit(name: .blockMechanical, position: [7,14], isPoly: false),
        Unit(name: .blockMechanical, position: [1,0], player: 1, isPoly: false),
        Unit(name: .blockMechanical, position: [7,0], player: 1, isPoly: false)]
    var hearts: [Int] = [3, 3]
    var items: [Int] = [0,0,0,0,0,0,0,0,0,0]
    var isEnd: Bool = false
    
    func getMyItems(_ index: Int) -> [Int] {
        return Array(items[(5*index)...(5*index+4)])
    }
    mutating func saveGame(turn: Int, units: [Unit], hearts: [Int], items: [Int], isEnd: Bool) {
        self.turn = turn
        self.units = units
        self.hearts = hearts
        self.isEnd = isEnd
        let index = turn%2
        for i in 0...4 {
            self.items[i+5*index] = items[i]
        }
    }
}

enum UnitName: String, Codable{
    case Null,blockCore,unitMace,unitPulsar,unitAtrax,unitPoly
        ,blockMechanical,blockPneumatic,blockSiSmelter,blockCryofluidMixer
}

struct Unit: Codable, Identifiable {
    let id = UUID()
    var name: UnitName
    var player: Int
    var posX: Int
    var posY: Int
    var isPoly: Bool = false
    
    init(name: UnitName, position: [Int], player: Int = 0, isPoly: Bool = true) {
        self.name = name
        self.player = player
        self.posX = position[0]
        self.posY = position[1]
        switch name {
        case .blockMechanical, .blockPneumatic, .blockSiSmelter, .blockCryofluidMixer:
            self.isPoly = isPoly
            break
        default:
            break
        }
    }

    mutating func changePlayer() {
        posX = 8-posX
        posY = 14-posY
        player = (player+1)%2
    }
    
    mutating func moveTo(_ position: [Int]) {
        self.posX = position[0]
        self.posY = position[1]
    }

    func getTurnEarn() -> [Int] {
        switch name {
        case .blockMechanical:
            return [50,20,0,0,0]
        case .blockPneumatic:
            return [0,0,20,0,0]
        case .blockSiSmelter:
            return [0,0,0,20,0]
        case .blockCryofluidMixer:
            return [0,0,-30,0,1]
        default:
            return [0,0,0,0,0]
        }
    }

    func getCanMove() -> [[Int]] {
        switch name {
        case .blockCore:
            return []
        case .unitMace:
            return [[0,1],[1,0],[0,-1],[-1,0]]
        case .unitPulsar:
            return [[1,1],[1,-1],[-1,-1],[-1,1]]
        case .unitAtrax:
            return player == 0 ? [[1,-1],[0,-1],[-1,-1],[0,1]] : [[1,1],[0,1],[-1,1],[0,-1]]
        default:
            return isPoly ? [[0,1],[1,0],[0,-1],[-1,0],[1,1],[1,-1],[-1,-1],[-1,1],[0,2],[2,0],[0,-2],[-2,0]] : []
        }
    }

    func getWinType() -> [UnitName] {
        switch name {
        case .unitMace:
            return [.blockCore, .blockMechanical, .blockPneumatic, .blockSiSmelter, .blockCryofluidMixer, .unitAtrax]
        case .unitPulsar:
            return [.blockCore, .blockMechanical, .blockPneumatic, .blockSiSmelter, .blockCryofluidMixer, .unitMace]
        case .unitAtrax:
            return [.blockCore, .blockMechanical, .blockPneumatic, .blockSiSmelter, .blockCryofluidMixer, .unitPulsar]
        default:
            return []
        }
    }
    
    func getPos() -> [Int] {
        return [posX,posY]
    }

    func canMoveTo() -> [[Int]] {
        var result: [[Int]] = []
        for move in getCanMove() {
            result.append([posX + move[0], posY + move[1]])
        }
        return result
    }
    
    func getOffset(_ size: Int) -> CGSize {
        let x = CGFloat((posX-4)*size)
        let y = CGFloat((posY-7)*size)
        return CGSize(width: x, height: y)
    }

    func getX(_ size: Int) -> CGFloat {
        return CGFloat((posX-4)*size)
    }

    func getY(_ size: Int) -> CGFloat {
        return CGFloat((posY-7)*size)
    }
}
