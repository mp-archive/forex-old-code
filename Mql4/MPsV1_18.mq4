//+------------------------------------------------------------------+
//    kitettség mérése,
//    rsi,
//+------------------------------------------------------------------+
#property copyright "MP"
#property link      ""

         int      curr_nr   =6;
         string   curr[10]  = {"","EUR","GBP","AUD","USD","CAD","CHF","JPY"} ;
         //string   curr[10]    = {"","EUR","GBP","AUD","USD","CHF","JPY"} ;
         string   curr_symbol;
extern   string   curr_ext = "";
         int      i,j,k;

         double   currpair_price[4];        // curr1,  curr2,  Time
         double   curr_strength[10];           // curr1,  Time
         double   curr_order;
         double   curr_spread;
         double   currpair_ma[4];   
         double   curr_strength_ma[10];    
         double   curr_exposure;              
         double   curr_exposure_acc;          
         
         int      open_nr,open_nr_account;          
         int      open_n_ticket[20];                  
         datetime open_n_opentime[20];              
         double   open_n_openprice[20];             
         string   open_n_curr[20];                
            
         
         int      time_nr=3;
extern   double   tp=15.0,sl=20.0,lot=0.1;
//extern   double   maxspread=3.0;
extern   double   b_reverse=1.0;
extern   bool     b_moneymanagement=false;                   
extern   double   BalancePerLot=50000;                      
extern   bool     b_hedging=true;                               
extern   bool     b_doubling_curr=false;                        
//extern   bool     b_doubling_currpair=false;                
//extern   bool     b_doubling_currpair_acc=true;               
extern   int      magic=100099;
//extern   int      timeframe1=1;
extern   int      hour_from=0,hour_to=25,hour_in=-1;                  
extern   int      p11=5,p12=10,p13=20,delay=0;
extern   double   k1=-999.0, k2=-999.0, k3=-999.0;
extern   double   km1=-999.0, km2=-999.0, km3=-999.0;
//extern   string   exc1="",exc2="",exc3="";
//extern   string   only="";
extern   int      freq_calc_sec=4,freq_ord_min=15,freq_check_sec=3;
extern   int      min_after_lastloose=180;
extern   int      maxopen_nr=4,maxopen_nr_account=11;       
extern   double   d5corr=10.0;
//extern   bool     b_filewrite=false;
//extern   bool     b_open_reverse_too=false;
extern   double   min_lot=0.1;                              

         int      file;
         string   filename,tmpstr1,tmpstr2;

         datetime lastcalculation,lastopen,lastcheck;
         datetime lastloose;
         double   lastsuccess;
         int      lastticket;
         double   cask,cbid,cpoint;
         string   tepmstr,labelname;  
         double   tempactvalue;
         double   b_reverse2;

//+-----------------------       

int init()
  {   F_check_open2();
      F_calculate1();
      return(0); }
 
int start()
  {   i=1;j=1;curr_symbol=Symbol();
      F_check_open2();
      F_calculate1();
      if (TimeCurrent()-lastopen>freq_ord_min*60) 
         {  F_check_last_loose();                          
            if (min_after_lastloose==0 || TimeCurrent()-lastloose>=min_after_lastloose*60) 
            //{b_reverse2=b_reverse*lastsuccess;b_reverse=b_reverse2;}          
            F_sendorder();}
      return(0); }
      
int deinit()
  {   return(0); }      

//+-----------------------   

void F_calculate1() {
      i=1;j=1;curr_symbol=Symbol();
      tempactvalue=Close[0];
      currpair_price[0]=Close[0+delay];
      currpair_price[1]=Close[0+delay]/Close[p11+delay];
      currpair_price[2]=Close[0+delay]/Close[p12+delay];
      currpair_price[3]=Close[0+delay]/Close[p13+delay];
      currpair_ma[1]=Close[0+delay]/iMA(Symbol(),0,p11+delay,0,MODE_SMA,PRICE_CLOSE,0);
      currpair_ma[2]=iMA(Symbol(),0,p11+delay,0,MODE_SMA,PRICE_CLOSE,0)/iMA(Symbol(),0,p12+delay,0,MODE_SMA,PRICE_CLOSE,0);
      currpair_ma[3]=iMA(Symbol(),0,p12+delay,0,MODE_SMA,PRICE_CLOSE,0)/iMA(Symbol(),0,p13+delay,0,MODE_SMA,PRICE_CLOSE,0);            
      curr_spread=MathAbs(Ask-Bid);  
      
   for (k=1;k<=time_nr;k++) for (i=1;i<=curr_nr;i++) 
      {curr_strength[k]=0.0; curr_strength_ma[k]=0.0; }

   for (k=1;k<=time_nr;k++)
         {  
         curr_strength[k]+=(currpair_price[k]*10000-10000);
         curr_strength_ma[k]+=(currpair_ma[k]*10000-10000);
         }    
         
      {  curr_order=0;
         if (  curr_strength[1]>k1  
            && curr_strength[2]>k2  
            && curr_strength[3]>k3
            && curr_strength_ma[1]>km1
            && curr_strength_ma[2]>km2
            && curr_strength_ma[3]>km3
            && (b_reverse==1 || Close[0]<=Close[0+delay])
            )    
            curr_order=1;
         if (  curr_strength[1]<-k1  
            && curr_strength[2]<-k2  
            && curr_strength[3]<-k3
            && curr_strength_ma[1]<-km1
            && curr_strength_ma[2]<-km2
            && curr_strength_ma[3]<-km3
            && (b_reverse==1 || Close[0]>=Close[0+delay])                        
            )    
            curr_order=-1;}
            
   lastcalculation=TimeCurrent();
   return(0);}

