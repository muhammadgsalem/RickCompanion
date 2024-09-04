//
//  FilterView.swift
//  RickCompanion
//
//  Created by Jimmy on 04/09/2024.
//

import SwiftUI

struct FilterView: View {
    @Binding var selectedFilter: CharacterStatus?
    let onFilterSelected: (CharacterStatus?) -> Void
    
    private let filterOptions: [CharacterStatus] = [.alive, .dead, .unknown]
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(filterOptions, id: \.self) { status in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedFilter = (selectedFilter == status) ? nil : status
                    }
                    onFilterSelected(selectedFilter)
                }) {
                    Text(status.rawValue)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(selectedFilter == status ? Color.blue : Color.clear)
                        .foregroundColor(selectedFilter == status ? Color.white : Color.blue)
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.blue, lineWidth: 2)
                        )
                }
                .scaleEffect(selectedFilter == status ? 1.05 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0), value: selectedFilter)
            }
        }
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(selectedFilter: .constant(nil), onFilterSelected: { _ in })
    }
}
