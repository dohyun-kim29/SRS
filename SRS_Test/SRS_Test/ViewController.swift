//
//  ViewController.swift
//  SRS_Test
//
//  Created by DohyunKim on 2021/03/22.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    let config = WKWebViewConfiguration()
    let webViewUrlRequest = URLRequest(url: URL(string: "http://www.dsm-srs.site/signin")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        WKWebsiteDataStore.default().httpCookieStore.getAllCookies { (cookies) in for cookie in cookies { print("@@@ cookie ==> \(cookie.name) : \(cookie.value)")
//            if cookie.name == "PHPSESSID" { UserDefaults.standard.set(cookie.value, forKey:"PHPSESSID")
//                print("@@@ PHPSESSID 저장하기: \(cookie.value)")
//            }
//        }
//        }
        
        config.websiteDataStore = WKWebsiteDataStore.default()
        
        let webView = WKWebView(frame: view.frame, configuration: config)
        webViewConfig(webView)
        view.addSubview(webView)
        webView.load(webViewUrlRequest)
        webViewConfig(webView)
        WKWebsiteDataStore.default().httpCookieStore.getAllCookies { (cookies) in for cookie in cookies { print("@@@ cookie ==> \(cookie.name) : \(cookie.value)")
            if cookie.name == "PHPSESSID" { UserDefaults.standard.set(cookie.value, forKey:"PHPSESSID")
                print("@@@ PHPSESSID 저장하기: \(cookie.value)")
            }
        }
        }
        
        
        
    }
    
    func webViewConfig(_ webView: WKWebView) { let loadedSessid = UserDefaults.standard.value(forKey: "PHPSESSID") as! String?
        if let temp = loadedSessid{ print("@@@ PHPSESSID 불러오기~~: \(temp)")
        let cookieString : String = "document.cookie='PHPSESSID=\(temp);path=/;domain=\("http://www.dsm-srs.site/signin");'"
            webView.evaluateJavaScript(cookieString) } }

    
    
    
}

