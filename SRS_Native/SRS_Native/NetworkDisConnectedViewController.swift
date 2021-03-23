//
//  NetworkDisConnectedViewController.swift
//  SRS_Native
//
//  Created by DohyunKim on 2021/03/23.
//

import UIKit
import RxSwift
import RxCocoa
import SystemConfiguration
import Toaster

class NetworkDisConnectedViewController : UIViewController {
    
    @IBOutlet weak var internetConnectLbl: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    
    let disposeBag = DisposeBag()
    let toastNetworkText = Toast(text: "네트워크 연결이 불안정합니다", duration: Delay.short)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        bindUI()
    }
}

extension NetworkDisConnectedViewController {
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
    
    
    func bind() {
        refreshButton.rx.tap
            .bind {
                if self.isInternetAvailable() == true {
//                    self.present()
                } else {
                    self.toastNetworkText.show()
                }
            }.disposed(by: disposeBag)
    }
    
    func bindUI() {
        if self.isInternetAvailable() == true {
            present()
        } else {
            refreshButton.isHidden = false
            internetConnectLbl.isHidden = false
        }
    }
    
    func present() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "MainViewController")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}



