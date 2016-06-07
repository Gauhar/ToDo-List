//
//  ListTableViewCell.h
//  ToDoListApp
//
//  Created by Gauhar Shakeel on 2016-05-12.
//  Copyright © 2016 Gauhar Shakeel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *colorView;
@property (strong, nonatomic) IBOutlet UILabel *listTitle;
@property (strong, nonatomic) IBOutlet UILabel *listCategory;
@property (strong, nonatomic) IBOutlet UILabel *itemCount;
@end
