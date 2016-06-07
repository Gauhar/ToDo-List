//
//  ToDoList+CoreDataProperties.h
//  ToDoListApp
//
//  Created by Gauhar Shakeel on 2016-05-12.
//  Copyright © 2016 Gauhar Shakeel. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ToDoList.h"

NS_ASSUME_NONNULL_BEGIN

@interface ToDoList (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSDate *createdAt;
@property (nullable, nonatomic, retain) NSDate *updatedAt;
@property (nullable, nonatomic, retain) NSString *category;
@property (nullable, nonatomic, retain) NSString *color;
@property (nullable, nonatomic, retain) NSSet<ToDoListItem *> *items;

@end

@interface ToDoList (CoreDataGeneratedAccessors)

- (void)addItemsObject:(ToDoListItem *)value;
- (void)removeItemsObject:(ToDoListItem *)value;
- (void)addItems:(NSSet<ToDoListItem *> *)values;
- (void)removeItems:(NSSet<ToDoListItem *> *)values;

@end

NS_ASSUME_NONNULL_END
