//
//  FilterButton.swift
//  RickCompanion
//
//  Created by Jimmy on 05/09/2024.
//
import SwiftUI

struct FilterButton: View {
    let status: CharacterStatus
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(status.rawValue)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color.clear)
                .foregroundColor(isSelected ? Color.white : Color.black)
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isSelected ? Color.blue : Color.gray, lineWidth: 1)
                )
        }
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0), value: isSelected)
    }
}
