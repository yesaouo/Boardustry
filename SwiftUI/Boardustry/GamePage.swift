import SwiftUI
import AVFoundation

struct GamePage: View {
    @StateObject var model = GameModel()
    var body: some View {
        ZStack {
            Color(red: 0.996, green: 0.98, blue: 0.878).ignoresSafeArea()
            VStack {
                if model.room.count == 2 {
                    HStack {
                        Image("Peko").resizable().frame(width: 50, height: 50)
                        VStack {
                            PlayerView(acc: model.acc)
                            HStack {
                                ForEach((0..<model.hearts[model.index[0]]), id: \.self) { i in
                                    Image("Heart").resizable().frame(width: 20, height: 20)
                                }
                            }
                        }
                        Spacer()
                        Image("VS").resizable().frame(width: 40, height: 40)
                        Spacer()
                        VStack {
                            PlayerView(acc: model.room.account[model.index[1]])
                            HStack {
                                ForEach((0..<model.hearts[model.index[1]]), id: \.self) { i in
                                    Image("Heart").resizable().frame(width: 20, height: 20)
                                }
                            }
                        }
                        Image("Miko").resizable().frame(width: 50, height: 50)
                    }
                    HStack {
                        Image("icon_Menu").resizable().frame(width: 30, height: 30)
                            .onTapGesture {model.showMenu = true}
                        if model.isMyTurn {
                            ForEach(1...5, id: \.self) { i in
                                Image("\(model.items[4]-5 >= i ? "liquid_Cryofluid" : "liquid_Water")").resizable().frame(width: 20, height: 20)
                                    .opacity(model.items[4] >= i ? 1 : 0)
                            }
                        }else{
                            Text("Enemy's turn").bold().foregroundColor(.red)
                        }
                        Image(model.isMyTurn ? "icon_Checkmark" : "icon_CheckmarkFill").resizable().frame(width: 30, height: 30)
                            .onTapGesture {if model.isMyTurn {model.updateGame()}}
                    }
                    Spacer()
                    GameBoardView().environmentObject(model).rotationEffect(Angle(degrees: model.index[0] == 0 ? 0 : 180))
                    Spacer()
                    RoundedRectangle(cornerRadius: 25.0).fill(Color.blue).frame(height: 180)
                        .overlay(
                            HStack {
                                StateView().environmentObject(model)
                                Image(systemName: "arrow.up.arrow.down.square.fill")
                                    .onTapGesture {
                                        AVPlayer.sysBtn.playFromStart()
                                        model.newUnitChoose = .Null
                                        model.pageState.toggle()
                                    }
                            }.padding(10),alignment: .trailing)
                }
            }
            .alert(isPresented: $model.isEnd) {
                Alert(title: Text("Game Over"), message: Text(model.hearts[model.index[0]]>0 ?
                    model.hearts[model.index[1]]>0 ? "Someone has left the game" : "You Win!" :
                    "You Lose!"), dismissButton: .default(Text("Exit"), action: {model.End()}))
            }
            if model.showMenu {GameMenuView().environmentObject(model)}
            if model.showDatabase {DatabaseView(showDatabase: $model.showDatabase)}
            if model.showSettings {SettingsView(showSettings: $model.showSettings)}
        }
    }
}

