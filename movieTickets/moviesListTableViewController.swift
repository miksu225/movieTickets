//
//  moviesListTableViewController.swift
//  movieTickets
//
//  Created by Koulutus on 15.11.2017.
//  Copyright © 2017 MikkoS. All rights reserved.
//

import UIKit


class moviesListTableViewController: UITableViewController{
    
    var db : Db = Db(dbname: "moviedatabase.db")
    var moviesId : [Int] = []
    var movies : [Movie] = []
    var movieImages : [UIImage] = []
    var config : Images = Images()
    let api_key = "85026d9e96590ed29d1fdc6d9d4c2713"
    let urlSession = URLSession.shared
    let dispatchGroup = DispatchGroup()
    let decoder = JSONDecoder()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if db.exists() {
            if db.open() {
                let resultset : FMResultSet = db.selectstatement(sqlstatement: "select * from movies;")
                
                while resultset.next() {
                    moviesId.append(Int(resultset.int(forColumn: "movieid")))
                }
            }
            db.close()
        }
        
            self.webrequest(completion: {
                config in
                self.config = config
                //print(self.config.images.poster_sizes)
            })
            for id in self.moviesId {
                self.dispatchGroup.enter()
                self.webrequest(id, completion: {
                    movie in
                    //append Movie
                    self.movies.append(movie)
                    print(movie.original_title + " lisätty")
                    
                    //append UIImage
                    self.webrequest(self.config.images.secure_base_url + self.config.images.poster_sizes[0] + movie.poster_path, completion: {image in
                        self.movieImages.append(image)
                        print("kuva lisätty arrayhin")
                        print(image)
                        self.dispatchGroup.leave()
                        
                    })
                    
                })
                
            }
        
         self.dispatchGroup.wait()
        
        dispatchGroup.notify(queue: .main) {
                print("loadataan")
           
                self.tableView.reloadData()
            
            }
      
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    func webrequest (_ targetweb : String, completion: @escaping ((_ movie: UIImage) -> Void)) {
        /*REQUEST RATE LIMIT TO https://api.themoviedb.org IS 40 REQUESTS IN 10 SECONDS*/
        //var returnData : Data = Data()
        //var movie : Movie = Movie()
        
        //let targetweb : String = "https://api.themoviedb.org/3/configuration?api_key=\(api_key)"
        
        let targetURL = URL(string: targetweb)
        
        let request = URLRequest(url: targetURL!,
                                 cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: 10.0)
        
        let dataTask = urlSession.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print("requesti ei toiminut!!!")
                print(error)
                return
            }
            else {
                print("requesti toimi")
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
        //var returnData : Data = Data()
        //var movie : Movie = Movie()
        
        let targetweb : String = "https://api.themoviedb.org/3/configuration?api_key=\(api_key)"
        
        let targetURL = URL(string: targetweb)
        
        let request = URLRequest(url: targetURL!,
                                 cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: 10.0)
        
        let dataTask = urlSession.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print("requesti ei toiminut!!!")
                print(error)
                return
            }
            else {
                print("requesti toimi")
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
        //var returnData : Data = Data()
        //var movie : Movie = Movie()
        
        let targetweb : String = "https://api.themoviedb.org/3/movie/\(id)?api_key=\(api_key)"
        
        let targetURL = URL(string: targetweb)
        
        let request = URLRequest(url: targetURL!,
                                 cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: 10.0)

        let dataTask = urlSession.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print("requesti ei toiminut!!!")
                print(error)
                return
            }
            else {
                print("requesti toimi")
                let httpResponse = response as? HTTPURLResponse
               // print(httpResponse)

                let movie = try! self.decoder.decode(Movie.self, from: data!)
                

                completion(movie)

            }
        })
        dataTask.resume()
        //print("ulkona")
       // print(movie)
        //return movie
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
        
        
        let movieId = moviesId[indexPath.row]
        

        print(1)
        if !movies.isEmpty {
            cell.labelMovie.text = movies[indexPath.row].original_title
        }


        if !movieImages.isEmpty {
            print("kuva lisätään imageviewiin")
            cell.imageMovie.image = movieImages[indexPath.row]
            tableView.rowHeight = (cell.imageMovie.image?.size.height)! + 60
            //tableView.rowHeight = 300
        }
        
        
        
        
        
        
        

        // Configure the cell...
        print(2)
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
    }
 

}
