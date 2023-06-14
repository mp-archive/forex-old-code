
#import "mt4_helper_v0101.dll"
  string h_currtimelabel();  
#import



#include <stderror.mqh>
#include <stdlib.mqh>


int init(){


     Print(""+ h_currtimelabel());
     
   int check;
   check=GetLastError();
   Print("error: ",ErrorDescription(check));
     

}

int start(){
}

int deinit()
{}