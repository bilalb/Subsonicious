//
//  LoginView.swift
//  Subsonicious
//
//  Created by Bilal on 15/06/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import SubsoniciousKit
import SwiftUI

struct LoginView: View {

    @EnvironmentObject var authentication: Authentication
    @State private var server = Server()

    var body: some View {
        GeometryReader { content in
            VStack {
                Text("login.login")

                VStack {
                    TextField("login.server", text: $server.address)
                        .keyboardType(.URL)
                        .textContentType(.URL)
                        .asLoginField()

                    TextField("login.username", text: $server.username)
                        .keyboardType(.asciiCapable)
                        .textContentType(.username)
                        .asLoginField()

                    SecureField("login.password", text: $server.password)
                        .textContentType(.password)
                        .asLoginField()
                }

                Button(action: continueButtonPressed) {
                    Text("login.continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: content.size.width, maxHeight: 44)
                        .background(Color.yellow)
                        .cornerRadius(6)
                        .opacity(continueButtonOpacity)
                }
                .disabled(isContinueButtonDisabled)

                Spacer()
            }
            .padding()
        }
    }
}

private extension LoginView {

    var continueButtonOpacity: Double {
        isContinueButtonDisabled ? 0.6 : 1
    }

    var isContinueButtonDisabled: Bool {
        !server.address.isValid ||
            !server.username.isValid ||
            !server.password.isValid
    }

    func continueButtonPressed() {
        authentication.isConnected = true
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

extension View {
    func asLoginField() -> some View {
        textFieldStyle(RoundedBorderTextFieldStyle())
            .autocapitalization(.none)
            .disableAutocorrection(true)
    }
}
