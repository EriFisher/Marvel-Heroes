//  Created by Eric on 10/25/18.
//  Copyright © 2018 App Parents LLC. All rights reserved.
// Menu to Pick Letter to be searched

import UIKit
import SpriteKit
//global variables to be called throughout project
var supremeCharacterArray: [String] = []
var supremeImageArray: [UIImage] = []
var supremeDescriptionArray: [String] = []
var letter = ""
var masterCharacter = ""
var finalImage: UIImage?
var superDescription = ""
class MenuViewController: UIViewController {
    //api client
    let apiClient = MarvelAPIClient(publicKey: "650e801e1408159969078d2a1361c71c",
                                    privateKey: "20112b45612fd05f0d21d80d70bc8c971695c7f1")
    var characterSearch = GetCharacters()
    var searchIsRunning = false
    var searchButton = UIButton()
  //  static var parent:GameViewController?
    //turns navigation root controller to the LettersearchViewController and releases self from controller
    func goToLetter() {
        print("works")
        let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "Letter")
        let customViewControllersArray : NSArray = [newViewController!]
        self.navigationController?.viewControllers = customViewControllersArray as! [UIViewController]
        self.navigationController?.popToRootViewController(animated: true)
    }
    //sets up skview for background scrolling

    let skView: SKView = {
        let view = SKView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    override var prefersStatusBarHidden: Bool {
        return true
    }
    var searchController: AZSearchViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        //removes all children controllers to ensure max memory

        if self.children.count > 0{
            let viewControllers:[UIViewController] = self.children
            for viewContoller in viewControllers{
                viewContoller.willMove(toParent: nil)
                viewContoller.view.removeFromSuperview()
                viewContoller.removeFromParent()
            }
        }
        self.searchController = AZSearchViewController()
        self.searchController.delegate = self
        characterSearch.nameStartsWith = "S"
        self.searchController.dataSource = self
        //  characterSearch.nameStartsWith = "Sp"
        self.searchController.searchBarPlaceHolder = "Search Marvel Character"
        self.searchController.navigationBarClosure = { bar in
            //The navigation bar's background color
            bar.barTintColor = #colorLiteral(red: 0.4941176471, green: 0, blue: 0.01568627451, alpha: 1)
            //The tint color of the navigation bar
            bar.tintColor = UIColor.black
        }
        //Shared instance Singleton to detect when cell in tableViewController is selected
        Singleton.shared.delegate = self
        searchController.keyboardAppearnce = .dark
        // translatebutton.setTitle("Test Button", for: .normal)
        //    searchButton.addTarget(self, action: #selector(translatething), for: .touchUpInside)
        navigationController?.isNavigationBarHidden = true
       
        //set up the UI

       let title = UILabel(frame: CGRect(x: 0, y: view.frame.minY + 20, width: view.frame.width , height: 45))
        title.font =  UIFont(name: "BentonSans", size: 40)
        title.textColor = .white
        title.layer.shadowColor = UIColor.black.cgColor
        title.layer.shadowRadius = 5.0
        title.layer.shadowOpacity = 1.0
       title.layer.shadowOffset = CGSize(width: 6, height: 6)
        title.layer.masksToBounds = false
title.text = "SELECT CHARACTER"
        title.textAlignment = .center
        view.addSubview(skView)
        view.addSubview(title)
title.adjustsFontSizeToFitWidth = true
        NSLayoutConstraint.activate([skView.topAnchor.constraint(equalTo: view.topAnchor),
        skView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        skView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        skView.leadingAnchor.constraint(equalTo: view.leadingAnchor)])
        
        let scene = GameplayScene(size: CGSize(width: ScreenSize.width, height: ScreenSize.height))
        scene.scaleMode = .resizeFill
        
        skView.ignoresSiblingOrder = true
        skView.presentScene(scene)
        let childViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "baby")
        childViewController.view.frame = CGRect(x: 0, y: 0, width: 300 , height: 500)
        childViewController.view.center = view.center
        self.addChild(childViewController)
        self.view.addSubview(childViewController.view)
        childViewController.view.alpha = 1
        childViewController.didMove(toParent: self)
        childViewController.view.layer.cornerRadius = 40.0
        childViewController.view.clipsToBounds = true
        searchButton.frame =  CGRect(x: view.frame.maxX - 80, y: view.frame.maxY - 80  , width: 80, height: 80)
     searchButton.center.x = view.center.x
        // translatebutton.backgroundColor = .green
        searchButton.setImage(#imageLiteral(resourceName: "searchthing"), for: .normal)
        view.addSubview(searchButton)
        searchButton.addTarget(self, action: #selector(search), for: .touchUpInside)
        
        //Change appearance based on device
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
                childViewController.view.frame = CGRect(x: 0, y: 0, width: 300 * 0.8 , height: 500 * 0.8)
                childViewController.view.center = view.center
searchButton.center.x = view.center.x
            case 1334:
                print("iPhone 6/6S/7/8")
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
            case 2436:
                print("iPhone X, Xs")
                title.frame = CGRect(x: 0, y: view.frame.minY + 40, width: view.frame.width , height: 45)

            case 2688:
                print("iPhone Xs Max")
                title.frame = CGRect(x: 0, y: view.frame.minY + 40, width: view.frame.width , height: 45)

            case 1792:
                print("iPhone Xr")
                title.frame = CGRect(x: 0, y: view.frame.minY + 40, width: view.frame.width , height: 45)

            default:
                print("unknown")
            }
        }
    }
    @objc func search() {
        searchController.show(in: self)
        
    }
}
//Search delegate using the 3rd Party AZSearchViewController to easily find characters
extension MenuViewController: AZSearchViewDelegate{
    func searchView(_ searchView: UITableView, didSelectRowAt indexPath: IndexPath) {
      superDescription = supremeDescriptionArray[indexPath.row % supremeDescriptionArray.count]
        title = supremeCharacterArray[indexPath.row % supremeCharacterArray.count]
        let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "Character")
        let customViewControllersArray : NSArray = [newViewController!]
        self.navigationController?.viewControllers = customViewControllersArray as! [UIViewController]
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    func searchView(_ searchView: AZSearchViewController, didSearchForText text: String) {
        searchView.dismiss(animated: false, completion: nil)
    }
    
