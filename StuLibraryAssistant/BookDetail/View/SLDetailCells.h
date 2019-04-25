//
//  SLDetailCells.h
//  StuLibraryAssistant
//
//  Created by yu on 2019/4/17.
//  Copyright © 2019 yu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SLBookLoactionViewModel;
@interface SLCollectInfoCell : UITableViewCell
- (void)bindBookLocationViewModel:(SLBookLoactionViewModel *)viewModel;
+ (NSString *)reuseId;
@end

@interface SLDetailInfoCell : UITableViewCell
- (void)updateDetailInfoWith:(NSString *)title content:(NSString *)content;
+ (NSString *)reuseId;
+ (CGFloat)heightForDetailCellWithContent:(NSString *)content;
@end

@class SLBookScoreViewModel;
@interface SLScoreOtherCell : UITableViewCell
+ (NSString *)reuseId;
- (void)bindBookScoreViewModel:(SLBookScoreViewModel *)viewModel;
@end

@class SLStarPointView;
@interface SLScoreMyCell : UITableViewCell
@property (nonatomic, strong) SLStarPointView *starPointView;
+ (NSString *)reuseId;
- (void)bindBookScoreViewModel:(SLBookScoreViewModel *)viewModel;
@end
