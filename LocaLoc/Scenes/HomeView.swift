//
//  HomeView.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 19/5/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    
    var body: some View {
        TabView {
            ForEach(viewModel.model.tabScenes) { view in
                view.tabItem()
            }
        }
        .onAppear {
            UITabBar.appearance().unselectedItemTintColor = .systemGray
            UITabBar.appearance().backgroundColor = .systemGray4
        }
        .tint(Color.Text.main)
    }
}

fileprivate extension TabScene<AnyView> {
    @ViewBuilder
    func tabItem() -> some View {
        NavigationView {
            content
        }
            .tabItem {
                image.renderingMode(.template)
                Text(title)
            }
    }
    
    var image: Image {
        switch type {
        case .channels:
            return Image(systemName: "list.bullet")
        case .settings:
            return Image(systemName: "gearshape")
        }
    }
    
    var title: String {
        switch type {
        case .channels:
            return "Channels"
        case .settings:
            return "Settings"
        }
    }
}

#Preview {
    let previewer = Previewer()
    
    return HomeComposer.view(
        authenticationService: AuthenticationService(
            userDataRepository: previewer.userDataRepository
        ),
        userDataRepository: previewer.userDataRepository
    )
}
