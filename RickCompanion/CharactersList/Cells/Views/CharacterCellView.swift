//
//  CharacterCellView.swift
//  RickCompanion
//
//  Created by Jimmy on 03/09/2024.
//

import DataRepository
import SwiftUI

struct CharacterCellView: View {
    let character: Character?
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            characterImage
            characterInfo
            Spacer()
        }
        .frame(height: 120)
        .padding(10)
        .background(backgroundForStatus)
        .overlay(borderForStatus)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal)
        .padding(.vertical, 4)
    }

    @ViewBuilder
    private var characterImage: some View {
        if let url = character?.image {
            CharacterImageView(imageURL: url)
        }
    }

    @ViewBuilder
    private var characterInfo: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let name = character?.name {
                Text(name)
                    .font(.headline)
                    .bold()
            }
            if let species = character?.species {
                Text(species)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    @ViewBuilder
    private var backgroundForStatus: some View {
        switch character?.status {
        case .alive:
            Color.customBackground.alive
        case .dead:
            Color.customBackground.dead
        default:
            Color.customBackground.unknown
        }
    }
    
    @ViewBuilder
    private var borderForStatus: some View {
        RoundedRectangle(cornerRadius: 10)
            .stroke(
                character?.status == .alive ? Color(hex: "E9F6FD") :
                character?.status == .dead ? Color(hex: "FCE6EB") :
                Color.gray,
                lineWidth: character?.status == .unknown ? 1 : 2
            )
    }
}

struct CharacterCellView_Preview: PreviewProvider {
    static var previews: some View {
        CharacterCellView(character: .mockCharacter)
            .previewLayout(.sizeThatFits)
            .padding()
            .previewDisplayName("Character Cell")
    }
}

extension Character {
    static var mockCharacter: Character {
        Character(
            id: 1,
            name: "Rick Sanchez",
            status: .alive,
            species: "Human",
            gender: .male,
            location: Location(name: "Earth"),
            image: URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")!
        )
    }
}
