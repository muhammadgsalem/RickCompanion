//
//  CharacterDetailsView.swift
//  RickCompanion
//
//  Created by Jimmy on 05/09/2024.
//

import DataRepository
import SwiftUI

struct CharacterDetailsView: View {
    let character: Character
    let onBackActionSelected: () -> Void
    let imageLoadingService: ImageCacheService

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                characterImageView
                characterInfoView
            }
        }
        .edgesIgnoringSafeArea(.top)
        .onAppear(perform: adjustScrollViewBehavior)
    }
    
    private var characterImageView: some View {
        ZStack(alignment: .topLeading) {
            CharacterAsyncImage(url: character.image, imageCache: imageLoadingService)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.bottom, 10)

            backButton
        }
    }
    
    private var backButton: some View {
        Button(action: performBackAction) {
            Image(systemName: "circle.fill")
                .font(.system(size: 40))
                .foregroundColor(.white)
                .overlay(
                    Image(systemName: "arrow.backward")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.black)
                )
                .frame(width: 40, height: 40)
                .shadow(radius: 20)
        }
        .padding(.top, 60)
        .padding(.leading, 20)
    }
    
    private var characterInfoView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                characterBasicInfo
                Spacer()
                StatusPill(character: character)
                    .shadow(radius: 5)
            }
            
            characterLocationInfo
        }
        .padding()
    }
    
    private var characterBasicInfo: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(character.name)
                .font(.title)
                .bold()
            HStack(spacing: 2) {
                Text(character.species)
                Text("• \(character.gender.rawValue)")
                    .foregroundStyle(.gray)
            }
            .font(.subheadline)
        }
    }
    
    private var characterLocationInfo: some View {
        HStack(spacing: 4) {
            Text("Location:")
                .fontWeight(.medium)
            Text(character.location.name)
                .fontWeight(.semibold)
                .foregroundStyle(.gray)
        }
        .font(.title3)
    }
    
    private func performBackAction() {
        withAnimation(.easeInOut(duration: 0.2)) {
            onBackActionSelected()
        }
    }
    
    private func adjustScrollViewBehavior() {
        DispatchQueue.main.async {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        }
    }
}





#Preview {
    CharacterDetailsView(character: .mockCharacter, onBackActionSelected: {}, imageLoadingService: DependencyContainer.shared.makeImageCache())
}
