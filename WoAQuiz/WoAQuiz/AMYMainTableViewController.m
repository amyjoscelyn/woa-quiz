//
//  AMYMainTableViewController.m
//  DreamGame
//
//  Created by Amy Joscelyn on 1/19/16.
//  Copyright © 2016 Amy Joscelyn. All rights reserved.
//

#import "AMYMainTableViewController.h"
#import "AMYStoryDataStore.h"
#import "ZhuLi.h"

@interface AMYMainTableViewController ()

@property (nonatomic, strong) AMYStoryDataStore *dataStore;
@property (nonatomic, strong) ZhuLi *zhuLi;
@property (strong, nonatomic) Question *currentQuestion;
@property (strong, nonatomic) NSArray *sortedChoices;
@property (strong, nonatomic) NSMutableArray *choicesArray;

@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) NSMutableArray *colorsArray;
@property (nonatomic, strong) UIColor *topColor;
@property (nonatomic, strong) UIColor *bottomColor;

@property (nonatomic) CGFloat textHue;

@property (nonatomic) NSInteger selectedRow;

@end

@implementation AMYMainTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.dataStore = [AMYStoryDataStore sharedStoryDataStore];
    
    [self.dataStore fetchData];
    
    [self setCurrentQuestionOfStory:self.dataStore.playthrough.currentQuestion];
    
    self.selectedRow = 10;
    
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = self.view.frame;
//    self.gradientLayer.frame = self.view.bounds; //this seems to have the same result as line above
    [self.view.layer insertSublayer:self.gradientLayer atIndex:0]; //maybe play around with this to see if i can make it not turn gray at the bottom
    
    //add a mask layer to cover the entire gradient layer?
    /*
     CALayer *maskLayer = [CALayer layer];
    
    maskLayer.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.5f].CGColor; //this color can be the current background color of the cells, then I can make the cells clear
    maskLayer.contents = (id)[[UIImage imageNamed:@"maskImage.png"] CGImage]; //I don't think I need this line of code here
    
    maskLayer.contentsGravity = kCAGravityCenter; //what is this?
    maskLayer.frame = YourLabel.bounds; //these wouold be the view bounds
    YourLabel.layer.mask = maskLayer;
     */
    
    self.zhuLi = [ZhuLi new];
    
    self.colorsArray = [[NSMutableArray alloc] init];
    
    self.topColor = [UIColor colorWithRed:255/255.0 green:233/255.0 blue:200/255.0 alpha:1.0];
    [self.colorsArray addObject:(id)self.topColor.CGColor];
    [self.colorsArray addObject:(id)self.topColor.CGColor];
    
    [self changeBackgroundColor];
}

