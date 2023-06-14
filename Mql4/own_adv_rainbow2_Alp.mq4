//--------------------------------------------------------------------
//--------------------------------------------------------------------



#define MAGICME 10031000

double Lots = 0.1;
double TakeProfit   = 1000;
extern double TakeProfitR  = 40;
double StopLoss     = 1000;
extern double StopLossR    = 500;
extern double RsiMin=30.0,StochMin=20.0;
extern double bool_dev=3.0;

string SETTINGS_2;
int shift=1;
extern int opennewafter=5,closeafter=15;
int tradehourfrom=0,tradehourto=25;

int max_period_M1=20;
int max_period_M5=10;
int max_period;
datetime lastcheck,lastopen;


int order_send    =0;
int order_close   =0;
int total         =0;
int last_ticket;
int order;
double tav0,tav1,tavm;
double prof0,prof1,profm;


//--------------------------------------------------------------------

int init()
   {  order=0;
      if (Period()==PERIOD_M1) max_period=max_period_M1;
                         else max_period=max_period_M5;
      return(0);   }

int deinit()
   {  return(0); }

int start()
   { total=OrdersTotal(); 
   
   if (total==0)
      {  order_send=F_order_send();
         if (order_send!=0 && TimeCurrent()>lastopen+Period()*60*opennewafter && Hour()>=tradehourfrom && Hour()<=tradehourto)
         {
         if (order_send==1)   last_ticket=OrderSend(Symbol(),OP_BUY,Lots,Ask,3,Ask-StopLoss*Point,Ask+TakeProfit*Point,"",MAGICME,0,Green);
         if (order_send==-1)  last_ticket=OrderSend(Symbol(),OP_SELL,Lots,Bid,3,Bid+StopLoss*Point,Bid-TakeProfit*Point,"",MAGICME,0,Red);
         lastopen=TimeCurrent();
         OrderSelect(last_ticket,SELECT_BY_TICKET);
         tav0=(OrderOpenPrice()-iMA(NULL,0,50,0,MODE_SMA,PRICE_CLOSE,shift));
         }
      }

      
   if (total!=0) 
      {  order_close=F_close_TP_SL(last_ticket,TakeProfitR,StopLossR);
         if (order_close==1) {
            OrderSelect(last_ticket,SELECT_BY_TICKET);
            if (OrderType()==0) OrderClose(OrderTicket(),OrderLots(),Bid,3,Red);
            if (OrderType()==1) OrderClose(OrderTicket(),OrderLots(),Ask,3,Red);}            
      }   
   }
   
   
//--------------------------------------------------------------------

int F_order_send()    {        
   if (Close[shift]> iBands(NULL,0,50,bool_dev,0,PRICE_CLOSE,MODE_UPPER,shift)
      && (100.0-RsiMin)<=iRSI(NULL,0,8,PRICE_CLOSE,shift) 
      && (100.0-StochMin)<=iStochastic(NULL,0,14,3,3,MODE_SMA,0,MODE_MAIN,shift)
      //&& iMA(NULL,1440,5,0,MODE_EMA,PRICE_CLOSE,1)<iMA(NULL,1440,20,0,MODE_EMA,PRICE_CLOSE,1)
      //&& Close[shift]<iMA(NULL,60,14,0,MODE_EMA,PRICE_CLOSE,shift)      
      ) return(-1);
   
   if (Close[shift]< iBands(NULL,0,50,bool_dev,0,PRICE_CLOSE,MODE_LOWER,shift)
      && RsiMin>=iRSI(NULL,0,8,PRICE_CLOSE,shift) 
      && StochMin>=iStochastic(NULL,0,14,3,3,MODE_SMA,0,MODE_MAIN,shift)
      //&&  Close[shift]>iMA(NULL,60,14,0,MODE_EMA,PRICE_CLOSE,shift)
      ) return(1);
   return(0);   }


int F_close_TP_SL(int tick,double tp,double sl) {
         OrderSelect(tick,SELECT_BY_TICKET);
         
         if (OrderType()==0 && (Bid-OrderOpenPrice()>=tp*Point || OrderOpenPrice()-Bid>=sl*Point)) return(1);
         if (OrderType()==1 && (OrderOpenPrice()-Ask>=tp*Point || Ask-OrderOpenPrice()>=sl*Point)) return(1);
   
         tav1=(OrderOpenPrice()-iMA(NULL,0,50,0,MODE_SMA,PRICE_CLOSE,shift));
         if (tav1/tav0<0.3) return(1);
         if (TimeCurrent()>lastopen+Period()*60*closeafter) return(1);

   return(0);}


