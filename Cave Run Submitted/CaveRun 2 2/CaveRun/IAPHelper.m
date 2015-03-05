//
//  IAPHelper.m
//  In App Rage
//
//  Created by Ray Wenderlich on 9/5/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

// 1
#import "IAPHelper.h"
#import <StoreKit/StoreKit.h>
#import "VerificationController.h"

NSString *const IAPHelperProductPurchasedNotification = @"IAPHelperProductPurchasedNotification";

// 2
@interface IAPHelper () <SKProductsRequestDelegate, SKPaymentTransactionObserver>
@end

// 3
@implementation IAPHelper {
    SKProductsRequest * _productsRequest;
    RequestProductsCompletionHandler _completionHandler;
    
    NSSet * _productIdentifiers;
    NSMutableSet * _purchasedProductIdentifiers;
}
// Step 1
- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers {
    
    if ((self = [super init])) {
        
        checkRestore = NO;
        // Store product identifiers
        _productIdentifiers = productIdentifiers;
        
        // Check for previously purchased products
        _purchasedProductIdentifiers = [NSMutableSet set];
        for (NSString * productIdentifier in _productIdentifiers) {
            BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
            if (productPurchased) {
                [_purchasedProductIdentifiers addObject:productIdentifier];
                //NSLog(@"Previously purchased: %@", productIdentifier);
            } else {
                NSLog(@"Not purchased: %@", productIdentifier);
            }
        }
        
        // Add self as transaction observer
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}

- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler {
    
    // 1
    _completionHandler = [completionHandler copy];
    
    // 2
    _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers];
    _productsRequest.delegate = self;
    [_productsRequest start];
}

- (BOOL)productPurchased:(NSString *)productIdentifier {
    return [_purchasedProductIdentifiers containsObject:productIdentifier];
}

// step 3
- (void)buyProduct:(SKProduct *)product {
    
    //NSLog(@"Buying %@...", product.productIdentifier);
   
//    keyChainMultiArrow = [[KeychainItemWrapper alloc] initWithIdentifier:@"powerboosters" accessGroup:nil];
//    [keyChainMultiArrow resetKeychainItem];
    /*
    if ([product.productIdentifier isEqualToString:@"com.globussoft.multipleArrows"]) {
        
        int multiArrowCount = 5;
        
        NSString *multiArrowString = [NSString stringWithFormat:@"%i",multiArrowCount];
        [keyChainMultiArrow setObject:multiArrowString forKey:(id)kSecValueData];
    }
    if ([product.productIdentifier isEqualToString:@"com.globussoft.powerboosterarrow"]) {
        
        int powerBoosterArrowCount = 3;
//        keyChainPowerBooster = [[KeychainItemWrapper alloc] initWithIdentifier:@"powerB" accessGroup:nil];
//        [keyChainPowerBooster resetKeychainItem];
        NSString *multiArrowString = [NSString stringWithFormat:@"%i",powerBoosterArrowCount];
        [keyChainMultiArrow setObject:multiArrowString forKey:(id)kSecAttrService];
    }
     */
    SKPayment * payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)validateReceiptForTransaction:(SKPaymentTransaction *)transaction {
    VerificationController * verifier = [VerificationController sharedInstance];
    verifier.delegate = self;
    [verifier verifyPurchase:transaction completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"Successfully verified receipt!");
            
//            [self provideContentForProductIdentifier:transaction.payment.productIdentifier];
            
            /*
            if ([transaction.payment.productIdentifier isEqualToString:@"com.globussoft.multipleArrows"]) {
                
                int multiArrowCount = 5;
                keyChainMultiArrow = [[KeychainItemWrapper alloc] initWithIdentifier:multiArrowCount accessGroup:nil];
                
                [keyChainMultiArrow setObject:multiArrowCount forKey:(id)kSecValueData];
               
//                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//                [userDefault setObject:@"RemoveAds" forKey:@"ads"];
//                [userDefault synchronize];
            }
            if ([transaction.payment.productIdentifier isEqualToString:@"com.globussoft.powerboosterarrow"]) {
                
//                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//                [userDefault setObject:@"z" forKey:@"zulu"];
//                [userDefault synchronize];
            }
            */
        } else {
            NSLog(@"Failed to validate receipt.");
            [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
        }
        
    }];
}
-(void) arrowPurchaseValidation:(BOOL)value{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(updateAfterArrowPurchase:)]) {
        [self.delegate updateAfterArrowPurchase:value];
    }
}
#pragma mark - SKProductsRequestDelegate

