//
//  ViewController.h
//  Watermark
//
//  Created by David 🤴 on 2021/10/22.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController

@property (weak,nonatomic) IBOutlet NSButton *picture;
@property (weak,nonatomic) IBOutlet NSButton *watermark;
@property (weak,nonatomic) IBOutlet NSImageView *pictureView;
@property (weak,nonatomic) IBOutlet NSImageView *watermarkView;
@property (weak,nonatomic) IBOutlet NSButton *generate;
@property (weak,nonatomic) IBOutlet NSImageView *resultView;
@end

