//
//  AlbumTVC.m
//  SNImagePicker
//
//  Created by Narek Safaryan on 2/23/14.
//  Copyright (c) 2014 X-TECH creative studio. All rights reserved.
//

#import "SNAlbumTVC.h"
#import "SNImagePickerNC.h"

@interface SNAlbumTVC ()

@end

@implementation SNAlbumTVC

@synthesize assetGroups = _assetGroups;
@synthesize library = _library;

#pragma - mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.navigationItem setTitle:@"Albums"];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Huỷ" style:UIBarButtonItemStyleDone target:self action:@selector(dismissImagePicker)];
    [cancelButton setTitle:@"Huỷ"];
    [cancelButton setTintColor:[UIColor whiteColor]];
	[self.navigationItem setRightBarButtonItem:cancelButton];
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
	self.assetGroups = tempArray;
    ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
    self.library = assetLibrary;
    // Load Albums into assetGroups
    dispatch_async(dispatch_get_main_queue(), ^{
                       // Group enumerator Block
                       void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop)
                       {
                           if (group == nil) {
                               return;
                           }
                           NSString *sGroupPropertyName = (NSString *)[group valueForProperty:ALAssetsGroupPropertyName];
                           NSUInteger nType = [[group valueForProperty:ALAssetsGroupPropertyType] intValue];
                           if (((SNImagePickerNC *)(self.navigationController)).pickerType == kPickerTypeMovie) {
                               [group setAssetsFilter:[ALAssetsFilter allVideos]];
                           }else{
                               [group setAssetsFilter:[ALAssetsFilter allPhotos]];
                           }
                           if ([[sGroupPropertyName lowercaseString] isEqualToString:@"camera roll"] && nType == ALAssetsGroupSavedPhotos) {
                               [self.assetGroups insertObject:group atIndex:0];
                           }
                           else {
                               if (group.numberOfAssets != 0) {
                                   [self.assetGroups addObject:group];
                               }
                           }
                           [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:YES];
                       };
                       // Group Enumerator Failure Block
                       void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) {
                           UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Album Error: %@ - %@", [error localizedDescription], [error localizedRecoverySuggestion]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                           [alert show];
                           
                           if ([[error localizedDescription] isEqualToString:@"User denied access" ]) {
                               [self performSelector:@selector(dismissImagePicker) withObject:nil afterDelay:2];
                           }
                       };
                       [self.library enumerateGroupsWithTypes:ALAssetsGroupAll
                                                   usingBlock:assetGroupEnumerator
                                                 failureBlock:assetGroupEnumberatorFailure];
                   });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)reloadTableView
{
	[self.tableView reloadData];
	[self.navigationItem setTitle:@"Albums"];
}

- (void)dismissImagePicker
{
    if ([((SNImagePickerNC *)(self.navigationController)).imagePickerDelegate respondsToSelector:@selector(imagePickerDidCancel:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:^{
                [((SNImagePickerNC *)(self.navigationController)).imagePickerDelegate imagePickerDidCancel:((SNImagePickerNC *)(self.navigationController))];
            }];
        });
    }
}

#pragma mark - TableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.assetGroups count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    ALAssetsGroup *group = (ALAssetsGroup*)[self.assetGroups objectAtIndex:indexPath.row];
    if (((SNImagePickerNC *)(self.navigationController)).pickerType == kPickerTypeMovie) {
        [group setAssetsFilter:[ALAssetsFilter allVideos]];
    }else{
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
    }
    NSInteger groupCount = [group numberOfAssets];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%d)",[group valueForProperty:ALAssetsGroupPropertyName], groupCount];
    [cell.imageView setImage:[UIImage imageWithCGImage:[(ALAssetsGroup*)[self.assetGroups objectAtIndex:indexPath.row] posterImage]]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}

#pragma mark - Table view delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	self.assetsGroupIndex = indexPath.row;
    [self performSegueWithIdentifier:@"AssetsSegue" sender:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return 57;
}

#pragma mark - Prepare segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"AssetsSegue"]){
        SNAssetsVC *assetsVC = [segue destinationViewController];
        assetsVC.assetsGroup = [self.assetGroups objectAtIndex:self.assetsGroupIndex];
    }
}


@end
