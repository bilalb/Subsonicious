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

    @EnvironmentObject var authenticationManager: AuthenticationManager
    @State private var server = Server()

    var body: some View {
        GeometryReader { content in
            VStack {
                Text("login.login")

                VStack {
                    TextField("login.server", text: $server.baseURL)
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
                .disabled(isLoading)

                Button(action: continueButtonPressed) {
                    if isLoading {
                        ProgressView()
                    } else {
                        Text("login.continue")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                .frame(maxWidth: content.size.width, maxHeight: 44)
                .background(Color.yellow)
                .cornerRadius(Constant.View.CornerRadius.default)
                .opacity(continueButtonOpacity)
                .disabled(isContinueButtonDisabled)

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .padding()
                }

                Spacer()
            }
            .padding()
        }
    }
}

private extension LoginView {

    var continueButtonOpacity: Double {
        isContinueButtonDisabled ? Constant.View.Opacity.disabled : 1
    }

    var isContinueButtonDisabled: Bool {
        let fieldsAreInvalid = !server.baseURL.isValid ||
            !server.username.isValid ||
            !server.password.isValid

        return fieldsAreInvalid || isLoading
    }

    var isLoading: Bool {
        switch authenticationManager.status {
        case .authenticating:
            return true
        default:
            return false
        }
    }

    func continueButtonPressed() {
        do {
            try authenticationManager.authenticate(with: server)
        } catch {
            preconditionFailure(error.localizedDescription)
        }
    }

    var errorMessage: String? {
        switch authenticationManager.status {
        case .notAuthenticated(let reason):
            switch reason {
            case .failure(let error):
                switch error {
                case .some(DecodingError.Subsonic.error(let subsonicError)):
                    return subsonicError.message
                default:
                    return error?.localizedDescription
                }
            default:
                return nil
            }
        default:
            return nil
        }
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
