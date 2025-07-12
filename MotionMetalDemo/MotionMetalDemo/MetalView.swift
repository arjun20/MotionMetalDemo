//
//  MetalView.swift
//  MotionMetalDemo
//
//  Created by Arjun Gautami on 11/07/25.
//
import SwiftUI
import MetalKit

struct MetalView: UIViewRepresentable {
    @ObservedObject var motion = MotionManager.shared

    func makeCoordinator() -> Renderer { Renderer(motion: motion) }

    func makeUIView(context: Context) -> MTKView {
        let view = MTKView()
        view.device = MTLCreateSystemDefaultDevice()
        view.clearColor = MTLClearColorMake(0.1, 0.1, 0.1, 1)
        view.delegate = context.coordinator
        return view
    }

    func updateUIView(_ uiView: MTKView, context: Context) {
        context.coordinator.motion = motion
    }
}

