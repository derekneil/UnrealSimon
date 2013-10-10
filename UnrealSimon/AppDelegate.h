//  AppDelegate.h
//  UnrealSimon
//
//  Created by Derek Neil on 2013-10-06.
//  Copyright (c) 2013 DKN Teck. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <AVFoundation/AVFoundation.h>
#import "Game.h"
#import "SoundController.h"
#import "PlayerController.h"
//#import "HighScoresController.h"
#import "GameViewController.h"
#import "PlayerOptionsViewController.h"
#import "HighScoresViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) Game* game;
@property (strong, nonatomic) SoundController* SC;
@property (strong, nonatomic) PlayerController* PC;
@property (strong, nonatomic) GameViewController* GVC;
@property (weak, nonatomic) PlayerOptionsViewController* POVC;
@property (weak, nonatomic) HighScoresViewController* HSVC;
//@property (weak, nonatomic) HighScoresController* highScores;

@end
