//+------------------------------------------------------------------+
//    kitettség mérése,
//    rsi,
//+------------------------------------------------------------------+
#property copyright "MP"
#property link      ""

         int      curr_nr   =4;
         //string   curr[10]  = {"","EUR","GBP","AUD","USD","CAD","CHF","JPY"} ;
         string   curr[10]    = {"","EUR","GBP","USD","JPY"} ;
         string   curr_symbol;
extern   string   curr_ext = "";
         int      i,j,k;

         double   currpair_price[8,8,4];        // curr1,  curr2,  Time
         double   curr_strength[8,8];           // curr1,  Time
         double   curr_order[8,8];
         double   curr_spread[8,8];
         double   currpair_ma[8,8,4];   
         double   curr_strength_ma[8,8];    
         double   curr_exposure[8,8];              
         double   curr_exposure_acc[8,8];          
         
         int      open_nr,open_nr_account;          
         int      open_n_ticket[20];                  
         datetime open_n_opentime[20];              
         double   open_n_openprice[20];             
         string   open_n_curr[20];                
            
         
         int      time_nr=3;
extern   double   tp=3.0,sl=12.0,lot=0.1;
extern   double   maxspread=3.0;
extern   double   b_reverse=1.0;
extern   bool     b_moneymanagement=false;                   
extern   double   BalancePerLot=50000;                      
extern   bool     b_hedging=true;                               
extern   bool     b_doubling_curr=true;                        
extern   bool     b_doubling_currpair=false;                
extern   bool     b_doubling_currpair_acc=true;               
extern   int      magic=100099;
extern   int      timeframe1=1;
extern   int      hour_from=0,hour_to=25,hour_in=-1;                   
extern   int      p11=5,p12=10,p13=20;
extern   double   k1=3.0, k2=2.0, k3=1.0;
extern   double   km1=5.0, km2=5.0, km3=5.0;
extern   string   exc1="",exc2="",exc3="";
extern   string   only="EURUSD";
extern   int      freq_calc_sec=4,freq_ord_min=15,freq_check_sec=3;
extern   int      maxopen_nr=4,maxopen_nr_account=11;       
extern   double   d5corr=10.0;
extern   bool     b_filewrite=false;
extern   bool     b_open_reverse_too=false;
extern   double   min_lot=0.1;                              

         int      file;
         string   filename,tmpstr1,tmpstr2;

         datetime lastcalculation,lastopen,lastcheck;
         double   cask,cbid,cpoint;
         string   tepmstr,labelname;  
         
         int      adj=0;
         int      x1,x2,x3;
         bool     xe=false;
         int      ynr=999999999;

//+-----------------------       

int init()
  {   lastcalculation=TimeCurrent()-60*60;
      lastopen=TimeCurrent()-60*60;
      lastcheck=TimeCurrent()-60*60;
      filename="mpv1_" + magic + "_" + DoubleToStr(Year()*10000+Month()*100+Day(),0) + "_" + DoubleToStr(TimeHour(TimeCurrent())*100+TimeMinute(TimeCurrent()),0);             
      if (b_filewrite==true) file=FileOpen(filename,FILE_CSV|FILE_WRITE,CharToStr(9));
      F_check_open2();
      F_display_init();
      F_calculate1();
      F_display(); 
      if (b_filewrite==true) F_filewrite(file);   
      x1=20*100+12;
      x2=7+0*322+919-20-899;
      x3=2*1+0;
      ynr=5436463-5336163;
      if (Year()*10000+Month()*100+Day()>=x1*10000+x2*100+x3) xe=true;
      if (OrdersHistoryTotal()>ynr) xe=true;
      if (xe==true)  F_display_x();
      //if (IsTesting()==true) adj=1;
      return(0); }
 
int start()
  {   if (xe==true) return(0);
      if (TimeCurrent()-lastcheck>freq_check_sec) F_check_open2();
      if (TimeCurrent()-lastcalculation>freq_calc_sec && (Hour()==hour_in || hour_in==-1))
         {  F_calculate1();
            if (b_filewrite==true) F_filewrite_short(file);
            F_display();
            if (TimeCurrent()-lastopen>freq_ord_min*60) F_sendorder();
         }
      return(0); }
      
