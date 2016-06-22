//
//  Interceptor.swift
//  Pods
//
//  Created by Simon Garnier on 2016-06-21.
//
//

import Foundation

@objc public protocol TIEMatcher {
    func match(url: TIEParsedURL) -> Bool
}

@objc public class TIELeaf: NSObject{
    let pattern:String
    public init(pattern:String){
        self.pattern = pattern
    }
}

@objc public class TIENode: NSObject{
    let childlren:[TIEMatcher]
    public init(childlren: [TIEMatcher]){
        self.childlren = childlren
    }
}

@objc public class TIEScheme: TIELeaf, TIEMatcher {
    public func match(url: TIEParsedURL) -> Bool {
        return url.scheme == pattern
    }
}

@objc public class TIEHost : TIELeaf, TIEMatcher{
    public func match(url: TIEParsedURL) -> Bool {
        return url.host == pattern
    }
}

@objc public class TIEParam: NSObject, TIEMatcher{
    let key:String
    let value:String?

    public init(key:String){
        self.key = key
        self.value = nil
    }

    public init(key:String, value:String){
        self.value = value
        self.key = key
    }

    public func match(url: TIEParsedURL) -> Bool {
        if let params = url.params, v = params[key] {
            if value == nil {
                return true
            }else{
                return v == value
            }
        }else{
            return false
        }
    }
}

@objc public class TIEOr: TIENode, TIEMatcher{
    public func match(url: TIEParsedURL) -> Bool {
        return childlren.reduce(false) { (memo, tie) -> Bool in
            memo || tie.match(url)
        }
    }
}

@objc public class TIEAnd: TIENode, TIEMatcher{
    public func match(url: TIEParsedURL) -> Bool {
        return childlren.reduce(true) { (memo, tie) -> Bool in
            memo && tie.match(url)
        }
    }
}
