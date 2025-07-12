//
//  Shaders.metal
//  MotionMetalDemo
//
//  Created by Arjun Gautami on 11/07/25.
//

//#include <metal_stdlib>
//using namespace metal;
//
//struct VertexOut { float4 position [[position]]; };
//
//vertex VertexOut vertex_main(uint vid [[vertex_id]], constant float3 &motion [[ buffer(1) ]]) {
//    float2 pos[3] = { {-1,-1}, {1,-1}, {0,1} };
//    VertexOut o; float shift = motion.y * 0.5;
//    o.position = float4(pos[vid].x + shift, pos[vid].y + shift, 0, 1);
//    return o;
//}
//
//fragment float4 fragment_main(VertexOut in [[stage_in]], constant float &time [[ buffer(0) ]], constant float3 &motion [[ buffer(1) ]]) {
//    float hue = fmod(time + motion.z, 1.0);
//    return float4(hue, 0.5 + motion.x, 1 - hue, 1);
//}

#include <metal_stdlib>
using namespace metal;

struct VertexOut {
    float4 position [[position]];
    float2 uv;
};

vertex VertexOut vertex_main(uint vid [[vertex_id]]) {
    float2 positions[6] = {
        {-1.0, -1.0}, { 1.0, -1.0}, { -1.0, 1.0 },
        { -1.0, 1.0 }, { 1.0, -1.0 }, { 1.0, 1.0 }
    };

    float2 uv = (positions[vid] + 1.0) * 0.5;

    VertexOut out;
    out.position = float4(positions[vid], 0, 1);
    out.uv = uv;
    return out;
}

float2 warpUV(float2 uv, float3 motion, float time) {
    float scale = 0.02 + sin(time * 2.0) * 0.01;
    uv.x += sin(uv.y * 20.0 + time * 5.0 + motion.z * 4.0) * scale;
    uv.y += cos(uv.x * 20.0 + time * 5.0 + motion.y * 4.0) * scale;
    return uv;
}

fragment float4 fragment_main(VertexOut in [[stage_in]],
                              constant float &time [[ buffer(0) ]],
                              constant float3 &motion [[ buffer(1) ]]) {
    float2 uv = warpUV(in.uv, motion, time);

    float r = 0.5 + 0.5 * sin((uv.x + motion.x) * 10.0 + time);
    float g = 0.5 + 0.5 * sin((uv.y + motion.y) * 10.0 + time + 2.0);
    float b = 0.5 + 0.5 * sin((uv.x + uv.y + motion.z) * 10.0 + time + 4.0);

    return float4(r, g, b, 1.0);
}
