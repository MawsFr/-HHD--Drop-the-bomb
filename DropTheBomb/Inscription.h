//
//  Inscription.h
//  DropTheBomb
//
//  Created by Aurélie Digeon on 13/09/2014.
//  Copyright (c) 2014 Laurent Thiebault. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Inscription : UIViewController
{
    IBOutlet UITextField * txtPseudo;
    IBOutlet UITextField * txtMdp;
    IBOutlet UITextField * txtMdpConfirm;

}
-(IBAction)returnKeyButton1:(id)sender;


@end
