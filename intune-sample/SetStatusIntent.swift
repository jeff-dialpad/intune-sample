//
//  SetStatusIntent.swift
//  intune-sample
//
//  Created by Jeff Pedersen on 2024-05-16.
//

import AppIntents
import Foundation

struct SetStatusIntent: AppIntent {
    @Parameter(title: "status") var status: String

    static let title: LocalizedStringResource = "Set Status"

    func perform() async throws -> some IntentResult & ProvidesDialog {
        let message: IntentDialog
        do {
            try StatusManager.shared.setSiriStatus(status)
            message = IntentDialog(stringLiteral: "OK, your status has been set to \(status)")
        } catch StatusError.siriIntentsDisallowedByIntunePolicy {
            message = IntentDialog("Your protection policy does not allow you to set status with Siri")
        } catch {
            message = IntentDialog("Sorry, something went wrong")
        }
        return .result(dialog: message)
    }
}
