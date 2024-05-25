//
//  CoordinatorProtocol.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 19/5/24.
//


protocol CoordinatorProtocol {
    var child: CoordinatorProtocol? { get }
    func start()
}
