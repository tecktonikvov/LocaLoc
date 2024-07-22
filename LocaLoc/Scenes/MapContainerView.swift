//
//  MapContainerView.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 4/7/24.
//

import SwiftUI

fileprivate enum PointInfoViewOpenDirection {
    case left
    case right
}

fileprivate struct PointInfoViewAnimationConfig {
    let direction: PointInfoViewOpenDirection
    let maxWidth: CGFloat
    let position: CGPoint
    let anchor: UnitPoint
}

struct MapContainerView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var viewModel: MapContainerViewModel
    @State private var isPointsAdded = false
    @State private var showPointInfoView = false
    @State private var showPointInfoViewContent = false
    @State private var pointInfoViewSize: CGSize = .zero

    // MARK: - Init
    init(viewModel: MapContainerViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack(alignment: .trailing) {
            MapViewControllerBridge(mapViewController: viewModel.mapView)
                .ignoresSafeArea()
                .navigationBarBackButtonHidden()
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: viewModel.backButtonTapped) {
                            Image(systemName: "chevron.backward")
                                .navBarStyled()
                        }
                    }
                    
                    ToolbarItem(placement: .navigation) {
                        HStack {
                            CachedCenteredImage(url: viewModel.channel.imageUrl, placeholderImageName: "channel_placeholder")
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.5), radius: 10, y: 4)
                            VStack(alignment: .leading) {
                                Text(viewModel.channel.name)
                                Text("222 Members, 23 points")
                                    .foregroundStyle(Color.Text.subtitle)
                            }
                            .shadow(color: .black, radius: 10, y: 4)
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: viewModel.settingsButtonTapped) {
                            Image(systemName: "gearshape")
                                .resizable()
                                .navBarStyled()
                        }
                    }
                }
                .safeAreaInset(edge: .bottom) {
                    if viewModel.userSubscriptionRelationType.subscriptionAvailable {
                        subscriptionButton()
                    }
                }
            VStack() {
                Spacer()
                if viewModel.showSynchronizationIndicator {
                    PointAnimationView()
                        .frame(width: 32, height: 32)
                } else {
                    Button(action: viewModel.recenterButtonTapped) {
                        Image("center")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundStyle(Color.Text.main)
                            .padding(.top, 16)
                            .shadow(color: .black, radius: 5, y: 4)
                    }
                }
            }
            .padding(.trailing, 20)
        }
        .overlay {
            pointInfoView()
        }
        .onChange(of: viewModel.selectedPointData) { _, data in
            withAnimation(.easeInOut(duration: 0.2)) {
                showPointInfoView = data != nil
            }
            
            withAnimation(.easeInOut(duration: 0.2).delay(0.1)) {
                showPointInfoViewContent = data != nil
            }
        }
        .onChange(of: viewModel.dismiss) { _, shouldDismiss in
            if shouldDismiss {
                dismiss()
            }
        }
        .popup(isPresented: $viewModel.showPointEditingView) {
            pointEditingView()
        } customize: {
            $0
                .type(.toast)
                .appearFrom(.bottomSlide)
                .isOpaque(false)
                .closeOnTap(false)
                .useKeyboardSafeArea(true)
        }
        .popup(isPresented: $viewModel.showAddPointView) {
            pointAddView()
        } customize: {
            $0
                .type(.toast)
                .appearFrom(.bottomSlide)
                .isOpaque(false)
                .closeOnTap(false)
                .useKeyboardSafeArea(true)
        }
        .onAppear {
            if !isPointsAdded {
                viewModel.addChannelPoints()
                isPointsAdded = true
                viewModel.synchronizeChannelsPoints()
            }
        }
    }
    
    // MARK: - Private
    @ViewBuilder
    private func pointInfoView() -> some View {
        if let selectedPointData = viewModel.selectedPointData {
            let point = selectedPointData.point
            let config = pointInfoViewAnimationConfig(markerFrame: selectedPointData.markerFrame)
            let animationValue = showPointInfoView ? 1 : 0.1
            let offset = offset(
                contentSize: pointInfoViewSize,
                config: config,
                markerFrame: selectedPointData.markerFrame
            )
            
            PointInfoView(
                address: point.address,
                description: point.description,
                updatedAt: point.updatedAt,
                isEditingAllowed: viewModel.isEditingAllowed(),
                showContent: $showPointInfoViewContent
            ) {
                viewModel.pointEditButtonTaped()
            }
            .readSize { size in
                self.pointInfoViewSize = size
            }

            .scaleEffect(animationValue, anchor: config.anchor)
            .opacity(animationValue)
            
            .frame(maxWidth: config.maxWidth)

            .position(x: config.position.x, y: config.position.y)
            .offset(x: offset.x, y: offset.y)
        }
    }
    
    private func pointInfoViewAnimationConfig(markerFrame: CGRect) -> PointInfoViewAnimationConfig {
        let screenWidth: CGFloat = UIScreen.main.bounds.width
        let horizontalPadding: CGFloat = 16
        let leftFreeWidth: CGFloat = markerFrame.midX - horizontalPadding
        let rightFreeWidth: CGFloat = screenWidth - markerFrame.midX - horizontalPadding
        let maxWidth: CGFloat = max(leftFreeWidth, rightFreeWidth)
        let topInset: CGFloat = viewModel.mapTopSafeAreaInset
        
        let openDirection = openDirection(leftFreeWidth: leftFreeWidth, rightFreeWidth: rightFreeWidth)
        let position = position(openDirection: openDirection, markerFrame: markerFrame, topInset: topInset)
        let anchor = anchor(openDirection: openDirection)
        
        let config = PointInfoViewAnimationConfig(
            direction: openDirection,
            maxWidth: maxWidth,
            position: position,
            anchor: anchor
        )
                
        return config
    }
    
    private func openDirection(leftFreeWidth: CGFloat, rightFreeWidth: CGFloat) -> PointInfoViewOpenDirection {
        if leftFreeWidth > rightFreeWidth {
            return .left
        } else {
            return .right
        }
    }
    
    private func position(openDirection: PointInfoViewOpenDirection, markerFrame: CGRect, topInset: CGFloat) -> CGPoint {
        switch openDirection {
        case .left:
            return CGPoint(x: markerFrame.minX, y: markerFrame.minY - topInset)
        case .right:
            return CGPoint(x: markerFrame.maxX, y: markerFrame.minY - topInset)
        }
    }
    
    private func anchor(openDirection: PointInfoViewOpenDirection) -> UnitPoint {
        switch openDirection {
        case .left:
            return .topTrailing
        case .right:
            return .topLeading
        }
    }
    
    private func offset(contentSize: CGSize, config: PointInfoViewAnimationConfig, markerFrame: CGRect) -> CGPoint {
        switch config.direction {
        case .left:
            return CGPoint(x: -contentSize.width * 0.5, y: contentSize.height * 0.5 - markerFrame.height)
        case .right:
            return CGPoint(x: contentSize.width * 0.5, y: contentSize.height * 0.5 - markerFrame.height)
        }
    }
    
    @ViewBuilder
    private func pointAddView() -> some View {
        if let selectedCoordinates = viewModel.selectedCoordinates {
            PointAddView(coordinates: selectedCoordinates,
                         addressString: $viewModel.addressString,
                         description: $viewModel.description,
                         showPoint: $viewModel.showPoint,
                         lifetime: $viewModel.lifetime,
                         emojiCode: $viewModel.emojiCode,
                         heading: $viewModel.heading,
                         selectedPointSingType: $viewModel.selectedPointSingType,
                         isApproveButtonLoading: $viewModel.pointCreationRequestInProgress) {
                self.viewModel.newPointApproved()
            } onClose: {
                self.viewModel.newPointCanceled()
            }
        }
    }
    
    @ViewBuilder
    private func pointEditingView() -> some View {
        if let pointEditingViewModel = viewModel.pointEditingViewModel {
            PointEditingView(viewModel: pointEditingViewModel)
        }
    }
    
    @ViewBuilder
    private func subscriptionButton() -> some View {
        HStack(alignment: .center) {
            Button(action: viewModel.subscribe) {
                HStack {
                    if viewModel.showSubscriptionRequestIndicator {
                        ProgressView()
                    } else {
                        Image(systemName: "hand.point.up")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(Color.brand)
                        
                        Text("Subscribe")
                            .foregroundStyle(Color.Text.main)
                    }
                }
                .padding()
                .background(Color.mapBackground)
                .clipShape(Capsule())
                .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 2)
            }
        }
    }
}

fileprivate extension Image {
    func navBarStyled() -> some View {
        self
            .frame(width: 32, height: 32)
            .foregroundStyle(Color.Text.main)
            .shadow(color: .black, radius: 10, y: 4)
    }
}

fileprivate extension UserChannelSubscriptionRelationType {
    var subscriptionAvailable: Bool {
        switch self {
        case .subscribed:
            return false
        case .invited, .notSubscribed:
            return true
        }
    }
}
