#import "xls_library.dll"
   //void xl_setfilename(string xli_filename);
   void     xl_setfilename();
   string   xl_getfilename();
   void     xl_openfile();
   void     xl_closefile();
   string   xl_readwrite(int x,int y);   
#import "mt4_helper_v0101.dll"
  string h_currtimelabel();  
#import

string t_path,t_name,t_file;

#include <stderror.mqh>
#include <stdlib.mqh>


int init(){


     t_path="" + TerminalPath() + "" + "\experts\libraries";
     t_name="\NLtester001.xls";
     t_file=t_path+t_name;
     Print("test0: ",t_file);
     Print(""+ h_currtimelabel());
     xl_setfilename();
     Print("test1: " + xl_getfilename());
     xl_openfile();
     
   int check;
   check=GetLastError();
   Print("error: ",ErrorDescription(check));
     
     
     Print("Open is ready");
     Print("test1: " + xl_getfilename());     
     //Print(xl_readwrite(1,"",1,1));
     //xl_closefile();
     //Print("cell11: " + xl_readwrite(1,1));
     //Print("file_closed");

}

int start(){
}

int deinit()
{}