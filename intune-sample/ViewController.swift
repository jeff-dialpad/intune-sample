//
//  ViewController.swift
//  intune-sample
//
//  Created by Jeff Pedersen on 2024-05-15.
//

import Intents
import SwiftUI
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        requestSiriAuthorization()
    }

    private func setUpViews() {
        let intuneHostingController = UIHostingController(rootView: HomeView())
        
        let intuneHomeView = intuneHostingController.view!
        intuneHomeView.translatesAutoresizingMaskIntoConstraints = false
        addChild(intuneHostingController)
        view.addSubview(intuneHomeView)
        intuneHostingController.didMove(toParent: self)

        NSLayoutConstraint.activate([
            intuneHomeView.topAnchor.constraint(equalTo: view.topAnchor),
            view.bottomAnchor.constraint(equalTo: intuneHomeView.bottomAnchor),
            intuneHomeView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: intuneHomeView.trailingAnchor),
        ])
    }

    private func requestSiriAuthorization() {
        INPreferences.requestSiriAuthorization { status in
            let statusDesc: String
            switch status {
            case .notDetermined: statusDesc = "notDetermined"
            case .restricted: statusDesc = "restricted"
            case .denied: statusDesc = "denied"
            case .authorized: statusDesc = "authorized"
            @unknown default: statusDesc = "unknown"
            }
            print("Siri Authorization status: \(statusDesc)")
        }
    }
}

