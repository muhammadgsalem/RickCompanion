//
//  PillView.swift
//  RickCompanion
//
//  Created by Jimmy on 05/09/2024.
//

import SwiftUI
struct StatusPill: View {
    let status: String
    
    var body: some View {
        Text(status)
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Capsule().fill(Color.blue))
    }
}
