//
//  ShorcutsProvider.swift
//  intune-sample
//
//  Created by Jeff Pedersen on 2024-05-16.
//

import AppIntents
import Foundation

struct ShortcutsProvider: AppShortcutsProvider {
    @AppShortcutsBuilder static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: SetStatusIntent(),
            phrases: ["Set my \(.applicationName) status"]
        )
    }
}
