import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import AVFoundation

struct RoomView: View {
    @FirestoreQuery(collectionPath: "rooms", predicates: [.order(by: "time", descending: true)]) private var rooms: [Room]
    @ObservedObject var model = RoomModel()
    var body: some View {
        ZStack {
            List {
                if !model.isCross {
                    HStack {
                        EightDigitTextField(inputText: $model.searchID)
                        Image(systemName: "magnifyingglass.circle.fill").resizable().foregroundColor(.gray).frame(width: 30, height: 30)
                    }
                    let filteredRooms = (!model.searchID.isEmpty) ? rooms.filter { $0.id?.hasPrefix(model.searchID) ?? false } : rooms
                    ForEach(filteredRooms) { room in
                        if room.count == 1, (room.isShow || room.id == model.searchID) {
                            HStack {
                                Text(room.id!)
                                Spacer()
                                VStack(alignment: .trailing) {
                                    let minutesBetween = Calendar.current.dateComponents([.minute], from: room.time, to: Date()).minute ?? 0
                                    Text("\(minutesBetween) 分鐘前建立")
                                }
                            }.onTapGesture {model.joinRoom(room.roomID)}
                        }
                    }
                }
            }.frame(width: shortSide/6*5).cornerRadius(10).overlay(
                Button {
                    AVPlayer.crossBtn.playFromStart()
                    model.plusBtnClick()} label: {
                    Image(systemName: "\(model.isCross ? "xmark.circle.fill" : "plus.circle.fill")")
                        .resizable()
                        .foregroundColor(Color(red: 0.902, green: 0.224, blue: 0.275))
                        .frame(width: 30, height: 30)
                }.offset(y: -10), alignment: .bottom)
            VStack {
                if model.isCross {
                    if !model.isCreate {
                        HStack {
                            Text("Public")
                            Toggle("Public", isOn: $model.isPublic).labelsHidden()
                        }
                        Button("CREATE ROOM") {
                            AVPlayer.bigBtn.playFromStart()
                            model.createRoom()}
                            .padding().foregroundColor(.white).background(Color.blue).cornerRadius(5.0)
                    } else {
                        Text("Room ID: \(model.room.roomID)")
                        Spacer()
                        if model.room.count == 2 {
                            HStack {
                                VStack {
                                    PlayerView(acc: model.room.account[0]).frame(width: shortSide/4)
                                    Image("Peko").resizable().frame(width: 70, height: 70)
                                    Text("\(model.isReady[0] ? "Ready" : "Not Ready")")
                                    Toggle("Ready", isOn: $model.isReady[0]).labelsHidden()
                                        .disabled(model.room.account[0] != model.acc || model.isReady[0])
                                        .onChange(of: model.isReady[0], perform: { value in model.checkAllReady()})
                                }
                                Image("VS").resizable().frame(width: 40, height: 40)
                                VStack {
                                    PlayerView(acc: model.room.account[1]).frame(width: shortSide/4)
                                    Image("Miko").resizable().frame(width: 70, height: 70)
                                    Text("\(model.isReady[1] ? "Ready" : "Not Ready")")
                                    Toggle("Ready", isOn: $model.isReady[1]).labelsHidden()
                                        .disabled(model.room.account[1] != model.acc || model.isReady[1])
                                        .onChange(of: model.isReady[1], perform: { value in model.checkAllReady()})
                                }
                            }.onAppear{model.isReady = [false, false]}
                        }else{
                            Text("Waiting...")
                        }
                        Spacer()
                    }
                }
            }
        }
    }
}

struct EightDigitTextField: View {
    @Binding var inputText: String
    var body: some View {
        TextField("Enter 8 digits", text: $inputText)
            .keyboardType(.numberPad)
            .onChange(of: inputText) { newValue in
                if newValue.count > 8 {
                    inputText = String(newValue.prefix(8))
                }
            }
    }
}
