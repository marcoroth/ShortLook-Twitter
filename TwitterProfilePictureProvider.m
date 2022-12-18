#import "TwitterProfilePictureProvider.h"

@interface UNNotificationAttachment
  -(NSURL *)URL;
@end

@interface UNNotificationContent
  -(NSArray *)attachments;
@end

@interface UNNotificationRequest
  -(UNNotificationContent *)content;
@end

@interface UNNotification
  -(UNNotificationRequest *)request;
@end

@interface NCNotificationRequest
  -(NSString *)threadIdentifier;
  -(UNNotification *)userNotification;
@end

static void debugAlert(NSString *title, NSString *message){
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
  [alert show];
}

@implementation TwitterProfilePictureProvider

- (DDNotificationContactPhotoPromiseOffer *)contactPhotoPromiseOfferForNotification:(DDUserNotification *)notification {
    NCNotificationRequest *request = [notification request];
    UNNotification *userNotification = [request userNotification];
    UNNotificationRequest *notificationRequest = [userNotification request];
    UNNotificationContent *content = [notificationRequest content];
    UNNotificationAttachment *attachment = [content attachments][0];

    NSString *imageURLStr;
    // NSURL *imageURL;
    UIImage *image;

    if (attachment) {
      image = [UIImage imageWithContentsOfFile:[attachment URL].path];
      return [NSClassFromString(@"DDNotificationContactPhotoPromiseOffer") offerInstantlyResolvingPromiseWithPhotoIdentifier:imageURLStr image:image];
    }

    NSString *userNotificationStr = [NSString stringWithFormat:@"%@",[notification.request userNotification]];
    NSString *applicationUserInfoStr = [NSString stringWithFormat:@"%@", [notification applicationUserInfo]];
    NSString *userInfoStr = [NSString stringWithFormat:@"%@", [notification userInfo]];
    NSString *notificationStr = [NSString stringWithFormat:@"%@", notification];
    NSString *requestStr = [NSString stringWithFormat:@"%@", [notification request]];

    debugAlert(@"Twitter userNotification", userNotificationStr);
    debugAlert(@"Twitter applicationUserInfo", applicationUserInfoStr);
    debugAlert(@"Twitter userInfo", userInfoStr);
    debugAlert(@"Twitter notification", notificationStr);
    debugAlert(@"Twitter request", requestStr);

    return nil;
    // return [NSClassFromString(@"DDNotificationContactPhotoPromiseOffer") offerInstantlyResolvingPromiseWithPhotoIdentifier:@imageURLStr image:image];
    // return [NSClassFromString(@"DDNotificationContactPhotoPromiseOffer") offerDownloadingPromiseWithPhotoIdentifier:imageURLStr fromURL:imageURL];
  }

@end
