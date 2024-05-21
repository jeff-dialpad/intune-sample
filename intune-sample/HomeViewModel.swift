//
//  HomeViewModel.swift
//  intune-sample
//
//  Created by Jeff Pedersen on 2024-05-15.
//

import Combine
import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    @Published private(set) var currentUser = "Unknown"
    @Published private(set) var areSiriIntentsAllowed = "Unknown"
    @Published private(set) var status = "Unknown"
    @Published private(set) var callList = "Unknown"

    private var subscriptions: Set<AnyCancellable> = []

    func onLoginButtonTapped() {
        IntuneClient.shared.login()
    }

    func onLogoutButtonTapped() {
        IntuneClient.shared.logout()
    }

    func onDisplayConsoleButtonTapped() {
        IntuneClient.shared.displayDiagnoticConsole()
    }

    func onAppear() {
        IntuneClient.shared.eventPublisher()
            .sink { [weak self] in self?.updateIntuneLabels() }
            .store(in: &subscriptions)
        updateIntuneLabels()

        StatusManager.shared.statusPublisher()
            .sink { [weak self] status in self?.updateStatusLabel(status: status) }
            .store(in: &subscriptions)
        updateStatusLabel(status: StatusManager.shared.status)

        CallManager.shared.callsPublisher()
            .sink { [weak self] calls in self?.updateCallList(calls) }
            .store(in: &subscriptions)
        updateCallList(CallManager.shared.calls)
    }
    
    private func updateIntuneLabels() {
        currentUser = IntuneClient.shared.currentUser ?? "None"
        areSiriIntentsAllowed = IntuneClient.shared.areSiriIntentsAllowed ? "Yes" : "No"
    }

    private func updateStatusLabel(status: String) {
        self.status = status
    }

    private func updateCallList(_ calls: [CallRecord]) {
        if calls.isEmpty {
            callList = "No Recent Calls"
        } else {
            let callDescriptions = calls.map(String.init(describing:)).reversed()
            callList = "Recent Calls:\n" + callDescriptions.joined(separator: "\n")
        }
    }
}