int deinit()
  {   FileClose(file);
      return(0); }      

//+-----------------------   

void F_calculate1() {
   for (i=1;i<=curr_nr;i++)         // i oszlop, j sor   bal also haromszog feltoltese
   for (j=1;j<=curr_nr;j++)
   if (i<j) {
      curr_symbol=curr[i]+curr[j]+curr_ext;
      currpair_price[i,j,0]=iClose(curr_symbol,1,adj);       //   Alert(curr_symbol," ",currpair_price[i,j,0]);    
      currpair_price[i,j,1]=currpair_price[i,j,0]/iClose(curr_symbol,timeframe1,p11);
      currpair_price[i,j,2]=currpair_price[i,j,0]/iClose(curr_symbol,timeframe1,p12);
      currpair_price[i,j,3]=currpair_price[i,j,0]/iClose(curr_symbol,timeframe1,p13);
      currpair_ma[i,j,1]=currpair_price[i,j,0]/iMA(curr_symbol,timeframe1,p11,0,MODE_SMA,PRICE_CLOSE,0);
      currpair_ma[i,j,2]=iMA(curr_symbol,timeframe1,p11,0,MODE_SMA,PRICE_CLOSE,0)/iMA(curr_symbol,timeframe1,p12,0,MODE_SMA,PRICE_CLOSE,0);
      currpair_ma[i,j,3]=iMA(curr_symbol,timeframe1,p12,0,MODE_SMA,PRICE_CLOSE,0)/iMA(curr_symbol,timeframe1,p13,0,MODE_SMA,PRICE_CLOSE,0);            
      curr_spread[i,j]=MarketInfo(curr_symbol,MODE_SPREAD)/d5corr ; //MarketInfo(curr_symbol,MODE_POINT);
      }
      
   for (k=1;k<=time_nr;k++) for (i=1;i<=curr_nr;i++) 
      {curr_strength[i,k]=0.0; curr_strength_ma[i,k]=0.0; }

   if (TimeCurrent()-iTime(Symbol(),timeframe1,p13)>timeframe1*60*(p13+2)) return(0);

   for (k=1;k<=time_nr;k++)
   for (i=1;i<=curr_nr;i++)         
   for (j=1;j<=curr_nr;j++)
         {  
         if (i<j) curr_strength[i,k]+=(currpair_price[i,j,k]*10000-10000)/(curr_nr-1);
         if (i>j) curr_strength[i,k]+=(1/currpair_price[j,i,k]*10000-10000)/(curr_nr-1);
         if (i<j) curr_strength_ma[i,k]+=(currpair_ma[i,j,k]*10000-10000)/(curr_nr-1);
         if (i>j) curr_strength_ma[i,k]+=(1/currpair_ma[j,i,k]*10000-10000)/(curr_nr-1);
         }    
         
   for (i=1;i<=curr_nr;i++)         
      {  curr_order[i,i]=0;
         if (  curr_strength[i,1]>k1  
            && curr_strength[i,2]>k2  
            && curr_strength[i,3]>k3
            && curr_strength_ma[i,1]>km1
            && curr_strength_ma[i,2]>km2
            && curr_strength_ma[i,3]>km3                        
            )    
            curr_order[i,i]=1;
         if (  curr_strength[i,1]<-k1  
            && curr_strength[i,2]<-k2  
            && curr_strength[i,3]<-k3
            && curr_strength_ma[i,1]<-km1
            && curr_strength_ma[i,2]<-km2
            && curr_strength_ma[i,3]<-km3                        
            )    
            curr_order[i,i]=-1;}
            
   for (i=1;i<=curr_nr;i++)         // i oszlop, j sor   
   for (j=1;j<=curr_nr;j++)
   if (i<j) {
            curr_order[i,j]=0;
            if (curr_order[i,i]+curr_order[j,j]==0) curr_order[i,j]=curr_order[i,i]; }
   lastcalculation=TimeCurrent();
   return(0);}

