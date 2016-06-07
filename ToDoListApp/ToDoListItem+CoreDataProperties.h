//
//  ToDoListItem+CoreDataProperties.h
//  ToDoListApp
//
//  Created by Gauhar Shakeel on 2016-05-12.
//  Copyright © 2016 Gauhar Shakeel. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ToDoListItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface ToDoListItem (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *itemTitle;
@property (nullable, nonatomic, retain) NSString *itemDescription;
@property (nullable, nonatomic, retain) NSDate *itemCreatedAt;
@property (nullable, nonatomic, retain) NSDate *itemUpdatedAt;
@property (nullable, nonatomic, retain) NSString *status;
@property (nullable, nonatomic, retain) ToDoList *list;

@end

NS_ASSUME_NONNULL_END
