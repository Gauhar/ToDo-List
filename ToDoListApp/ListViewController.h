//
//  MasterViewController.h
//  ToDoListApp
//
//  Created by Gauhar Shakeel on 2016-05-12.
//  Copyright © 2016 Gauhar Shakeel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface ListViewController : UITableViewController <NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UITableView *toDoListtableView;

@end

