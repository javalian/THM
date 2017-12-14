
#ifndef THM_CommonMacros_h
#define THM_CommonMacros_h


#define SINGLETON_FOR_CLASS(classname) \
\
+ (id) shared##classname \
{ \
static dispatch_once_t pred = 0; \
__strong static id _sharedObject = nil; \
dispatch_once(&pred, ^{ \
_sharedObject = [[self alloc] init]; \
}); \
return _sharedObject;\
}

#endif