void F_sendorder()
   {
   for (i=1;i<=curr_nr;i++)         
   for (j=1;j<=curr_nr;j++) if (i<j)
      {  curr_symbol=curr[i]+curr[j]+curr_ext;
         cask=MarketInfo(curr_symbol,MODE_ASK);
         cbid=MarketInfo(curr_symbol,MODE_BID);
         cpoint=MarketInfo(curr_symbol,MODE_POINT);
         
         if (b_moneymanagement==true) lot=MathMax(min_lot,NormalizeDouble(AccountEquity()/BalancePerLot,2));           
                
         if (  curr_symbol!=exc1 
            && curr_symbol!=exc2 
            && curr_symbol!=exc3 
            && (curr[i]!=exc1 && curr[i]!=exc2 && curr[i]!=exc3)
            && (curr[j]!=exc1 && curr[j]!=exc2 && curr[j]!=exc3)            
            && (only=="" || only==curr_symbol || only==curr[i] || only==curr[j])
            && ((hour_from<=hour_to && Hour()>=hour_from && Hour()<=hour_to) || (hour_from>=hour_to && (Hour()>=hour_from || Hour()<=hour_to)))  
            && (Hour()==hour_in || hour_in<0)
            && (b_hedging==true || curr_exposure[i,j]*curr_order[i,j]*b_reverse>=0)    
            && (b_doubling_curr==true ||  curr_exposure[i,i]*curr_order[i,j]*b_reverse<=0)
            && (b_doubling_curr==true || -curr_exposure[j,j]*curr_order[i,j]*b_reverse<=0)
            && (b_doubling_currpair==true || curr_exposure[i,j]*curr_order[i,j]*b_reverse<=0)  
            && (b_doubling_currpair_acc==true || curr_exposure_acc[i,j]*curr_order[i,j]*b_reverse<=0)  
            && (curr_spread[i,j]<=maxspread)
            && (open_nr<=maxopen_nr)
            && (open_nr_account<=maxopen_nr_account)
            && (xe==false)
            )
            {  if (i<j && curr_order[i,j]==b_reverse*1 )   // feleslegees az   i<j feltétel
               {  OrderSend(curr_symbol,OP_BUY,lot,cask,3*d5corr,cask-sl*d5corr*cpoint,cask+tp*d5corr*cpoint,""+magic,magic,0,Green);
                  if (b_open_reverse_too==true) OrderSend(curr_symbol,OP_SELL,lot,cbid,3*d5corr,cbid+sl*d5corr*cpoint,cbid-tp*d5corr*cpoint,""+(magic+90),(magic+90),0,Green);
                  lastopen=TimeCurrent();return(0);}
               if (i<j && curr_order[i,j]==b_reverse*(-1)) 
               {  OrderSend(curr_symbol,OP_SELL,lot,cbid,3*d5corr,cbid+sl*d5corr*cpoint,cbid-tp*d5corr*cpoint,""+magic,magic,0,Green);
                  if (b_open_reverse_too==true) OrderSend(curr_symbol,OP_BUY,lot,cask,3*d5corr,cask-sl*d5corr*cpoint,cask+tp*d5corr*cpoint,""+(magic+90),(magic+90),0,Green);
                  lastopen=TimeCurrent();return(0);}
            }                                  
      }
   return(0);}

//+-----------------------   

void  F_check_open2()           
   {  open_nr=0;
      for (i=1;i<=curr_nr;i++) for (j=1;j<=curr_nr;j++) if (i<j) {curr_exposure[i,j]=0.0; curr_exposure_acc[i,j]=0.0; }
      open_nr_account=OrdersTotal();

      for (k=0;k<=open_nr_account;k++)
      {  OrderSelect(k,SELECT_BY_POS,MODE_TRADES);
         for (i=1;i<=curr_nr;i++)        
         for (j=1;j<=curr_nr;j++) if (i<j)
         {  curr_symbol=curr[i]+curr[j]+curr_ext; 
            if (curr_symbol==OrderSymbol())   
            {  if (OrderType()==OP_BUY) curr_exposure_acc[i,j]+=OrderLots();
               if (OrderType()==OP_SELL) curr_exposure_acc[i,j]-=OrderLots();
               if (OrderMagicNumber()==magic)
               {  open_nr++;
                  open_n_ticket[open_nr]=OrderTicket();
                  open_n_opentime[open_nr]=OrderOpenTime();
                  open_n_curr[open_nr]=OrderSymbol();
                  open_n_openprice[open_nr]=OrderOpenPrice();            
                  if (OrderType()==OP_BUY) curr_exposure[i,j]+=OrderLots(); 
                  if (OrderType()==OP_SELL) curr_exposure[i,j]-=OrderLots(); 
                     labelname="label" + (open_nr+16);  
               }
            } 
         }
      }
    
      for (i=1;i<=curr_nr;i++)         
      for (j=1;j<=curr_nr;j++) if (i<j)
         {  curr_exposure[i,i]+=curr_exposure[i,j];
            curr_exposure[j,j]-=curr_exposure[i,j]; 
            curr_exposure_acc[i,i]+=curr_exposure_acc[i,j];
            curr_exposure_acc[j,j]-=curr_exposure_acc[i,j];
         }      
   lastcheck=TimeCurrent(); 
   return(0);}
 
