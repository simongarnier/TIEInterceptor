//
//  InterceptorWebView.swift
//  Pods
//
//  Created by Simon Garnier on 2016-06-21.
//
//

import Foundation

public class TIEWebView: UIWebView {
    
    var interceptors:[(TIEMatchable, (TIEParsedURL) -> ())] = []
    
    public func addInterceptors(interceptors: (TIEMatchable, (TIEParsedURL) -> ())...){
        self.interceptors.appendContentsOf(interceptors)
    }
    
    override public func loadRequest(request: NSURLRequest) {
        if let url = request.URL{
            let parsedURL = TIEParsedURL.init(url: url)
            for interceptor in interceptors {
                let (matcher, callback) = interceptor
                if matcher.match(parsedURL){
                    // only invoke the callback of the first matched interceptor
                    callback(parsedURL)
                    return
                }
            }
        }
        super.loadRequest(request)
    }
}