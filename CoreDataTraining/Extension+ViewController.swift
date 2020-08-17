//
//  Extension+ViewController.swift
//  CoreDataTraining
//
//  Created by Andrei Volkau on 13.08.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func setupNavBarAppearance() {
        navigationController?.navigationBar.prefersLargeTitles = true
        
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.backgroundColor = .lightRedColor
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        }
    }
    
    
    func setupPlusBarButton(selector: Selector) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: selector)
    }
    
    @discardableResult
    func presentAlertController(title: String, message: String, acceptAction: Bool = false) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let bluredView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        navigationController?.view.addSubview(bluredView)
        bluredView.fillSuperview()
        bluredView.alpha = 0
        UIView.animate(withDuration: 0.5) {
            bluredView.alpha = 1
        }
        if !acceptAction {
            present(alert, animated: true) {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    alert.dismiss(animated: true, completion: nil)
                    UIView.animate(withDuration: 0.5, animations: {
                        bluredView.alpha = 0
                    }) { (_) in
                        bluredView.removeFromSuperview()
                    }
                }
            }
        } else {
            let action = UIAlertAction.init(title: "OK", style: .default) { (action) in
                UIView.animate(withDuration: 0.3, animations: {
                    bluredView.alpha = 0
                }) { (_) in
                    bluredView.removeFromSuperview()
                }
            }
            alert.addAction(action)
            present(alert, animated: true)
        }
        
        return alert
    }
    
}
