//
//  calculatorUIApp.swift
//  calculatorUI
//
//  Created by Sumit Chandora on 17/10/23.
//

import SwiftUI

@main
struct calculatorUIApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(Numbers())
                .background(.black)
        }
    }
}
