//
//  CharacterImageView.swift
//  RickCompanion
//
//  Created by Jimmy on 05/09/2024.
//

import SwiftUI

struct CharacterImageView: View {
    let imageURL: URL
    let imageLoadingService: ImageCacheService
    var body: some View {
        CharacterAsyncImage(url: imageURL, imageCache: imageLoadingService)
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct CharacterImageView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterImageView(imageURL: URL(string: "https://example.com/image.jpg")!, imageLoadingService: DependencyContainer.shared.makeImageCache())
    }
}
