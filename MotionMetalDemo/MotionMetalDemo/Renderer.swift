//
//  Renderer.swift
//  MotionMetalDemo
//
//  Created by Arjun Gautami on 11/07/25.
//
import MetalKit

class Renderer: NSObject, MTKViewDelegate {
    var device: MTLDevice!
    var queue: MTLCommandQueue!
    var pipeline: MTLRenderPipelineState!
    var time0 = CACurrentMediaTime()
    var motion: MotionManager

    init(motion: MotionManager) {
        self.motion = motion
        super.init()
        device = MTLCreateSystemDefaultDevice()
        queue = device.makeCommandQueue()
        let lib = device.makeDefaultLibrary()!
        let pd = MTLRenderPipelineDescriptor()
        pd.vertexFunction = lib.makeFunction(name: "vertex_main")
        pd.fragmentFunction = lib.makeFunction(name: "fragment_main")
        pd.colorAttachments[0].pixelFormat = .bgra8Unorm
        pipeline = try! device.makeRenderPipelineState(descriptor: pd)
    }

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}

    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
              let pass = view.currentRenderPassDescriptor else { return }
        let cb = queue.makeCommandBuffer()!
        let enc = cb.makeRenderCommandEncoder(descriptor: pass)!
        enc.setRenderPipelineState(pipeline)

        var t = Float(CACurrentMediaTime() - time0)
        var m = motion.motionData

        enc.setVertexBytes(&m, length: MemoryLayout<SIMD3<Float>>.size, index: 1)
        enc.setFragmentBytes(&t, length: MemoryLayout<Float>.size, index: 0)
        enc.setFragmentBytes(&m, length: MemoryLayout<SIMD3<Float>>.size, index: 1)

//        enc.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
        enc.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 6)
        enc.endEncoding()
        cb.present(drawable)
        cb.commit()
    }
}

