//
//  MyTestDemoTests.swift
//  MyTestDemo
//  
//  Created by Bai, Payne on 2023/4/26.
//  Copyright © 2023 Garmin All rights reserved
//  

import XCTest

final class MyTestDemoTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWaitBlock() throws {
        let semaphore = DispatchSemaphore(value: 0)
        Task {
            try await loadApi()
            semaphore.signal()
        }
        semaphore.wait()
        print("completed test")
    }

    func loadApi() async throws {
        print("start loadApi")
        throw NSError(domain: "报错", code: 400)
        print("throw error")
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
