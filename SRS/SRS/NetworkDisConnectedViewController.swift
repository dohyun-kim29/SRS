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

class NetworkDisConnectedViewController: UIViewController {
    
    @IBOutlet weak var refreshButton: UIButton!
    
    let disposeBag = DisposeBag()
    
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
                    //toaster 추가 해줄 예정.
                }
            }.disposed(by: disposeBag)
    }
}
