//  Created by Eric on 10/25/18.
//  Copyright © 2018 App Parents LLC. All rights reserved.
//
import UIKit
import SpriteKit
import  AVFoundation
//animated tableViewController where user can select letter

class TableViewController: UITableViewController {
//letters array
    var objects = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K","L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X","Y", "Z" ]
    var cellAnimationType = GLSTableViewCellAnimationType.flipInLeft
    let skView: SKView = {
        let view = SKView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
  

    var player: AVAudioPlayer?
    //plays sound effect when cell is selected
    //bug so far on IPhone SE IOS 12 where it won't play, but plays on Simulator and previous IOS versions
    func playSound() {
        guard let url = Bundle.main.url(forResource: "ESM_Riochet_Notification_Notification_Synth_Electronic_Particle_Cute_Cartoon", withExtension: "wav") else {  return print("crap")}
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback, options: .defaultToSpeaker)
            try AVAudioSession.sharedInstance().setActive(true)
            
            
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
          
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: view.frame)
       
        backgroundImage.image = #imageLiteral(resourceName: "background2")


        tableView.backgroundView = backgroundImage
     
     
    }

    override func viewWillAppear(_ animated: Bool) {
      //  self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 

    // MARK: - Segues
//select cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.isSelected {
                print("This cell is selected")
                cell.contentView.backgroundColor = .red
                // plays sound
                playSound()
                // animate

                cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
                UIView.animate(withDuration: 0.3, animations: {
                    cell.layer.transform = CATransform3DMakeScale(1.05, 1.05, 1)
                },completion: { finished in
                    UIView.animate(withDuration: 0.1, animations: {
                        cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
                        letter = (cell.textLabel?.text)!
                        print(letter)
                        //trigger singleton to go to letterViewController
                     Singleton.shared.variable = 2
                        print(Singleton.shared.variable)
                     //self.tabBarController?.navigationController?.popViewController(animated: true)
                        //    self.childFunction()

                        
                    
                     //   self.parent?.removeFromParent()
                    })
                })
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
// makes the tableview look pretty
        let object = objects[indexPath.row] as! String
        cell.contentView.backgroundColor = .clear
        cell.contentView.tintColor = .clear
cell.textLabel?.textColor = .white
        cell.textLabel!.text = object
        cell.textLabel?.center = cell.center
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font =  UIFont(name: "BentonSans", size: 50)
           cell.textLabel?.layer.shadowColor = UIColor.black.cgColor
           cell.textLabel?.layer.shadowRadius = 5.0
           cell.textLabel?.layer.shadowOpacity = 1.0
           cell.textLabel?.layer.shadowOffset = CGSize(width: 6, height: 6)
           cell.textLabel?.layer.masksToBounds = false
        return cell
    }

    

    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let customCell = cell as? GLSTableViewCell
        {
            customCell.animationType = self.cellAnimationType
            customCell.animateIn(0.8)
            
        }
    }


}