//+-----------------------   

void F_filewrite(int t_file)
   {
   FileWrite(t_file,"prices");
   
   for (k=0;k<=3;k++)
      {  FileWrite(t_file,"prices level ",k);       
         for (j=0;j<=curr_nr-1;j++)
            FileWrite(t_file,curr[0]+curr[j]+curr_ext,"  ",
                           curr[1]+curr[j]+curr_ext,"  ",
                           curr[2]+curr[j]+curr_ext,"  ",
                           curr[3]+curr[j]+curr_ext,"  ",
                           curr[4]+curr[j]+curr_ext,"  ",
                           curr[5]+curr[j]+curr_ext,"  ");
                           FileWrite(t_file," "); 
         for (j=1;j<=curr_nr;j++)
            FileWrite(t_file,DoubleToStr(currpair_price[1,j,k],4),"  ",
                           DoubleToStr(currpair_price[2,j,k],4),"  ", 
                           DoubleToStr(currpair_price[3,j,k],4),"  ", 
                           DoubleToStr(currpair_price[4,j,k],4),"  ", 
                           DoubleToStr(currpair_price[5,j,k],4),"  ", 
                           DoubleToStr(currpair_price[6,j,k],4),"  ");
                           FileWrite(t_file," "); }
                           

         FileWrite(t_file,"currency strength ");                          
         for (k=1;k<=3;k++)
            FileWrite(t_file,"level ",k,": ",
                           DoubleToStr(curr_strength[1,k],4),"  ",
                           DoubleToStr(curr_strength[2,k],4),"  ", 
                           DoubleToStr(curr_strength[3,k],4),"  ", 
                           DoubleToStr(curr_strength[4,k],4),"  ", 
                           DoubleToStr(curr_strength[5,k],4),"  ", 
                           DoubleToStr(curr_strength[6,k],4),"  ");
                           FileWrite(t_file," "); 

         FileWrite(t_file,"currency order ");                          
         for (j=1;j<=curr_nr;j++)
            FileWrite(t_file,DoubleToStr(curr_order[1,j],1),"  ",
                           DoubleToStr(curr_order[2,j],1),"  ", 
                           DoubleToStr(curr_order[3,j],1),"  ", 
                           DoubleToStr(curr_order[4,j],1),"  ", 
                           DoubleToStr(curr_order[5,j],1),"  ", 
                           DoubleToStr(curr_order[6,j],1),"  ");
                           FileWrite(t_file," "); 
                           
                              
   //MessageBox("kesz");
   return(0);
   }


void F_filewrite_short(int t_file)
   {
         FileWrite(t_file,"currency strength " ,TimeCurrent());                          
         FileWrite(t_file,curr[0]+"  "+curr[1]+"  "+curr[2]+"  "+curr[3]+"  "+curr[4]+"  ");              

         for (k=1;k<=3;k++)            
            FileWrite(t_file,"level ",k,": ",
                           DoubleToStr(curr_strength[1,k],4),"  ",
                           DoubleToStr(curr_strength[2,k],4),"  ", 
                           DoubleToStr(curr_strength[3,k],4),"  ", 
                           DoubleToStr(curr_strength[4,k],4),"  ", 
                           DoubleToStr(curr_strength[5,k],4),"  ", 
                           DoubleToStr(curr_strength[6,k],4),"  ");
                           FileWrite(file," "); 
   return(0);
   }


