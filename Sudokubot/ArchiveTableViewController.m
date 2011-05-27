//
//  ArchiveTableViewController.m
//  Sudokubot
//
//  Created by Haoest on 4/12/11.
//  Copyright 2011 none. All rights reserved.
//

#import "ArchiveTableViewController.h"
#import "AppConfig.h"
#import "ArchiveEntry.h"
#import "BoardViewController.h"

@implementation ArchiveTableViewController

@synthesize archiveContents;
@synthesize rootViewDelegate;

- (void)dealloc
{
    [super dealloc];
    if (self.archiveContents){
        [self.archiveContents release];
    }
}

-(void) viewDidLoad{
    [super viewDidLoad];
}

+(ArchiveTableViewController*) archiveTableViewControllerFromDefaultArchive{
    ArchiveTableViewController* rv = [[ArchiveTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [rv reloadDataSource];
    return rv;
}

-(void) reloadDataSource{
    ArchiveManager* archiveManager = [[ArchiveManager alloc]initDefaultArchive];
    NSArray* contents = [archiveManager getAllEntries];
    self.archiveContents = contents;
    [archiveManager release];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rv = [self.archiveContents count]; // exclude last row
    return rv;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	NSString *rowId = [NSString stringWithFormat:@"myRowId_%d", indexPath.row];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rowId];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rowId] autorelease];
	}
    ArchiveEntry *archiveEntry = [self.archiveContents objectAtIndex:indexPath.row];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[AppConfig archiveDateFormat]];
	NSString *label = [NSString stringWithFormat:@"%@ : %@", [dateFormatter stringFromDate:[archiveEntry getCreationDateGMT]], archiveEntry.comments ];
    [dateFormatter release];
	cell.textLabel.text = label;
    UIFont* font = cell.textLabel.font;
    cell.textLabel.font = [font fontWithSize:[AppConfig archiveCellFontHeight]];  
	return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [AppConfig archiveCellHeight];
}

-(void) tableView: (UITableView*) tableView didSelectRowAtIndexPath:(NSIndexPath*) indexPath{
    NSArray *archive = self.archiveContents;
    NSInteger index = indexPath.row;
    ArchiveEntry* entry = [archive objectAtIndex:index];
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    int entryId = entry.entryId;
    [self.rootViewDelegate showBoardViewWithEntry:entry];
}

@end
