//
//  News.h
//  RSSReader
//
//  Created by Takeshi Bingo on 2013/07/31.
//  Copyright (c) 2013年 Takeshi Bingo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface News : NSObject

@property (nonatomic,strong) NSString  *title;
@property (nonatomic,strong) NSString *url;
@property (nonatomic,strong) NSString *date;

@end
