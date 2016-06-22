//
//  Interceptor.swift
//  Pods
//
//  Created by Simon Garnier on 2016-06-21.
//
//

import Foundation

public protocol TIEMatchable {
    func match(url: TIEParsedURL) -> Bool
}

public struct TIEMatcher {
    
    public class Leaf{
        let pattern:String
        public init(pattern:String){
            self.pattern = pattern
        }
    }

    public class Node{
        let childlren:[TIEMatchable]
        public init(childlren: [TIEMatchable]){
            self.childlren = childlren
        }
    }

    public class Scheme : Leaf, TIEMatchable{
        public func match(url: TIEParsedURL) -> Bool {
            return url.scheme == pattern
        }
    }

    public class Host : Leaf, TIEMatchable{
        public func match(url: TIEParsedURL) -> Bool {
            return url.host == pattern
        }
    }

    public class Param: TIEMatchable{
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

    public class Or: Node, TIEMatchable{
        public func match(url: TIEParsedURL) -> Bool {
            return childlren.reduce(false) { (memo, tie) -> Bool in
                memo || tie.match(url)
            }
        }
    }

    public class And: Node, TIEMatchable{
        public func match(url: TIEParsedURL) -> Bool {
            return childlren.reduce(true) { (memo, tie) -> Bool in
                memo && tie.match(url)
            }
        }
    }
}
