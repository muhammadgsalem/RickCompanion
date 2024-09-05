//
//  CharacterImageView.swift
//  RickCompanion
//
//  Created by Jimmy on 05/09/2024.
//

import SwiftUI
struct CharacterImageView: View {
    let imageURL: URL
    
    var body: some View {
        AsyncImage(url: imageURL) { phase in
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
                    .frame(width: 80, height: 80)
            @unknown default:
                Color.gray
            }
        }
        .frame(width: 80, height: 80)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
