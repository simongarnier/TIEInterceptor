//
//  InterceptorWebView.swift
//  Pods
//
//  Created by Simon Garnier on 2016-06-21.
//
//

import Foundation

public class TIEWebView: UIWebView, UIWebViewDelegate {
    var interceptors:[(TIEMatcher, (TIEParsedURL) -> ())] = []
    public var externalDelegate: UIWebViewDelegate? = nil
    
    public func addInterceptor(matcher: TIEMatcher, callback: (TIEParsedURL) -> ()){
        interceptors.append((matcher, callback))
        super.delegate = self
    }
    
    public func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        externalDelegate?.webView?(webView, didFailLoadWithError: error)
    }
    
    public func webViewDidFinishLoad(webView: UIWebView) {
        externalDelegate?.webViewDidFinishLoad?(webView)
    }
    
    public func webViewDidStartLoad(webView: UIWebView) {
        externalDelegate?.webViewDidStartLoad!(webView)
    }
    
    public func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if let url = request.URL{
            let parsedURL = TIEParsedURL.init(url: url)
            for interceptor in interceptors {
                let (matcher, callback) = interceptor
                if matcher.match(parsedURL){
                    // only invoke the callback of the first matched interceptor
                    callback(parsedURL)
                    return false
                }
            }
        }
        return true
    }

}