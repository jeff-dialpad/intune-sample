//
//  StatusManager.swift
//  intune-sample
//
//  Created by Jeff Pedersen on 2024-05-16.
//

import Combine
import Foundation

enum StatusError: Error {
    case siriIntentsDisallowedByIntunePolicy
}

class StatusManager {
    static let shared = StatusManager()

    private let statusSubject = CurrentValueSubject<String, Never>("None")

    private(set) var status: String {
        get { statusSubject.value }
        set { statusSubject.value = newValue }
    }

    private init() { }

    func statusPublisher() -> AnyPublisher<String, Never> {
        return statusSubject.dropFirst().eraseToAnyPublisher()
    }

    func setSiriStatus(_ status: String) throws {
        guard IntuneClient.shared.areSiriIntentsAllowed else {
            throw StatusError.siriIntentsDisallowedByIntunePolicy
        }
        self.status = status
    }
}
