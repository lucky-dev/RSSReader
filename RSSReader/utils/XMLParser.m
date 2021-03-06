//
//  XMLParser.m
//  RSSReader
//
//  Created by Vladimir on 29.08.13.
//  Copyright (c) 2013 Vladimir. All rights reserved.
//

#import "XMLParser.h"
#import "AppDelegate.h"
#import "Constants.h"

@interface XMLParser ()

- (NSDate *)getDateFromString:(NSString *)dateStr;

@end

@implementation XMLParser
{
    NSMutableArray *mListNews;
    NSMutableString *mCurrentElementValue;
    NSMutableDictionary *mNews;
}

- (XMLParser *) initXMLParser
{
    self = [super init];
    
    if (self)
    {
        mListNews = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    mListNews = [[NSMutableArray alloc] init];
    mCurrentElementValue = nil;
    mNews = nil;
}

- (NSArray *)getListNews
{
    return mListNews;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    mCurrentElementValue = nil;
    mNews = nil;
}

- (void)parser:  (NSXMLParser *)parser
didStartElement: (NSString *)elementName
  namespaceURI:  (NSString *)namespaceURI
 qualifiedName:  (NSString *)qName
    attributes:  (NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"item"])
    {
        mNews = [[NSMutableDictionary alloc] init];
    }
    else if ([elementName isEqualToString:@"enclosure"])
    {
        [mNews setValue: [attributeDict objectForKey:@"url"]
                 forKey: @"linkImage"];
    }
}

- (void)parser: (NSXMLParser *)parser
 didEndElement: (NSString *)elementName
  namespaceURI: (NSString *)namespaceURI
 qualifiedName: (NSString *)qName
{
    if ([elementName isEqualToString:@"channel"])
    {
        return;
    }
    
    if ([elementName isEqualToString:@"item"])
    {
        [mListNews addObject:mNews];
    }
    else
    {
        if ([elementName isEqualToString:@"title"])
        {
            [mNews setValue: mCurrentElementValue
                     forKey: @"title"];
        }
        else if ([elementName isEqualToString:@"pubDate"])
        {
            [mNews setValue: [self getDateFromString:mCurrentElementValue]
                     forKey: @"pubDate"];
        }
        else if ([elementName isEqualToString:@"fulltext"])
        {
            [mNews setValue: mCurrentElementValue
                     forKey: @"fullText"];
        }
    }
    
    mCurrentElementValue = nil;
}

- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
    mCurrentElementValue = [[NSMutableString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
}

- (NSDate *)getDateFromString:(NSString *)dateStr;
{
    static NSDateFormatter *dateFormat = nil;
    
    if (!dateFormat)
    {
        dateFormat = [[NSDateFormatter alloc] init];
    }
    
    [dateFormat setDateFormat:DATE_FORMAT_PARSER];
    [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    
    return [dateFormat dateFromString:dateStr];
}

@end
