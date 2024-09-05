//
//  CharacterDetailsView.swift
//  RickCompanion
//
//  Created by Jimmy on 05/09/2024.
//

import DataRepository
import SwiftUI

struct CharacterDetailsView: View {
    let character: Character?
    let onBackActionSelected: () -> Void
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ZStack(alignment: .topLeading) {
                    PreviewableAsyncImage(url: character?.image) { phase in
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
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.bottom, 10)

                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            onBackActionSelected()
                            presentationMode.wrappedValue.dismiss()
                        }
                    } label: {
                        Image(systemName: "circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.white)
                            .overlay(
                                Image(systemName: "arrow.backward")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.black)
                            )
                            .frame(width: 40, height: 40)
                            .shadow(radius: 10)
                    }
                    .padding(.top, 60)
                    .padding(.leading, 20)
                }

                HStack(alignment: .center) {
                    VStack {
                        Text(character?.name ?? "")
                            .font(.largeTitle)
                        HStack {
                            Text(character?.species ?? "")
                                .font(.subheadline)
                            Text("• \(character?.gender.rawValue ?? "")")
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                        }
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.top)
        .onAppear {
            DispatchQueue.main.async {
                UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
            }
        }
    }
}

#Preview {
    CharacterDetailsView(character: nil, onBackActionSelected: {  })
}

struct PreviewableAsyncImage<Content: View>: View {
    let url: URL?
    @ViewBuilder let content: (AsyncImagePhase) -> Content

    var body: some View {
        if let url = url, ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            // Use a local image for previews
            Image("MockedImage")
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            AsyncImage(url: url, content: content)
        }
    }
}