- (void)changeBackgroundColor //this method can definitely be broken into several smaller methods
{
    NSNumber *charm = @(self.dataStore.playerCharacter.charm);
    NSNumber *practical = @(self.dataStore.playerCharacter.practical);
    NSNumber *history = @(self.dataStore.playerCharacter.history);
    NSNumber *potions = @(self.dataStore.playerCharacter.potions);
    NSNumber *healing = @(self.dataStore.playerCharacter.healing);
    NSNumber *divining = @(self.dataStore.playerCharacter.divining);
    NSNumber *animalia = @(self.dataStore.playerCharacter.animalia);
    
    //maybe this part can be a separate method, everything to do with this array of dictionaries
    NSArray *arrayOfMajors = @[ @{ @"major" : @"charm"      ,
                                   @"value" : charm },
                                @{ @"major" : @"practical"  ,
                                   @"value" : practical },
                                @{ @"major" : @"history"    ,
                                   @"value" : history },
                                @{ @"major" : @"potions"    ,
                                   @"value" : potions },
                                @{ @"major" : @"healing"    ,
                                   @"value" : healing },
                                @{ @"major" : @"divining"   ,
                                   @"value" : divining },
                                @{ @"major" : @"animalia"   ,
                                   @"value" : animalia },
                                @{ @"major" : @"new game"   ,
                                   @"value" : @1 }
                                ];
    
    NSSortDescriptor *sortByHighestValue = [NSSortDescriptor sortDescriptorWithKey:@"value" ascending:NO];
    NSArray *sortedArrayOfMajors = [arrayOfMajors sortedArrayUsingDescriptors:@[sortByHighestValue]];
    
        // can these below be moved into their own method???? they have nothing to do with changing the background color
    
    //these are the NSDict top three majors
    NSDictionary *highestValueMajor = sortedArrayOfMajors.firstObject;
    NSDictionary *secondHighestValueMajor = sortedArrayOfMajors[1];
    NSDictionary *thirdHighestValueMajor = sortedArrayOfMajors[2];
    
    //this is the first major broken out into String and Int
    NSString *primaryMajor = highestValueMajor[@"major"];
    NSNumber *primaryMajorValue = highestValueMajor[@"value"];
    NSInteger primaryMajorInteger = primaryMajorValue.integerValue;

    //this determines whether the user is accepted (REQUIRES primaryMajorInteger)
    if (primaryMajorInteger > 10)
    {
        self.dataStore.playerCharacter.accepted = YES;
    }
    else
    {
        self.dataStore.playerCharacter.accepted = NO;
    }
    
    //this is breaking out the value of the second major
    NSNumber *secondMajorValue = secondHighestValueMajor[@"value"];
    NSInteger secondMajorInteger = secondMajorValue.integerValue;
    
    //this is breaking out the value of the third major
    NSNumber *thirdMajorValue = thirdHighestValueMajor[@"value"];
    NSInteger thirdMajorInteger = thirdMajorValue.integerValue;
    
    //this is alloc initing a second major
    NSString *secondaryMajor = @"";
    NSNumber *secondaryMajorValue = @0;
    NSInteger secondaryMajorInteger = 0;
    
    //this is testing between the second and third major's value (RETURNS secondaryMajor and secondaryMajorInteger) (REQUIRES secondMajorInteger, thirdMajorInteger)
    if (secondMajorInteger == thirdMajorInteger)
    {
        //there is a tie.
        if ([thirdHighestValueMajor[@"major"] isEqualToString:@"divining"])
        {
            secondaryMajor = thirdHighestValueMajor[@"major"];
            secondaryMajorValue = thirdHighestValueMajor[@"value"];
            secondaryMajorInteger = secondaryMajorValue.integerValue;
        }
    }
    else
    {
        secondaryMajor = secondHighestValueMajor[@"major"];
        secondaryMajorValue = secondHighestValueMajor[@"value"];
        secondaryMajorInteger = secondaryMajorValue.integerValue;
    }
    
    //this is determining whether the user is a diviner, and skilled at that (REQUIRES primaryMajor/Integer and secondaryMajor/Integer)
    if ([primaryMajor isEqualToString:@"divining"])
    {
        self.dataStore.playerCharacter.diviner = YES;
        if (primaryMajorInteger > 8)
        {
            self.dataStore.playerCharacter.skilledDiviner = YES;
        }
        else
        {
            self.dataStore.playerCharacter.skilledDiviner = NO;
        }
    }
    else if ([secondaryMajor isEqualToString:@"divining"])
    {
        self.dataStore.playerCharacter.diviner = YES;
        if (secondaryMajorInteger > 8)
        {
            self.dataStore.playerCharacter.skilledDiviner = YES;
        }
        else
        {
            self.dataStore.playerCharacter.skilledDiviner = NO;
        }
    }
    else
    {
        self.dataStore.playerCharacter.diviner = NO;
    }
    
    //all of the above should be in its own method, but still capable of accessing the three dictionary key-value pairs
    //maybe the method can take all three in as parameters

    self.bottomColor = [self.zhuLi colorFromPrimaryMajor:primaryMajor];

    [self.colorsArray replaceObjectAtIndex:1 withObject:(id)self.bottomColor.CGColor];
    
    self.gradientLayer.colors = self.colorsArray;
    
    self.dataStore.playerCharacter.chosenMajor = primaryMajor;
//    NSLog(@"the major color is %@", self.dataStore.playerCharacter.chosenMajorColor);
}

- (void)setCurrentQuestionOfStory:(Question *)currentQuestion
{
    _currentQuestion = currentQuestion;
    _sortedChoices = [currentQuestion.choiceOuts sortedArrayUsingDescriptors:@[self.dataStore.sortByStoryIDAsc]];
    
    _dataStore.playthrough.currentQuestion = currentQuestion;
    
    [_dataStore saveContext];
    
    [self generateChoicesArrayForCurrentQuestion:currentQuestion];
}

- (void)generateChoicesArrayForCurrentQuestion:(Question *)currentQuestion
{
    self.choicesArray = [[NSMutableArray alloc] init];
    
    if (self.sortedChoices.count > 0)
    {
        if ([currentQuestion.storyID isEqualToString:@"q156"])
        {
            NSString *choiceStoryID = @"";
            if (self.dataStore.playerCharacter.accepted)
            {
                if (self.dataStore.playerCharacter.diviner)
                {
                    if (self.dataStore.playerCharacter.skilledDiviner)
                    {
                        //Skilled Diviner Accepted
                        choiceStoryID = @"c156.3";
                    }
                    else
                    {
                        //Unskilled Diviner Accepted
                        choiceStoryID = @"c156.5";
                    }
                }
                else
                {
                    //Accepted
                    choiceStoryID = @"c156.1";
                }
            }
            else
            {
                if (self.dataStore.playerCharacter.diviner)
                {
                    if (self.dataStore.playerCharacter.skilledDiviner)
                    {
                        //Skilled Diviner Rejected
                        choiceStoryID = @"c156.2";
                    }
                    else
                    {
                        //Unskilled Diviner Rejected
                        choiceStoryID = @"c156.4";
                    }
                }
                else
                {
                    //Rejected
                    choiceStoryID = @"c156.0";
                }
            }
            for (Choice *choice in currentQuestion.choiceOuts)
            {
                if ([choice.storyID isEqualToString:choiceStoryID])
                {
                    [self.choicesArray addObject:choice];
                }
            }
        }
        else
        {
            for (Choice *choice in currentQuestion.choiceOuts)
            {
                if (choice.prerequisites.count == 0)
                {
                    [self.choicesArray addObject:choice];
                }
                else
                {
                    BOOL passesCheck = NO;
                    
                    for (Prerequisite *prereq in choice.prerequisites)
                    {
                        //passesCheck must come back as YES to be displayed among the choices
                        passesCheck = [self.zhuLi checkPrerequisite:prereq];
                        
                        if (passesCheck)
                        {
//                            NSLog(@"%@ should be displayed", choice.content);
                            [self.choicesArray addObject:choice];
                        }
                        else //I don't really need this but I'll keep it here for now to make sure it works
                        {
//                            NSLog(@"%@ should NOT be displayed", choice.content);
                        }
                    }
                }
            }
        }
    } //this is so ugly
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
        {
            return 1;
        }
        case 1:
        {
            NSInteger choiceOutsCount = self.choicesArray.count;
            if (choiceOutsCount > 0)
            {
                return choiceOutsCount;
            }
            else
            {
                return 1;
            }
        }
        default:
        {
            return 0;
        }
    }
}

