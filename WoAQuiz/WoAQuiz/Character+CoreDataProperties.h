//
//  Character+CoreDataProperties.h
//  WoAQuiz
//
//  Created by Amy Joscelyn on 3/29/16.
//  Copyright © 2016 Amy Joscelyn. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Character.h"

NS_ASSUME_NONNULL_BEGIN

@interface Character (CoreDataProperties)

@property (nonatomic) BOOL accepted;
@property (nonatomic) int64_t animalia;
@property (nonatomic) int64_t charm;
@property (nonatomic) int64_t chosenMajorValue;
@property (nonatomic) BOOL diviner;
@property (nonatomic) int64_t divining;
@property (nonatomic) int64_t diviningSkill;
@property (nonatomic) int64_t healing;
@property (nonatomic) int64_t history;
@property (nonatomic) int64_t potions;
@property (nonatomic) int64_t practical;
@property (nonatomic) BOOL skilledDiviner;
@property (nullable, nonatomic, retain) NSString *stateOfAcceptance;
@property (nullable, nonatomic, retain) NSString *chosenMajor;
@property (nullable, nonatomic, retain) NSString *chosenMajorColor;
@property (nullable, nonatomic, retain) Playthrough *playthrough;

@end

NS_ASSUME_NONNULL_END
