//  Created by Eric on 10/25/18.
//  Copyright © 2018 App Parents LLC. All rights reserved.
//

import UIKit
import Kingfisher
//displays the character info, description, comics they were in and has a web crawler to pick the correct wikipedia page that describes them
class CharacterViewController: UIViewController{
    let apiClient = MarvelAPIClient(publicKey: "68ecd20c670e6422b5fbb8584f23fdbd8",
                                    privateKey: "b5ff2cea38f44ff5d6284b5965dcb307bd2b882f")
    var scrollViewVert: UIScrollView!

    var wikiView = UITextView()
    var wikiTitle = UILabel()
    let backButton = UIButton()
    //back to menu
    @objc func back() {
        //clear everything
            supremeCharacterArray = []
            supremeImageArray = []
            supremeDescriptionArray = []
            letter = ""
            masterCharacter = ""
            finalImage = nil
            superDescription = ""
        //returns to menu
            let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "Menu")
            let customViewControllersArray : NSArray = [newViewController!]
            self.navigationController?.viewControllers = customViewControllersArray as! [UIViewController]
            self.navigationController?.popToRootViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //removes children view controllers
        if self.children.count > 0{
            let viewControllers:[UIViewController] = self.children
            for viewContoller in viewControllers{
                viewContoller.willMove(toParent: nil)
                viewContoller.view.removeFromSuperview()
                viewContoller.removeFromParent()
            }
        }
        //launches wikipedia search
        searchAll()
        //set up UI
        
        let backgroundImage = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        backgroundImage.image = UIImage(named: "Space-Background-Photo.jpg")
        view.addSubview(backgroundImage)
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let screenHeight = screensize.height
        var scrollView: UIScrollView!
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        scrollView.contentSize = CGSize(width: screenWidth, height: 1700)
        view.addSubview(scrollView)
        let title = UILabel(frame: CGRect(x: 0, y: 20, width: view.frame.width, height: 30))
        title.center.x =  view.center.x
        title.textAlignment = .center
        title.textColor = .white
        title.backgroundColor = .black
        title.font = UIFont(name: "BentonSans", size: 30)
        title.text = masterCharacter
        switch UIScreen.main.nativeBounds.height {
        case 1136:
            print("iPhone 5 or 5S or 5C")
            title.font =  UIFont(name: "BentonSans", size: 14)
          title.adjustsFontSizeToFitWidth = true
            title.center.x = view.center.x
            //     cell.label.font =  UIFont(name: "BentonSans", size: cell.label.font.pointSize - 3)
            
        default:
            print("unknown")
        }
        scrollView.addSubview(title)
        scrollView.indicatorStyle = .white
        let imageView = UIImageView(frame: CGRect(x: 0, y: 50, width: 300, height: 300))
        imageView.center.x = view.center.x
      //  imageView.isHidden = true
        imageView.image = finalImage
        scrollView.addSubview(imageView)
        let textView = UITextView(frame: CGRect(x: 0, y: 348, width: 300, height: 300))
        textView.center.x = view.center.x
        scrollView.addSubview(textView)
        textView.textColor = UIColor.white
        textView.backgroundColor = UIColor.clear
        textView.font = UIFont(name: "BentonSans", size: 18)
        textView.textAlignment = .natural
        textView.isEditable = false
        textView.layer.shadowColor = UIColor.black.cgColor
        textView.layer.shadowRadius = 5.0
        textView.layer.shadowOpacity = 1.0
        textView.layer.shadowOffset = CGSize(width: 6, height: 6)
        textView.layer.masksToBounds = false
        textView.text = superDescription
    
