/*
 MIT License
 Copyright (c) 2016 Emotly Contributors
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import UIKit

class NewEmotlyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var moods = [Mood]()
    let emotly = Emotly()
        
    // MARK: Properties
    @IBOutlet weak var emotlyLabel: UILabel!
    @IBOutlet weak var moodsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMoods(endPoint())
        moodsTableView.delegate = self
        moodsTableView.dataSource = self
    }

    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moods.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "moodTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        // Fetches the appropriate meal for the data source layout.
        let mood = moods[indexPath.row]
        cell.textLabel?.text = mood.value as String
        cell.detailTextLabel?.text = String(mood.id)
        cell.detailTextLabel?.hidden = true
        return cell
    }
        
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if let mood_value = cell!.detailTextLabel?.text{
            let mood : NSDictionary = ["mood": mood_value]
            newEmotly(mood)
        }
    }

    // MARK: - Action
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    func getMoods(restApiService: EmotlyAPIManagerAbstract = EmotlyAPIManager()) {
        restApiService.getOperation(Constant.RESTAPI.Prefix + "/moods") { json in
            let data = json["moods"] as! NSArray
            for item in data { // loop through data items
                let obj = item as! NSDictionary
                let mood = Mood()
                for (key, val) in obj {
                    if (key as! String == "id"){
                        mood.id = val as! NSNumber
                    } else {
                        mood.value = val as! NSString
                    }
                }
            self.moods.append(mood)
        }
    
        // Since the fetch operation is async we need to realod the tableview data.
        // We sort in place the moods array to be ordered alphabetically.
        dispatch_async(dispatch_get_main_queue(),{
            self.moods.sortInPlace({ $0.value.compare($1.value as String) == NSComparisonResult.OrderedAscending })
            self.moodsTableView.reloadData()
        })
        }
    }
    
    func newEmotly(mood_value: NSDictionary, restApiService: EmotlyAPIManagerAbstract = EmotlyAPIManager()) {
        restApiService.postOperation(Constant.RESTAPI.Prefix + "/emotlies/new", bodyParam: mood_value) { json in
            if let data = json["emotly"]{
            let obj = data as! NSDictionary
                for (key, val) in obj {
                    if (key as! String == "mood") {
                        self.emotly.mood.value = val as! NSString
                    }
                    else if (key as! String == "nickname") {
                        self.emotly.user.nickname = val as! NSString
                    }
                    else if (key as! String == "created_at"){
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
                        let temp = dateFormatter.dateFromString(val as! String)
                        self.emotly.created_at = temp!
                    }
                }
            }else {
                if let data = json["message"]{
                    print(data)
                }
                
            }
        }
    }
}


