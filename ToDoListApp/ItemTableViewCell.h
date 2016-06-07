//
//  ItemTableViewCell.h
//  ToDoListApp
//
//  Created by Gauhar Shakeel on 2016-05-16.
//  Copyright © 2016 Gauhar Shakeel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *itemTitle;
@property (strong, nonatomic) IBOutlet UILabel *itemStatus;

@end
