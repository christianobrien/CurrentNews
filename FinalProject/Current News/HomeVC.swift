import UIKit
import SwiftyJSON
import Alamofire
import AlamofireImage

class HomeVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var labelForNavBar: UILabel!
    @IBOutlet weak var storiesTableView: UITableView!
    
    // MARK: - Lets & Vars
    var stories : [JSON] = []
    var section : String = "home" {
        didSet {
            getDataFromNYT(section)
            setTitleForNavBar()
        }
    }
    let topStoriesAPIKey : String = "b6e77db24e759e30453d3ac9baa2349e:11:74951692"
    let placeholderImage = UIImage(named: "placeholder.png")
    let missingImage = UIImage(named: "_NewsIcon.png")
    var refreshStories : UIRefreshControl?
    
    override func viewDidAppear(animated: Bool) {
        // need to get data here so user doesn't wait for images to populate
        getDataFromNYT(section)
    }
    
    override func viewDidLoad() {
        storiesTableView.delegate = self
        storiesTableView.dataSource = self
        setTitleForNavBar()
        
        self.storiesTableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLineEtched
        
    }
    
    func setTitleForNavBar() {
        if section == "home" {
            labelForNavBar.text = "Top Stories"
        } else if section == "world" {
            labelForNavBar.text = "World"
        } else if section == "politics" {
            labelForNavBar.text = "Politics"
        } else if section == "technology" {
            labelForNavBar.text = "Technology"
        } else if section == "travel" {
            labelForNavBar.text = "Travel"
        } else if section == "health" {
            labelForNavBar.text = "Health"
        } else if section == "sports" {
            labelForNavBar.text = "Sports"
        } else if section == "realestate" {
            labelForNavBar.text = "Real Estate"
        } else if section == "magazine" {
            labelForNavBar.text = "Magazine"
        } else if section == "arts" {
            labelForNavBar.text = "Arts"
        } else if section == "opinion" {
            labelForNavBar.text = "Opinion"
        } else {
            labelForNavBar.text = section
        }
    }
    
    func getDataFromNYT(section: String) {
        let nyTimesTopStoriesURL : String = "http://api.nytimes.com/svc/topstories/v1/\(section).json?api-key=\(topStoriesAPIKey)"
        
        Alamofire.request(.GET, nyTimesTopStoriesURL).responseData { (response) in
            if let data = response.data {
                let json = JSON(data: data)
                self.stories = json["results"].arrayValue
                dispatch_async(dispatch_get_main_queue(), {
                    self.storiesTableView.reloadData()
                })
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath ) -> UITableViewCell{
        
        let cell = storiesTableView.dequeueReusableCellWithIdentifier("storyCell") as! StoryTVCell
        let imageForCell = stories[indexPath.row]["multimedia"][4]["url"].stringValue
        let url = NSURL(string: "\(imageForCell)")
        
        if imageForCell != "" {
        cell.articleImage?.af_setImageWithURL(url!, placeholderImage: placeholderImage, filter: nil, imageTransition: .CrossDissolve(0.05), runImageTransitionIfCached: false, completion: { (response) in
            cell.setNeedsLayout()
        })
        } else {
            cell.articleImage?.image = missingImage
        }

        
        
        cell.articleImage?.contentMode = UIViewContentMode.ScaleAspectFill

        cell.articleTitle?.text = stories[indexPath.row]["title"].stringValue
        cell.articleAbstract?.text = stories[indexPath.row]["abstract"].stringValue
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedArticle = stories[indexPath.row]
        let webURLString = selectedArticle["url"].stringValue
        let webURL = NSURL(string: webURLString)
        let webURLRequest = NSURLRequest(URL: webURL!)
        performSegueWithIdentifier("toWeb", sender: webURLRequest)
    }
    
    @IBAction func sectionButtonClicked(sender: AnyObject) {
        performSegueWithIdentifier("toSections", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toWeb" {
            let displayStoryVC = segue.destinationViewController as? WebVC
            displayStoryVC?.storyToLoad = sender as? NSURLRequest
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 500
    }
    
}
