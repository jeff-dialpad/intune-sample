//
//  IntuneClient.swift
//  intune-sample
//
//  Created by Jeff Pedersen on 2024-05-15.
//

import Combine
import Foundation
import IntuneMAMSwift

class IntuneClient: NSObject {
    static let shared = IntuneClient()
    private let eventSubject = PassthroughSubject<Void, Never>()

    var currentUser: String? {
        IntuneMAMEnrollmentManager.instance().enrolledAccount()
    }
    
    var areSiriIntentsAllowed: Bool {
        IntuneMAMPolicyManager.instance().policy()?.areSiriIntentsAllowed ?? true
    }
    
    private override init() {
        super.init()
        IntuneMAMEnrollmentManager.instance().delegate = self
    }
    
    /// Publishes when the current user or policy may have changed
    public func eventPublisher() -> AnyPublisher<Void, Never> {
        return eventSubject.eraseToAnyPublisher()
    }
    
    func start() { }
    
    func login() {
        IntuneMAMEnrollmentManager.instance().loginAndEnrollAccount(nil)
    }
    
    func logout() {
        guard let currentUser = IntuneMAMEnrollmentManager.instance().enrolledAccount(), !currentUser.isEmpty
        else { return }
        IntuneMAMEnrollmentManager.instance().deRegisterAndUnenrollAccount(currentUser, withWipe: false)
    }

    func displayDiagnoticConsole() {
        IntuneMAMDiagnosticConsole.display()
    }
}

extension IntuneClient: IntuneMAMEnrollmentDelegate {
    func enrollmentRequest(with status: IntuneMAMEnrollmentStatus) {
        print("IntuneMAMEnrollmentDelegate \(#function), status: \(status.desc)")
        eventSubject.send(())
    }
    
    func policyRequest(with status: IntuneMAMEnrollmentStatus) {
        print("IntuneMAMEnrollmentDelegate \(#function), status: \(status.desc)")
        eventSubject.send(())
    }
    
    func unenrollRequest(with status: IntuneMAMEnrollmentStatus) {
        print("IntuneMAMEnrollmentDelegate \(#function), status: \(status.desc)")
        eventSubject.send(())
    }
}

extension IntuneMAMEnrollmentStatus {
    var desc: String {
        """

        identity: "\(identity)"
        accoundId: "\(accountId)"
        didSucceed: \(didSucceed)
        statusCode: \(statusCode)
        errorString: \(errorString ?? "nil")
        error: \(error.map(String.init(reflecting:)) ?? "nil")

        """
    }
}
