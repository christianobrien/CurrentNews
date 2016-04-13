import UIKit

class StoriesVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var sectionTableView: UITableView!
    
    let sectionList : [String] = ["home", "world", "politics", "technology", "travel", "health", "sports", "realestate", "magazine", "arts", "opinion"]
    let storyData = StoryData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sectionTableView.dataSource = self
        sectionTableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func cancelPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionList.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = sectionTableView.dequeueReusableCellWithIdentifier("sectionCell")
        
        let selectedSection : String = sectionList[indexPath.row]
        cell?.textLabel?.text = selectedSection
        cell?.imageView?.image = UIImage(named:"\(selectedSection).png")
        cell?.imageView?.frame.size = CGSize(width: 30, height: 30)
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedSection : String = sectionList[indexPath.row]
        ((self.presentingViewController as! UINavigationController).topViewController as! HomeVC).section = selectedSection
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
