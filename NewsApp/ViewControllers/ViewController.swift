import UIKit

class NewsViewController: UIViewController {
    
    private var newsService = NewsService()
    
    private var newsModels: [News] = [] {
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: - UI Elements
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        
        table.dataSource = self
        table.delegate = self
        table.register(NewsTableViewCell.self,
                       forCellReuseIdentifier: NewsTableViewCell.identifier)
        return table
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        return searchBar
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        return indicator
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupSearchHistoryButton()
        fetchData()
    }
    
    //MARK: - Private methods
    
    private func fetchData(forQuery  query: String = "tesla") {
        newsModels = []
        activityIndicator.startAnimating()
        
        newsService.getNews(forQuery: query) { result in
            switch result {
                
            case .success(let response):
                self.newsModels = response.news
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func setupSearchHistoryButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: .init(systemName: "note.text"),
            style: .plain,
            target: self ,
            action: #selector(didTapRecentSearches)
        )
    }
    
    @objc private func didTapRecentSearches() {
        let vc = RecentSearchesViewController()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupViews() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

    //MARK: - TableViewDelegate and DataSource

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        newsModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NewsTableViewCell.identifier,
            for: indexPath
        ) as? NewsTableViewCell else { return UITableViewCell() }
        
        cell.configure(with: newsModels[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        NewsTableViewCell.prefferedHeight
    }
}

    //MARK: - Searchbar delegate

extension NewsViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        
        RecentSearchService.shared.saveSearch(query: query)
        fetchData(forQuery: query)
        searchBar.resignFirstResponder()
    }
    
    func searchBarShouldReturn(_ searchBar: UISearchBar) -> Bool {
        searchBar.resignFirstResponder()
        return true
    }
}

extension NewsViewController: RecentSearchVCDelegate {
    func didSelectCell(withQuery query: String) {
        searchBar.text = ""
        fetchData(forQuery: query)
        searchBar.resignFirstResponder()
    }
}
