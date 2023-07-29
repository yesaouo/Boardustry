import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import AVFoundation

struct FormationView: View {
    let db = Firestore.firestore()
    let boardSize: CGFloat = CGFloat(Int(shortSide)/divisor)
    @AppStorage("acc") var acc: String = ""
    @State var unitChoose: UnitName = .Null
    @State var formate: [Unit] = []
    @State var units: [UnitName] = [.unitMace,.unitPulsar,.unitAtrax]
    @State var isUpdate: Bool = false
    @State var isDownload: Bool = false
    func getMyFormation() {
        db.collection("profiles").document(acc).getDocument { document, error in
            guard let document = document, document.exists, let profile = try? document.data(as: Profile.self) else {return}
            formate = profile.formation
            isDownload = true
            isUpdate = false
        }
    }
    func updateMyformation() {
        let profileReference = db.collection("profiles").document(acc)
        profileReference.getDocument { document, error in
            guard let document = document, document.exists, var profile = try? document.data(as: Profile.self) else {return}
            profile.formation = formate
            do {
                try profileReference.setData(from: profile)
                isUpdate = false
            } catch {print(error)}
        }
    }
    var body: some View {
        VStack {
            HStack {
                Button {
                    AVPlayer.sysBtn.playFromStart()
                    getMyFormation()
                } label: {Image("icon_CloudDown\(isDownload ? "" : "Fill")")}
                .disabled(isDownload)
                Button {
                    AVPlayer.sysBtn.playFromStart()
                    formate.removeLast()
                    isUpdate = true
                    isDownload = false
                } label: {Image("icon_Uturn")}
                .disabled(formate.count == 0)
                Button {
                    AVPlayer.sysBtn.playFromStart()
                    updateMyformation()
                } label: {Image("icon_CloudUp\(isUpdate ? "Fill" : "")")}
                .disabled(!isUpdate)
                Text("\(formate.count)/5").font(.largeTitle)
            }
            ZStack {
                VStack(spacing: 0) {
                    ForEach(0...2, id: \.self) { y in
                        HStack(spacing: 0) {
                            ForEach(0...8, id: \.self) { x in
                                Rectangle().fill(Color.white).border(Color.black, width: 1).frame(width: boardSize, height: boardSize)
                                    .onTapGesture {
                                        formate.append(Unit(name: unitChoose, position: [x,10+y]))
                                        isUpdate = true
                                        isDownload = false
                                    }
                            }
                        }
                    }
                }.overlay(Rectangle().stroke(Color.black, lineWidth: 5))
                ForEach(formate) {unit in
                    Image("\(unit.name.rawValue)").resizable().frame(width: boardSize, height: boardSize)
                        .offset(x: CGFloat(unit.posX-4)*boardSize, y: CGFloat(unit.posY-11)*boardSize)
                }
            }
            ZStack {
                RoundedRectangle(cornerRadius: 25.0).fill(Color(red: 0.1137, green: 0.2078, blue: 0.3412)).frame(width: 240, height: 60)
                HStack {
                    ForEach(units, id: \.self) {unit in
                        ZStack {
                            RoundedRectangle(cornerRadius: 10).fill(Color.white).frame(width: 60, height: 40)
                            if unitChoose == unit {RoundedRectangle(cornerRadius: 10).stroke(formate.count<5 ? Color.yellow : Color.red, lineWidth: 5).frame(width: 60, height: 40)}
                            Image("\(unit.rawValue)").resizable().frame(width: 40, height: 40)
                        }.onTapGesture {unitChoose = unit}
                    }
                }
            }
        }
    }
}
