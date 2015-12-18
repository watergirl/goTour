//
//  WHUrl.h
//  project
//
//  Created by lanou3g on 15/10/22.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#ifndef WHUrl_h
#define WHUrl_h




//城市酒店资料接口,三个参数已经给出
#define WHHotellModelUrl(thmid , cityid , count)  [NSString stringWithFormat:@"http://www.ly.com/hotels/FindHotel/CarefullyHandler.ashx?action=hotelfoundthemedetail&thmId=%d&cityid=%d&pagesize=8&pageindex=%d", thmid , cityid , count]


//具体的城市资料接口
#define  WHCityUrl(thmid)  [NSString stringWithFormat:@"http://www.ly.com/hotels/FindHotel/CarefullyHandler.ashx?action=themecity&thmid=%d",thmid]


#endif /* WHUrl_h */