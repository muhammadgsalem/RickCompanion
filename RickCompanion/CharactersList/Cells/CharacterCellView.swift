import DataRepository
import SwiftUI

struct CharacterCellView: View {
    let character: Character?

    private let roundedRectangleShape = RoundedRectangle(cornerRadius: 10)

    var body: some View {
        if let character = character {
            HStack(alignment: .top) {
                AsyncImage(url: character.image) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 80, height: 80)
                .clipShape(roundedRectangleShape)
                .padding([.leading, .bottom, .top], 10)

                VStack(alignment: .leading) {
                    Text(character.name)
                        .font(.headline)
                    Text(character.species)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding([.leading, .bottom, .top], 10)

                Spacer()
            }
            .frame(height: 120)
            .background(backgroundColor(for: character.status)
                .clipShape(roundedRectangleShape))
            .overlay(overlayStroke(for: character.status)
                .clipShape(roundedRectangleShape))
            .clipShape(roundedRectangleShape)
            .padding([.top, .bottom], 4)
            .padding([.leading, .trailing])
        }
    }

    // Background color based on character status
    private func backgroundColor(for status: Character.Status) -> Color {
        switch status {
        case .alive:
            return Color(hex: "E9F6FD")
        case .dead:
            return Color(hex: "FCE6EB")
        default:
            return Color.clear
        }
    }

    // Overlay stroke based on character status
    private func overlayStroke(for status: Character.Status) -> some View {
        switch status {
        case .alive:
            return roundedRectangleShape.stroke(Color(hex: "E9F6FD"), lineWidth: 2)
        case .dead:
            return roundedRectangleShape.stroke(Color(hex: "FCE6EB"), lineWidth: 2)
        default:
            return roundedRectangleShape.stroke(Color.gray, lineWidth: 1)
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
