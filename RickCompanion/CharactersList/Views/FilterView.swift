//
//  FilterView.swift
//  RickCompanion
//
//  Created by Jimmy on 04/09/2024.
//

import SwiftUI


struct FilterView: View {
    @State private var selectedFilter: CharacterStatus?
    let onFilterSelected: (CharacterStatus?) -> Void
    
    private let filterOptions: [CharacterStatus] = [.alive, .dead, .unknown]
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(filterOptions, id: \.self) { status in
                FilterButton(
                    status: status,
                    isSelected: selectedFilter == status,
                    action: {
                        if selectedFilter == status {
                            selectedFilter = nil
                        } else {
                            selectedFilter = status
                        }
                        onFilterSelected(selectedFilter)
                    }
                )
            }
        }
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(onFilterSelected: { _ in })
    }
}
