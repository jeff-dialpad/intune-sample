//
//  HomeView.swift
//  intune-sample
//
//  Created by Jeff Pedersen on 2024-05-15.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()

    var body: some View {
        VStack(spacing: 28) {
            Text("Current User: \(viewModel.currentUser)")
            Text("Are Siri Intents Allowed: \(viewModel.areSiriIntentsAllowed)")
            Text("Status: \(viewModel.status)")

            Button("Intune Login and Enroll") { viewModel.onLoginButtonTapped() }
            Button("Intune Deregister") { viewModel.onLogoutButtonTapped() }
            Button("Diagnostic Console") { viewModel.onDisplayConsoleButtonTapped() }

            ScrollView {
                Text(viewModel.callList)
            }
        }
        .task { viewModel.onAppear() }
        .padding(.all)
    }
}
