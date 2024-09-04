//
//  CharacterCellView.swift
//  RickCompanion
//
//  Created by Jimmy on 03/09/2024.
//

import SwiftUI
import DataRepositoryProtocol

struct CharacterCellView: View {
    let character: Character
    @State private var image: UIImage?

    var body: some View {
        HStack {
            Group {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    ProgressView()
                }
            }
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 2))
            .shadow(radius: 5)
            .padding(.trailing, 10)

            VStack(alignment: .leading) {
                Text(character.name)
                    .font(.headline)
                Text(character.species)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding()
        .task {
            await loadImage()
        }
    }

    private func loadImage() async {
        let url = character.image

        do {
            let cachedImage = try await CacheManager.shared.loadResource(withKey: url.absoluteString) {
                try await url.loadImage()
            }
            await MainActor.run {
                self.image = cachedImage
            }
        } catch {
            print("Failed to load image: \(error)")
        }
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
