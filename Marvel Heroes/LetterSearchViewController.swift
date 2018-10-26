//
//  TestCollectionViewController.swift
//  Marvel Heroes
//
//  Created by Eric on 10/25/18.
//  Copyright © 2018 App Parents LLC. All rights reserved.
//
import UIKit
import CollectionViewSlantedLayout
import AVFoundation
import SwiftSpinner
///searches by letter the characters and returns an image and name
class LetterSearchViewController: UIViewController {
    let apiClient = MarvelAPIClient(publicKey: "650e801e1408159969078d2a1361c71c",
                                    privateKey: "20112b45612fd05f0d21d80d70bc8c971695c7f1")
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewLayout: CollectionViewSlantedLayout!
    //sets up parameters
    let reuseIdentifier = "customViewCell"
    var imageArray: [UIImage] = []
    var image2Array: [UIImage] = []
var titleArray2: [String] = []
    var titleArray: [String] = []
    var descriptionArray: [String] = []
    var descriptionArray2: [String] = []

    var characterSearch = GetCharacters()
    var isLoading: Bool = false
let backButton = UIButton()
    var characternameArray: [String] = []
    //back func to go back to main menu
   @objc func back () {
   supremeCharacterArray = []
  supremeImageArray = []
   supremeDescriptionArray = []
     letter = ""
    masterCharacter = ""
    finalImage = nil
  superDescription = ""
    let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "Menu")
    let customViewControllersArray : NSArray = [newViewController!]
    self.navigationController?.viewControllers = customViewControllersArray as! [UIViewController]
    self.navigationController?.popToRootViewController(animated: true)
    }
    var searchController: AZSearchViewController!
var searchButton = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.frame = view.frame
        //removes all children viewcontrollers
        if self.children.count > 0{
            let viewControllers:[UIViewController] = self.children
            for viewContoller in viewControllers{
                viewContoller.willMove(toParent: nil)
                viewContoller.view.removeFromSuperview()
                viewContoller.removeFromParent()
            }
        }
        backButton.frame =  CGRect(x: view.frame.minX + 10, y: view.frame.minY + 5 , width: 30, height: 30)
        backButton.alpha = 0.9
       
        backButton.setTitle("X", for: .normal)
        backButton.titleLabel?.font = UIFont(name: "BentonSans", size: 25)
        backButton.setTitleColor(.white, for: .normal)
        view.addSubview(backButton)
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        //sets up searchbar
        self.searchController = AZSearchViewController()
        self.searchController.delegate = self
        characterSearch.nameStartsWith = letter
        self.searchController.dataSource = self
        self.searchController.searchBarPlaceHolder = "Search Marvel Character"
        self.searchController.navigationBarClosure = { bar in
            //The navigation bar's background color
            bar.barTintColor = #colorLiteral(red: 0.4941176471, green: 0, blue: 0.01568627451, alpha: 1)
            bar.tintColor = UIColor.black
        }
        searchController.keyboardAppearnce = .dark
  
        navigationController?.isNavigationBarHidden = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.reloadData()
