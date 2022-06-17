//
//  MovieViewController.m
//  Flixter
//
//  Created by Zeke Reyes on 6/15/22.
//

#import "MovieViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"

@interface MovieViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *myArray;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
//remember when a property is set, you must call it with self.myArray
@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=7d49b7171d5da5240be056375660bb14"];
    // Create request object
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    // Create NSURL session
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    // Create session task
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               
               NSLog(@"%@", dataDictionary);// log an object with the %@ formatter.
               for (NSDictionary *myArray in self.myArray) {
//                   NSLog(@"%@", myArray[@"title"]);
               }

               // TODO: Get the array of movies
               self.myArray = dataDictionary[@"results"];
               [self.tableView reloadData];
               
           }
        [self.refreshControl endRefreshing];
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
//    cell.movieImageView.image = nil;
    [cell.movieImageView setImageWithURL:url];
    
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
