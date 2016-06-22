//
//  InterceptorWebView.swift
//  Pods
//
//  Created by Simon Garnier on 2016-06-21.
//
//

import Foundation

@objc public class TIEWebView: UIWebView, UIWebViewDelegate {
    
    var interceptors:[(TIEMatchable, (TIEParsedURL) -> ())] = []
    
    private var externalDelegate:UIWebViewDelegate?
    
    @objc override public var delegate:UIWebViewDelegate?{
        get{
            return externalDelegate
        }
        set(d){
            self.externalDelegate = d
        }
    }
    
    public func addInterceptors(interceptors: (TIEMatchable, (TIEParsedURL) -> ())...){
        self.interceptors.appendContentsOf(interceptors)
        super.delegate = self
    }
    
    @objc public func addInterceptor(matcher: TIEMatchable, callback:(TIEParsedURL) -> ()){
        self.interceptors.append((matcher, callback))
        super.delegate = self
    }
    
    public func webViewDidStartLoad(webView: UIWebView) {
        externalDelegate?.webViewDidStartLoad?(webView)
    }
    
    public func webViewDidFinishLoad(webView: UIWebView) {
        externalDelegate?.webViewDidFinishLoad?(webView)
    }
    
    public func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        externalDelegate?.webView?(webView, didFailLoadWithError: error)
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
        if let deleteResult = externalDelegate?.webView?(webView, shouldStartLoadWithRequest: request, navigationType: navigationType) {
            return deleteResult
        }else{
            return true
        }
    }
}