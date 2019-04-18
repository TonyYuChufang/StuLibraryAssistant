//
//  SLDetailCells.h
//  StuLibraryAssistant
//
//  Created by yu on 2019/4/17.
//  Copyright © 2019 yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLCollectInfoCell : UITableViewCell
+ (NSString *)reuseId;
@end

@interface SLDetailInfoCell : UITableViewCell
+ (NSString *)reuseId;
@end

@interface SLScoreOtherCell : UITableViewCell
+ (NSString *)reuseId;
@end

@class SLStarPointView;
@interface SLScoreMyCell : UITableViewCell
@property (nonatomic, strong) SLStarPointView *starPointView;
+ (NSString *)reuseId;
@end
