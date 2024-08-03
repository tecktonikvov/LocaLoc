//
//  LocaLocApp.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 6/5/24.
//

import SwiftUI
import Factory
import FirebaseCore
import GoogleMaps
import K_Logger

@main
struct CoreApp: App {    
    private let appComposer: AppComposer
    
    @Injected(\.userDataRepository) private var userDataRepository
    @Injected(\.authenticationService) private var authenticationService

    @State private var path = NavigationPath()
        
    // MARK: - Init
    init() {
        CoreApp.setupFirebaseApp()
        CoreApp.setupGMaps()
        
        let appComposer = AppComposer()
        self.appComposer = appComposer
        
        if let isAppEnvironmentWasChanged = AppEnvironment.isAppEnvironmentWasChanged, isAppEnvironmentWasChanged {
            authenticationService.signOut()
        }

        AppEnvironment.saveCurrentAppEnvironment()
        
        if let user = userDataRepository.currentUser {
            setCrashlyticsData(user: user)
        }
    }
    
    // MARK: - Private
    private func setCrashlyticsData(user: User) {
        CrashlyticsService.shared.set(userId: user.id)
        CrashlyticsService.shared.set(username: user.profile.username)
        CrashlyticsService.shared.set(userEmail: user.profile.email)
    }
    
    private static func setupFirebaseApp() {
        FirebaseApp.configure()
    }
    
    private static func setupGMaps() {
        GMSServices.provideAPIKey(EnvironmentVariables.gMapsApiKey)
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $path) {
                appComposer.view(path: $path)
                    .navigationDestination(for: NavigationState.self) { state in
                        view(forNavigationState: state)
                    }
            }
            .onOpenURL { incomingURL in
                Log.info("App was opened via URL: \(incomingURL)")
                handleIncomingURL(incomingURL)
            }
        }
    }
    
    // MARK: - Private
    private func handleIncomingURL(_ url: URL) {
        guard url.scheme == "https" else {
            Log.error("Deeplink has incorrect scheme: \(url.scheme ?? "")")
            return
        }
        
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            Log.error("Invalid url: \(url.absoluteString)")
            return
        }
                
        guard let host = components.host, host == EnvironmentVariables.hostUrl else {
            Log.error("Unknown host: \(components.host ?? "nil")")
            return
        }
        
        let path = components.path
        
        switch path {
        case "/channel":
            guard let id = components.queryItems?.first(where: { $0.name == "id" })?.value else {
                Log.error("Channel id not found in url, URL: \(url.absoluteString)")
                return
            }
            
            InMemoryDeeplinkHolder.channelDeepLink = ChannelDeeplinkModel(channelId: id, invitationId: nil)
            
        case "/channel_invitation":
            guard let id = components.queryItems?.first(where: { $0.name == "id" })?.value else {
                Log.error("Invitation id not found in url, URL: \(url.absoluteString)")
                return
            }
            
            guard let channelId = components.queryItems?.first(where: { $0.name == "channel_id" })?.value else {
                Log.error("Channel id not found in url, URL: \(url.absoluteString)")
                return
            }
            
            InMemoryDeeplinkHolder.channelDeepLink = ChannelDeeplinkModel(channelId: channelId, invitationId: id)
        default:
            break
        }
    }
    
    @ViewBuilder
    private func view(forNavigationState state: NavigationState) -> some View {
        switch state {
        case .createNewChannel:
            let channelCreationViewModel = ChannelCreationViewModel()
            ChannelCreationView(viewModel: channelCreationViewModel, path: $path)
            
        case let .map(channel, relation):
            let mapContainerViewModel = MapContainerViewModel(channel: channel, userSubscriptionRelationType: relation)
            MapContainerView(viewModel: mapContainerViewModel, path: $path)
            
        case let .privateChannel(privateChannelModel):
            let privateChannelViewModel = PrivateChannelViewModel(channelModel: privateChannelModel)
            PrivateChannelView(viewModel: privateChannelViewModel, path: $path)
            
        case let .channelDetails(channelDetailsModel):
            let channelDetailsViewModel = ChannelDetailsViewModel(channelDetailsModel: channelDetailsModel)
            ChannelDetailsView(viewModel: channelDetailsViewModel, path: $path)
            
        case .profileEditing:
            let profileEditingViewModel = ProfileEditingViewModel()
            ProfileEditingView(viewModel: profileEditingViewModel, path: $path)
            
        case let .channelEditing(channel):
            let channelEditingViewModel = ChannelEditingViewModel(channel: channel)
            ChannelEditingView(viewModel: channelEditingViewModel, path: $path)
        }
    }
}
