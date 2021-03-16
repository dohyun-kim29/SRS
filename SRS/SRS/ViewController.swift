//
//  ViewController.swift
//  SRS
//
//  Created by DohyunKim on 2021/03/16.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var mainWebView: WKWebView!
    
    let mainWebViewUrl = "http://dsm-rsr.s3-website.ap-northeast-2.amazonaws.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        request()
    }


}

extension ViewController {
    
    func request() {
        
        self.mainWebView.load(URLRequest(url: URL(string: mainWebViewUrl)!))
        self.mainWebView.navigationDelegate = self
        
    }
}

