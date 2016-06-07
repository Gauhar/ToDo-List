//
//  ItemListViewController.h
//  ToDoListApp
//
//  Created by Gauhar Shakeel on 2016-05-16.
//  Copyright © 2016 Gauhar Shakeel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToDoList.h"

@interface ItemListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) ToDoList *list;

@property (strong, nonatomic) IBOutlet UITableView *itemListTableView;
- (IBAction)menu:(id)sender;
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;

- (IBAction)dismissView:(id)sender;
@end

