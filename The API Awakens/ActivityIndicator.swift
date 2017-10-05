//
//  ActivityIndicator.swift
//  The API Awakens
//
//  Created by Leticia Rodriguez on 10/5/17.
//  Copyright © 2017 Leticia Rodriguez. All rights reserved.
//


import UIKit

class ActivityIndicator {
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var loadingView: UIView = UIView()
    
    func startActivityIndicator(activityIndicator: UIActivityIndicatorView){
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }

    func stopActivityIndicator(activityIndicator: UIActivityIndicatorView){
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
        loadingView.removeFromSuperview()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    func addActivityIndicatorToPickerView(view: UIView){
    
        loadingView = UIView()
        loadingView.frame = CGRect(x: 0, y:0, width: 40, height: 40)
        loadingView.center = CGPoint(x: view.frame.size.width / 2, y: (view.frame.size.height / 2) + 125)
        loadingView.backgroundColor = .black
        loadingView.alpha = 0.3
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
    
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        activityIndicator.center = CGPoint(x: loadingView.frame.size.width/2, y: loadingView.frame.size.height/2)
        loadingView.addSubview(activityIndicator)
        view.addSubview(loadingView)
    
    }
    
    func addActivityIndicator(to view: UIView){
        
        loadingView = UIView()
        loadingView.frame = CGRect(x: 0, y:0, width: 80, height: 80)
        loadingView.center = CGPoint(x: view.frame.size.width / 2, y: (view.frame.size.height / 2) - 120)
        loadingView.backgroundColor = .black
        loadingView.alpha = 0.6
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        activityIndicator.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
        activityIndicator.center = CGPoint(x: loadingView.frame.size.width/2, y: loadingView.frame.size.height/2)
        
        loadingView.addSubview(activityIndicator)
        view.addSubview(loadingView)
        
    }
    
}
