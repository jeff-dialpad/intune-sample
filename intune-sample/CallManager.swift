//
//  CallManager.swift
//  intune-sample
//
//  Created by Jeff Pedersen on 2024-05-16.
//

import Combine
import Foundation
import Intents

struct CallRecord: CustomStringConvertible {
    var date: Date
    var name: String

    var description: String { "\(date.formatted(date: .omitted, time: .shortened)) \(name)" }
}

class CallManager {
    static let shared = CallManager()
    private let callsSubject = PassthroughSubject<[CallRecord], Never>()

    private(set) var calls: [CallRecord] = [] {
        didSet { callsSubject.send(calls) }
    }

    private init() { }

    func callsPublisher() -> AnyPublisher<[CallRecord], Never> {
        return callsSubject.eraseToAnyPublisher()
    }

    func continueUserActivity(_ userActivity: NSUserActivity) -> Bool {
        if userActivity.activityType == "com.jkp-dp-dev.intune-sample.intent.start-call",
           let intent = userActivity.interaction?.intent as? INStartCallIntent
        {
            handleStartCallIntent(intent)
            return true
        } else {
            return false
        }
    }

    private func handleStartCallIntent(_ intent: INStartCallIntent){
        let name = intent.contacts?.first?.displayName ?? "Unknown Contact"
        calls.append(CallRecord(date: Date(), name: name))
    }
}