//this is a messy, messy method
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StoryCell" forIndexPath:indexPath];
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (self.dataStore.playthrough.fontChange)
    {
        [cell.textLabel setFont:[UIFont fontWithName:@"Palatino" size:22.5]];
    }
    else
    {
        [cell.textLabel setFont:[UIFont systemFontOfSize:23.5]];
    }
    
    if (section == 0)
    {
        NSString *content = [self.currentQuestion.content mutableCopy];
        
        if ([content containsString:@"#"])
        {
            content = [self.zhuLi replaceContent:content];
        }
        cell.textLabel.text = content;
        cell.textLabel.textColor = [UIColor colorWithHue:self.textHue saturation:1.0 brightness:0.25 alpha:1.0];
        cell.textLabel.numberOfLines = 0;
        
        cell.detailTextLabel.hidden = YES;
        
        cell.userInteractionEnabled = NO;
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 45;
    }
    else if (section == 1)
    {
        if (self.choicesArray.count > 0)
        {
            Choice *choice = self.choicesArray[row];
            cell.textLabel.text = choice.content;
        }
        else if (self.currentQuestion.questionAfter)
        {//maybe this should be in section 3, and hide section 2?
            cell.textLabel.text = @"Continue";
        }
        else if ([self.currentQuestion.content isEqualToString:@"THE END."])
        {
            cell.textLabel.text = @"(tap to restart)";
        }
        else
        {
            cell.textLabel.text = @"You have reached a precarious end with no further content! (Hang here for a bit or tap to restart)";
        }
        cell.textLabel.textColor = [UIColor colorWithHue:self.textHue saturation:1.0 brightness:0.5 alpha:1.0];
        cell.textLabel.numberOfLines = 0;
        cell.detailTextLabel.hidden = YES;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = indexPath.section;
    NSUInteger indentation = 0;
    
    if (section)
    {
        indentation += 3;
    }
    return indentation;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) { return; }
    
    NSUInteger row = indexPath.row;
    
    if (self.selectedRow != row)
    {
        self.selectedRow = row;
        return;
    }
    
    if (self.currentQuestion.effects.count > 0)
    {
        //this takes care of effects the currentQuestion might incur
        for (Effect *thing in self.currentQuestion.effects)
        {
            [self.zhuLi doThe:thing];
        }
    }
    
    if (self.currentQuestion.questionAfter)
    {
        [self setCurrentQuestionOfStory:self.currentQuestion.questionAfter];
    }
    else if (self.choicesArray.count > 0)
    {
        Choice *selectedChoice = self.choicesArray[row];
        
        if (selectedChoice.effects.count)
        {
            for (Effect *thing in selectedChoice.effects)
            {
                if ([thing.stringValue isEqualToString:@""])
                {
                    Choice *selectedChoice = self.choicesArray[row];
                    thing.stringValue = selectedChoice.content;
                }
                [self.zhuLi doThe:thing];
            }
        }
        [self setCurrentQuestionOfStory:selectedChoice.questionOut];
    }
    else
    {
        [self setCurrentQuestionOfStory:self.dataStore.questions[0]];
        
        // below resets the properties
        [self.zhuLi resetAttributes];
        self.textHue = 0;
//        self.saturation = 0.8;
        
        [_dataStore saveContext];
        
        // go to next chapter or restart here
    }
    [self changeBackgroundColor];
    self.selectedRow = 10;
    
    [self.tableView reloadData];
}

/*
 suggestion to make everything clear or blurry, but not the awkward gray of the background right now
 maybe a different text color--a gray, brown, or black, perhaps
 
 also, take away the tab-view controller?  i don't need it for this quiz
 */

@end
