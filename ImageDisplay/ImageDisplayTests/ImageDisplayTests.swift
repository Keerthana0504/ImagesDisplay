//
//  ImageDisplayTests.swift
//  ImageDisplayTests
//
//  Created by Keerthana Reddy Ragi on 29/07/19.
//  Copyright © 2019 Keerthana Reddy Ragi. All rights reserved.
//

import XCTest
@testable import ImageDisplay

class ImageDisplayTests: XCTestCase {
    var viewController: ViewController!
    var store: ImagesDisplayMocks.MockStore!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        store = ImagesDisplayMocks.MockStore()
        viewController = ViewController.init()
        viewController.images = store.imagesDisplay.photo
        _ = viewController.view
        viewController.loadViewIfNeeded()
        XCTAssert(viewController != nil, "Images View Controller should not be nil")
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testModels() {
        let mockedResponseModel = store.mockedResponseModel
        viewController.viewDidLoad()
        viewController.viewDidAppear(true)
        wait(for: 4)
        /// Putting XCTAssert
        XCTAssert(viewController.images.count == mockedResponseModel.images.photo.count, "Model count should be same")
        XCTAssert(viewController.images.first?.identifier == mockedResponseModel.images.photo.first!.identifier, "Data should be same")
    }
    
    func wait(for duration: TimeInterval) {
        let waitExpectation = expectation(description: "Waiting")
        let when = DispatchTime.now() + duration
        DispatchQueue.main.asyncAfter(deadline: when) {
            waitExpectation.fulfill()
        }
        // We use a buffer here to avoid flakiness with Timer on CI
        waitForExpectations(timeout: duration + 0.5)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
