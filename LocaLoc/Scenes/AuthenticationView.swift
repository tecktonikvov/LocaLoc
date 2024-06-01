//
//  AuthenticationView.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 21/5/24.
//

import SwiftUI

struct AuthenticationView: View {
    var viewModel: AuthenticationViewModel
    
    var body: some View {
        VStack {
            Text("Authorization")
                .foregroundStyle(Color.Text.main)
                .font(.system(size: 32))
                .fontWeight(.semibold)
            Spacer()
            VStack {
                Image(systemName: "location.north.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundStyle(Color.Text.main)
                Text("LocaLoc")
                    .foregroundStyle(Color.Text.main)
                    .font(.system(size: 28))
                    .fontWeight(.semibold)
            }
          
            Spacer()

            VStack {
                Button {
                    viewModel.signIn(providerType: .google, view: self)
                } label: {
                    HStack {
                        Spacer()
                        Image("google_icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                        Spacer()
                        Text("Continue with Google")
                            .font(.system(size: 20))
                            .foregroundStyle(Color.Extra.taupe)
                        Spacer()
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12)
                        .fill(Color.Extra.isabelline)
                    )
                }
                
                Button {
                    print("Button was tapped")
                } label: {
                    HStack {
                        Spacer()
                        Image("apple_icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                        Spacer()
                        Text("Continue with Apple")
                            .font(.system(size: 20))
                            .foregroundStyle(Color.Extra.taupe)
                        Spacer()
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12)
                        .fill(Color.Extra.isabelline)
                    )
                }
            }
            .padding(.horizontal, 20)
           
            Spacer()
        }
        .background {
            Color.background
                .ignoresSafeArea()
        }
    }
}

//#Preview {
//    AuthenticationView()
//        .environmentObject(AuthenticationViewModel())
//}

extension View {
    func rootViewController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        
        return root
    }
}
