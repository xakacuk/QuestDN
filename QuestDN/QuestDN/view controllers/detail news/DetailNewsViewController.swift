//
//  DetailNewsViewController.swift
//  QuestDN
//
//  Created by Евгений Бейнар on 11/07/2019.
//

import UIKit
import WebKit

final class DetailNewsViewController: UIViewController, WKNavigationDelegate {
    
// variable
    private var webView: WKWebView!
    var selectedNews: News?
    private let activityIndicator: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.color = .black
        return spinner
    }()
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
// life c
    override func viewDidLoad() {
        super.viewDidLoad()
        webViewLoad(urlNews: selectedNews!.url)
    }
    
// private funcs
    private func webViewLoad(urlNews: String) {
        let url = URL(string: urlNews)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    private func showIndicator() {
        self.navigationItem.titleView = self.activityIndicator
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
    }
    
    private func hideIndicator() {
        self.navigationItem.titleView = nil
    }
    
}
