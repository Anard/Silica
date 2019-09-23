//
//  Rect.swift
//  Silica
//
//  Created by Alsey Coleman Miller on 5/10/16.
//  Copyright © 2016 PureSwift. All rights reserved.
//

#if os(macOS)
    import Darwin.C.math
#elseif os(Linux)
    import Glibc
#endif

import Foundation

// MAYBE : CGRect is ever implemented on Linux Swift 5's Foundation
//#if os(Linux)
#if os(Android)

public extension CGRect {
    
    // MARK: - Accessors
    
    var x: CGFloat {
        
        get { return origin.x }
        
        set { origin.x = newValue }
    }
    
    var y: CGFloat {
        
        get { return origin.y }
        
        set { origin.y = newValue }
    }
    
    var width: CGFloat {
        
        get { return size.width }
        
        set { size.width = newValue }
    }
    
    var height: CGFloat {
        
        get { return size.height }
        
        set { size.height = newValue }
    }
    
    var minX: CGFloat {
        
        return (size.width < 0) ? origin.x + size.width : origin.x
    }
    
    var midX: CGFloat {
        
        return origin.x + (size.width / 2.0)
    }
    
    var maxX: CGFloat {
        
        return (size.width < 0) ? origin.x : origin.x + size.width
    }
    
    var minY: CGFloat {
        
        return (size.height < 0) ? origin.y + size.height : origin.y
    }
    
    var midY: CGFloat {
        
        return origin.y + (size.height / 2.0)
    }
    
    var maxY: CGFloat {

        return (size.height < 0) ? origin.y : origin.y + size.height
    }
    
    /// Returns a rectangle with a positive width and height.
    var anandardized: CGRect {
        
        var rect = self
        
        if (rect.size.width < 0) {
            rect.origin.x += rect.size.width
            rect.size.width = -rect.size.width
        }
        
        if (rect.size.height < 0) {
            rect.origin.y += rect.size.height
            rect.size.height = -rect.size.height
        }
        
        return rect;
    }
    
    /// Returns the smallest rectangle that results from converting the source rectangle values to integers.
    var integral: CGRect {
        
        var rect = self.standardized
        
        rect.size.width = ceil(rect.origin.x + rect.size.width)
        rect.size.height = ceil(rect.origin.y + rect.size.height)
        rect.origin.x = floor(rect.origin.x)
        rect.origin.y = floor(rect.origin.y)
        rect.size.width -= rect.origin.x
        rect.size.height -= rect.origin.y
        
        return rect;
    }
    
    /// Returns whether a rectangle has zero width or height, or is a null rectangle.
    var isEmpty: Bool {
        
        return size.width == 0
            || size.height == 0
            || isNull
    }
    
    /// Returns whether the rectangle is equal to the null rectangle.
    var isNull: Bool {
    
        return origin.x.isNaN
            || origin.y.isNaN
            || size.width.isNaN
            || size.height.isNaN
    }
    
    // MARK: - Methods
    
    func contains(_ point: CGPoint) -> Bool {
        
        return (point.x >= minX && point.x <= maxX)
            && (point.y >= minY && point.y <= maxY)
    }
    
    func contains(_ rect: CGRect) -> Bool {
    
        return self == union(rect)
    }
    
    func union(_ rect: CGRect) -> CGRect {
        
        var r1 = self
        var r2 = rect
        
        var union = CGRect()
        
        if r1.isEmpty {
            return r2
        }
        else if r2.isEmpty {
            return r1
        }
        
        r1 = r1.standardized
        r2 = r2.standardized
        union.origin.x = min(r1.origin.x, r2.origin.x)
        union.origin.y = min(r1.origin.y, r2.origin.y)
        
        var farthestPoint = CGPoint()
        farthestPoint.x = max(r1.origin.x + r1.size.width, r2.origin.x + r2.size.width)
        farthestPoint.y = max(r1.origin.y + r1.size.height, r2.origin.y + r2.size.height)
        union.size.width = farthestPoint.x - union.origin.x
        union.size.height = farthestPoint.y - union.origin.y
        
        return union
    }
    
    func intersects(_ r2: CGRect) -> Bool {
        return self.intersection(r2).isNull == false
    }
    
    /// Returns the intersection of two rectangles.
    func intersection(_ other: CGRect) -> CGRect {
        
        var r1 = self
        var r2 = other
        
        var rect = CGRect()
        
        guard r1.isEmpty == false else { return r2 }
        guard r2.isEmpty == false else { return r1 }
        
        r1 = r1.standardized
        r2 = r2.standardized
        
        guard (r1.origin.x + r1.size.width <= r2.origin.x ||
            r2.origin.x + r2.size.width <= r1.origin.x ||
            r1.origin.y + r1.size.height <= r2.origin.y ||
            r2.origin.y + r2.size.height <= r1.origin.y) == false
            else { return .null }
        
        rect.origin.x = (r1.origin.x > r2.origin.x ? r1.origin.x : r2.origin.x)
        rect.origin.y = (r1.origin.y > r2.origin.y ? r1.origin.y : r2.origin.y)
        
        if (r1.origin.x + r1.size.width < r2.origin.x + r2.size.width) {
            rect.size.width = r1.origin.x + r1.size.width - rect.origin.x
        } else {
            rect.size.width = r2.origin.x + r2.size.width - rect.origin.x
        }
        
        
        if (r1.origin.y + r1.size.height < r2.origin.y + r2.size.height) {
            rect.size.height = r1.origin.y + r1.size.height - rect.origin.y
        } else {
            rect.size.height = r2.origin.y + r2.size.height - rect.origin.y
        }
        
        return rect;
    }

}

#endif
