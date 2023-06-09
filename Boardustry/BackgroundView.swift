import SwiftUI

struct BackgroundView: View {
    @State private var position = CGSize(width: 0, height: 0)
    @State private var velocity = CGSize(width: 5, height: 3)
    @State private var rotationAngle: Double = 0
    let unitSize: CGFloat = 50
    let screenBounds = UIScreen.main.bounds
    var body: some View {
        ZStack {
            Image("Bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            Image("unitGamma")
                .resizable()
                .scaledToFit()
                .frame(width: unitSize, height: unitSize)
                .rotationEffect(Angle(degrees: rotationAngle))
                .offset(x: position.width, y: position.height)
                .animation(.linear(duration: 0.02))
                .onAppear { self.startAnimating() }
        }
        
    }
    func startAnimating() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
            self.updatePosition()
            self.startAnimating()
        }
    }
    func updatePosition() {
        let newPosition = CGSize(width: position.width + velocity.width, height: position.height + velocity.height)
        if newPosition.width < -screenBounds.width/2 || newPosition.width > screenBounds.width/2 {
            velocity.width = -velocity.width
        }
        if newPosition.height < -screenBounds.height/2 || newPosition.height > screenBounds.height/2 {
            velocity.height = -velocity.height
        }
        position = newPosition
        rotationAngle = Double(atan2(velocity.height, velocity.width) * 180 / .pi) + 90
    }
}
