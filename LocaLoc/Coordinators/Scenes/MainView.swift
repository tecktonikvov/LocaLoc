//
//  MainView.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 19/5/24.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var viewModel: MainViewModel
    
    var body: some View {
        TabView {
            ForEach(viewModel.model.tabScenes) { view in
                view.tabItem()
            }
        }
        .onAppear {
            let standardAppearance = UITabBarAppearance()
            standardAppearance.configureWithTransparentBackground()
            standardAppearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
            UITabBar.appearance().standardAppearance = standardAppearance
        }
        .tint(Color.ContentPrimary.Text.main)

    }
}

fileprivate extension TabScene<AnyView> {
    @ViewBuilder
     func tabItem() -> some View {
         content
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
    MainComposer.view()
}
