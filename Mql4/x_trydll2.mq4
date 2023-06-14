#import "minimal.dll"
   // declare the imported function exactly as it is exported by the dll
   string foo(double x, string y);
#import

int init(){
   string s = foo(42.3, "Worlds");
   Print(s); // will print "Hello 42.3 Worlds!"
}

int start(){
}

int deinit()
{}