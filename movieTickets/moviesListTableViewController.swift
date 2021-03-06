//
//  moviesListTableViewController.swift
//  movieTickets
//
//  Created by Koulutus on 15.11.2017.
//  Copyright © 2017 MikkoS. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class moviesListTableViewController: UITableViewController{
    
    let db = Db.shared()
    let signs = Signs()
    //var db = Db("moviedatabase.db")
    var moviesId : [Int] = []
    var movies : [Movie] = []
    var movieImages : [UIImage] = []
    var config : Images = Images()
    var showsNext : [Show] = []
    let api_key = "{your api key here}"
    let urlSession = URLSession.shared
    let dispatchGroup = DispatchGroup()
    let decoder = JSONDecoder()
    
    @IBAction func signOutPressed(_ sender: UIBarButtonItem) {
        
        signs.signOut(self.storyboard)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if db.exists() {
            if db.open() {
                let resultset : FMResultSet = db.selectstatement(sqlstatement: "select * from movies;")!
                
                while resultset.next() {
                    moviesId.append(Int(resultset.int(forColumn: "movieid")))
                }
                
                //If you want to next show when compared to time and date now, use
                //startday >= date('now') and starttime >= time('now')
                for id in moviesId {
                    
                    let resultset2 : FMResultSet = db.selectstatement(sqlstatement: "select * from shows, theaters where shows.theaterid = theaters.theaterid and movieid = \(id) order by startday, starttime asc limit 1;")!
                    
                    
                    while resultset2.next() {
                         let resultset3 : FMResultSet = db.selectstatement(sqlstatement: "select count(showid) as seatstaken from tickets where showid = \(Int(resultset2.int(forColumn: "showid")))")!
                        
                        while resultset3.next() {
                            showsNext.append(Show(
                                showid: Int(resultset2.int(forColumn: "showid")),
                                theater: Theater(
                                    theaterid: Int(resultset2.int(forColumn: "theaterid")),
                                    name: resultset2.string(forColumn: "name")!,
                                    seatstotal: Int(resultset2.int(forColumn: "seatstotal"))),
                                startday: resultset2.string(forColumn: "startday")!,
                                starttime: resultset2.string(forColumn: "starttime")!,
                                endtime: resultset2.string(forColumn: "endtime")!,
                                seatstaken: Int(resultset3.int(forColumn: "seatstaken"))))
                        }
                                            
                        
                    }
                }

            }
            db.close()
        }
        
    
        
            self.webrequest(completion: {
                config in
                self.config = config
                //print(self.config.images.secure_base_url)
            })
            for id in self.moviesId {
                self.dispatchGroup.enter()
                self.webrequest(id, completion: {
                    movie in
                    //append Movie
                    self.movies.append(movie)
                    //print(movie.original_title + " lisätty")
                    
                    //append UIImage
                    self.webrequest(self.config.images.secure_base_url + self.config.images.poster_sizes[0] + movie.poster_path, completion: {image in
                        self.movieImages.append(image)
                        //print("kuva lisätty arrayhin")
                        //print(image)
                        self.dispatchGroup.leave()
                        
                    })
                    
                })
                
            }
        
         self.dispatchGroup.wait()
        
        dispatchGroup.notify(queue: .main) {
           
                self.tableView.reloadData()
            
            }
      

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    func webrequest (_ targetweb : String, completion: @escaping ((_ movie: UIImage) -> Void)) {
        /*REQUEST RATE LIMIT TO https://api.themoviedb.org IS 40 REQUESTS IN 10 SECONDS*/
        
        
        let targetURL = URL(string: targetweb)
        
        let request = URLRequest(url: targetURL!,
                                 cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: 10.0)
        
        let dataTask = urlSession.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print("request not working!!!")
                print(error)
                return
            }
            else {
                print("request worked")
                let httpResponse = response as? HTTPURLResponse
                // print(httpResponse)
                
                let image = UIImage(data: data!)
                
                completion(image!)
                
            }
        })
        dataTask.resume()
        
    }
    
    func webrequest ( completion: @escaping ((_ movie: Images) -> Void)) {
        /*REQUEST RATE LIMIT TO https://api.themoviedb.org IS 40 REQUESTS IN 10 SECONDS*/
        
        let targetweb : String = "https://api.themoviedb.org/3/configuration?api_key=\(api_key)"
        
        let targetURL = URL(string: targetweb)
        
        let request = URLRequest(url: targetURL!,
                                 cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: 10.0)
        
        let dataTask = urlSession.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print("request not working!!!")
                print(error)
                return
            }
            else {
                print("request worked")
                let httpResponse = response as? HTTPURLResponse
                // print(httpResponse)
                
                let config = try! self.decoder.decode(Images.self, from: data!)

                completion(config)
                
            }
        })
        dataTask.resume()

    }
    
    func webrequest (_ id : Int, completion: @escaping ((_ movie: Movie) -> Void)) {
        /*REQUEST RATE LIMIT TO https://api.themoviedb.org IS 40 REQUESTS IN 10 SECONDS*/
        
        let targetweb : String = "https://api.themoviedb.org/3/movie/\(id)?api_key=\(api_key)"
        
        let targetURL = URL(string: targetweb)
        
        let request = URLRequest(url: targetURL!,
                                 cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: 10.0)

        let dataTask = urlSession.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print("request not working!!!")
                print(error)
                return
            }
            else {
                print("request worked")
                let httpResponse = response as? HTTPURLResponse
               // print(httpResponse)

                let movie = try! self.decoder.decode(Movie.self, from: data!)
                

                completion(movie)

            }
        })
        dataTask.resume()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return moviesId.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell_id", for: indexPath) as! movieTableViewCell
        
        

        if !movies.isEmpty {
            cell.labelMovie.text = movies[indexPath.row].original_title
            cell.labelStartDate.text = showsNext[indexPath.row].startday
            cell.labelStartTime.text = showsNext[indexPath.row].starttime
            cell.labelTheater.text = showsNext[indexPath.row].theater.name
            /*cell.labelSeatsLeft.text = String(showsNext[indexPath.row].theater.seatstotal - showsNext[indexPath.row].seatstaken)*/
        }


        if !movieImages.isEmpty {
            print("kuva lisätään imageviewiin")
            cell.imageMovie.image = movieImages[indexPath.row]
            tableView.rowHeight = (cell.imageMovie.image?.size.height)! + 60
            //tableView.rowHeight = 300
        }
        
        
        
        
        
        
        

        // Configure the cell...
        return cell
        
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation
    
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let target = segue.destination as! movieInfoViewController
        
        let backItem = UIBarButtonItem()
        backItem.title = "Movie select"
        navigationItem.backBarButtonItem = backItem
        
        
        let movie = self.tableView.indexPathForSelectedRow?.row
        target.movie = movies[movie!]
        target.movieImage = movieImages[movie!]
    }
 

}
