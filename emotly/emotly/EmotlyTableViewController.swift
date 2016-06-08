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

// Table view controller for the list of emotlies.
class EmotlyTableViewController: UITableViewController {
    // MARK: Property
    @IBOutlet weak var moodLabel: UILabel!
    var emotlies = [Emotly]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getEmotlies(endPoint())
    }
    
    func endPoint()-> EmotlyAPIManagerAbstract {
        if ((NSProcessInfo.processInfo().environment["UI_TESTING_MODE"]) == "true") {
            return EmotlyAPIManagerTest()
        }else{
            return EmotlyAPIManager()
        }
    }
    
    // Function used to fetch the list of emotlies from the rest api service.
    func getEmotlies(restApiService: EmotlyAPIManagerAbstract = EmotlyAPIManager()) {
        restApiService.getOperation(Constant.RESTAPI.Prefix + "/emotlies") { json in
            let data = json["emotlies"] as! NSArray
            for item in data { // loop through data items
                let obj = item as! NSDictionary
                let emotly = Emotly()
                for (key, val) in obj {
                    if (key as! String == "mood") {
                        emotly.mood.value = val as! NSString
                    }
                    else if (key as! String == "nickname") {
                        emotly.user.nickname = val as! NSString
                    }
                    else if (key as! String == "created_at"){
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
                        let temp = dateFormatter.dateFromString(val as! String)
                        emotly.created_at = temp!
                    }
                }
                self.emotlies.append(emotly)
            }
            // Since the fetch operation is async we need to realod the tableview data.
            // We sort in place the emotlies array to be ordered based on the created_at date.
            dispatch_async(dispatch_get_main_queue(),{
                self.emotlies.sortInPlace({ $0.created_at.compare($1.created_at) == NSComparisonResult.OrderedDescending })
                self.tableView.reloadData()
                
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emotlies.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> EmotlyTableViewCell {
        let cellIdentifier = "emotlyTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! EmotlyTableViewCell
        
        // Fetches the appropriate emotly for the data source layout.
        let emotly = emotlies[indexPath.row]
        
        cell.nicknameLabel?.text = emotly.user.nickname as String
        cell.moodLabel?.text = emotly.mood.value as String
        cell.created_atLabel?.text = emotly.created_at.relativeTime as String
        return cell
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
