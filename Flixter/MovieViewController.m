//
//  MovieViewController.m
//  Flixter
//
//  Created by Zeke Reyes on 6/15/22.
//

#import "MovieViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"

@interface MovieViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *myArray;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

//remember when a property is set, you must call it with self.myArray
@end

@implementation MovieViewController

int totalColors = 100;
- (UIColor*)colorForIndexPath:(NSIndexPath *) indexPath{
    if(indexPath.row >= totalColors){
        return UIColor.blackColor;    // return black if we get an unexpected row index
    }
    
    CGFloat hueValue = (CGFloat)(indexPath.row)/(CGFloat)(totalColors);
    return [UIColor colorWithHue:hueValue saturation:1.0 brightness:1.0 alpha:1.0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.activityIndicator startAnimating];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 350;
    
    [self fetchMovies];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
//    [self.tableView addSubview:self.refreshControl];
    
    
    
}

- (void) fetchMovies {
    // Do any additional setup after loading the view.
    
    //Alert UI
    UIAlertController *networkAlert = [UIAlertController alertControllerWithTitle:@"Cannot Get Movies" message:@"The internet connection appears to be offline." preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *tryAgainAction = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        [self fetchMovies];
    }];
    
    [networkAlert addAction:tryAgainAction];
    
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=7d49b7171d5da5240be056375660bb14"];
    // Create request object
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    // Create NSURL session
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    // Create session task
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
               
               //Alert UI
               [self presentViewController:networkAlert animated:YES completion:^{
                   // optional code for what happens after the alert controller has finished presenting.
               }];
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               
               NSLog(@"%@", dataDictionary);// log an object with the %@ formatter.
               //for (NSDictionary *myArray in self.myArray) {
//                   NSLog(@"%@", myArray[@"title"]);
               //}

               // TODO: Get the array of movies
               self.myArray = dataDictionary[@"results"];
               [self.tableView reloadData];
               
           }
        [self.refreshControl endRefreshing];
        [self.activityIndicator stopAnimating];
       }];
    [task resume];
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.myArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
   // Get info for movie
    NSString *title = self.myArray[indexPath.row][@"title"];
    cell.titleLabel.text = title;
    cell.synopsisLabel.text = self.myArray[indexPath.row][@"overview"];
    // Base url string
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *urlString = self.myArray[indexPath.row][@"poster_path"];
    
    // Full poster image url
    NSString *fullPosterURL = [baseURLString stringByAppendingString:urlString];
    NSURL *url = [NSURL URLWithString:fullPosterURL];
    // Resets image to get rid of flickering
    cell.movieImageView.image = nil;
    // Sets the movie poster image
    [cell.movieImageView setImageWithURL:url];
    
    
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    DetailsViewController *detailsVC = [segue destinationViewController];
    // Will act as the key for which cell info will ve sent over
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    
    // Pass the selected object to the new view controller.
    // then is accessible to us to use and implement
    detailsVC.detailsDict = self.myArray[indexPath.row];
    
}

@end
