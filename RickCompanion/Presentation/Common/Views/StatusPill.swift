//
//  StatusPill.swift
//  RickCompanion
//
//  Created by Jimmy on 05/09/2024.
//

import SwiftUI
import DataRepository

struct StatusPill: View {
    let character: Character
    
    var body: some View {
        Text(character.status.rawValue)
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(.black)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Capsule().fill(backgroundColor))
    }
    
    private var backgroundColor: Color {
        switch character.status {
        case .alive:
            return Color.customBackground.alive
        case .dead:
            return Color.customBackground.dead
        default:
            return Color(hex: "D3D3D3")
        }
    }
}
