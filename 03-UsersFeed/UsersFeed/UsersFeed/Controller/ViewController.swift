
import UIKit

class ViewController: UIViewController {
    private let tableView = UITableView()
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    private let searchBar = UISearchBar()
    private let tableRefreshControl = UIRefreshControl()
    private let collectionRefreshControl = UIRefreshControl()

    private var filteredUsers = [User]()
    private var tableConstraints: [NSLayoutConstraint] = []
    private var gridConstraints: [NSLayoutConstraint] = []
    private let layoutControl = UISegmentedControl(items: [
        UIImage(systemName: "list.bullet")!,
        UIImage(systemName: "square.grid.2x2")!
    ])

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupActions()
        layoutControlChanged(layoutControl)
    }

    // MARK: - Private

    private func updateLikes() {
        let likesCount = users.filter { $0.like }.count
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "♥ \(likesCount)")
        navigationItem.rightBarButtonItem?.tintColor = .systemRed
    }

    private func reloadVisible() {
        if tableView.isHidden {
            collectionView.reloadData()
        } else {
            tableView.reloadData()
        }
    }

    private func reloadAll() {
        tableView.reloadData()
        collectionView.reloadData()
    }

    // MARK: - Setup

    private func setupViews() {
        view.backgroundColor = .systemBackground
        title = "Users Feed"
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: layoutControl)
        layoutControl.selectedSegmentIndex = 0
        updateLikes()

        filteredUsers = users

        searchBar.placeholder = "Search by name..."
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self

        tableView.dataSource = self
        tableView.register(UserCell.self, forCellReuseIdentifier: UserCell.reuseIdentifier)
        tableView.refreshControl = tableRefreshControl

        collectionView.dataSource = self
        collectionView.register(UserCollectionCell.self, forCellWithReuseIdentifier: UserCollectionCell.reuseIdentifier)
        collectionView.refreshControl = collectionRefreshControl
        collectionView.backgroundColor = .systemBackground

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 8
            layout.minimumLineSpacing = 8
        }

        [searchBar, tableView, collectionView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            searchBar.heightAnchor.constraint(equalToConstant: 56)
        ])

        tableConstraints = [
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ]

        gridConstraints = [
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ]

        NSLayoutConstraint.activate(tableConstraints)
    }

    private func setupActions() {
        tableRefreshControl.addTarget(self, action: #selector(didRefresh), for: .valueChanged)
        collectionRefreshControl.addTarget(self, action: #selector(didRefresh), for: .valueChanged)
        layoutControl.addTarget(self, action: #selector(layoutControlChanged), for: .valueChanged)
    }

    // MARK: - Actions

    @objc private func didRefresh(_ sender: UIRefreshControl) {
        users.shuffle()
        let currentSearch = searchBar.text ?? ""
        filteredUsers = currentSearch.isEmpty
            ? users
            : users.filter { $0.name.lowercased().contains(currentSearch.lowercased()) }
        reloadAll()
        sender.endRefreshing()
    }

    @objc private func layoutControlChanged(_ sender: UISegmentedControl) {
        let showGrid = sender.selectedSegmentIndex == 1
        tableView.isHidden = showGrid
        collectionView.isHidden = !showGrid

        if showGrid {
            NSLayoutConstraint.deactivate(tableConstraints)
            NSLayoutConstraint.activate(gridConstraints)
        } else {
            NSLayoutConstraint.deactivate(gridConstraints)
            NSLayoutConstraint.activate(tableConstraints)
        }
        reloadAll()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        // Use safeArea width minus collectionView insets (16+16) to avoid depending on collectionView.bounds
        // which may be zero when the view is hidden
        let collectionWidth = view.safeAreaLayoutGuide.layoutFrame.width - 32
        let width = (collectionWidth - layout.minimumInteritemSpacing) / 2
        layout.itemSize = CGSize(width: width, height: 200)
    }
}

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredUsers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.reuseIdentifier, for: indexPath) as! UserCell
        cell.configure(with: filteredUsers[indexPath.row])
        cell.delegate = self
        return cell
    }
}

// MARK: - UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filteredUsers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserCollectionCell.reuseIdentifier, for: indexPath) as! UserCollectionCell
        cell.configure(with: filteredUsers[indexPath.row])
        cell.delegate = self
        return cell
    }
}

// MARK: - UISearchBarDelegate

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredUsers = searchText.isEmpty
            ? users
            : users.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        reloadVisible()
    }
}

// MARK: - ButtonLikeDelegate

extension ViewController: ButtonLikeDelegate {
    func setLike(for id: UUID, _ isLiked: Bool) {
        if let index = users.firstIndex(where: { $0.id == id }) {
            users[index].like = isLiked
        }
        if let index = filteredUsers.firstIndex(where: { $0.id == id }) {
            filteredUsers[index].like = isLiked
        }
        updateLikes()
    }
}
