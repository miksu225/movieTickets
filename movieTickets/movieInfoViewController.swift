//
//  movieInfoViewController.swift
//  movieTickets
//
//  Created by Koulutus on 20.11.2017.
//  Copyright © 2017 MikkoS. All rights reserved.
//

import UIKit

class movieInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let db = Db.shared()
    var movie : Movie = Movie()
    
    var movieImage : UIImage  = UIImage()
    //var shows : [Show] = []
    var shows : [Show] = [Show(theaterid: 1, startday: "2017-01-01", starttime: "14:30:00", endtime: "16:30:00"),Show(theaterid: 2, startday: "2017-01-02", starttime: "14:30:00", endtime: "16:30:00")]
    
    @IBOutlet weak var labelMovieTitle: UILabel!
    @IBOutlet weak var labelMovieOverview: UILabel!
    @IBOutlet weak var imageMovie: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navBarMovieInfo: UINavigationBar!
    
    

    @IBAction func rewindToMovieList(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        labelMovieTitle.text = movie.original_title
        labelMovieOverview.text = movie.overview
        imageMovie.image = movieImage
        // Do any additional setup after loading the view.
       
        if db.exists() {
            
            if db.open() {
                
                let resultset2 : FMResultSet = db.selectstatement(sqlstatement: "select * from shows where movieid = 550;")!
                
                while resultset2.next() {
                    shows.append(Show(
                        theaterid: Int(resultset2.int(forColumn: "theaterid")),
                        startday: resultset2.string(forColumn: "startday")!,
                        starttime: resultset2.string(forColumn: "starttime")!,
                        endtime: resultset2.string(forColumn: "endtime")!))
                }
                print("SHOW")
                print(shows)
                
               /* let resultset : FMResultSet? = db.selectstatement(sqlstatement: "select * from shows;")
                */
                
               /* print("isopen: " + String(db.connectiontoFMDB.isOpen))
                print("tableexists: " + String(db.connectiontoFMDB.tableExists("shows")))
               */
                
               /* if resultset == nil {
                    print("tyhjää täynnä")
                }
                else {
                    print("löytyy tavaraa")
                }
*/
                /*while (resultset?.next())! {
                    shows.append(Show(
                        theaterid: Int(resultset.int(forColumn: "theaterid")),
                        startday: resultset.string(forColumn: "startday"),
                        starttime: resultset.string(forColumn: "starttime"),
                        endtime: resultset.string(forColumn: "endtime"))
                    
                }*/
            }
            db.close()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return shows.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "showsListTableViewCell_id", for: indexPath) as! showsListTableViewCell
        
        // Configure the cell...
       cell.labelShowStartDay.text = shows[indexPath.row].startday
        cell.labelShowStartTime.text = shows[indexPath.row].starttime
        
        
        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let target = segue.destination as! showInfoViewController
        
        let show = self.tableView.indexPathForSelectedRow?.row
        target.show = shows[show!]
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
