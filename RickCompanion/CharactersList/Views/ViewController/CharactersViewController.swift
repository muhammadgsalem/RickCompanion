//
//  CharactersViewController.swift
//  RickCompanion
//
//  Created by Jimmy on 03/09/2024.
//
import BusinessLayerProtocol
import DataRepositoryProtocol
import UIKit

class CharactersViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    weak var coordinator: CharactersCoordinator?
    fileprivate let viewModel: CharactersViewModelProtocol
    private let viewControllerNibName = "CharactersViewController"
    private let refreshControl = UIRefreshControl()

    init(viewModel: CharactersViewModelProtocol) {
        self.viewModel = viewModel
        let bundle = Bundle(for: CharactersViewController.self)
        super.init(nibName: viewControllerNibName, bundle: bundle)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureRefreshControl()
        title = "Characters"
        loadCharacters()
    }

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.register(CharacterTableViewCell.self, forCellReuseIdentifier: CharacterTableViewCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
    }

    private func configureRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    @objc private func refreshData(_ sender: Any) {
        // Reset the pagination and data
        viewModel.resetPagination()
        loadCharacters()
    }

    fileprivate func loadCharacters() {
        viewModel.loadCharacters(onSuccess: { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            }
        }, onError: { error in
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
            // Handle error
            print("Error loading characters: \(error)")
        })
    }
}

// MARK: - UITableViewDataSource

extension CharactersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.characters.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterTableViewCell.reuseIdentifier, for: indexPath) as? CharacterTableViewCell else {
            return UITableViewCell()
        }

        let character = viewModel.characters[indexPath.row]
        cell.configure(with: character)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CharactersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let character = viewModel.characters[indexPath.row]
        coordinator?.showCharacterDetails(for: character)
    }
}

// MARK: - UITableViewDataSourcePrefetching

extension CharactersViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let maxIndex = indexPaths.map { $0.row }.max() ?? 0
        if maxIndex >= viewModel.characters.count - 1 {
            loadCharacters()
        }
    }
}
