//
//  MotionManager.swift
//  MotionMetalDemo
//
//  Created by Arjun Gautami on 11/07/25.
//
import CoreMotion

class MotionManager1: ObservableObject {
    static let shared = MotionManager1()
    private let manager = CMMotionManager()
    @Published var motionData = SIMD3<Float>(0, 0, 0)

    private init() { start() }

    private func start() {
        guard manager.isDeviceMotionAvailable else { return }
        manager.deviceMotionUpdateInterval = 1/60
        manager.startDeviceMotionUpdates(to: .main) { [weak self] data, _ in
            guard let a = data?.attitude else { return }
            self?.motionData = SIMD3<Float>(Float(a.pitch), Float(a.roll), Float(a.yaw))
        }
    }
}

import Combine

class MotionManager: ObservableObject {
    static let shared = MotionManager()
    private let manager = CMMotionManager()
    @Published var motionData = SIMD3<Float>(0, 0, 0)

    private var buffer = SIMD3<Float>(0, 0, 0)

    private init() { start() }

    private func start() {
        guard manager.isDeviceMotionAvailable else { return }
        manager.deviceMotionUpdateInterval = 1/60
        manager.startDeviceMotionUpdates(to: .main) { [weak self] data, _ in
            guard let self = self, let a = data?.attitude else { return }
            let newData = SIMD3<Float>(Float(a.pitch), Float(a.roll), Float(a.yaw))
            let alpha: Float = 0.05 // smoothing factor
            self.buffer = alpha * newData + (1 - alpha) * self.buffer
            self.motionData = self.buffer
        }
    }
}