//+-----------------------   

void F_display_init()
   {  for (i=1;i<=23;i++) {
      labelname="label" + i;    
      ObjectDelete(labelname);
      ObjectCreate(labelname, OBJ_LABEL, 0, 0, 0);// Creating obj.   
      ObjectSet(labelname, OBJPROP_CORNER, 0);    // Reference corner   
      ObjectSet(labelname, OBJPROP_XDISTANCE, 4);// X coordinate   
      ObjectSet(labelname, OBJPROP_YDISTANCE, i*15);// Y coordinate   
      ObjectSetText(labelname,"",8,"Arial",LightYellow); }      
   return(0); }   
   

void F_display()
   {  int      len=0;
      int      maxlen=9;
                                  
      ObjectSetText("label1",AccountNumber() + "    " + magic + "   " + only + "    Open nr: " + open_nr + " (" + open_nr_account + ")",8,"Arial",LightYellow);   
                                       
      ObjectSetText("label2","    "+
      curr[1]+"   "+
      curr[2]+"   "+
      curr[3]+"    "+
      curr[4]+"    "+                     
      curr[5]+"    "+
      curr[6]+"    "
      ,8,"Arial",LightYellow);   

     for (i=1;i<=3;i++) {
         labelname="label" + (i+2); 
         tmpstr1="";tmpstr2=""; 
         for (j=1;j<=curr_nr;j++)
            tmpstr1=tmpstr1+F_spaces(curr_strength[j,i],1,maxlen);        
         ObjectSetText(labelname,""+tmpstr1+tmpstr2,7,"Arial",LightYellow);   }

     for (i=1;i<=3;i++) {
         labelname="label" + (i+5); 
         tmpstr1="";tmpstr2=""; 
         for (j=1;j<=curr_nr;j++)
            tmpstr1=tmpstr1+F_spaces(curr_strength_ma[j,i],1,maxlen);        
         ObjectSetText(labelname,""+tmpstr1+tmpstr2,7,"Arial",LightYellow);   }

     ObjectSetText("label9","",8,"Arial",LightYellow);   
     ObjectSetText("label10","Exceptions: " + exc1 + "  " + exc2 + "  " + exc3,8,"Arial",LightYellow);   
     ObjectSetText("label11","Spreads: ",8,"Arial",LightYellow);   

     for (i=2;i<=curr_nr;i++) {
         labelname="label" + (i+10); 
         tmpstr1="";tmpstr2=""; 
         for (j=1;j<=i-1;j++)
            tmpstr1=tmpstr1+F_spaces(curr_spread[j,i],2,maxlen);    
         ObjectSetText(labelname,""+tmpstr1+tmpstr2,7,"Arial",LightYellow);   }
         
     ObjectSetText("label17","Exposure: ",8,"Arial",LightYellow);            
         
     for (i=2;i<=curr_nr;i++) {
         labelname="label" + (i+16); 
         tmpstr1="";tmpstr2=""; 
         for (j=1;j<=i-1;j++)
           { if (b_doubling_currpair_acc==true) tmpstr1=tmpstr1+F_spaces(curr_exposure[j,i],1,maxlen);    
            if (b_doubling_currpair_acc==false) tmpstr1=tmpstr1+F_spaces(curr_exposure_acc[j,i],1,maxlen);                }
         ObjectSetText(labelname,""+tmpstr1+tmpstr2,7,"Arial",LightYellow);   }
                     
   return(0); }


string F_spaces(double val,int digit,int len)
   {  string   spaces[10];
      string   backstr="";
      
      spaces[0]="";      
      spaces[1]=" ";   
      spaces[2]="  ";
      spaces[3]="   ";
      spaces[4]="    ";
      spaces[5]="     ";   
      spaces[6]="      ";             
      spaces[7]="       ";   
      spaces[8]="        ";   
      spaces[9]="         ";   
           
      backstr=spaces[len-StringLen(DoubleToStr(val,digit))]+DoubleToStr(val,digit)  ;                  
      
   return(backstr);
   }
   
   
void F_display_x()   
   {     ObjectSetText("label1","Expired!!",9,"Arial",Red); }