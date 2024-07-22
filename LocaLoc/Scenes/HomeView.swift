//
//  HomeView.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 19/5/24.
//

import SwiftUI
import K_Logger

struct HomeView: View {
    private let viewModel: HomeViewModel
    
    @Binding private var path: NavigationPath
    
    // MARK: - Init
    init(viewModel: HomeViewModel, path: Binding<NavigationPath>) {
        self._path = path
        self.viewModel = viewModel
    }
    
    var body: some View {
        TabView {
            ForEach(viewModel.model.tabScenes) { view in
                view.tabItem()
            }
        }
        .onAppear {
            UITabBar.appearance().unselectedItemTintColor = .systemGray
            UITabBar.appearance().backgroundColor = .systemGray4
            
            viewModel.checkForDeepLinks(delay: 1.0)
        }
        .tint(Color.Text.main)
        .onChange(of: viewModel.deeplinkChannel) { _, deeplinkChannel in
            guard let deeplinkChannel else { return }
            
            switch deeplinkChannel {
            case let .accessAllowed(channel, relation):
                path.append(NavigationState.map(channel: channel, relationType: relation))
            case .accessDenied(let privateChannelModel):
                path.append(NavigationState.privateChannel(privateChannelModel: privateChannelModel))
            }
        }
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
