//
//  NetworkDisConnectedViewController.swift
//  SRS
//
//  Created by DohyunKim on 2021/03/16.
//

import UIKit
import RxCocoa
import RxSwift
import SystemConfiguration
import Toaster

class NetworkDisConnectedViewController: UIViewController {
    
    @IBOutlet weak var refreshButton: UIButton!
    
    let disposeBag = DisposeBag()
    let toastNetworkText = Toast(text: "네트워크 연결이 불안정합니다", duration: Delay.short)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
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
                if (self.isInternetAvailable() == true) {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.toastNetworkText.show()
                    self.dismiss(animated: true, completion: nil)
                    
                }
            }.disposed(by: disposeBag)
    }
}