        if textView.text == "" {
            textView.text = "   " + "\("Character Description Unavailable")"

        }
        adjustContentSize(tv: textView)
        wikiView = UITextView(frame: CGRect(x: 0, y: 1100, width: 300, height: 500))
        wikiView.center.x = view.center.x
        scrollView.addSubview(wikiView)
        wikiView.textColor = UIColor.black
        wikiView.backgroundColor = UIColor.white
        wikiView.font = UIFont(name: "BentonSans", size: 18)
        wikiView.textAlignment = .natural
        wikiView.isEditable = false
        wikiView.isHidden = true
        wikiTitle = UILabel(frame: CGRect(x: 0, y: 1050, width: view.frame.width, height: 30))
        wikiTitle.center.x =  view.center.x
        wikiTitle.textAlignment = .center
        wikiTitle.textColor = .white
        wikiTitle.backgroundColor = .clear
        wikiTitle.font = UIFont(name: "BentonSans", size: 30)
        wikiTitle.text = "Wikipedia Description"
        wikiTitle.sizeToFit()
        wikiTitle.isHidden = true
        wikiTitle.center.x = view.center.x
        wikiTitle.layer.shadowColor = UIColor.black.cgColor
        wikiTitle.layer.shadowRadius = 5.0
        wikiTitle.layer.shadowOpacity = 1.0
        wikiTitle.layer.shadowOffset = CGSize(width: 6, height: 6)
        wikiTitle.layer.masksToBounds = false
        scrollView.addSubview(wikiTitle)
        var character = GetCharacters()
        character.name = masterCharacter
        title.text = character.name
        title.sizeToFit()
        title.center.x = view.center.x
        scrollViewVert = UIScrollView(frame: CGRect(x: 0, y: 650, width: screenWidth, height: 500))
        scrollViewVert.contentSize = CGSize(width: 25000, height: 250 )
        scrollViewVert.backgroundColor = UIColor.clear
        scrollView.addSubview(scrollViewVert)
        /* title.layer.shadowColor = UIColor.black.cgColor
         title.layer.shadowRadius = 3.0
         title.layer.shadowOpacity = 1.0
         title.layer.shadowOffset = CGSize(width: 4, height: 4)
         title.layer.masksToBounds = false */
        var checkdistance = 0
        var description = ""
        backButton.frame =  CGRect(x: view.frame.minX, y: view.frame.minY + 20 , width: 30, height: 30)
        backButton.alpha = 0.9
        // translatebutton.backgroundColor = .green
      //  backButton.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        backButton.setTitle("X", for: .normal)
            backButton.titleLabel?.font = UIFont(name: "BentonSans", size: 25)
        backButton.setTitleColor(.white, for: .normal)
        view.addSubview(backButton)
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        apiClient.send(character) { response in
            print("\nGetCharacters finished:")
            
            switch response {
            case .success(let dataContainer):
                for character in dataContainer.results {
                    print(self.apiClient.json)
                    var nsString = NSString()
                    let task = URLSession.shared.dataTask(with: self.apiClient.json) {(data, response, error) in
                        
                        nsString =  NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
                        
                    }
                    //gets characters comics and downloads their images
                    task.resume()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        //split string into spaces
                        let fullArray =  nsString.description.components(separatedBy: "\"")
                        for i in fullArray {
                            
                            if i.contains("http://gateway.marvel.com/v1/public/comics/") || i.contains("http://gateway.marvel.com/v1/public/series/") || i.contains("http://gateway.marvel.com/v1/public/stories/")   {
                                print(i)
                                let stringArray =  i.description.components(separatedBy: CharacterSet.decimalDigits.inverted)
                                for item in stringArray {
                                    if let numberthing = Int(item) {
                                        // print("number: \(numberthing)")
                                        if numberthing != 1 {
                                            //   print("number: \(numberthing)")
                                            self.apiClient.send(GetComic(comicId: numberthing)) { response in
                                                print("\nGetComic finished:")
                                                
                                                switch response {
                                                case .success(let dataContainer):
                                                    let comic = dataContainer.results.first
                                                    
                                                    print("  Title: \(comic?.title ?? "Unnamed comic")")
                                                    print("  Thumbnail: \(comic?.thumbnail?.url.absoluteString ?? "None")")
                                                    ImageDownloader.default.downloadImage(with: (comic?.thumbnail?.url)!, options: [], progressBlock: nil) {
                                                        (image, error, url, data) in
                                                        print("Downloaded Image: \(image)")
                                                        //    imageView.image = image
                                                        let comicImage = UIImageView(frame: CGRect(x: 0 + checkdistance, y: 0, width: 300, height: 300))
                                                        let comicLabel = UILabel(frame: CGRect(x: 0 + checkdistance, y: 310, width: 280, height: 20))
                                                        checkdistance += 300
                                                        //    comicLabel.sizeToFit()
                                                        comicImage.image = image
                                                        self.scrollViewVert.addSubview(comicImage)
                                                        
                                                        comicLabel.text = comic?.title
                                                        comicLabel.textColor = UIColor.white
                                                        self.scrollViewVert.addSubview(comicLabel)
                                                        comicLabel.font = UIFont(name: "BentonSans", size: 16)
                                                        comicLabel.textAlignment = .center
                                                        //   comicLabel.sizeToFit()
                                                        comicLabel.layer.shadowColor = UIColor.black.cgColor
                                                        comicLabel.layer.shadowRadius = 3.0
                                                        comicLabel.layer.shadowOpacity = 1.0
                                                        comicLabel.layer.shadowOffset = CGSize(width: 4, height: 4)
                                                        comicLabel.layer.masksToBounds = false
                                                        comicLabel.adjustsFontSizeToFitWidth = true
                                                        //  self.realImages.append(image!)
                                                    }
                                                case .failure(let error):
                                                    print(error)
                                                }
                                                self.comicadded += 1

                                            }
                                           
                                        }
                                      
                                    }
                                }
                            }
                        }
                    })
                    print("  Title: \(character.name ?? "Unnamed character")")
                    print("  Thumbnail: \(character.thumbnail?.url.absoluteString ?? "None")")
                    print("  description: \(character.description)")
                    
                    DispatchQueue.main.async {
                        
                        if character.description == "" {
                            textView.text = "Character Description Unavailable"
                            textView.textAlignment = .center
                            textView.sizeToFit()
                            textView.frame = CGRect(x: 0, y: 348, width: 300, height: textView.frame.height)
                            textView.center.x = self.view.center.x
                            
                        }
                        else {
                            textView.text = "   " + "\(character.description ?? "Character Description Unavailable")"
                            textView.sizeToFit()
                            
                            
                        }
                    }
                    
                    ImageDownloader.default.downloadImage(with: (character.thumbnail?.url)!, options: [], progressBlock: nil) {
                        (image, error, url, data) in
                        print("Downloaded Image: \(image)")
                        imageView.image = image
                        imageView.isHidden = false
                        self.adjustContentSize(tv: textView)

                    }
                }
                
                
                
                
            case .failure(let error):
                print(error)
            }
        }
        // Visual Format Constraints
        
        // Using iOS 9 Constraints in order to place the label past the iPhone 7 view
        
    }
    
    // change
    var comicadded = 0 {
        didSet {
            DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
                var contentRect = CGRect.zero

                for view in self.scrollViewVert.subviews {
                    contentRect = contentRect.union(view.frame)
                }
                self.scrollViewVert.contentSize = contentRect.size
            }
          
        }
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func adjustContentSize(tv: UITextView){
        while tv.contentSize.height > tv.frame.size.height {
            tv.font = tv.font?.withSize((tv.font?.pointSize)! - 1)
            tv.layoutIfNeeded()
        }
        let deadSpace = tv.bounds.size.height - tv.contentSize.height
        let inset = max(0, deadSpace/2.0)
        tv.contentInset = UIEdgeInsets(top: inset, left: tv.contentInset.left, bottom: inset, right: tv.contentInset.right)
        
    }
    
    
    
    
    
    //wikipedia algorythmn everything down
    var dave: NSString = NSString(string: "")
    
    var characterSearch = "\(masterCharacter)".replacingOccurrences(of: " ", with: "_").replacingOccurrences(of: "(Ultimate)", with: "")
    var characterSearchWithout = "\(masterCharacter)".replacingOccurrences(of: " ", with: "_").replacingOccurrences(of: "(Ultimate)", with: "")
    var numberOfMarvels = 0
    var wikiArray: [String] = [""] {
        didSet {
            
            for i in wikiArray {
                //compare number of times Marvel is Said
                let tok =  i.components(separatedBy:"Marvel")
                if  tok.count-1 >= numberOfMarvels {
                    print("win")
                    numberOfMarvels = tok.count-1
                    
                    wikiView.text = "   " + "\(i.replacingOccurrences(of: "<", with: ""))"
                    
                    wikiTitle.isHidden = false
                    wikiView.isHidden = false
                    if masterCharacter.contains("A-Bomb") == true {
                        wikiTitle.isHidden = true
                        wikiView.isHidden = true
                    }
                    if masterCharacter.contains("3-D") == true {
                        wikiTitle.isHidden = true
                        wikiView.isHidden = true
                    }
                }
            }
        }
    }
    func searchAll() {
        //the wikipedia search
        apiSearch()
        firstSearch()
        reSearch()
        reSearch2()
        reSearch3()
    }
    //normal wiki search
    func firstSearch() {
        if let index = characterSearch.range(of: "(")?.lowerBound {
            let substring = characterSearch[..<index]
            let string = String(substring)
            print(string)  // "ora"
            
            
        }
        var url = URL(string: "https://en.wikipedia.org/wiki/" + characterSearch)
        if masterCharacter == "Wolverine" {
            url = URL(string: "https://en.wikipedia.org/wiki/" + "Wolverine_(character)")
        }
        if masterCharacter == "Alpha Flight" {
            url = URL(string: "https://en.wikipedia.org/wiki/" + "Alpha_Flight")
            print("cat")
        }
        //The wikipedia descripitions the algorythmn would never get
        if masterCharacter == "Captain Universe" {
            self.wikiArray.append("Captain Universe is a fictional character, a superhero appearing in American comic books published by Marvel Comics. It is the guardian and protector of Eternity. Rather than a character with a single identity, Captain Universe is a persona that has merged with several hosts during its publication history."
            )
            wikiView.text = "Captain Universe is a fictional character, a superhero appearing in American comic books published by Marvel Comics. It is the guardian and protector of Eternity. Rather than a character with a single identity, Captain Universe is a persona that has merged with several hosts during its publication history."
        }
        if masterCharacter == "Agent Brand" {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.wikiView.text = "Abigail Brand is the commanding officer of S.W.O.R.D., a S.H.I.E.L.D. offshoot that deals with defending the Earth from extraterrestrial threats. Almost no details about her personal life have been revealed, but she is known to be 28 years old as of the Skrull's \"Secret Invasion\".[1]"
            }
            
        }
        
        
        if masterCharacter == "A.I.M." {
            self.wikiArray.append("A.I.M. (Advanced Idea Mechanics) is a fictional organization of villains and supervillains appearing in American comic books published by Marvel Comics, first appearing in Strange Tales #146. The organization was created by Stan Lee and Jack Kirby. They are characterized as a network of terrorist arms dealers and scientists specializing in highly advanced and technological weaponry whose ultimate goal is the overthrow of all world governments for their own gain."
            )}
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            self.dave =  NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
            
        }
        task.resume()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            if self.dave.contains("Marvel"){
                
                let contentArray = self.dave.description.components(separatedBy: "</tbody></table>")
                //      print(self.dave)
                
                if contentArray.count > 1 {
                    //   stringSeparator = "\",\""
                    
                    let newContentArray = contentArray[1].components(separatedBy: "<div")
                    if newContentArray.count > 1 {
                        
                        let message = newContentArray[0].replacingOccurrences(of: "\",", with: "°")
                        // print(message.withoutHtml)
                        
                        self.wikiArray.append(message.withoutHtml)
                        
                        print("good")
                    }
                    
                    
                    
                    
                }
                
                
                
                
            }
            
            
            
        })
    }
    //adds marvel comics in search

    func reSearch() {
        print("egg Mcmiuiff")
        let url = URL(string: "https://en.wikipedia.org/wiki/" + self.characterSearchWithout + "_(Marvel_Comics)")
        
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            self.dave =  NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
            
        }
        task.resume()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            
            let contentArray = self.dave.description.components(separatedBy: "</tbody></table>")
            
            if contentArray.count > 1 {
                
                //   stringSeparator = "\",\""
                let newContentArray = contentArray[1].components(separatedBy: "div")
                
                if newContentArray.count > 1 {
                    
                    let message = newContentArray[0].replacingOccurrences(of: "\",", with: "°")
                    
                    
                    
                    //   print(message.withoutHtml)
                    self.wikiArray.append(message.withoutHtml)
                    //   self.answer(string: message)
                    
                }
                
                
                
                
                
            }
            
            
            
            } as! @convention(block) () -> Void)
        
    }
    //searches inside parenthesis

    func reSearch2() {
        
        if characterSearch.contains("(") && characterSearch.contains(")") {
            let url = URL(string: "https://en.wikipedia.org/wiki/" + self.characterSearch.slice(from: "(", to: ")")!)
            print(url)
            let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
                self.dave =  NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
                
            }
            task.resume()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                
                let contentArray = self.dave.description.components(separatedBy: "</tbody></table>")
                print("PUPPY")
                
                if contentArray.count > 1 {
                    
                    //   stringSeparator = "\",\""
                    
                    let newContentArray = contentArray[1].components(separatedBy: "div")
                    
                    if newContentArray.count > 1 {
                        let message = newContentArray[0].replacingOccurrences(of: "\",", with: "°")
                        let bob = (message as String).replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")
                        print(message.withoutHtml)
                        self.wikiArray.append(message.withoutHtml)
                        
                        //   self.answer(string: message)
                        
                    }
                    
                    
                    
                }
                    
                else {
                    
                    // print("fuck")
                }
            })
        }
        else {
            self.reSearch3()
            
            // print("fuck")
        }
    }
    //searches for the term + comic

    func reSearch3() {
        let url = URL(string: "https://en.wikipedia.org/wiki/" + self.characterSearchWithout + "_(comics)")
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            self.dave =  NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
            
        }
        task.resume()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            
            let contentArray = self.dave.description.components(separatedBy: "</tbody></table>")
            
            if contentArray.count > 1 {
                
                //   stringSeparator = "\",\""
                
                let newContentArray = contentArray[1].components(separatedBy: "</p><p>")
                
                if newContentArray.count > 1 {
                    let message = newContentArray[0].replacingOccurrences(of: "\",", with: "°")
                    self.wikiArray.append(message.withoutHtml)
                    
                    //      print(message.withoutHtml)
                    
                    //   self.answer(string: message)
                    
                }
                
                
                
            }
            
            
        })
        
    }
    //searches using the wikipedia api... probably the most effective one

    func apiSearch() {
        let language = WikipediaLanguage("en")
        WikipediaNetworking.appAuthorEmailForAPI = "appparentsinfo@gmail.com"
        
        
        var times = 0
        let _ = Wikipedia.shared.requestOptimizedSearchResults(language: language, term: "\(masterCharacter) Marvel Comics") { (searchResults, error) in
            
            guard error == nil else { return }
            guard let searchResults = searchResults else { return }
            
            for articlePreview in searchResults.items {
                //   print(articlePreview.displayTitle)
                if times < 1 {
                    let imageWidth = Int(self.view.frame.size.width * UIScreen.main.scale)
                    let _ = Wikipedia.shared.requestArticle(language: language, title: articlePreview.displayTitle, imageWidth: imageWidth) { (article, error) in
                        guard error == nil else { return }
                        guard let article = article else { return }
                        
                        print(article.displayTitle)
                        //    print(article.displayText)
                        print(article.url)
                        
                        let task = URLSession.shared.dataTask(with: article.url!) {(data, response, error) in
                            self.dave =  NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
                            
                        }
                        task.resume()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                            
                            let contentArray = self.dave.description.components(separatedBy: "Abilities")
                            if contentArray.count > 1 {
                                //   stringSeparator = "\",\""
                                let newContentArray = contentArray[1].components(separatedBy: "</p><p>")
                                
                                if newContentArray.count > 1 {
                                    
                                    let message = newContentArray[0].replacingOccurrences(of: "\",", with: "°")
                                    
                                    
                                    print(message.withoutHtml)
                                    self.wikiArray.append(message.withoutHtml)
                                    //   print(message.withoutHtml)
                                    //  self.wikiArray.append(message.withoutHtml)
                                    //   self.answer(string: message)
                                    
                                }
                                
                                
                                
                                
                                
                            }
                            
                            
                            
                            } as! @convention(block) () -> Void)
                        
                    }
                }
                times += 1
            }
        }
        let imageWidth = Int(self.view.frame.size.width * UIScreen.main.scale)
        let _ = Wikipedia.shared.requestArticle(language: language, title: "", imageWidth: imageWidth) { (article, error) in
            guard error == nil else { return }
            guard let article = article else { return }
            
            print(article.displayTitle)
            //    print(article.displayText)
            print(article.url)
            
            let task = URLSession.shared.dataTask(with: article.url!) {(data, response, error) in
                self.dave =  NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
                
            }
            task.resume()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                
                let contentArray = self.dave.description.components(separatedBy: "Abilities")
                
                if contentArray.count > 1 {
                    
                    //   stringSeparator = "\",\""
                    let newContentArray = contentArray[1].components(separatedBy: "</p><p>")
                    
                    if newContentArray.count > 1 {
                        
                        let message = newContentArray[0].replacingOccurrences(of: "\",", with: "°")
                        
                        
                        print(message.withoutHtml)
                   
                        
                    }
                    
                    
                    
                    
                    
                }
                else {
                    if contentArray.count > 0 {
                        //   stringSeparator = "\",\""
                        if let newContentArray = contentArray[1].components(separatedBy: "</p><p>") as Optional{
                            if newContentArray.count > 0 {
                                
                                let message = newContentArray[0].replacingOccurrences(of: "\",", with: "°")
                                
                                
                                print(message.withoutHtml)
                                
                            }
                        }
                        
                        
                        
                        
                        
                        
                        
                    }
                }
                
                
                
                } as! @convention(block) () -> Void)
            
        }
    }

    
}
