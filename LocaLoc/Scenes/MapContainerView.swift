//
//  MapContainerView.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 4/7/24.
//

import SwiftUI

struct MapContainerView: View {
    //  @Binding var markers: [GMSMarker]
    //  @Binding var selectedMarker: GMSMarker?
    @Environment(\.dismiss) var dismiss

    private let viewModel: MapContainerViewModel
    
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
                            VStack(alignment: .leading) {
                                Text(viewModel.channel.name)
                                Text("222 Members, 23 points")
                                    .foregroundStyle(Color.Text.subtitle)
                            }
                        }
                        .shadow(color: .black, radius: 10, y: 4)
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack {
                            Button(action: viewModel.addNewPointButtonTapped) {
                                Image("point_add")
                                    .resizable()
                                    .navBarStyled()
                            }
                            
                            Button(action: viewModel.settingsButtonTapped) {
                                Image(systemName: "gearshape")
                                    .resizable()
                                    .navBarStyled()
                            }
                        }
                    }
                }
            
            VStack() {
                Spacer()
                Button(action: viewModel.recenterButtonTapped) {
                    Image("center")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundStyle(Color.Text.main)
                        .padding(.top, 16)
                        .shadow(color: .black, radius: 5, y: 4)
                }
            }
            .padding(.trailing, 20)
        }
        .onChange(of: viewModel.dismiss) { _, shouldDismiss in
            if shouldDismiss {
                dismiss()
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
