//
//  MyPulseUITests.swift
//  MyPulseUITests
//
//  Created by Farah Nedjadi on 06/06/2018.
//  Copyright © 2018 MTI. All rights reserved.
//

import XCTest

class MyPulseUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        app = XCUIApplication()
        
        // We send a command line argument to our app,
        // to enable it to reset its state
        app.launchArguments.append("--uitesting")
//        app.launchArguments.append("defaults write com.apple.iphonesimulator ConnectHardwareKeyboard 0")
        
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testNavigationLogin() {
        app.buttons["Inscrivez-vous"].tap()
        app.buttons["Connectez-vous"].tap()
    }
    
    func testEmailInputLogin() {
        let textField = app.textFields["emailUser"]
        textField.tap()
        textField.typeText("mypulse")
        XCTAssertEqual(textField.value as! String, "mypulse")
    }
    
    func testPasswordInputLogin() {
        let textField = app.secureTextFields["pwdUser"]
        textField.tap()
        textField.typeText("test")
        XCTAssertEqual(textField.value as! String, "••••")
    }
    
    func testConnectionLogin() {
        self.testEmailInputLogin()
        self.testPasswordInputLogin()
        app.buttons["CONNEXION"].tap()
    }
    
    func testSkipFormLogin() {
        self.testConnectionLogin()
        let button = app.buttons["Passer"]
        if button.exists {
            button.tap()
        }
    }
    
    func testAccessFormLogin() {
        self.testConnectionLogin()
        let button = app.buttons["Commencer"]
        if button.exists {
            button.tap()
        }
    }
    
}
