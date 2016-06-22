//
//  Interceptor.swift
//  Pods
//
//  Created by Simon Garnier on 2016-06-21.
//
//

import Foundation

@objc public protocol TIEMatchable {
    func match(url: TIEParsedURL) -> Bool
}

@objc public class TIEMatcher: NSObject {
    
    @objc public class Leaf: NSObject{
        let pattern:String
        public init(pattern:String){
            self.pattern = pattern
        }
    }

    @objc public class Node: NSObject{
        let childlren:[TIEMatchable]
        public init(childlren: [TIEMatchable]){
            self.childlren = childlren
        }
    }

    @objc public class Scheme: Leaf, TIEMatchable {
        public func match(url: TIEParsedURL) -> Bool {
            return url.scheme == pattern
        }
    }

    @objc public class Host : Leaf, TIEMatchable{
        public func match(url: TIEParsedURL) -> Bool {
            return url.host == pattern
        }
    }

    @objc public class Param: NSObject, TIEMatchable{
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

    @objc public class Or: Node, TIEMatchable{
        public func match(url: TIEParsedURL) -> Bool {
            return childlren.reduce(false) { (memo, tie) -> Bool in
                memo || tie.match(url)
            }
        }
    }

    @objc public class And: Node, TIEMatchable{
        public func match(url: TIEParsedURL) -> Bool {
            return childlren.reduce(true) { (memo, tie) -> Bool in
                memo && tie.match(url)
            }
        }
    }
}
