//
//  NewsCell.h
//  RSSReader
//
//  Created by Vladimir on 29.08.13.
//  Copyright (c) 2013 Vladimir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageNews;
@property (strong, nonatomic) IBOutlet UILabel *titleNews;
@property (strong, nonatomic) IBOutlet UILabel *dateNews;

@end
