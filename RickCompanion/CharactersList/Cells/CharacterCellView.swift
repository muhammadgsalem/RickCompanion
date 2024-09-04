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
        HStack(alignment: .top) {
            AsyncImage(url: character?.image) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                case .failure:
                    Image(systemName: "photo")
                        .foregroundColor(.gray)
                @unknown default:
                    Color.gray
                }
            }
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding([.leading, .bottom, .top], 10)

            VStack(alignment: .leading) {
                Text(character?.name ?? "")
                    .font(.headline)
                Text(character?.species ?? "")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding([.leading, .bottom, .top], 10)
            
            Spacer()
        }
        .frame(height: 120)
        .background(
            Group {
                switch character?.status {
                case .alive:
                    Color(hex: "E9F6FD")
                case .dead:
                    Color(hex: "FCE6EB")
                default:
                    Color.clear
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
        )
        .overlay(
            Group {
                switch character?.status {
                case .alive:
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(hex: "E9F6FD"), lineWidth: 2)
                case .dead:
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(hex: "FCE6EB"), lineWidth: 2)
                default:
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                }
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding([.top, .bottom], 4)
        .padding([.leading, .trailing])
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
