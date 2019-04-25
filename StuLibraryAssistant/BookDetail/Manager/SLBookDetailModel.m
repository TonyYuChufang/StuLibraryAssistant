//
//  SLBookDetailModel.m
//  StuLibraryAssistant
//
//  Created by yu on 2019/4/18.
//  Copyright © 2019 yu. All rights reserved.
//

#import "SLBookDetailModel.h"

@implementation SLBookDetailModel

@end

@implementation SLBookLocationModel

@end

@implementation SLBookScoreModel

@end

@implementation SLBookDetailInfoModel

@end

@implementation SLBookContentInfoModel
+ (SLBookContentInfoModel *)contentInfoTitle:(NSString *)title content:(NSString *)content
{
    SLBookContentInfoModel *contentModel = [[SLBookContentInfoModel alloc] init];
    contentModel.title = title;
    contentModel.content = content;
    
    return contentModel;
}
@end
