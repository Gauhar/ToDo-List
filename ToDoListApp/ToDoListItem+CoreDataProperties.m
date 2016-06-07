//
//  ToDoListItem+CoreDataProperties.m
//  ToDoListApp
//
//  Created by Gauhar Shakeel on 2016-05-12.
//  Copyright © 2016 Gauhar Shakeel. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ToDoListItem+CoreDataProperties.h"

@implementation ToDoListItem (CoreDataProperties)

@dynamic itemTitle;
@dynamic itemDescription;
@dynamic itemCreatedAt;
@dynamic itemUpdatedAt;
@dynamic status;
@dynamic list;

@end
