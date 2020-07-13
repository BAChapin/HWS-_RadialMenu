//
//  ContentView.swift
//  RadialMenu
//
//  Created by Brett Chapin on 7/12/20.
//

import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .font(.title)
            .background(Color.blue.opacity(configuration.isPressed ? 0.5 : 1))
            .foregroundColor(.white)
            .clipShape(Circle())
    }
}

struct RadialButton {
    let label: String
    let image: Image
    let action: () -> Void
}

struct RadialMenu: View {
    @State private var isExpanded = false
    @State private var isShowingSheet = false
    
    let title: String
    let closedImage: Image
    let openImage: Image
    let buttons: [RadialButton]
    var direction = Angle(degrees: 315)
    var range = Angle(degrees: 90)
    var distance = 100.0
    var animation = Animation.default
    
    var body: some View {
        ZStack {
            Button {
                UIAccessibility.isVoiceOverRunning ? isShowingSheet.toggle() : isExpanded.toggle()
            } label: {
                isExpanded ? openImage : closedImage
            }
            .accessibility(label: Text(title))
            
            ForEach(0..<buttons.count, id: \.self) { i in
                Button {
                    buttons[i].action()
                    isExpanded.toggle()
                } label: {
                    buttons[i].image
                }
                .accessibility(hidden: !isExpanded)
                .accessibility(label: Text(buttons[i].label))
                .offset(offset(for: i))
            }
            .opacity(isExpanded ? 1 : 0)
            .animation(animation)
        }
        .actionSheet(isPresented: $isShowingSheet) {
            ActionSheet(title: Text(title), message: nil, buttons: buttons.map { btn in
                ActionSheet.Button.default(Text(btn.label), action: btn.action)
            } + [.cancel()])
        }
    }
    
    func offset(for index: Int) -> CGSize {
        guard isExpanded else { return .zero }
        
        let buttonAngle = range.radians / Double(buttons.count - 1)
        let ourAngle = buttonAngle * Double(index)
        let finalAngle = direction - (range / 2) + Angle(radians: ourAngle)
        
        let finalX = cos(finalAngle.radians - .pi / 2) * distance
        let finalY = sin(finalAngle.radians - .pi / 2) * distance
        
        return CGSize(width: finalX, height: finalY)
    }
}

struct ContentView: View {
    
    var buttons: [RadialButton] {
        [
            RadialButton(label: "Photo", image: Image(systemName: "photo"), action: photoTapped),
            RadialButton(label: "Video", image: Image(systemName: "video"), action: videoTapped),
            RadialButton(label: "Document", image: Image(systemName: "doc"), action: documentTapped)
        ]
        
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color.black
                .edgesIgnoringSafeArea(.all)
            
//            RadialMenu(title: "Attach...",
//                       closedImage: Image(systemName: "ellipsis.circle"),
//                       openImage: Image(systemName: "multiply.circle.fill"),
//                       buttons: buttons,
//                       animation: .interactiveSpring(response: 0.4,
//                                                     dampingFraction: 0.6))
                LinearButtonArray(title: "Attach...",
                                  closeImage: Image(systemName: "multiply.circle.fill"),
                                  openImage: Image(systemName: "ellipsis.circle.fill"),
                                  buttons: buttons)
                .offset(x: -20, y: -20)
                .buttonStyle(CustomButtonStyle())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func photoTapped() {
        print(#function)
    }
    
    func videoTapped() {
        print(#function)
    }
    
    func documentTapped() {
        print(#function)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
