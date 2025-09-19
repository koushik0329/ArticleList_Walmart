//
//  Sample.swift
//  ArticleList_Walmart
//
//  Created by Koushik Reddy Kambham on 9/18/25.
//
//AnyObject
protocol SampleProtocol {
    func hello() -> String
}

class Sample : SampleProtocol{
    func hello() -> String {
        return "Hello, World!"
    }
}

struct Sample1 : SampleProtocol{
    func hello() -> String {
        return "Hello, World!"
    }
}