struct GameMenuView: View {
    @EnvironmentObject var model: GameModel
    var body: some View {
        ZStack {
            Color(red: 0, green: 0, blue: 0, opacity: 0.8).ignoresSafeArea()
            VStack {
                Text("Menu").bold().foregroundColor(.yellow)
                Divider().frame(height: 2).background(Color.yellow)
                Spacer()
                HStack {
                    Button(action: {
                            AVPlayer.bigBtn.playFromStart()
                            model.showMenu = false}) {
                        ZStack {
                            Rectangle().opacity(0).frame(width: 90, height: 90).cornerRadius(5)
                                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 4))
                            VStack {
                                Image("icon_Play").resizable().scaledToFit().frame(width: 25, height: 25)
                                Text("Back").foregroundColor(.white).bold()
                            }
                        }
                    }
                    Button(action: {
                            AVPlayer.bigBtn.playFromStart()
                            model.recovery()}) {
                        ZStack {
                            Rectangle().opacity(0).frame(width: 90, height: 90).cornerRadius(5)
                                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 4))
                            VStack {
                                Image("icon_Clockwise").resizable().scaledToFit().frame(width: 25, height: 25)
                                Text("Recovery").foregroundColor(.white).bold()
                            }
                        }
                    }
                    
                }
                HStack {
                    Button(action: {
                            AVPlayer.bigBtn.playFromStart()
                            model.showSettings = true}) {
                        ZStack {
                            Rectangle().opacity(0).frame(width: 90, height: 90).cornerRadius(5)
                                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 4))
                            VStack {
                                Image("icon_Gear").resizable().scaledToFit().frame(width: 25, height: 25)
                                Text("Settings").foregroundColor(.white).bold()
                            }
                        }
                    }
                    Button(action: {
                            AVPlayer.bigBtn.playFromStart()
                            model.showDatabase = true}) {
                        ZStack {
                            Rectangle().opacity(0).frame(width: 90, height: 90).cornerRadius(5)
                                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 4))
                            VStack {
                                Image("icon_BookClose").resizable().scaledToFit().frame(width: 25, height: 25)
                                Text("Database").foregroundColor(.white).bold()
                            }
                        }
                    }
                }
                Button(action: {
                        AVPlayer.bigBtn.playFromStart()
                        model.callEnd()}) {
                    ZStack {
                        Rectangle().opacity(0).frame(width: 90, height: 90).cornerRadius(5)
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 4))
                        VStack {
                            Image("icon_Portrait").resizable().scaledToFit().frame(width: 25, height: 25)
                            Text("Quit").foregroundColor(.white).bold()
                        }
                    }
                }
                Spacer()
            }
        }
    }
}

struct GameBoardView: View {
    @EnvironmentObject var model: GameModel
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ForEach(0...14, id: \.self) { y in
                    HStack(spacing: 0) {
                        ForEach(0...8, id: \.self) { x in
                            let choose = model.canChoose.contains {$0 == [x,y]}
                            let notChoose = model.canNotChoose.contains {$0 == [x,y]}
                            Rectangle()
                                .fill(notChoose ? Color.red : choose ? Color.green : Color.white)
                                .border(Color.black, width: 1)
                                .frame(width: CGFloat(model.boardSize), height: CGFloat(model.boardSize))
                                .onTapGesture {
                                    if model.isMyTurn, choose, !notChoose {
                                        if model.unitChooseIndex == nil {
                                            model.items = model.subtractArrays(arr1: model.items, arr2: model.getPrice(model.newUnitChoose))
                                            model.units.append(Unit(name: model.newUnitChoose, position: [x,y], player: model.index[0]))
                                        }else if model.items[4]>0 {
                                            model.units[model.unitChooseIndex!].moveTo([x,y])
                                            model.items[4] -= 1
                                        }
                                    }
                                    model.clearClick()
                                }
                        }
                    }
                }
            }.overlay(Rectangle().stroke(Color.black, lineWidth: 5))
            ForEach(model.units.indices, id: \.self) { index in
                if model.units[index].name != .Null {
                    Image("\(model.units[index].isPoly ? UnitName.unitPoly.rawValue : model.units[index].name.rawValue)")
                        .resizable()
                        .frame(width: CGFloat(model.boardSize), height: CGFloat(model.boardSize))
                        .rotationEffect(Angle(degrees: model.units[index].player == 0 ? 0 : 180))
                        .offset(model.units[index].getOffset(model.boardSize))
                        .animation(.easeOut(duration: 1), value: model.units[index].getX(model.boardSize))
                        .animation(.easeOut(duration: 1), value: model.units[index].getY(model.boardSize))
                        .onTapGesture {model.tapUnit(index)}
                }
            }
        }
    }
}
