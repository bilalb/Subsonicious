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

    @State private var server = Server()

    var body: some View {
        GeometryReader { content in
            VStack {
                Text("Subsonic server")

                VStack {
                    TextField("Server", text: self.$server.address)
                        .keyboardType(.URL)
                        .textContentType(.URL)
                        .asLoginField()

                    TextField("Username", text: self.$server.username)
                        .keyboardType(.asciiCapable)
                        .textContentType(.username)
                        .asLoginField()

                    SecureField("Password", text: self.$server.password)
                        .textContentType(.password)
                        .asLoginField()
                }

                Button(action: { }) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: content.size.width, maxHeight: 44)
                        .background(Color.yellow)
                        .cornerRadius(6)
                        .opacity(self.continueButtonOpacity)
                }
                .disabled(self.isContinueButtonDisabled)

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