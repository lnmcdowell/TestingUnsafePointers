//
//  main.swift
//  TestingUnsafePointers
//
//  Created by Larry Mcdowell on 10/29/22.
//

import Foundation

print("Hello, World!")

func unsafe<T>(_ thing: UnsafePointer<T>) -> UnsafePointer<T> {
    return UnsafePointer<T>(thing)
}


extension UnsafePointer where Pointee == VTX {
  
    func report() -> String{
    return "unsafe pointer to x:\(self.pointee.loc.x), y:\(self.pointee.loc.y), z: \(self.pointee.loc.z) has id: \(self.pointee.id) and memory address: \(self)"
    }
}

/*
extension VTX {
    func up() -> UnsafePointer<VTX>{
        return UnsafePointer<VTX>(&self)
    }
}
*/
var h2 = hE() //all halfedge properties are optionals
var h3 = hE()

var v1 = VTX(loc: SIMD3<Float>(x: 2, y: 0, z: 2), id: 1,hE:&h2)
var v2 = VTX(loc: SIMD3<Float>(x: 2, y: 2, z: 2), id: 2,hE: &h3)
var v3 = VTX(loc: SIMD3<Float>(x: 0, y: 2, z: 2), id: 3,hE:&h3)
var v4 = VTX(loc: SIMD3<Float>(x: 0, y: 0, z: 2), id: 4,hE:&h3)
var v5 = VTX(loc: SIMD3<Float>(x: 0, y: 0.5, z: 0), id: 5,hE:&h3)
var v6 = VTX(loc: SIMD3<Float>(x: 0, y: 2, z: 0), id: 6,hE:&h3)
var v7 = VTX(loc: SIMD3<Float>(x: 2, y: 2, z: 0), id: 7,hE:&h3)
var v8 = VTX(loc: SIMD3<Float>(x: 0.3, y: 0.5, z: 0.11), id: 8,hE:&h3)


var pt = UnsafePointer<VTX>?(&v1)
//print("pt is \(pt)")
//pt.deallocate()
pt = nil
//print("pt is \(pt)")

var v8Pointer = UnsafePointer<VTX>(&v8)
print("v8 pointer value is: \(v8Pointer)")

var v7Pointer = UnsafePointer<VTX>(&v7)
print("v7 pointer value is: \(v7Pointer)")

print("stride of VTX is \(MemoryLayout<VTX>.stride)")
print("size is \(MemoryLayout<VTX>.size)")
print("stride of float is \(MemoryLayout<Float>.stride)")

var v5Pointer = UnsafePointer<VTX>(&v5)
v5Pointer = UnsafePointer<VTX>(&v6)
var mutableV7Pointer = UnsafeMutablePointer<VTX>(&v7)
print("v5 structures address is: \(v5Pointer)")

var vtxRawBufferPointer = UnsafeRawBufferPointer(start: UnsafeRawPointer(&v8), count: MemoryLayout<SIMD3<Float>>.stride)

var vtxMutableRawPointer = UnsafeMutableRawPointer(&v8)

/*
var f1 = FCE(vertices: [unsafe(v1),
                                 UnsafePointer<VTX>(&v2),
                                 UnsafePointer<VTX>(&v3),
                                 UnsafePointer<VTX>(&v4)])
*/
var f1 = FCE(&v1,&v2,&v3,&v4)

var h1 = hE(vertex: &v1, face: &f1)


var f2 = FCE([unsafe(&v5),unsafe(&v6),unsafe(&v7),unsafe(&v8)],halfEdges: [unsafe(&h1)])
    //var f3 = FCE([&v1,&v2]) // won't work no implicit conversion to pointer unless
    //the &'d item is a funcrion argument directly.  Meaningless to have an array of
    //&'d things.
var sideface =  FCE([unsafe(&v3),unsafe(&v4),unsafe(&v7),unsafe(&v8)], halfEdges: [unsafe(&h1)])
var frontFace = FCE(&v2,&v3,&v4)

