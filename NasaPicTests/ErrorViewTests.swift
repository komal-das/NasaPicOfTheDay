//
//  ErrorViewTests.swift
//  NasaPicTests
//
//  Created by Das,KomalNutan on 22/11/22.
//

import XCTest

class ErrorViewTests: XCTestCase {

    func test_ErrorView() {
        let view = ErrorView.init()
        let errorMainView = view.subviews[0]
        
        if let errorStackView = errorMainView.subviews[0] as? UIStackView {
            XCTAssertNotNil(errorStackView, "Error stackView is not nil")
            
            if let errorTitleLabel = errorStackView.subviews[0] as? UILabel {
                XCTAssertNotNil(errorTitleLabel, "Error title label is not nil")
                XCTAssertEqual(errorTitleLabel.text!, "Oops !!!!", "Error title text is not equal")
            } else {
                XCTFail("Error title label is nil")
            }
            
            if let errorDescriptionLabel = errorStackView.subviews[1] as? UILabel {
                XCTAssertNotNil(errorDescriptionLabel, "Error description label is not nil")
                XCTAssertEqual(errorDescriptionLabel.text!, "Something went wrong. Please try again.")
            } else {
                XCTFail("Error description label is nil")
            }
        } else {
            XCTFail("Error stackView is nil")
        }
        
        
    }
}