// Step 2
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    //NSLog(@"Loaded list of products...");
    _productsRequest = nil;
    
    NSArray * skProducts = response.products;
    for (SKProduct * skProduct in skProducts) {
        NSLog(@"Found product: %@ %@ %0.2f",
              skProduct.productIdentifier,
              skProduct.localizedTitle,                     //to display title
              skProduct.price.floatValue);
    }
    _completionHandler(YES, skProducts);
    _completionHandler = nil;
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    
    NSLog(@"Failed to load list of products.");
    NSLog(@"Error -==- %@",error);
    _productsRequest = nil;
    
    _completionHandler(NO, nil);
    _completionHandler = nil;
    
     [[[UIAlertView alloc]initWithTitle:@"Error" message:error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil]show];
}

#pragma mark SKPaymentTransactionOBserver

// Step 4
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction * transaction in transactions) {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    };
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"completeTransaction...");
    
    [self validateReceiptForTransaction:transaction];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}
- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions
{
    NSLog(@"Purchase removedTransactions");
    
    // Release the transaction observer since transaction is finished/removed.
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(updateAfterArrowPurchase:)]) {
        [self.delegate updateAfterArrowPurchase:NO];
    }
}
- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    
    //NSLog(@"Transaction info = %@",transaction.description);
    //NSLog(@"restoreTransaction...");
    [self validateReceiptForTransaction:transaction];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    
    NSLog(@"failedTransaction...");
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
        
        [[[UIAlertView alloc]initWithTitle:@"Error" message:transaction.error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil]show];
    }
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(updateAfterArrowPurchase:)]) {
        [self.delegate updateAfterArrowPurchase:NO];
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}
-(void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    NSLog(@"Error when purchasing: %@",error);
}
- (void)provideContentForProductIdentifier:(NSString *)productIdentifier {

     //keyChainMultiArrow = [[KeychainItemWrapper alloc] initWithIdentifier:@"powerboosters" accessGroup:nil];
   
    if ([productIdentifier isEqualToString:@"com.globussoft.CRMnewLife"])
    {
        
       
    }
    else {
        [_purchasedProductIdentifiers addObject:productIdentifier];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:productIdentifier];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductPurchasedNotification object:productIdentifier userInfo:nil];
}

- (void)restoreCompletedTransactions {
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}
- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    //NSLog(@"%@",queue );
    NSLog(@"Restored Transactions are once again in Queue for purchasing %@",[queue transactions]);
    
    NSMutableArray *purchasedItemIDs = [[NSMutableArray alloc] init];
    //NSLog(@"received restored transactions: %i", queue.transactions.count);
    
    for (SKPaymentTransaction *transaction in queue.transactions) {
        NSString *productID = transaction.payment.productIdentifier;
        [purchasedItemIDs addObject:productID];
        //NSLog (@"product id is %@" , productID);
        // here put an if/then statement to write files based on previously purchased items
        // example if ([productID isEqualToString: @"youruniqueproductidentifier]){write files} else { nslog sorry}
    }
    if (queue.transactions.count == 0) {
        if (!checkRestore) {
            [[[UIAlertView alloc] initWithTitle:@"" message:@"Sorry !! No Products for Restore." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil]show];
            checkRestore = YES;
        }
    }
}
@end