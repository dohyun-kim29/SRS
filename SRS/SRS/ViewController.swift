//
//  ViewController.swift
//  SRS
//
//  Created by DohyunKim on 2021/03/16.
//

import UIKit
import WebKit
import SystemConfiguration

class ViewController: UIViewController, WKNavigationDelegate {
    
    var mainWebView: WKWebView!
    
    let mainWebViewUrl: URLRequest = URLRequest.init(url: NSURL.init(string: "http://www.dsm-srs.site/signin")! as URL, cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 10)
    
    let mainWebViewUrl2: URLRequest = URLRequest.init(url: URL(string: "http://www.dsm-srs.site/signin")!)
    
    let config = WKWebViewConfiguration()
    let preferens = WKPreferences()
    
    //    let httpCookieStorage = WKHTTPCookieStore
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //        bringcookie()
        
        request()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        networkVaild()
        
    }
    
    
}

extension ViewController {
    
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            
            return false
            
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
    
    func networkVaild() {
        
        if(isInternetAvailable() == true) {
            print("네트워크 연결 성공")
        } else {
            print("네트워크 연결 실패")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "NetworkDisConnectedViewController")
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func request() {
        
        config.websiteDataStore = WKWebsiteDataStore.default()
        
//        config.processPool = WKProcessPool()
        
        preferens.javaScriptEnabled = true
        
        config.preferences = preferens
        
        
        let cookies = HTTPCookieStorage.shared.cookies ?? [HTTPCookie]()
        cookies.forEach({ config.websiteDataStore.httpCookieStore.setCookie($0, completionHandler: nil) })
        
        mainWebView = WKWebView(frame: view.bounds, configuration: config)
        view.addSubview(mainWebView)
        self.mainWebView.load(self.mainWebViewUrl)
        
        
        self.mainWebView.navigationDelegate = self
        mainWebView.becomeFirstResponder()
        
    }
    
    func fillCookieStore(store: WKHTTPCookieStore, completionHandler: (() -> Void)? = nil) {
        
        
        if let cookies = HTTPCookieStorage.shared.cookies {
            
            let sem = DispatchGroup()
            for cookie in cookies {
                sem.enter()
                store.setCookie(cookie, completionHandler: {
                    sem.leave()
                })
            }
            
            sem.notify(queue: .main) {
                completionHandler?()
            }
        } else {
            completionHandler?()
        }
    }
    
    
    
}

