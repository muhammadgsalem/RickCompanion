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
    let imageLoadingService: ImageCacheService?
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            if let character = character, let imageLoadingService = imageLoadingService {
                CharacterImageView(imageURL: character.image, imageLoadingService: imageLoadingService)
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 80, height: 80)
            }
            
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
            
            Spacer()
        }
        .frame(height: 120)
        .padding(10)
        .background(backgroundForStatus)
        .overlay(borderForStatus)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal)
        .padding(.vertical, 4)
        .id(character?.id)
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
        CharacterCellView(character: .mockCharacter, imageLoadingService: nil)
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
