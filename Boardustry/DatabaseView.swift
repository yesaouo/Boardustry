import SwiftUI
import AVFoundation

struct DatabaseView: View {
    @State var isUnit: Bool = true
    @Binding var showDatabase: Bool
    var body: some View {
        ZStack {
            Color(red: 0, green: 0, blue: 0, opacity: 0.8).ignoresSafeArea()
            VStack {
                Text("Database").bold().foregroundColor(.yellow)
                Divider().frame(height: 2).background(Color.yellow)
                Spacer()
                VStack {
                    if isUnit {
                        HStack {
                            VStack {
                                Rectangle().fill(Color.red).frame(width: 30, height: 30).border(Color.black)
                                Rectangle().fill(Color.green).frame(width: 30, height: 30).border(Color.black)
                                Rectangle().fill(Color.red).frame(width: 30, height: 30).border(Color.black)
                            }
                            VStack {
                                Rectangle().fill(Color.green).frame(width: 30, height: 30).border(Color.black)
                                Image("unitMace").resizable().frame(width: 30, height: 30)
                                Rectangle().fill(Color.green).frame(width: 30, height: 30).border(Color.black)
                            }
                            VStack {
                                Rectangle().fill(Color.red).frame(width: 30, height: 30).border(Color.black)
                                Rectangle().fill(Color.green).frame(width: 30, height: 30).border(Color.black)
                                Rectangle().fill(Color.red).frame(width: 30, height: 30).border(Color.black)
                            }
                            VStack {
                                Text("Mace").foregroundColor(.yellow)
                                MineView(mine: "Copper", mineCnt: .constant(100))
                                MineView(mine: "Silicon", mineCnt: .constant(20))
                            }
                        }
                        Divider().frame(height: 1).background(Color.gray)
                        HStack {
                            VStack {
                                Rectangle().fill(Color.green).frame(width: 30, height: 30).border(Color.black)
                                Rectangle().fill(Color.red).frame(width: 30, height: 30).border(Color.black)
                                Rectangle().fill(Color.green).frame(width: 30, height: 30).border(Color.black)
                            }
                            VStack {
                                Rectangle().fill(Color.red).frame(width: 30, height: 30).border(Color.black)
                                Image("unitPulsar").resizable().frame(width: 30, height: 30)
                                Rectangle().fill(Color.red).frame(width: 30, height: 30).border(Color.black)
                            }
                            VStack {
                                Rectangle().fill(Color.green).frame(width: 30, height: 30).border(Color.black)
                                Rectangle().fill(Color.red).frame(width: 30, height: 30).border(Color.black)
                                Rectangle().fill(Color.green).frame(width: 30, height: 30).border(Color.black)
                            }
                            VStack {
                                Text("Pulsar").foregroundColor(.yellow)
                                MineView(mine: "Copper", mineCnt: .constant(100))
                                MineView(mine: "Titanium", mineCnt: .constant(20))
                            }
                        }
                        Divider().frame(height: 1).background(Color.gray)
                        HStack {
                            VStack {
                                Rectangle().fill(Color.green).frame(width: 30, height: 30).border(Color.black)
                                Rectangle().fill(Color.red).frame(width: 30, height: 30).border(Color.black)
                                Rectangle().fill(Color.red).frame(width: 30, height: 30).border(Color.black)
                            }
                            VStack {
                                Rectangle().fill(Color.green).frame(width: 30, height: 30).border(Color.black)
                                Image("unitAtrax").resizable().frame(width: 30, height: 30)
                                Rectangle().fill(Color.green).frame(width: 30, height: 30).border(Color.black)
                            }
                            VStack {
                                Rectangle().fill(Color.green).frame(width: 30, height: 30).border(Color.black)
                                Rectangle().fill(Color.red).frame(width: 30, height: 30).border(Color.black)
                                Rectangle().fill(Color.red).frame(width: 30, height: 30).border(Color.black)
                            }
                            VStack {
                                Text("Atrax").foregroundColor(.yellow)
                                MineView(mine: "Copper", mineCnt: .constant(100))
                                MineView(mine: "Lead", mineCnt: .constant(20))
                            }
                        }
                        Divider().frame(height: 1).background(Color.gray)
                        HStack {
                            VStack {
                                Image("unitMace").resizable().frame(width: 30, height: 30)
                                HStack {
                                    Image("icon_ArrowUpRight").resizable().frame(width: 30, height: 30)
                                    Image("icon_ArrowDownRight").resizable().frame(width: 30, height: 30)
                                }
                                HStack {
                                    Image("unitPulsar").resizable().frame(width: 30, height: 30)
                                    Image("icon_ArrowLeft").resizable().frame(width: 30, height: 30)
                                    Image("unitAtrax").resizable().frame(width: 30, height: 30)
                                }
                            }
                            Image("icon_ArrowLeft").resizable().frame(width: 30, height: 30).rotationEffect(.degrees(180))
                            Rectangle().fill(Color.green).frame(width: 30, height: 30).border(Color.black)
                            VStack {
                                Rectangle().fill(Color.green).frame(width: 30, height: 30).border(Color.black)
                                Rectangle().fill(Color.green).frame(width: 30, height: 30).border(Color.black)
                                Rectangle().fill(Color.green).frame(width: 30, height: 30).border(Color.black)
                            }
                            VStack {
                                Rectangle().fill(Color.green).frame(width: 30, height: 30).border(Color.black)
                                Rectangle().fill(Color.green).frame(width: 30, height: 30).border(Color.black)
                                Image("unitPoly").resizable().frame(width: 30, height: 30)
                                Rectangle().fill(Color.green).frame(width: 30, height: 30).border(Color.black)
                                Rectangle().fill(Color.green).frame(width: 30, height: 30).border(Color.black)
                            }
                            VStack {
                                Rectangle().fill(Color.green).frame(width: 30, height: 30).border(Color.black)
                                Rectangle().fill(Color.green).frame(width: 30, height: 30).border(Color.black)
                                Rectangle().fill(Color.green).frame(width: 30, height: 30).border(Color.black)
                            }
                            Rectangle().fill(Color.green).frame(width: 30, height: 30).border(Color.black)
                        }
                    }else{
                        HStack(spacing: 50) {
                            VStack {
                                Text("Mechanical Drill").foregroundColor(.yellow)
                                HStack {
                                    Image("blockMechanical").resizable().frame(width: 60, height: 60)
                                    MineView(mine: "Copper", mineCnt: .constant(150))
                                }
                            }
                            VStack {
                                Text("Output").foregroundColor(.white)
                                MineView(mine: "Copper", mineCnt: .constant(50))
                                MineView(mine: "Lead", mineCnt: .constant(20))
                            }
                        }
                        Divider().frame(height: 1).background(Color.gray)
                        HStack(spacing: 50) {
                            VStack {
                                Text("Pneumatic Drill").foregroundColor(.yellow)
                                HStack {
                                    Image("blockPneumatic").resizable().frame(width: 60, height: 60)
                                    VStack {
                                        MineView(mine: "Copper", mineCnt: .constant(100))
                                        MineView(mine: "Lead", mineCnt: .constant(100))
                                    }
                                }
                            }
                            VStack {
                                Text("Output").foregroundColor(.white)
                                MineView(mine: "Titanium", mineCnt: .constant(20))
                            }
                        }
                        Divider().frame(height: 1).background(Color.gray)
                        HStack(spacing: 50) {
                            VStack {
                                Text("Silicon Smelter").foregroundColor(.yellow)
                                HStack {
                                    Image("blockSiSmelter").resizable().frame(width: 60, height: 60)
                                    VStack {
                                        MineView(mine: "Copper", mineCnt: .constant(100))
                                        MineView(mine: "Lead", mineCnt: .constant(100))
                                    }
                                }
                            }
                            VStack {
                                Text("Output").foregroundColor(.white)
                                MineView(mine: "Silicon", mineCnt: .constant(20))
                            }
                        }
                        Divider().frame(height: 1).background(Color.gray)
                        HStack(spacing: 50) {
                            VStack {
                                Text("Cryofluid Mixer").foregroundColor(.yellow)
                                HStack {
                                    Image("blockCryofluidMixer").resizable().frame(width: 60, height: 60)
                                    VStack {
                                        MineView(mine: "Copper", mineCnt: .constant(200))
                                        MineView(mine: "Silicon", mineCnt: .constant(200))
                                    }
                                }
                            }
                            VStack {
                                Text("Input").foregroundColor(.white)
                                MineView(mine: "Titanium", mineCnt: .constant(30))
                            }
                            VStack {
                                Text("Output").foregroundColor(.white)
                                Image("liquid_Cryofluid").resizable().frame(width: 20, height: 20)
                            }
                        }
                    }
                }
                Group {
                    Spacer()
                    Text("\(isUnit ? "Units" : "Blocks")").foregroundColor(.yellow)
                    Divider().frame(height: 1).background(Color.yellow)
                    Button("\(isUnit ? "Blocks" : "Units")") {
                        AVPlayer.dataBtn.playFromStart()
                        isUnit.toggle()
                    }
                    Button(action: {
                            AVPlayer.crossBtn.playFromStart()
                            showDatabase = false}) {
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
}
