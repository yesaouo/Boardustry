import SwiftUI
import AVFoundation

struct UnitView: View {
    let unit: UnitName
    @State var isEnough: Bool = true
    @EnvironmentObject var model: GameModel
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
            if model.newUnitChoose == unit {RoundedRectangle(cornerRadius: 10).stroke(isEnough ? Color.yellow : Color.red, lineWidth: 5)}
            VStack {
                Spacer()
                Image("\(unit.rawValue)").resizable().frame(width: 40, height: 40)
                let prices = model.getPrice(unit)
                if prices[0] > 0 {
                    MineView(mine: "Copper", mineCnt: .constant(prices[0]))
                }
                if prices[1] > 0 {
                    MineView(mine: "Lead", mineCnt: .constant(prices[1]))
                }
                if prices[2] > 0 {
                    MineView(mine: "Titanium", mineCnt: .constant(prices[2]))
                }
                if prices[3] > 0 {
                    MineView(mine: "Silicon", mineCnt: .constant(prices[3]))
                }
                Spacer()
            }
        }
        .onTapGesture {
            AVPlayer.tapUnit.playFromStart()
            if model.isMyTurn {
                model.newUnitChoose = (model.newUnitChoose == unit) ? .Null : unit
                if model.newUnitChoose == .Null {
                    model.clearClick()
                }else if model.newUnitChoose != .unitPoly {
                    let result = model.subtractArrays(arr1: model.items, arr2: model.getPrice(model.newUnitChoose))
                    if result.contains(where: { $0 < 0 }) {
                        isEnough = false
                        model.canChoose = []
                        model.canNotChoose = []
                        model.unitChooseIndex = nil
                    }else{
                        isEnough = true
                        model.addUnit()
                    }
                }
            }
        }
    }
}

struct MineView: View {
    @State var isRounded: Bool = false
    @State var mine: String
    @Binding var mineCnt: Int
    var body: some View {
        if isRounded {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                HStack {
                    Image("item_\(mine)").resizable().frame(width: 40, height: 40)
                    Text("\(mineCnt)").foregroundColor(.white)
                }
            }
        }else{
            HStack {
                Image("item_\(mine)").resizable().frame(width: 20, height: 20)
                Text("\(mineCnt)").foregroundColor(.white)
            }
        }
    }
}

struct StateView: View {
    @EnvironmentObject var model: GameModel
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25.0)
                .fill(Color.white)
                .frame(height: 160)
            if model.pageState {
                HStack {
                    let blocks: [UnitName] = [.unitPoly,.blockMechanical,.blockPneumatic,.blockSiSmelter,.blockCryofluidMixer]
                    if !blocks.contains(model.newUnitChoose) {
                        UnitView(unit: .unitMace).environmentObject(model)
                        UnitView(unit: .unitPulsar).environmentObject(model)
                        UnitView(unit: .unitAtrax).environmentObject(model)
                        UnitView(unit: .unitPoly).environmentObject(model)
                    }else{
                        UnitView(unit: .blockMechanical).environmentObject(model)
                        UnitView(unit: .blockPneumatic).environmentObject(model)
                        UnitView(unit: .blockSiSmelter).environmentObject(model)
                        UnitView(unit: .blockCryofluidMixer).environmentObject(model)
                    }
                }
            }else{
                VStack {
                    HStack {
                        MineView(isRounded: true, mine: "Copper", mineCnt: $model.items[0])
                        MineView(isRounded: true, mine: "Lead", mineCnt: $model.items[1])
                    }
                    HStack {
                        MineView(isRounded: true, mine: "Titanium", mineCnt: $model.items[2])
                        MineView(isRounded: true, mine: "Silicon", mineCnt: $model.items[3])
                    }
                }
            }
        }
    }
}
