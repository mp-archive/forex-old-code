#import "xls_library.dll"
   //void xl_setfilename(string xli_filename);
   void     xl_setfilename();
   string   xl_getfilename();
   void     xl_openfile();
   void     xl_closefile();
   string   xl_readwrite(int x,int y);   
#import

string t_path,t_name,t_file;

int init(){


     t_path="" + TerminalPath() + "" + "\experts\libraries";
     t_name="\NLtester001.xls";
     t_file=t_path+t_name;
     Print("test0: ",t_file);
     xl_setfilename(t_file);
     Print("test1: " + xl_getfilename());
     xl_openfile(t_file);
     Print("Open is ready");
     //Print(xl_readwrite(1,"",1,1));
     //xl_closefile();
     Print("file_closed");

}

int start(){
}

int deinit()
{}