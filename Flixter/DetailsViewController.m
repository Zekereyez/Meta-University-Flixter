//
//  DetailsViewController.m
//  Flixter
//
//  Created by Zeke Reyes on 6/16/22.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *detailSynopsis;
@property (weak, nonatomic) IBOutlet UILabel *detailTitle;
@property (weak, nonatomic) IBOutlet UIImageView *movieDetailsImage;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.detailTitle.text = self.detailsDict[@"title"];
    self.detailSynopsis.text = self.detailsDict[@"overview"];
    
    // Base url string
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *urlString = self.detailsDict[@"backdrop_path"];
    
    // Full poster image url
    NSString *fullPosterURL = [baseURLString stringByAppendingString:urlString];
    NSURL *url = [NSURL URLWithString:fullPosterURL];
    // Resets image to get rid of flickering
    self.movieDetailsImage = nil;
    // Sets the movie poster image
    //[self.movieDetailsImage setImageWithURL:url];
}

/*
#pragma mark - Navigation

 //In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    TitleCellTableViewCell *cell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSDictionary *data
//     Get the new view controller using [segue destinationViewController].
//     Pass the selected object to the new view controller.
//     you'll need to have gotten an index with indexPathForCell
     NSDictionary *dataToPass = self.myArray[indexPath.row]
     DetailsViewController *detailVC = [segue destinationViewController];
    detailVC.detailDict = dataToPass;
}
*/

@end
