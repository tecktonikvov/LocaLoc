//
//  UsernameCreationView.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 4/6/24.
//

import SwiftUI

struct UsernameCreationView: View {
    @State private var viewModel: UsernameCreationViewViewModel
    
    // MARK: - Init
    init(viewModel: UsernameCreationViewViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                Text("Create username")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding(.bottom)
                
                VStack {
                    HStack {
                        Text("@")
                            .padding(.trailing, -6)
                        TextField("Username",
                                  text: $viewModel.username.max(Constants.usernameCharactersLimit))
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12)
                        .fill(.gray.opacity(0.3))
                    )

                    if let errorText = viewModel.errorText {
                        Text(errorText)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .font(.footnote)
                            .foregroundColor(Color.Text.attention)
                    } else {
                        let amount = symbolsLeft()
                        Text("\(amount) symbols left")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .font(.footnote)
                            .foregroundColor(amount <= 0 ? Color.Text.attention : Color.Text.main)
                    }
                }
                .padding()
                
                Button(action: viewModel.setUsername) {
                    if !viewModel.isLoading {
                        Text("Continue")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.Extra.taupe)
                            .frame(maxWidth: 120, maxHeight: 56)
                            .background(RoundedRectangle(cornerRadius: 12)
                                .fill(Color.Extra.isabelline)
                            )
                    } else {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.Text.main))
                            .scaleEffect(1.5, anchor: .center)
                            .frame(maxWidth: 56, maxHeight: 56)
                    }
                }
                .padding(.top)
                
                Spacer()
            }
            .disabled(viewModel.isLoading)
        }
        .backgroundDefault()
        .onChange(of: viewModel.username) { _, newValue in
            viewModel.errorText = nil
        }
    }
    
    // MARK: - Private
    private func symbolsLeft() -> Int {
        let amount = Constants.usernameCharactersLimit - viewModel.username.count
        return max(0, amount)
    }
}

//#Preview {
//    UsernameCreationView(viewModel: UsernameCreationViewViewModel())
//}
