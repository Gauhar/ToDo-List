//
//  ToDoList.h
//  ToDoListApp
//
//  Created by Gauhar Shakeel on 2016-05-12.
//  Copyright © 2016 Gauhar Shakeel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ToDoListItem;

NS_ASSUME_NONNULL_BEGIN

@interface ToDoList : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "ToDoList+CoreDataProperties.h"
