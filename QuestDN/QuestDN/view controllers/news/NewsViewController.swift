//
//  NewsViewController.swift
//  QuestDN
//
//  Created by Евгений Бейнар on 11/07/2019.
//

import UIKit

private enum Constans: String {
    case newsTableViewCell
    case detailNewsSegue
}

class NewsViewController: UIViewController {
    
// variable
    var networkManager = NetworkManager.shared
    
    private let model = NewsModel()
    private var pageNumber = 0
    private var waiting = false
    private var news = [News]()
    private var selectedNews: News?
    private var refreshControl: UIRefreshControl!
    
    private let activityIndicator: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.color = .black
        return spinner
    }()
    
// IB O
    @IBOutlet weak var returnRequestButton: UIButton!
    @IBOutlet weak var newsTableView: UITableView! {
        didSet {
            newsTableView.tableFooterView = UIView()
        }
    }
    
// IB A
    @IBAction func returnRequestTap(_ sender: Any) {
        self.returnRequestButton.isEnabled = false
        getNews(pageNumber: pageNumber, false)
    }
    
// life c
    override func viewDidLoad() {
        super.viewDidLoad()
        checkInternet()
        setupTableView()
        setupRefresh()
        showIndicator()
        getNews(pageNumber: pageNumber, false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        networkManager.reachabilityManager?.stopListening()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        networkManager.reachabilityManager?.startListening()
    }
    
// private func
    private func checkInternet() {
        networkManager.startNetworkReachabilityObserver() { result in
            if result {
                self.navigationController?.navigationBar.barTintColor = .red
                self.navigationItem.title = "No Internet"
                self.returnRequestButton.isHidden = false
                self.returnRequestButton.isEnabled = false
            } else {
                self.navigationController?.navigationBar.barTintColor = .none
                self.navigationItem.title = "List News"
                self.returnRequestButton.isEnabled = true
            }
        }
    }
    
    private func setupTableView() {
        newsTableView.delegate = self
        newsTableView.dataSource = self
        newsTableView.prefetchDataSource = self
    }
    
    private func getNews(pageNumber: Int, _ flag: Bool) {
        model.getNews(page: pageNumber) { (result) in
            switch result {
            case .success(let response):
                if flag {self.news.removeAll()}
                self.pageNumber += 1
                self.news.append(contentsOf: response)
                self.newsTableView.reloadData()
                self.hideIndicator()
                self.returnRequestButton.isHidden = true
                self.refreshControl.endRefreshing()
                break
            case .failure(let error):
                if error._code == NSURLErrorTimedOut {
                    self.hideIndicator()
                    self.returnRequestButton.isEnabled = true
                    self.refreshControl.endRefreshing()
                    self.showAlertMessage(title: "Error", message: error.localizedDescription)
                } else {
                    self.hideIndicator()
                    self.returnRequestButton.isEnabled = true
                    self.refreshControl.endRefreshing()
                    self.showAlertMessage(title: "Error", message: error.localizedDescription)
                }
                break
            }
        }
        waiting = false
    }
    
    private func showIndicator() {
        self.navigationItem.titleView = self.activityIndicator
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
    }
    
    private func hideIndicator() {
        self.navigationItem.titleView = nil
    }
    
    private func setupRefresh() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        newsTableView.refreshControl = refreshControl
    }
    
    @objc private func refresh() {
        pageNumber = 1
        getNews(pageNumber: pageNumber, true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constans.detailNewsSegue.rawValue {
            let controller = segue.destination as! DetailNewsViewController
            controller.selectedNews = selectedNews
        }
    }
    
}

extension NewsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if news.count > 0 {
            selectedNews = news[indexPath.row]
            performSegue(withIdentifier: Constans.detailNewsSegue.rawValue, sender: nil)
        }
        tableView.cellForRow(at: indexPath)?.isSelected = false
    }
}

extension NewsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constans.newsTableViewCell.rawValue, for: indexPath) as! NewsTableViewCell
        if news.count > 0 {
            cell.configureCell(news: news[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == news.count - 1 && !self.waiting {
            waiting = true
            self.getNews(pageNumber: pageNumber, false)
        }
    }
    
}

extension NewsViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
    }
    
}
