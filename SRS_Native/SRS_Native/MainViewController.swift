//
//  MainViewController.swift
//  SRS_Native
//
//  Created by DohyunKim on 2021/03/23.
//
import UIKit
import WebKit

class MainViewController: UIViewController {
    @IBOutlet weak var webview: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPage()
    }
}

extension MainViewController: WKUIDelegate, WKNavigationDelegate {
    func loadPage() {
        webview.uiDelegate = self
        webview.navigationDelegate = self
        
        let url: URL = URL(string: "https://www.dsm-srs.site/")!
        let request = URLRequest(url: url)
        webview.load(request)
    }
}