    func searchView(_ searchView: AZSearchViewController, didTextChangeTo text: String, textLength: Int) {
       supremeCharacterArray.removeAll()
        print("puppy")
        
        characterSearch.nameStartsWith = searchController.searchBar.text
        //   searchController.searchBar.isUserInteractionEnabled = false
        if searchIsRunning == false {
            searchIsRunning = true
            apiClient.send(characterSearch) { response in
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
                    
                    
                    
                    
                    
                case .failure(let error):
                    print(error)
                }
                searchView.reloadData()
                
            }
            
            self.searchIsRunning = false
            
            
            
            
        }//    for i in 0..<arc4random_uniform(10)+1 {self.characternameArray.append("\(text) \(i+1)")}
        
        
    }
    
    func searchView(_ searchView: AZSearchViewController, didSelectResultAt index: Int, text: String) {
        searchView.dismiss(animated: true, completion: {
            // self.pushWithTitle(text: text)
            superDescription = supremeDescriptionArray[index % supremeDescriptionArray.count]

           masterCharacter = supremeCharacterArray[index % supremeCharacterArray.count]
            let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "Character")
            let customViewControllersArray : NSArray = [newViewController!]
            self.navigationController?.viewControllers = customViewControllersArray as! [UIViewController]
            self.navigationController?.popToRootViewController(animated: true)
        })
    }
}

extension MenuViewController: AZSearchViewDataSource{
    
    func results() -> [String] {
        return supremeCharacterArray
    }
    
}
//Singleton connected to TableViewController to detect when cell is tapped to go to LetterViewController
extension MenuViewController: SingletonDelegate{
    func variableDidChange(newVariableValue value: Int) {
        let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "Letter")
        let customViewControllersArray : NSArray = [newViewController!]
        self.navigationController?.viewControllers = customViewControllersArray as! [UIViewController]
        self.navigationController?.popToRootViewController(animated: true)
        //here u get value if changed
    }
}
