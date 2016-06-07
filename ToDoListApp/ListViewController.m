//
//  MasterViewController.m
//  ToDoListApp
//
//  Created by Gauhar Shakeel on 2016-05-12.
//  Copyright © 2016 Gauhar Shakeel. All rights reserved.
//

#import "ListViewController.h"
#import "ToDoList.h"
#import "ListTableViewCell.h"

#import "ItemListViewController.h"

@interface ListViewController ()
@property (nonatomic) BOOL showEditMode;
@end

@implementation ListViewController

-(void) viewDidLoad
{
    self.toDoListtableView.dataSource = self;
    self.toDoListtableView.delegate = self;
    
   // [self.view addSubview:self.toDoListtableView];
    [self.toDoListtableView registerNib:[UINib nibWithNibName:@"ListTableViewCell" bundle:nil]
                 forCellReuseIdentifier:@"ListCell"];
    
}

-(void) viewDidAppear:(BOOL)animated
{
//    ToDoList *list1 = [NSEntityDescription insertNewObjectForEntityForName:@"ToDoList" inManagedObjectContext:self.managedObjectContext];
//    list1.title = @"Packing Office";
//    list1.category = @"Office";
//    list1.color = @"FC7200";
    
//    ToDoList *list2 = [NSEntityDescription insertNewObjectForEntityForName:@"ToDoList" inManagedObjectContext:self.managedObjectContext];
//    list2.title = @"Buy Grocery";
//    list2.category = @"Personal";
//    list2.color = @"58C300";
//    
//    ToDoList *list3 = [NSEntityDescription insertNewObjectForEntityForName:@"ToDoList" inManagedObjectContext:self.managedObjectContext];
//    list3.title = @"Prepare For Interview";
//    list3.category = @"Other";
//    list3.color = @"5D207F";
    
    //[self _saveContext];
}



- (IBAction)menu:(id)sender {
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    //TODO: Add buttons
    // - create list button
    UIAlertAction *createList = [UIAlertAction actionWithTitle:@"Create a List" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self _showDialogueForList:nil];
    }];
    
    [ac addAction:createList];
    // - delete list
    UIAlertAction *deleteList = [UIAlertAction actionWithTitle: self.editing ? @"Done editing": @"Delete"
        style:self.editing ? UIAlertActionStyleDefault : UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self setEditing:!self.editing animated:YES];
    }];
    [ac addAction:deleteList];
    // update a list (Rename)
    UIAlertAction *update = [UIAlertAction actionWithTitle: self.showEditMode ? @"Exit Edit Mode" : @"Edit List" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.showEditMode = !self.showEditMode;
        [self.tableView reloadData];
    }];
    [ac addAction:update];
    // -cancel
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [ac addAction:cancel];
    
    
    
    [self presentViewController:ac animated:YES completion:nil];
}

-(void) _showDialogueForList:(ToDoList *) listToEdit
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:listToEdit == nil ?@"Add New List" : @"Rename List" message:@"Please enter title and category of your list" preferredStyle:UIAlertControllerStyleAlert];
    
    // - add text field
    [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
       textField.placeholder = @"Add Title";
        
    }];
    
    [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Add Category (office, personal, other)";
    }];
    
    // - cancel button
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [ac addAction:cancelButton];
    // -save button
    UIAlertAction *saveButton = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        // save list
        if(listToEdit != nil)
        {
            if(![ac.textFields[0].text isEqualToString:@""])
            {
                listToEdit.title = ac.textFields[0].text;
            }
            
            if(![ac.textFields[1].text isEqualToString:@""])
            {
                listToEdit.category = ac.textFields[1].text;;
            }
            self.showEditMode = NO;
            
        }
        else
        {
            NSString *title = ac.textFields[0].text;
            NSString *category = ac.textFields[1].text;
            ToDoList *newList = [NSEntityDescription insertNewObjectForEntityForName:@"ToDoList" inManagedObjectContext:self.managedObjectContext];
            newList.title = title;
            newList.category = category;
            if([title isEqualToString:@""] || [category isEqualToString:@""])
            {
                // error alert
                
            }
            if([category isEqualToString:@"office"] || [category isEqualToString:@"Office"])
            {
                //FC7200
                newList.color = @"FC7200";
            }
            if([category isEqualToString:@"personal"] || [category isEqualToString:@"Personal"])
            {
                //58C300
                newList.color = @"58C300";
                
            }
            if([category isEqualToString:@"other"] || [category isEqualToString:@"Other"])
            {
                //5D207F
                newList.color = @"5D207F";
            }
        }
        [self _saveContext];
        [self.tableView reloadData];
    }];
    
    [ac addAction:saveButton];
    
    [self presentViewController:ac animated:YES completion:nil];
}

-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

-(void) _saveContext
{
    NSError *error = nil;
    if ( [self.managedObjectContext hasChanges] && ![self.managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

    
}

#pragma mark - Table View

//- (void) tableView: (UITableView *) tableView accessoryButtonTappedForRowWithIndexPath:(nonnull NSIndexPath *)indexPath
//{
//    [self _showDialogueForList:]
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"ListCell";
   
    
    ListTableViewCell *cell = (ListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    ToDoList *listForRow = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    [self _configureCell:cell withObject:listForRow];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if ( ![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        [self setEditing:NO animated:YES];
    }
}

- (void)_configureCell:(ListTableViewCell *)cell withObject:(ToDoList *)object {
    
     UIView *lineView;
    cell.listTitle.text =  object.title;
    cell.listCategory.text = object.category;
    cell.colorView.backgroundColor = [self colorWithHexString:object.color];
    cell.itemCount.text = [NSString stringWithFormat:@"%d", (int)[object.items count]];
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.frame.size.height - 1.0, cell.contentView.frame.size.width, 1)];
     lineView.backgroundColor = [UIColor grayColor];
    cell.accessoryType = self.showEditMode ? UITableViewCellAccessoryDetailDisclosureButton : UITableViewCellAccessoryDisclosureIndicator;
    [cell.contentView addSubview:lineView];
}

- (void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self _showDialogueForList:[self.fetchedResultsController objectAtIndexPath:indexPath]];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ItemListViewController *itemListView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ItemListViewController"];
    itemListView.list = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self presentViewController:itemListView animated:YES completion:nil];
     
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ToDoList" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];

    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Lists"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	     // Replace this implementation with code to handle the error appropriately.
	     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}    

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self _configureCell:[tableView cellForRowAtIndexPath:indexPath] withObject:anObject];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

@end
