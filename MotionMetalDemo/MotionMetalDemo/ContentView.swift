//
//  ContentView.swift
//  MotionMetalDemo
//
//  Created by Arjun Gautami on 11/07/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack { MetalView().edgesIgnoringSafeArea(.all) }
    }
}

#Preview {
    ContentView()
}
