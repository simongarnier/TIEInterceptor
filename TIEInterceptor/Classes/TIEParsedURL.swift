//
//  TIEURL.swift
//  Pods
//
//  Created by Simon Garnier on 2016-06-22.
//
//

import Foundation

@objc public class TIEParsedURL: NSObject{
    @objc public let url:NSURL
    @objc public var params:[String:String]? = nil
    @objc public let scheme:String?
    @objc public let host:String?
    
    public init(url:NSURL){
        self.url = url
        self.host = self.url.host
        self.scheme = self.url.scheme
        super.init()
        self.params = paramsAsDict(url.query)
    }
    
    private func paramsAsDict(params:String?) -> [String: String]{
        var paramDict:[String:String] = [:]
        params?.componentsSeparatedByString("&").forEach({ (param) in
            let splitted = param.componentsSeparatedByString("=")
            if let key = splitted.first, value = splitted.last{
                paramDict[key] = value
            }
        })
        return paramDict
    }
}