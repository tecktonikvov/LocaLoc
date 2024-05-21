////
////  AppCoordinator.swift
////  LocaLoc
////
////  Created by Volodymyr Kotsiubenko on 19/5/24.
////
//
//import UIKit
//import SwiftUI
//import Combine
//
//class AppCoordinator: Coordinator, CoordinatorProtocol {
//    var cancellables = [String: AnyCancellable]()
//    
//    
////    init() {//window: UIWindow) {
////       // self.window = window
////        super.init()
////    }
//
////    var navigationController: UINavigationController! {
////        window.rootViewController as? UINavigationController
////    }
//
//    func start() {
//        showMainScene()
//    }
//
//    private func showMainScene() {
//        let view = MainComposer.view()
//        let controller = UIHostingController(rootView: view)
//        let navigationController = UINavigationController(rootViewController: controller)
//       // window.rootViewController = navigationController
////        let viewModel = IndividualListViewModel()
////        viewModel.fetchItems()
////        cancellables["showList"] = viewModel.didSelectedIndividual
////            .sink { [weak self] (item) in
////            self?.showDetailScreen(item)
////        }
////
////        // Use a UIHostingController as window root view controller
////        let view = IndividualListView().environmentObject(viewModel)
////        let controller = UIHostingController(rootView: view)
////        let nav = UINavigationController(rootViewController: controller)
////        nav.navigationBar.isHidden = true
////        window.rootViewController = nav
//    }
//
////    private func showDetailScreen(_ item:IndividualModel) {
////        let viewModel = IndividualDetailViewModel(model: item)
////        cancellables["detailBack"] = viewModel.didNavigateBack
////            .sink { [weak self] in
////            self?.navigationController.popViewController(animated: true)
////        }
////        let view = IndividualDetailView().environmentObject(viewModel)
////        let controller = UIHostingController(rootView: view)
////        navigationController.pushViewController(controller, animated: true)
////    }
//}
