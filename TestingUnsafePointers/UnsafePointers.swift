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
    var hE:UnsafePointer<hE>
}

struct FCE {
    var vertices:[UnsafePointer<VTX>?]
    
    init(_ vertices:UnsafePointer<VTX>..., halfEdges:UnsafePointer<hE>?...){
        self.vertices = vertices
        self.halfEdges = halfEdges
    }
    
    init(_ vertices:[UnsafePointer<VTX>], halfEdges:[UnsafePointer<hE>]){
        self.vertices = vertices
        self.halfEdges = halfEdges
    }
    
    var halfEdges:[UnsafePointer<hE>?]
}

struct hE{
    var opposite:UnsafePointer<hE>?
    var next:UnsafePointer<hE>?
    var vertex:UnsafePointer<VTX>?
    var face:UnsafePointer<FCE>?
}

