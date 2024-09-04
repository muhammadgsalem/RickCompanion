//
//  CharactersTableViewCell.swift
//  RickCompanion
//
//  Created by Jimmy on 03/09/2024.
//

import UIKit
import SwiftUI
import DataRepository

class CharacterTableViewCell: UITableViewCell {
    static let reuseIdentifier = "CharacterTableViewCell"
    
    private var hostingController: UIHostingController<CharacterCellView>?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupHostingController()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHostingController() {
        hostingController = UIHostingController(rootView: CharacterCellView(character: nil))
        hostingController?.view.backgroundColor = .clear
        
        guard let hostingView = hostingController?.view else { return }
        contentView.addSubview(hostingView)
        hostingView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            hostingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hostingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            hostingView.topAnchor.constraint(equalTo: contentView.topAnchor),
            hostingView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with character: Character) {
        hostingController?.rootView = CharacterCellView(character: character)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        hostingController?.rootView = CharacterCellView(character: nil)
    }
}
