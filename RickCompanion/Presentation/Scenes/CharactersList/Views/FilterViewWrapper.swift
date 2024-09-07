//
//  FilterViewWrapper.swift
//  RickCompanion
//
//  Created by Jimmy on 06/09/2024.
//

import SwiftUI
import UIKit
/// This class is responsible for handling the FilterView creation and callbacks for the VC.
class FilterViewWrapper: UIView {
    private var hostingController: UIHostingController<FilterView>?
    
    var onFilterSelected: ((CharacterStatus?) -> Void)? {
        didSet {
            setupFilterView()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFilterView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFilterView()
    }
    
    private func setupFilterView() {
        if let existingHostingController = hostingController {
            existingHostingController.view.removeFromSuperview()
            existingHostingController.removeFromParent()
        }
        
        let filterView = FilterView { [weak self] newFilter in
            self?.onFilterSelected?(newFilter)
        }
        
        let hostingController = UIHostingController(rootView: filterView)
        addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        self.hostingController = hostingController
    }
}
