//
//  Interceptor.swift
//  Pods
//
//  Created by Simon Garnier on 2016-06-21.
//
//

import Foundation

public protocol TIEMatcher {
    func match(url: TIEParsedURL) -> Bool
}

public struct Matcher {

    public class Leaf{
        let pattern:String
        public init(pattern:String){
            self.pattern = pattern
        }
    }

    public class Node{
        let childlren:[TIEMatcher]
        public init(childlren: [TIEMatcher]){
            self.childlren = childlren
        }
    }

    public class Scheme : Leaf, TIEMatcher{
        public func match(url: TIEParsedURL) -> Bool {
            return url.scheme == pattern
        }
    }

    public class Host : Leaf, TIEMatcher{
        public func match(url: TIEParsedURL) -> Bool {
            return url.host == pattern
        }
    }

    public class Param: TIEMatcher{
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

    public class Or: Node, TIEMatcher{
        public func match(url: TIEParsedURL) -> Bool {
            return childlren.reduce(false) { (memo, tie) -> Bool in
                memo || tie.match(url)
            }
        }
    }

    public class And: Node, TIEMatcher{
        public func match(url: TIEParsedURL) -> Bool {
            return childlren.reduce(true) { (memo, tie) -> Bool in
                memo && tie.match(url)
            }
        }
    }
}
