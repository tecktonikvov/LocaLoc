//
//  Prefix.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 16/7/24.
//

import SwiftUI

prefix func ! (value: Binding<Bool>) -> Binding<Bool> {
    Binding<Bool>(
        get: { !value.wrappedValue },
        set: { value.wrappedValue = !$0 }
    )
}
