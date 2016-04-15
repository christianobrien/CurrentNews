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
            labelForNavBar.text = section
        }
    }
    let topStoriesAPIKey : String = "b6e77db24e759e30453d3ac9baa2349e:11:74951692"
    let placeHolderImage = UIImage(named: "placeholder.png")
    var refreshControl : UIRefreshControl?
    
    override func viewDidLoad() {
        storiesTableView.delegate = self
        storiesTableView.dataSource = self
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(HomeVC.getDataFromNYT(_:)), forControlEvents: .ValueChanged)
        //        navBarTitle.text = ""
        getDataFromNYT(section)
        labelForNavBar.text = section
        
        self.storiesTableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLineEtched
        
    }
    
    func getDataFromNYT(section: String) {
        let nyTimesTopStoriesURL : String = "http://api.nytimes.com/svc/topstories/v1/\(section).json?api-key=\(topStoriesAPIKey)"
        
        Alamofire.request(.GET, nyTimesTopStoriesURL).responseData { (response) in
            if let data = response.data {
                let json = JSON(data: data)
                self.stories = json["results"].arrayValue
                dispatch_async(dispatch_get_main_queue(), {
                    self.refreshControl?.endRefreshing()
                    self.storiesTableView.reloadData()
                })
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath ) -> UITableViewCell{
        
        let cell = storiesTableView.dequeueReusableCellWithIdentifier("storyCell") as! StoryTVCell
        let imageForCell = stories[indexPath.row]["multimedia"][4]["url"].stringValue

//        let widthForImage = stories[indexPath.row]["multimedia"][4]["width"].intValue
//        let heightForImage = stories[indexPath.row]["multimedia"][4]["height"].intValue
//        let filter = ScaledToSizeFilter(size: CGSize(width: widthForImage, height: heightForImage))
        
        let url = NSURL(string: "\(imageForCell)")
        cell.articleImage?.af_setImageWithURL(url!, placeholderImage: placeHolderImage, filter: nil, imageTransition: .CrossDissolve(0.9), runImageTransitionIfCached: false, completion: { (response) in
            cell.setNeedsLayout()
        })

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
