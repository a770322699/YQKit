//
//  UISearchBar+YQCategory.m
//  CodingRiver_iOS
//
//  Created by maygolf on 16/10/11.
//  Copyright © 2016年 Mars-Jae. All rights reserved.
//

#import "UISearchBar+YQCategory.h"

@implementation UISearchBar (YQCategory)

- (UITextField *)yq_textField{
    return [self valueForKey:@"_searchField"];
}

- (UIButton *)yq_cancelButton{
    return [self valueForKey:@"_cancelButton"];
}

@end
