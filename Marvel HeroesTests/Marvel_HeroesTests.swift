//
//  Marvel_HeroesTests.swift
//  Marvel HeroesTests
//
//  Created by Bill on 10/25/18.
//  Copyright © 2018 App Parents LLC. All rights reserved.
//

import XCTest
@testable import Marvel_Heroes

class Marvel_HeroesTests: XCTestCase {
    let marvel = MarvelAPIClient(publicKey: "650e801e1408159969078d2a1361c71c",
                                                 privateKey: "20112b45612fd05f0d21d80d70bc8c971695c7f1")
    var characterSearch = GetCharacters()

    override func setUp() {
     
        // Put setup code here. This method is called before the invocation of each test method in the class.
    
 
    }
    func testVideoCut(){
        let expectationthing = expectation(description: "VideoCutter")
        let videoCutter = VideoCutter()
        let url =  Bundle.main.url(forResource: "Marvel Intro HD", withExtension: "mp4")
        
        videoCutter.cropVideoWithUrl(
            videoUrl: url!,
            startTime: 0.0,
            duration: 12.0) { (videoPath, error) -> Void in
                if let path = videoPath as NSURL? {
                    let priority = DispatchQueue.GlobalQueuePriority.default
                    DispatchQueue.global(qos: .userInitiated).async {
                        DispatchQueue.main.async {
                            XCTAssertNotNil(path, "video cut has failed")
                            expectationthing.fulfill()
                        }
                    }
                }
        }
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
//make sure the actual number of people is a 100 and the code works
    func testMarvelApi() {
        // 1. given
        marvel.send(characterSearch) { response in
            print("\nGetCharacters finished:")
            self.characterSearch.limit = 100
            switch response {
            case .success(let dataContainer):
                for character in dataContainer.results {
                    print("  Title: \(character.name ?? "Unnamed character")")
                    print("  Thumbnail: \(character.thumbnail?.url.absoluteString ?? "None")")
                    print("  Thumbnail: \(character.description ?? "None")")
                    supremeCharacterArray.append(character.name!)
                    supremeDescriptionArray.append(character.description!)
                    
                    
                    
                }
                
                
                //     XCTAssertEqual(supremeCharacterArray.count, 100, "Correct Amount Recieved")
                print(supremeCharacterArray.count)
                XCTAssertEqual(supremeDescriptionArray.count, 100, "Correct Amount Recieved")
                XCTAssertEqual(supremeCharacterArray.count, 100, "Correct Amount Recieved")
                
            case .failure(let error):
                print(error)
            }
            
        }
      
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            //measure JSON Speed
            marvel.send(characterSearch) { response in
                print("\nGetCharacters finished:")
                
                switch response {
                case .success(let dataContainer):
                    for character in dataContainer.results {
                        print("  Title: \(character.name ?? "Unnamed character")")
                        print("  Thumbnail: \(character.thumbnail?.url.absoluteString ?? "None")")
                        print("  Thumbnail: \(character.description ?? "None")")
                        supremeCharacterArray.append(character.name!)
                        supremeDescriptionArray.append(character.description!)
                        
                        
                        
                    }
                    
                    
                    //     XCTAssertEqual(supremeCharacterArray.count, 100, "Correct Amount Recieved")
                    
                    
                    
                case .failure(let error):
                    print(error)
                }
                
            }
            
            // Put the code you want to measure the time of here.
        }
    }

}
