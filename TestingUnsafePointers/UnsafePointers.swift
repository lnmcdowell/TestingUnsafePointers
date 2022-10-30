//
//  UnsafePointers.swift
//  TestingUnsafePointers
//
//  Created by Larry Mcdowell on 10/29/22.
//

import Foundation
import Metal
import simd

struct VTX {
    var loc:SIMD3<Float>
    var id:Int
}

struct FCE {
    var vertices:[UnsafePointer<VTX>?]
    
    init(_ vertices:UnsafePointer<VTX>...){
        self.vertices = vertices
    }
    
    init(_ vertices:[UnsafePointer<VTX>]){
        self.vertices = vertices
    }
}

struct HE{
    var opposite:UnsafePointer<HE>?
    var next:UnsafePointer<HE>?
    var vertex:UnsafePointer<VTX>?
    var face:UnsafePointer<FCE>?
}

