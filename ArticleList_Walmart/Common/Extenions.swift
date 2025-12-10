//
//  Extenions.swift
//  ArticleList
//
//  Created by Shobhakar Tiwari on 9/15/25.
//

import UIKit

protocol RetryAlertDelegate: AnyObject {
    func didTapTryAgain()
    func didTapOK()
}

extension UIViewController {
    func showAlert(title: String, message: String, retryCount: Int, delegate: RetryAlertDelegate?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if retryCount < 3 {
            let tryagainAction = UIAlertAction(title: "Try Again", style: .default) { _ in
                delegate?.didTapTryAgain()
            }
            alertController.addAction(tryagainAction)
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            delegate?.didTapOK()
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
}
