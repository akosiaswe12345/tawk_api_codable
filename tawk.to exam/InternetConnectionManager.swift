//
//  Network.swift
//  tawk.to exam
//
//  Created by Taison Digital on 3/10/21.
//

import Foundation
import UIKit
import SystemConfiguration
import SVProgressHUD

public class InternetConnectionManager {
    
    
    private init() {
        
    }
    
    public static func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                
                SCNetworkReachabilityCreateWithAddress(nil, $0)
                
            }
            
        }) else {
            
            return false
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
}

let MAROON = "#800000"
public func loader() {
    SVProgressHUD.show()
    SVProgressHUD.setBackgroundColor(.white)
    SVProgressHUD.setForegroundColor(hexStringToUIColor(hex: MAROON))
}


public func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: 53 / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}


extension UIViewController {
    
    @discardableResult
    func presentDismissableAlertController(title: String?, message: String?, completion: (() -> Swift.Void)? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAlertAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
        
        alertController.addAction(dismissAlertAction)
        present(alertController, animated: true, completion: completion)
        return alertController
    }
    
}
