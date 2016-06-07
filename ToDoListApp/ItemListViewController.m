//
//  ItemListViewController.m
//  ToDoListApp
//
//  Created by Gauhar Shakeel on 2016-05-16.
//  Copyright © 2016 Gauhar Shakeel. All rights reserved.
//

#import "ItemListViewController.h"
#import "ToDoListItem.h"
#import "ItemTableViewCell.h"
#import "AppDelegate.h"


@interface ItemListViewController ()
@property (nonatomic, strong) NSArray *items;
@property Boolean showEditMode;
@property AppDelegate *appDel;
@property NSManagedObjectContext * context;

@end

@implementation ItemListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.itemListTableView registerNib:[UINib nibWithNibName:@"ItemTableViewCell" bundle:nil]
                 forCellReuseIdentifier:@"itemCell"];
    
    self.itemListTableView.dataSource = self;
    self.itemListTableView.delegate = self;
    
    _appDel = [[UIApplication sharedApplication] delegate];
    _context = _appDel.managedObjectContext;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void) viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    
//    if([self.list.items count] == 0)
//    {
//        //        AppDelegate *appDel = [[UIApplication sharedApplication] delegate];
//        //        NSManagedObjectContext *context = appDel.managedObjectContext;
//        ToDoListItem *item = [NSEntityDescription insertNewObjectForEntityForName:@"ToDoListItem" inManagedObjectContext:_context];
//        item.itemTitle = @"Item 1";
//        item.status = @"Not Started";
//        item.list = self.list;
//        
//        [self _saveContext];
//        self.items = nil; // force a refresh
//        [self.itemListTableView reloadData];
//    }
//    
//}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = self.list.title;
    
    
    
}

-(void) _saveContext
{
    //    AppDelegate *appDel = [[UIApplication sharedApplication] delegate];
    //    NSManagedObjectContext *context = appDel.managedObjectContext;
    
    NSError *error = nil;
    if ( [_context hasChanges] && ![_context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (NSArray *) items
{
    if(_items == nil)
    {
        _items = self.list.items.allObjects;
    }
    
    return _items;
}

- (void)_configureCell:(ItemTableViewCell *)cell withObject:(ToDoListItem *)object {
    
    cell.itemTitle.text =  object.itemTitle;
    cell.itemStatus.text = object.status;
    cell.accessoryType = self.showEditMode ? UITableViewCellAccessoryDetailDisclosureButton : UITableViewCellAccessoryDisclosureIndicator;
}

- (IBAction)menu:(id)sender {
    UIAlertController *menuActionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    //TODO: create new item, rename new items, delete
    
    UIAlertAction *createItem = [UIAlertAction actionWithTitle:@"Add New Item" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self _showDialogueForList:nil];
    }];
    [menuActionSheet addAction:createItem];
    UIAlertAction *deleteList = [UIAlertAction actionWithTitle: self.editing ? @"Done editing": @"Delete" style:self.editing ? UIAlertActionStyleDefault : UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    [self setEditing:!self.editing animated:YES];
    }];
    [menuActionSheet addAction:deleteList];
    // update a list (Rename)
    UIAlertAction *update = [UIAlertAction actionWithTitle: self.showEditMode ? @"Exit Edit Mode" : @"Edit Item" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.showEditMode = !self.showEditMode;
        [self.itemListTableView reloadData];
    }];
    [menuActionSheet addAction:update];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [menuActionSheet addAction:cancel];
    
    [self presentViewController:menuActionSheet animated:YES completion:nil];
    
    
}

-(void) _showDialogueForList:(ToDoListItem *) itemToEdit
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:itemToEdit == nil ?@"Add New Item" : @"Rename Item" message:@"Please enter title and status of your item" preferredStyle:UIAlertControllerStyleAlert];
    
    // - add text field
    [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Add Title";
        
    }];
    
    [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Add status (New, In Progress, Completed)";
    }];
    
    // - cancel button
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [ac addAction:cancelButton];
    // -save button
    UIAlertAction *saveButton = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        // save list
        _appDel = [[UIApplication sharedApplication] delegate];
        _context = _appDel.managedObjectContext;
        if(itemToEdit != nil)
        {
            if(![ac.textFields[0].text isEqualToString:@""])
            {
                itemToEdit.itemTitle = ac.textFields[0].text;
            }
            
            if(![ac.textFields[1].text isEqualToString:@""])
            {
                itemToEdit.status = ac.textFields[1].text;;
            }
            itemToEdit.list = self.list;
            self.showEditMode = NO;
            
        }
        else
        {
            NSString *title = ac.textFields[0].text;
            NSString *status = ac.textFields[1].text;
            
            ToDoListItem *newItem = [NSEntityDescription insertNewObjectForEntityForName:@"ToDoListItem" inManagedObjectContext:_context];
            newItem.itemTitle = title;
            newItem.status = status;
            newItem.list = self.list;
        }
        [self _saveContext];
        self.items = nil; // force a refresh
        [self.itemListTableView reloadData];    }];
    
    [ac addAction:saveButton];
    
    [self presentViewController:ac animated:YES completion:nil];
}

- (IBAction)dismissView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.items count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"itemCell";
    ItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    ToDoListItem *item = [self.items objectAtIndex:indexPath.row];
    [self _configureCell:cell withObject: item];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [_context deleteObject:[self.items objectAtIndex:indexPath.row]];
        
        NSError *error = nil;
        if ( ![_context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        self.items = nil;
        [self.itemListTableView reloadData];
        [self setEditing:NO animated:YES];
    }
}

- (void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self _showDialogueForList:[self.items objectAtIndex:indexPath.row]];
}



/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */



@end