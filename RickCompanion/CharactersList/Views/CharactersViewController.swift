//
//  CharactersViewController.swift
//  RickCompanion
//
//  Created by Jimmy on 03/09/2024.
//
import DataRepository
import SwiftUI
import UIKit

class CharactersViewController: UIViewController {
    weak var coordinator: CharactersCoordinator?
    private let viewModel: CharactersViewModelProtocol
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    private var filterChangeTimer: Timer?
    private var filterView: UIHostingController<FilterView>!
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Characters"
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .gray
        indicator.hidesWhenStopped = true
        return indicator
    }()

    init(viewModel: CharactersViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureTableView()
        configureRefreshControl()
        setupActivityIndicator()
        viewModel.delegate = self
        loadCharacters()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func setupUI() {
        view.backgroundColor = .white

        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.register(CharacterTableViewCell.self, forCellReuseIdentifier: CharacterTableViewCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .none
        tableView.tableHeaderView = createHeaderView()
    }

    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func createHeaderView() -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 150))
        headerView.backgroundColor = .white
        
        headerView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16)
        ])
        
        // Add filter view to the header
        let swiftUIFilterView = FilterView(
            selectedFilter: Binding(
                get: { self.viewModel.currentFilter },
                set: { self.viewModel.applyFilter($0) }
            ),
            onFilterSelected: { [weak self] filter in
                self?.loadCharacters()
            }
        )
        
        filterView = UIHostingController(rootView: swiftUIFilterView)
        addChild(filterView)
        headerView.addSubview(filterView.view)
        filterView.didMove(toParent: self)
        
        filterView.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            filterView.view.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            filterView.view.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            filterView.view.trailingAnchor.constraint(lessThanOrEqualTo: headerView.trailingAnchor, constant: -16),
            filterView.view.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -16),
            filterView.view.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        return headerView
    }


    private func configureRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    @objc private func refreshData() {
        viewModel.resetPagination()
        viewModel.loadCharacters()
    }

    private func loadCharacters() {
        viewModel.loadCharacters()
    }

    private func showError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func showLoadingIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.startAnimating()
            self?.view.isUserInteractionEnabled = false
        }
    }

    private func hideLoadingIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.view.isUserInteractionEnabled = true
        }
    }

}

extension CharactersViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.characters.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterTableViewCell.reuseIdentifier, for: indexPath) as? CharacterTableViewCell else {
            return UITableViewCell()
        }

        let character = viewModel.characters[indexPath.row]
        cell.configure(with: character)
        viewModel.loadMoreCharactersIfNeeded(for: indexPath.row)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let character = viewModel.characters[indexPath.row]
        coordinator?.showCharacterDetails(character)
    }
}

extension CharactersViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let maxIndex = indexPaths.map { $0.row }.max() ?? 0
        if maxIndex >= viewModel.characters.count - 1 {
            loadCharacters()
        }
    }
}

extension CharactersViewController: CharactersViewModelDelegate {
    func viewModelDidUpdateState(_ viewModel: CharactersViewModel, state: ViewState) {
        DispatchQueue.main.async { [weak self] in
            switch state {
            case .idle:
                self?.tableView.reloadData()
            case .loading:
                if viewModel.characters.isEmpty {
                    self?.showLoadingIndicator()
                }
            case .loaded:
                self?.hideLoadingIndicator()
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
            case .error(let error):
                self?.hideLoadingIndicator()
                self?.showError(error)
                self?.refreshControl.endRefreshing()
            }
        }
    }
}
