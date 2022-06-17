//
//  MovieCell.h
//  Flixter
//
//  Created by Zeke Reyes on 6/16/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MovieCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *movieImageView;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

NS_ASSUME_NONNULL_END