characterSearch.limit = 100
        collectionViewLayout.isFirstCellExcluded = true
        collectionViewLayout.isLastCellExcluded = true
        collectionViewLayout.slantingSize = 30
        var nsString = NSString()

        SwiftSpinner.show("Retrieving Marvel Characters that Start with" + " " + "\(letter)" )
        SwiftSpinner.sharedInstance.outerColor = UIColor.red.withAlphaComponent(0.5)

       // activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
       // view.addSubview(activityIndicator)
        SwiftSpinner.setTitleFont(UIFont(name: "BentonSans", size: 22.0))
    // activityIndicator.center =  view.center
        DispatchQueue.main.async {
            self.loadImages()
            self.loadImages2()
        }
     
        
        
       
    }

    
    var offset = 0
    func loadBothImages() {
        
    }
    func loadImages() {
        
//offset is the difference between characters
        characterSearch.offset = offset
      // offset = offset + 100
            self.apiClient.send(self.characterSearch) { response in
                print("\nGetCharacters finished:")
                self.isLoading = true
                
                switch response {
                    //searches for every character with the first letter
                case .success(let dataContainer):
                    DispatchQueue.main.sync {
                        
                        
                        for character in dataContainer.results {
                     
                            self.descriptionArray.append(character.description! )
                            self.titleArray.append(character.name!)
                            if let data = try? Data(contentsOf: (character.thumbnail?.url)!) {
                            
                                self.imageArray.append( UIImage(data: data)!)
                               
                                print(self.imageArray)
                            }
                            else {
                                
                            }
                            
                        }
                        self.isLoading = false
                    }
                    
                    
                    print(self.imageArray)
                    
                case .failure(let error):
                    print(error)
                }
                print("nut job")
                self.ready1 = true

                DispatchQueue.main.sync {
                    self.collectionView.invalidateIntrinsicContentSize()
                    self.collectionView.reloadData()
              
                }
               

            }
       
    }
    //does the same thing as the first one, but with a different offset and different arrays
    func loadImages2() {
        
        //split string into spaces
        characterSearch.offset = 100
   //     offset = offset + 100
        self.apiClient.send(self.characterSearch) { response in
            print("\nGetCharacters finished:")
            self.isLoading = true
            
            switch response {
            case .success(let dataContainer):
                DispatchQueue.main.sync {
                    
                    
                    for character in dataContainer.results {

                        self.descriptionArray2.append(character.description! )

                        self.titleArray2.append(character.name!)
                        if let data = try? Data(contentsOf: (character.thumbnail?.url)!) {
                            self.image2Array.append( UIImage(data: data)!)
                          
                            print(self.imageArray)
                        }
                        else {
                            
                        }
                        
                    }
                    self.isLoading = false
                }
                
                
                print(self.image2Array)
                //       print(self.titles)
                
            case .failure(let error):
                print(error)
            }
            self.ready2 = true
            DispatchQueue.main.sync {
                self.collectionView.invalidateIntrinsicContentSize()
                self.collectionView.reloadData()
             
            }
            
            
        }
        
    }
    //checks if the first batch of images are downloaded
    var ready1 = false {
        didSet {
        if ready2 == true && ready1 == true {
            loadItAll = true

        }
    }
    }
    //checks if the second batch of images are downloaded

    var ready2 = false {
    didSet {
    if ready2 == true && ready1 == true {
    loadItAll = true
    }
    }
}
    var superTitleArray: [String] = []
    var superImageArray: [UIImage] = []
    var loadItAll = false {
        //works when all images are downloaded
        //stitches all arrays together
        //reloads collectionviewdata to be presented and stops activity indicator
        didSet {
            print("crap")
            SwiftSpinner.hide()
            superImageArray.append(contentsOf: imageArray)
            superImageArray.append(contentsOf: image2Array)
            superTitleArray.append(contentsOf: titleArray)
            superTitleArray.append(contentsOf: titleArray2)
            supremeDescriptionArray.append(contentsOf: descriptionArray)
            supremeDescriptionArray.append(contentsOf: descriptionArray2)

            DispatchQueue.main.sync {
                self.collectionView.reloadData()
                collectionView.collectionViewLayout.invalidateLayout()
            }
          

        }
    }
    
    let searchLabel = UILabel()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
        searchButton.frame =  CGRect(x: view.frame.maxX - 80, y: view.frame.minY , width: 70, height: 70)
        searchButton.setImage(#imageLiteral(resourceName: "searchthing"), for: .normal)
        view.addSubview(searchButton)
        searchButton.addTarget(self, action: #selector(search), for: .touchUpInside)
      backButton.center.y =  searchButton.center.y
        searchLabel.frame =  CGRect(x: view.frame.maxX - 80, y: view.frame.minY + 60, width: 70, height: 20)
        searchLabel.text = "Search"
        searchLabel.textColor = .white
        searchLabel.font = UIFont(name: "BentonSans", size: 14)
        searchLabel.textAlignment = .center
        searchLabel.layer.shadowColor = UIColor.black.cgColor
        searchLabel.layer.shadowRadius = 5.0
        searchLabel.layer.shadowOpacity = 1.0
        searchLabel.layer.shadowOffset = CGSize(width: 6, height: 6)
        searchLabel.layer.masksToBounds = false
view.addSubview(searchLabel)
       

    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    //opens searchviewcontroller
   @objc func search() {
        searchController.show(in: self)

    }
    var player: AVAudioPlayer?
    //play audio func
    func playSound() {
        guard let url = Bundle.main.url(forResource: "MagicSpellWhoosh_SFXB.1392", withExtension: "wav") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback, options: .defaultToSpeaker)
            try AVAudioSession.sharedInstance().setActive(true)
            
            
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
 
    var searchIsRunning = false

}
//sets up collectionview
extension LetterSearchViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        print("\(titleArray)" + "cat")
        return superImageArray.count
    

    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
            as? CustomCollectionCell else {
                fatalError()
        }

        
            
         cell.image =   self.superImageArray[indexPath.row % self.superImageArray.count]
        cell.label.layer.shadowColor = UIColor.black.cgColor
        cell.label.layer.shadowRadius = 3.0
        cell.label.layer.shadowOpacity = 1.0
        cell.label.layer.shadowOffset = CGSize(width: 4, height: 4)
        cell.label.layer.masksToBounds = false
        if let layout = collectionView.collectionViewLayout as? CollectionViewSlantedLayout {
            cell.contentView.transform = CGAffineTransform(rotationAngle: layout.slantingAngle)
            cell.label.transform = CGAffineTransform(rotationAngle: layout.slantingAngle )
            cell.label.text = self.superTitleArray[indexPath.row % self.superTitleArray.count]
            cell.label.adjustsFontSizeToFitWidth = true
            
        }
        switch UIScreen.main.nativeBounds.height {
        case 1136:
            print("iPhone 5 or 5S or 5C")
            cell.label.font =  UIFont(name: "BentonSans", size: 15)
            cell.label.adjustsFontSizeToFitWidth = true
cell.label.center.x = view.center.x

        default:
            print("unknown")
        }
        
            
        
        
        if let layout = collectionView.collectionViewLayout as? CollectionViewSlantedLayout {
            cell.contentView.transform = CGAffineTransform(rotationAngle: layout.slantingAngle)
        }
        
        return cell
    }
}
//collectionview delegate
extension LetterSearchViewController: CollectionViewDelegateSlantedLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NSLog("Did select item at indexPath: [\(indexPath.section)][\(indexPath.row)]")
        UIView.animate(withDuration: 0.5) {
            if let cell = collectionView.cellForItem(at: indexPath) as? CustomCollectionCell {
                self.playSound()
            cell.imageView.transform = .init(scaleX: 2, y: 2)
                //creates a beautiful cell
                finalImage = cell.image
                masterCharacter = cell.label.text!
                superDescription = supremeDescriptionArray[indexPath.row % supremeDescriptionArray.count]
               
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: {
                let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "Character")
                let customViewControllersArray : NSArray = [newViewController!]
                self.navigationController?.viewControllers = customViewControllersArray as! [UIViewController]
                self.navigationController?.popToRootViewController(animated: true)
            })
          
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: CollectionViewSlantedLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGFloat {
        return collectionViewLayout.scrollDirection == .vertical ? 275 : 325
    }
}
//makes the unique scroll experience with the parallax views
extension LetterSearchViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchLabel.isHidden = true
        searchButton.alpha = 0.4
        backButton.alpha = 0.4

        guard let collectionView = collectionView else {return}
        guard let visibleCells = collectionView.visibleCells as? [CustomCollectionCell] else {return}
        for parallaxCell in visibleCells {
            let yOffset = (collectionView.contentOffset.y - parallaxCell.frame.origin.y) / parallaxCell.imageHeight
            let xOffset = (collectionView.contentOffset.x - parallaxCell.frame.origin.x) / parallaxCell.imageWidth
            parallaxCell.offset(CGPoint(x: xOffset * xOffsetSpeed, y: yOffset * yOffsetSpeed))
        }
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            searchLabel.isHidden = false
            searchButton.alpha = 1
backButton.alpha = 1

        }
        
    }

}

//same code as the menuviewcontroller to open character search through typing
extension LetterSearchViewController: AZSearchViewDelegate{
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
 

extension LetterSearchViewController: AZSearchViewDataSource{
    
    func results() -> [String] {
        return supremeCharacterArray
    }
    
}

