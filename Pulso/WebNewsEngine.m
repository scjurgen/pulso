//
//  WebNewsEngine.m
//  testnewopengl
//
//  Created by Schwietering, Jürgen on 22.03.14.
//  Copyright (c) 2014 Jürgen Schwietering. All rights reserved.
//

#import "WebNewsEngine.h"
#import "DataLoader/MHDPublicInterface.h"
#import "DataLoader/DataTypes/MHDArticle.h"


char *randId[]=
{
    "c3847b605fd767abcefde95987725a75",
    "85d1a0da31a13403276e8385c2e838d9",
    "0d6ecf7c2621a2d86637617e54eba039",
    "3c78f8c279520a94b021628f5fff0d3c",
    "47d8886aeaab3a4bf841014b0d68fe0f",
    "2399dcdb2355bc891e8d74b61ed88a28",
    "e8cd09d44d92253af53eba77bc1ae4b2",
    "c51df026d7f2544812d9776b6509831b",
    "7381761af1ff1188f54977de7383f6dc",
    "aa5a87555b0a9a257824fa237585b4ec",
    "9d6f67fda2e60c576589d838ca3ef585",
    "aebeefcea7b2898fd1354ca7b4662fb3",
    "542fad583cd5cf097823e166d272550b",
    "4e34173f57a3f42ad89085fb99d38564",
    "61b5d049d2593940c67e4cb6de836f7c",
    "deced8696d5e14654da30297ff650fd0",
    "d652f5b51643b4ddbaed4ebd00bafd07",
    "f367d9dce91b9aa0d0617cf4514625ec",
    "72db834443dde532f8dcadaabcfb8cc4",
    "b09675816c35fbf490beac8f209404da",
    "46274f458da00c91e588c3b30924bb08",
    "72db834443dde532f8dcadaabcfb8cc4",
    "394a83f34ea0f9b65eff4ccc1922f413",
    "37376d8431c2eb4942931bc7a7bc9aee",
    "58ff482bf2a66c1a1e074c4b8bd43e20",
    "4ed090d7011b0676e76afa5c16597025",
    "446c234208deb278aa582d90de2b118b",
    "9a275cd6b5f19f4436d84d6bd1eee9a6",
    "672a6bc171289d3d7308ded11b06e941",
    "2503a5676b6b3be059d50e8867e2cd47",
    "ec5de4102d3e5ac37256821a2bc9713f",
    "cc2010c47ceb2a2d9c11ec27f417aace",
    "8dc5ceebc48b902feb6fd30261ecc7a0",
    "c5809a762ef4d0714e125f9e1b9dffa4",
    "a8faad0c69625ae7e034dc96ebb6fbbd",
    "609034dbb26b788880d52e1c5cd08004",
    "bd448d9c1a9e126af2963e12d6bf5472",
    "2503a5676b6b3be059d50e8867e2cd47",
    "a07c07d3ccaf22d17117c3196e7f02e4",
    "37ca94f98fab26e6e53d9d1c7e27c56c",
    "e287eaa605594cd92819250428a2072f",
    "7e47e2c4808b18190bda918166fb4cdd",
    "dc8c5b7c1655f93122ca6df78edc9355",
    "cb09ccfffdd605106635636d1ec41ef0",
    "45843eadf460cfe25110dbf1b1f66b00",
    "18da6090877188239fbd4d0addfd07ba",
    "31baab99c14b364f5180c7165d1ff3dd",
    "6faccc90f214bdb63743932efd2df610",
    "36a84bef576a1c9ceb74cff895fb97b5",
    "d8c68df2823a9605b6831d9368827858",
    "72b970ab2621dfd22814665db53957bc",
    "ec1610c8a30c8820299aad85130f1947",
    "dad6f55aa87cc4cf09c8ea4faffece37",
    "b45c8a69a530514501e173cb21a4f2c9",
    "40d1ec500e6c0b0d99348144f992b444",
    "cee01cd4b4ff5e41b7338481f1743bba",
    "3934178b7cfd6dc18fa08aa3754d8626",
    "52dd0af9a2d2b97f83329acdd7a231cf",
    "334c9f49ccb82bcbd6a06308522a0614",
    "3e34a9e18a3b6cd587b3846ebf299db6",
    "072328f964bd5bdb475b5ab505b1211f",
    "79800d0573ecf9bff03427891544bde0",
    "ffeec914020ba5e085c8010ec2e8fd26",
    "9a2a8e08b498492870c4f5ffa10593c4",
    "aab8a15eb87e5100f4e6f71e35281d4f",
    "e270e6eb67968b3c0e4feb5f32d01714",
    "f5acc2eacc70b27e9480e7ebb502cb5a",
    "aedbc47c606109a55192bf088266ed2c",
    "127af441c9d051cc66c49005e8e1fe39",
    "038fae153a5cbdaeb98050a517205abf",
    "f9dc0b3eee151e11cbfa1c5d0ffe370c",
    "effecdd60d93ed985a676351b8405adf",
    "1c7b3e1351ca9655307ee483689c90cf",
    "3a712aa28db0cd59b7c2420f5e117bc2",
    "a9521dc84a0f3ff92dd5cc7b09bcef21",
    "ca39fa99cc88b719e3a90d200131b230",
    "038fae153a5cbdaeb98050a517205abf",
    "b12875e3a8d9bcef126b7a36ace4a61c",
    "b6743d731d72555bdec0a4013061ab82",
    "b32e116d24604d5e11a33e4608731190",
    "fce7a019320c819d304608f2d74a32d1",
    "4c0f927b85535905f59b242564a78840",
    "6984048100c2597b65f3011423a802f9",
    "9a2a8e08b498492870c4f5ffa10593c4",
    "5e470985c66d1615884c0bd963b18758"
};

