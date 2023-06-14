//+------------------------------------------------------------------+
//|                                          own_adv_noLoss1_001.mq4 |
//|                                                               MP |
//|                                                   nincs nem kell |
//+------------------------------------------------------------------+
#property copyright "MP"
#property link      "nincs nem kell"

#define MAGIC_Rf 10020001

   extern bool       money_management  =false;
   extern double     lots              =0.1;
          double     lots2;
   extern double     lots_equityperlot =1000000.0;
   extern bool       increase_lots     =false;
   extern int        increase_for_every   = 3;
   extern int        increase_percent     =0.1;
   
   
   extern int        step              =15;
   extern double     average_win       =11;
   extern double     max_loss_percent  =60.0;
            double sl=20000, tp=9000;
   
      extern string     Settings="-------------------" ;
   extern double     signal_adx_limit =40.0;
   extern double     rsi_limit_down    =100.0;
   extern int        bool_preiod       =30,
                     bool_dev          =2;
                     
                     
   bool              open_bool=false;
   int               open_nr=0;
   int               open_array_ticket[200];
   double            open_array_lot[200];
   double            open_array_price[200];
   double               open_hlp1=0.0,open_hlp2=0.0;
   int               open_type=0;
   double            open_last_price=0.0;
   double            open_avgprice=0.0;
   double            open_total_lot=0.0;
   double            open_total_profit=0.0;

   
   int               total=0;
   int               order_send=0;
   
     
  //        double     lots2=1.0;       
  // extern double     szorzo=1.0,   agression=2.0, szorzo_max=8.0;
  // extern double     lots_min=0.1,     lots_pt=0.1;
  // extern double     mv =40,     tp = 20,   sl =50;
          //double     tpB = 80,   slB =80;         EZ MÉG NEM MÛKÖDIK



//-------


int init()
  {F_check_open(); return(0);  }


int deinit()
  { return(0);  }


int start()
  {
   F_check_open();
   if (open_bool==false) F_open_now(F_signal());
   if (open_bool==true) 
      {
      //F_change();
      F_build(open_type,open_last_price,step);      
      //F_change();
      F_close(open_type);          
      }
   return(0);
  }
 
 
 //----------------------------------

int F_signal()
   { if (   iADX(NULL,0,14,PRICE_CLOSE,MODE_MAIN,1) >= signal_adx_limit   )
         {     if ( Close[1]> iBands(NULL,0,bool_preiod,bool_dev,0,PRICE_CLOSE,MODE_UPPER,1) 
                  && iRSI(NULL,0,bool_preiod,PRICE_CLOSE,1)>=100.0-rsi_limit_down ) return(-1);
               if ( Close[1]< iBands(NULL,0,bool_preiod,bool_dev,0,PRICE_CLOSE,MODE_LOWER,1) 
                  && iRSI(NULL,0,bool_preiod,PRICE_CLOSE,1)<=rsi_limit_down )       return(1);}
     return(0);   
   }
   
void F_check_open()
   {  total=OrdersTotal(); 
         open_bool=false; open_nr=0; open_hlp1=0.0;open_hlp2=0.0; open_type=0; open_last_price=0.0; open_avgprice=0.0;
         open_total_lot=0.0;  open_total_profit=0.0;
      if (total>0)
      for(int cnt=0;cnt<=total;cnt++)
     {
      OrderSelect(cnt, SELECT_BY_POS,MODE_TRADES);
      if (OrderMagicNumber()==MAGIC_Rf && OrderSymbol()==Symbol() && OrderType()<2) 
      {  open_bool=true;
         open_nr++;
         open_type=OrderType()*(-2)+1;
         open_array_ticket[open_nr]=OrderTicket();
         open_array_lot[open_nr]=OrderLots();
         open_total_lot+=OrderLots();
         open_total_profit+=(OrderProfit()+OrderSwap()+OrderCommission());
         open_array_price[open_nr]=OrderOpenPrice();
         open_hlp1+=OrderLots();
         open_hlp2+=OrderLots()*OrderOpenPrice();
         if (OrderOpenPrice()*open_type<open_last_price*open_type) open_last_price=OrderOpenPrice();
         if (open_last_price==0) open_last_price=OrderOpenPrice();
      }
     }
     if (open_hlp1>0) open_avgprice=open_hlp2/open_hlp1;
   }


void F_open_now(int order_type)
   {  if (money_management==true) lots=NormalizeDouble(AccountEquity()/lots_equityperlot,2); lots2=lots;
      if (order_type==1)  {  
            open_array_ticket[open_nr+1]=OrderSend(Symbol(),OP_BUY,lots,Ask,3,0,0,"",MAGIC_Rf,0,Green);   open_nr++; }
      if (order_type==-1) {  
            open_array_ticket[open_nr+1]=OrderSend(Symbol(),OP_SELL,lots,Bid,3,0,0,"",MAGIC_Rf,0,Green);   open_nr++; }  
      return(0);}

   
void F_build(int order_type,double order_last_price,int order_step)
   {  if (order_type==1 && Ask<=order_last_price-order_step*Point)   { 
            if (open_nr/increase_for_every==open_nr%increase_for_every*1.0) lots2=NormalizeDouble(lots2+lots*increase_percent,2);
            open_nr++;
            open_array_ticket[open_nr]=OrderSend(Symbol(),OP_BUY,lots2,Ask,3,0,0,"",MAGIC_Rf,0,Green); 
            F_check_open(); }
            
      if (order_type==-1 && Bid>=order_last_price+order_step*Point)  { 
            if (open_nr/increase_for_every==open_nr%increase_for_every*1.0) lots2=NormalizeDouble(lots2+lots*increase_percent,2);
            open_nr++;     
            open_array_ticket[open_nr]=OrderSend(Symbol(),OP_SELL,lots2,Bid,3,0,0,"",MAGIC_Rf,0,Green); 
            F_check_open(); }   
      return(0);}
   
   
void F_change()
   { for(int cnt=0;cnt<=open_nr;cnt++)
      { OrderSelect(open_array_ticket[cnt],SELECT_BY_TICKET);
         OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),open_avgprice,0,Green);}
   return(0);  }

   
void F_close(int order_type)
   { if ((order_type==1 && Bid>=open_avgprice+average_win*Point) ||
         (order_type==-1 && Ask<=open_avgprice-average_win*Point) ||
         (open_total_profit<AccountEquity()*(-max_loss_percent/100)))
         for(int cnt=open_nr;cnt>=0;cnt--)
            {  OrderSelect(open_array_ticket[cnt],SELECT_BY_TICKET);
               if (order_type==1) OrderClose(OrderTicket(),OrderLots(),Bid,3,Red); 
               if (order_type==-1) OrderClose(OrderTicket(),OrderLots(),Ask,3,Red); 
            }
   return(0);}

