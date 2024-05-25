//
//  AuthenticationCoordinator.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 21/5/24.
//

import SwiftUI

enum AuthenticationPage {
    case providers, forgotPassword
}

final class AuthenticationCoordinator: Hashable {
    @Binding var navigationPath: NavigationPath

    private var id: UUID
    private var output: Output?
    private var page: AuthenticationPage

    struct Output {
        var goToMainScreen: () -> Void
    }

    init(
        page: AuthenticationPage,
        navigationPath: Binding<NavigationPath>,
        output: Output? = nil
    ) {
        id = UUID()
        self.page = page
        self.output = output
        self._navigationPath = navigationPath
    }

    @ViewBuilder
    func view() -> some View {
        switch self.page {
            case .providers:
                loginView()
            case .forgotPassword:
                loginView()
        }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (
        lhs: AuthenticationCoordinator,
        rhs: AuthenticationCoordinator
    ) -> Bool {
        lhs.id == rhs.id
    }

    private func loginView() -> some View {
        AuthenticationView()
            .environmentObject(AuthenticationViewModel(authenticationService: AuthenticationService(dataRepository: DataRepository.shared)))
//        let loginView = LoginView(
//            output:
//                .init(
//                    goToMainScreen: {
//                        self.output?.goToMainScreen()
//                    },
//                    goToForgotPassword:  {
//                        self.push(
//                            AuthenticationCoordinator(
//                                page: .forgotPassword,
//                                navigationPath: self.$navigationPath
//                            )
//                        )
//                    }
//                )
//        )
//        return loginView
    }

   // private func forgotPasswordView() -> some View {
      //  ChannelsComposer.compose().body
//        let forgotPasswordView = ForgotPasswordView(output:
//                .init(
//                    goToForgotPasswordWebsite: {
//                        self.goToForgotPasswordWebsite()
//                    }
//                )
//        )
//        return forgotPasswordView
 //   }

    func push<V>(_ value: V) where V : Hashable {
        navigationPath.append(value)
    }
}