@interface WebNewsEngine ()

@property(nonatomic, retain)NSString *contentString;

@end
@implementation WebNewsEngine

- (id)init
{
    self = [super init];
    if (self)
    {
        _htmlTemplate = nil;

    }
    return self;
}


- (void)defineTemplate:(NSString*)templateName
{
    NSString *bundleHtml = [[NSBundle mainBundle] pathForResource:templateName ofType:@"html"];
    if (bundleHtml==nil)
        return;
    NSURL *path = [NSURL fileURLWithPath:bundleHtml];
    _htmlTemplate =  [NSString  stringWithContentsOfURL:path encoding:NSUTF8StringEncoding error:nil];
}

- (NSString *)mapResourcePath:(NSString*)resource ofType:(NSString*)resourceType
{
    NSString *resourcePath = [[[[NSBundle mainBundle]
                                pathForResource:resource ofType:@"jpg"]
                               stringByReplacingOccurrencesOfString:@"/" withString:@"//"]
                              stringByReplacingOccurrencesOfString:@" " withString:@"%20"];

    return [NSString stringWithFormat:@"file:/%@", resourcePath];
}

-(void)createHtmlUsingBlock:(MHDHTMLContentBlock)result
{
    if (_htmlTemplate==nil)
    {
        result(nil, nil);
    }
    [self loadContentUsingBlock:^(MHDArticle *article, NSString *htmltemplate) {
        
        result(article, _htmlTemplate);
        
    }];
}

- (void)loadContentUsingBlock:(MHDHTMLContentBlock)result {

    NSString *articleId = [NSString stringWithFormat:@"%s",randId[rand()%40]];
    [MHDPublicInterface getArticleForId:articleId
                              onSuccess:^(id resultSuccess) {
                                  MHDArticle *article = (MHDArticle *)resultSuccess;
                                  _contentString = article[@"content"];
                                  // NSLog(@"%@", (MHDArticle *)resultSuccess);
                                  
                                  result(article, _htmlTemplate);
                              }
                              onFailure:^(id resultFailure) {
                                  NSLog(@"%@", (MHDArticle *)resultFailure);
                                  
                                  result(nil, _htmlTemplate);
                              }];
    
}


@end
