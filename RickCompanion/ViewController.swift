//
//  ViewController.swift
//  RickCompanion
//
//  Created by Jimmy on 02/09/2024.
//

import UIKit
import BusinessLayer

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let repository = CharacterRepository()
        let fetchCharactersUseCase = FetchCharactersUseCase(characterRepository: repository)
        fetchCharactersUseCase.execute(page: 1) { result in
            switch result {
            case .success(let success):
                break
            case .failure(let failure):
                break
            }
        }
    }


}

