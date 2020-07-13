//
//  LinearButtonArray.swift
//  RadialMenu
//
//  Created by Brett Chapin on 7/12/20.
//

import SwiftUI

struct LinearButtonArray: View {
    @State private var isExpanded = false
    
    let title: String
    let closeImage: Image
    let openImage: Image
    let buttons: [RadialButton]
    var distance = 75.0
    var animation = Animation.default
    
    var body: some View {
        ZStack {
            Button {
                isExpanded.toggle()
            } label: {
                isExpanded ? closeImage : openImage
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
    }
    
    func offset(for index: Int) -> CGSize {
        guard isExpanded else { return .zero }
        
        let buttonDistance = Double(index + 1) * -distance
        
        return CGSize(width: 0, height: buttonDistance)
    }
}
