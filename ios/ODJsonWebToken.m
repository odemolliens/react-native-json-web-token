
#import "ODJsonWebToken.h"

#import <CommonCrypto/CommonHMAC.h>

@implementation ODJsonWebToken

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE()


RCT_EXPORT_METHOD(encodeDic:(NSString *)algorithmByName
                  payload:(NSDictionary *)payload
                  secret:(NSString *)secret
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject )
{
    NSString * json = [ODJsonWebToken jsonStringWith:payload andPrettyPrint:NO];
    [self encode:algorithmByName payloadJson:json secret:secret resolver:resolve rejecter:reject];
}

RCT_EXPORT_METHOD(encodeJSONString:(NSString *)algorithmByName
                  payload:(NSString *)payload
                  secret:(NSString *)secret
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject )
{
    [self encode:algorithmByName payloadJson:payload secret:secret resolver:resolve rejecter:reject];
}

RCT_EXPORT_METHOD(encodeArray:(NSString *)algorithmByName
                  payload:(NSArray *)payload
                  secret:(NSString *)secret
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject )
{
    NSString * json = [ODJsonWebToken jsonStringWith:payload andPrettyPrint:NO];
    [self encode:algorithmByName payloadJson:json secret:secret resolver:resolve rejecter:reject];
}

-(void)encode:(NSString *)algorithmByName
  payloadJson:(NSString *)payload
       secret:(NSString *)secret
     resolver:(RCTPromiseResolveBlock)resolve
     rejecter:(RCTPromiseRejectBlock)reject {
    
    NSString * header = [NSString stringWithFormat:@"{\"typ\":\"JWT\",\"alg\":\"%@\"}",algorithmByName];
    NSString * headerEncode = [self encode:header];
    NSString * payloadEncode = [self encode:payload];
    NSString * signatureStr = [NSString stringWithFormat:@"%@.%@",headerEncode,payloadEncode];
    NSString * signature = [self HmacSHA256:signatureStr key:secret];
    NSString * token = [NSString stringWithFormat:@"%@.%@.%@",headerEncode,payloadEncode,signature];
    resolve(token);
}

+(NSString *)jsonStringWith:(id)object andPrettyPrint:(BOOL)prettyPrint{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:nil
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

/**
 * Encodes a String with Base64Url and no padding
 *
 * @param input String to be encoded
 * @return Encoded result from input
 */

-(NSString *)encode:(NSString *)str{
    NSData *nsdata = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
    return base64Encoded;
}



-(NSString *)HmacSHA256:(NSString *)data key:(NSString *)key{
    const char *cKey    =[key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData   =[data cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    NSString *hash =[HMAC base64EncodedStringWithOptions:0];
    return hash;
}

@end
  
