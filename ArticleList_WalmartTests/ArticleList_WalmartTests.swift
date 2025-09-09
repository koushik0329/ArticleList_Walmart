//
//  ArticleList_WalmartTests.swift
//  ArticleList_WalmartTests
//
//  Created by Koushik Reddy Kambham on 9/8/25.
//

import XCTest
@testable import ArticleList_Walmart

final class ArticleList_WalmartTests: XCTestCase {
    
    var objArticle: ArticleViewModel!
    var objNetwork: NetworkManager!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        objArticle = ArticleViewModel()
        objNetwork = NetworkManager()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        objArticle = nil
        objNetwork = nil
    }
    
    func testArticleCount() {
        XCTAssertEqual(objArticle.getArticleCount(), 0)
        
        let sampleArticle = Article(
                    author: "Test Author",
                    description: "Test Description",
                    urlToImage: "",
                    publishedAt: "2020-02-05T15:47:40Z",
                )
        objArticle.articles.append(sampleArticle)
        XCTAssertEqual(objArticle.getArticleCount(), 1)
    }
    
    func testFirstArticleProperties() {
        
        let sampleArticle = Article(
                    author: "Test Author",
                    description: "Test Description",
                    urlToImage: "",
                    publishedAt: "2020-02-05T15:47:40Z",
                )
        objArticle.articles.append(sampleArticle)
        
        XCTAssertEqual(objArticle.getArticle(at: 0)?.author, "Test Author")
        XCTAssertEqual(objArticle.getArticle(at: 0)?.description, "Test Description")
    }
}
