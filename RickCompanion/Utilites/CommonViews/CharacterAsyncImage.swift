//
//  CharacterAsyncImage.swift
//  RickCompanion
//
//  Created by Jimmy on 05/09/2024.
//

import SwiftUI
struct CharacterAsyncImage: View {
    let url: URL?
    
    var body: some View {
        AsyncImage(url: url) { phase in
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
    }
}