void F_sendorder()
   {
      {  i=1;j=1;curr_symbol=Symbol();
         if (b_moneymanagement==true) lot=MathMax(min_lot,NormalizeDouble(AccountEquity()/BalancePerLot,2));           
         if (  1==1
            //curr_symbol!=exc1 
            //&& curr_symbol!=exc2 
            //&& curr_symbol!=exc3 
            && ((hour_from<=hour_to && Hour()>=hour_from && Hour()<=hour_to) || (hour_from>=hour_to && (Hour()>=hour_from || Hour()<=hour_to)))  
            && (Hour()==hour_in || hour_in<0)
            && (b_hedging==true || curr_exposure*curr_order*b_reverse>=0)    
            && (b_doubling_curr==true ||  curr_exposure*curr_order*b_reverse<=0)
            //&& (b_doubling_curr==true || -curr_exposure[j,j]*curr_order[i,j]*b_reverse<=0)
            //&& (b_doubling_currpair==true || curr_exposure[i,j]*curr_order[i,j]*b_reverse<=0)  
            //&& (b_doubling_currpair_acc==true || curr_exposure_acc[i,j]*curr_order[i,j]*b_reverse<=0)  
            //&& (curr_spread[i,j]<=maxspread)
            //&& (open_nr<=maxopen_nr)
            //&& (open_nr_account<=maxopen_nr_account)
            )
            {  if (curr_order==b_reverse*1)  
               {  Print(lastticket," ",lastsuccess," ",b_reverse);
                  lastticket=OrderSend(curr_symbol,OP_BUY,lot,Ask,3*d5corr,Ask-sl*d5corr*Point,Ask+tp*d5corr*Point,""+magic,magic,0,Green);
                  lastopen=TimeCurrent();return(0);}
               if (curr_order==b_reverse*(-1)) 
               {  Print(lastticket," ",lastsuccess," ",b_reverse);
                  lastticket=OrderSend(curr_symbol,OP_SELL,lot,Bid,3*d5corr,Bid+sl*d5corr*Point,Bid-tp*d5corr*Point,""+magic,magic,0,Green);                  
                  lastopen=TimeCurrent();return(0);}
            }                                  
      }
   return(0);}

//+-----------------------   

void  F_check_open2()           
   {  open_nr=0;
      curr_exposure=0.0; curr_exposure_acc=0.0;
      open_nr_account=OrdersTotal();
      
      curr_symbol=Symbol();
      
      for (k=0;k<=open_nr_account;k++)
      {  OrderSelect(k,SELECT_BY_POS,MODE_TRADES);
         {  if (curr_symbol==OrderSymbol())   
            {  if (OrderType()==OP_BUY) curr_exposure_acc+=OrderLots();
               if (OrderType()==OP_SELL) curr_exposure_acc-=OrderLots();
               if (OrderMagicNumber()==magic)
               {  open_nr++;
                  open_n_ticket[open_nr]=OrderTicket();
                  open_n_opentime[open_nr]=OrderOpenTime();
                  open_n_curr[open_nr]=OrderSymbol();
                  open_n_openprice[open_nr]=OrderOpenPrice();            
                  if (OrderType()==OP_BUY) curr_exposure+=OrderLots(); 
                  if (OrderType()==OP_SELL) curr_exposure-=OrderLots(); 
                     labelname="label" + (open_nr+16);  
               }
            } 
         }
      }
    
   return(0);}
 

void F_check_last_loose()
   {
   lastsuccess=1.0; lastloose=TimeCurrent()-1*24*60*60;
         if (lastticket!=0)
         if (OrderSelect(lastticket,SELECT_BY_TICKET,MODE_HISTORY)==true)
         if (curr_symbol==OrderSymbol() && magic==OrderMagicNumber() && OrderProfit()<0) 
            {lastsuccess=-1.0; lastloose=OrderCloseTime();}
   
   /*if (curr_exposure_acc!=0 || min_after_lastloose==0) lastloose=TimeCurrent()+3;
   if (curr_exposure_acc==0 && min_after_lastloose!=0) 
      for (int kk=OrdersHistoryTotal();kk>=0;kk--)
      {  OrderSelect(kk,SELECT_BY_POS,MODE_HISTORY);         
         if (curr_symbol==OrderSymbol() && magic==OrderMagicNumber() && OrderProfit()<0) 
            {lastloose=OrderCloseTime();return(0);}}
   */
   return(0);
   }
   