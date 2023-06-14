//--------------------------------------------------------------------
//--------------------------------------------------------------------



#define MAGICME 10031000

double Lots = 0.1;

extern string SETTINGS_1;
double TakeProfit = 1000,StopLoss = 1000;
extern double TpR = 40,SlR = 500;
extern bool reverse=true;
extern double Tp2R = 40,Sl2R = 500;
extern int opennewafter=5,closeafter=15;
extern int tradehourfrom=0,tradehourto=25;

extern string SETTINGS_2;
extern double RsiMin=30.0,StochMin=20.0;
extern int shift=2;
extern double bool_dev=3.0;

datetime lastcheck,lastopen;
int order_send    =0;
int order_close   =0;
int total         =0;
int last_ticket,last_ticket2;
int order;
double tav0,tav1,tavm;
double prof0,prof1,profm;


//--------------------------------------------------------------------

int init()
   {  order=0; return(0);   }


int start()
   { total=OrdersTotal(); 
   
   if (total==0)
      {  order_send=F_order_send();
         if (order_send!=0 && TimeCurrent()>lastopen+Period()*60*opennewafter 
            && ((tradehourfrom<tradehourto && Hour()>=tradehourfrom && Hour()<tradehourto) ||
               (tradehourfrom>tradehourto && (Hour()>=tradehourfrom || Hour()<tradehourto))) )
                  {
                  if (order_send==1)  
                     {  last_ticket=OrderSend(Symbol(),OP_BUY,Lots,Ask,3,Ask-StopLoss*Point,Ask+TakeProfit*Point,"",MAGICME,0,Green);
                        if (reverse) last_ticket2=OrderSend(Symbol(),OP_SELLSTOP,Lots*2,Ask-(TpR+10)*Point,3,Bid+StopLoss*2.5*Point,Bid-TakeProfit*2.5*Point,"",MAGICME,0,Blue); 
                        }
                  if (order_send==-1) 
                     {  last_ticket=OrderSend(Symbol(),OP_SELL,Lots,Bid,3,Bid+StopLoss*Point,Bid-TakeProfit*Point,"",MAGICME,0,Red);  
                        if (reverse) last_ticket2=OrderSend(Symbol(),OP_BUYSTOP,Lots*2,Bid+(TpR+10)*Point,3,Ask-StopLoss*2.5*Point,Ask+TakeProfit*2.5*Point,"",MAGICME,0,Blue); 
                        }
                  lastopen=TimeCurrent();
                  OrderSelect(last_ticket,SELECT_BY_TICKET);
                  tav0=(OrderOpenPrice()-iMA(NULL,0,50,0,MODE_SMA,PRICE_CLOSE,shift));
                  }
      }

      
   if (total!=0) 
      {  F_close_TP_SL(last_ticket,TpR,SlR);
         F_close_TP_SL(last_ticket2,Tp2R,Sl2R);
         order_close=F_close(last_ticket,TpR,SlR);
         if (order_close==1) {
            OrderSelect(last_ticket,SELECT_BY_TICKET);
            if (OrderType()==0) {OrderClose(OrderTicket(),OrderLots(),Bid,3,Red); OrderDelete(last_ticket2);   }
            if (OrderType()==1) {OrderClose(OrderTicket(),OrderLots(),Ask,3,Red); OrderDelete(last_ticket2);   }
            }            
      }   
   }
   
   
//--------------------------------------------------------------------

int F_order_send()    {        
   if (Close[shift]> iBands(NULL,0,50,bool_dev,0,PRICE_CLOSE,MODE_UPPER,shift)
      && (100.0-RsiMin)<=iRSI(NULL,0,8,PRICE_CLOSE,shift) 
      && (100.0-StochMin)<=iStochastic(NULL,0,14,3,3,MODE_SMA,0,MODE_MAIN,shift)
         //&& Close[shift-1]< iBands(NULL,0,50,bool_dev,0,PRICE_CLOSE,MODE_UPPER,shift-1)
         && Close[1]<iMA(NULL,1440,14,0,MODE_EMA,PRICE_CLOSE,0)      
      ) return(-1);
   
   if (Close[shift]< iBands(NULL,0,50,bool_dev,0,PRICE_CLOSE,MODE_LOWER,shift)
      && RsiMin>=iRSI(NULL,0,8,PRICE_CLOSE,shift) 
      && StochMin>=iStochastic(NULL,0,14,3,3,MODE_SMA,0,MODE_MAIN,shift)
         //&& Close[shift-1]> iBands(NULL,0,50,bool_dev,0,PRICE_CLOSE,MODE_LOWER,shift-1)
        && Close[1]>iMA(NULL,1440,14,0,MODE_EMA,PRICE_CLOSE,0)   
      ) return(1);
   return(0);   }


int F_close(int tick2,double tp2,double sl2) {
         OrderSelect(tick2,SELECT_BY_TICKET);
         tav1=(OrderOpenPrice()-iMA(NULL,0,50,0,MODE_SMA,PRICE_CLOSE,1));
         if (tav1/tav0<0.0) return(1);
         if (TimeCurrent()>lastopen+Period()*60*closeafter) return(1);
   return(0);}


void F_close_TP_SL(int tick,double tp,double sl) {
         OrderSelect(tick,SELECT_BY_TICKET);
         if (OrderType()==0 && (Bid-OrderOpenPrice()>=tp*Point || OrderOpenPrice()-Bid>=sl*Point)) OrderClose(OrderTicket(),OrderLots(),Bid,3,Red);
         if (OrderType()==1 && (OrderOpenPrice()-Ask>=tp*Point || Ask-OrderOpenPrice()>=sl*Point)) OrderClose(OrderTicket(),OrderLots(),Ask,3,Red);      
   return(0);}