print("found instance is \(f2.vertices[0]!.pointee)")

print("f2 contains \(f2.vertices[0]!),\(f2.vertices[1]!)")
if f2.vertices[0]! == unsafe(&v5) {
    print("face 2 array member is same address as v5 created")
} else {
    print("fails")
    print(" address \(f2.vertices[0]!)  is id: \(f2.vertices[0]!.pointee.id)")
    print(" address \(unsafe(&v5)) is id: \(unsafe(&v5).pointee.id)")
}
f1.vertices[2] = unsafe(&v1)



var here:UnsafePointer<VTX> = (f2.vertices.first(where: {$0?.pointee.loc.hashValue == v5.loc.hashValue}))!!//UnsafePointer<VTX>(&v5)})
print("unsafe pointer found is :\(here)")


var there = here.pointee.loc
print("vertex is \(there)")
print("hash is \(there.hashValue)")
print("original hash is \(here.pointee.loc.hashValue)")
print("has of v8 is \(v8.loc.hashValue)")
print("location of v8 is \(unsafe(&v8))")
//print(" it is: \((here.pointee) as! VTX)")
print("last check of extension of \(v5Pointer.report())")

print("\n\nattempt to modify pointee")
var v7P = mutableV7Pointer.pointee
print("old pointee value of: \(v7P.loc.x)")
//mutableV7Pointer.pointee.loc.x = 8  //won't compile like this if not Unsafe "Mutable" Pointer

/*
 UnsafeMutablePointer vs UnsafePointer
  - Editor/Compile error if attempting to change pointee directly.  Still possible with non-mutable
    if you assign pointee to a new temporary variable.  i.e. something.pointee = newThing; newThing.x = 5
    instead of something.pointee.x = 5 which requires Mutable pointer.  Just a safeguard against oops modify
 */
v7P.loc.x = 9
print("was changed to: \(v7P.loc.x) through assignment of pointee to a new var")

///RAW
var v8x = vtxRawBufferPointer.load(as: Float.self)
print("v8's x is \(v8x)")
var v8y = vtxRawBufferPointer.load(fromByteOffset: MemoryLayout<Float>.stride, as: Float.self)
print("v8's y is \(v8y)")

var offsetPointer = vtxMutableRawPointer + (MemoryLayout<Float>.stride * 2)
print("v8's z is \(offsetPointer.load(as: Float.self))")

let oPointer = UnsafeMutableRawPointer.allocate(byteCount: 32, alignment: 4)

//oPointer.storeBytes(of: offsetPointer.load(as: SIMD3<Float>.self), as: SIMD3<Float>.self)


oPointer.initializeMemory(as: UInt8.self, repeating: 4, count: 16)
var newV = SIMD3<Float>(x: 0.3, y: 0.4, z: 0.5)
oPointer.storeBytes(of: newV, toByteOffset: 16, as:SIMD3<Float>.self)
//let bPointer = oPointer.advanced(by: MemoryLayout<SIMD3<Float>>.stride)

print("interpreting raw initialized memory as a Raw Bytes")
for i in 0...15 {
    //print("\(oPointer.load(as: UInt8.self))")
    print(" value \(i) - \(oPointer.load(fromByteOffset: i, as: UInt8.self))")
}
/*
print("interpreting raw initialized memory as Floats")
for i in 16...31 {
    //print("\(oPointer.load(as: UInt8.self))")
    print(" value \(i) - \(oPointer.load(fromByteOffset: i, as: Float.self))")
}
 */
// runtime crash - advanced by one byte, then tried to read a Float(4 bytes) -
// load from misaligned raw pointer
print("interpreting raw initialized memory as Floats")
for i in 16...31 {
    //print("\(oPointer.load(as: UInt8.self))")
    print(" value \(i) - \(oPointer.load(fromByteOffset: ((Int((i % 16) / 4)) * 4) + 16, as: Float.self))")
//print("\((Int((i % 16) / 4)) * 4)")

}
