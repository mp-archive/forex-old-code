//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

#property copyright "MP"
#property link      "nincs nem kell"

   extern bool       b_fivedigitbroker    =true;
                     
          string     program_name         ="";         
 
                    
   extern double     lots_init          =0.1;   
   extern double     lots_incD          =0.1;
   extern double     lots_inc           =0.1;
   extern double     loss_init          =20;   
   extern double     loss_inc           =5;   
          double     lots=0.1;   
          double     loss=15; 
          int        open_nr=0; 
                          
          int        MAGIC_Rf          =6000;              
   
   extern string     Setup_building="-------------------" ;  
     
                  
   extern double     win               =15.0;    
   extern int        maxnr             =10;
   
   
         int    open_type,last_type;
         double open_total_profit;
         double last_profit;
         int    open_array_ticket[50],open_array_price[50];  
         double open_total_lot;
         double open_hlp1,open_hlp2,open_avgprice;
 
         int total;

//--------------------------------------------------------------------------------------------------------


int init()
  { return(0);  }



int start()
  {
   if (OrdersTotal()==0) F_open(); 
      else 
         {  F_check_open();
            F_close();
            F_build(); }
   return(0);
  }
 
 int deinit()
  {   return(0);  }

 
 //----------- STRATEGIE 1 -------------------------------------------------------------------------------------------

   


void F_open()
   { if (OrdersTotal()!=0) return(0);
   if (iRSI(Symbol(),PERIOD_M1,20,PRICE_CLOSE,1)>=76.0) {open_nr=0;lots=lots_init;lots_inc=lots_init;loss=loss_init;last_profit=0; Fs_open(-1);}
   if (iRSI(Symbol(),PERIOD_M1,20,PRICE_CLOSE,1)<=24.0) {open_nr=0;lots=lots_init;lots_inc=lots_init;loss=loss_init;last_profit=0; Fs_open(1);}
   return(0);  
   }


void F_build()
   {  
   if (open_total_profit<last_profit-loss)
      {  lots_inc+=lots_incD;lots+=lots_inc;loss+=loss_inc;
         last_profit=open_total_profit;
         Fs_open(-last_type); }
   return(0);  
   }


void Fs_open(int otype)
   {  
   open_nr+=1;
   if (open_nr>maxnr) return(0);
   last_type=otype;   last_profit=open_total_profit;
   if (otype==1)  open_array_ticket[open_nr]=OrderSend(Symbol(),OP_BUY,lots,Ask,3,0,0,"",MAGIC_Rf,0,Red);
   if (otype==-1) open_array_ticket[open_nr]=OrderSend(Symbol(),OP_SELL,lots,Bid,3,0,0,"",MAGIC_Rf,0,Red);
   return(0);  
   }   


void F_check_open()
   {  
      open_type=0;open_total_profit=0;open_total_lot=0;open_hlp1=0;open_hlp2=0;open_avgprice=0;
      
      total=OrdersTotal();                       
      if (total>0) for(int cnt=0;cnt<=total;cnt++)
      {
      OrderSelect(open_array_ticket[cnt], SELECT_BY_TICKET);
         int open_type=(OrderType()*(-2)+1);
         open_total_profit+=(OrderProfit()+OrderSwap()+OrderCommission());
         open_array_price[open_nr]=OrderOpenPrice();
         open_total_lot+=OrderLots()*open_type;
         open_hlp1+=OrderLots()*open_type;
         open_hlp2+=OrderLots()*OrderOpenPrice()*open_type;
         if (open_hlp1>0) open_avgprice=MathAbs(open_hlp2/open_hlp1);     
      }
      return(0);}
      
void F_close()
   { if (OrdersTotal()>0 && open_total_profit>win)
      for(int cnt=1;cnt<=total;cnt++) 
      {  OrderSelect(open_array_ticket[cnt], SELECT_BY_TICKET);
         if (OrderType()==0) OrderClose(OrderTicket(),OrderLots(),Bid,30,Red); 
            else OrderClose(OrderTicket(),OrderLots(),Ask,30,Red); }
   return(0);}   