//+------------------------------------------------------------------+
//|                                                        test1.mq5 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright ""
#property link      ""
#property version   "1.00"
#include <Trade\Trade.mqh>
#include <Trade\PositionInfo.mqh>
#include <Trade\AccountInfo.mqh>
#include <mp\mp_currencies.mqh>


   input int entry_type        =1;     
   input double sl2=30,tp2=20,lot=0.01;
   input ENUM_TIMEFRAMES   strat_period=0;

   int handle_ma,signal;
   double d5=10;
   double ma[];
   string symbol;
   

/* ---------------------- */

int OnInit()
  {
   symbol=F_symbol();
   return(INIT_SUCCEEDED); 
  }


void OnDeinit(const int reason)
  {

   
  }

void OnTick()
  {

   handle_ma=iMA(NULL,strat_period,21,0,MODE_EMA,PRICE_CLOSE);
   CopyBuffer(handle_ma,0,0,100,ma);
   ArraySetAsSeries(ma,true);
   
   if (PositionsTotal()==0) {
   signal=F_setsignal();
   if(signal!=0) F_Open(signal);}

   
  }


/* ---------------------- */


int F_setsignal()
{ int signal2=0;
   
   if (entry_type==1) {
      if (ma[5]>ma[20] && ma[20]>ma[70]) signal2=1;
      if (ma[5]<ma[20] && ma[20]<ma[70]) signal2=1;
   }
return(signal2);
}

void F_Open(int signal2)
{

MqlTick current_price;
CPositionInfo current_order;
CAccountInfo account_info;
CTrade trade;      
double lastprice;

      SymbolInfoTick(symbol,current_price);
      if(signal2==1) {
         trade.PositionOpen(symbol,ORDER_TYPE_BUY,lot,current_price.ask,current_price.ask-sl2*d5*Point(),current_price.ask+tp2*d5*Point(),"");
         PositionSelect(symbol);lastprice=PositionGetDouble(POSITION_PRICE_OPEN);
         if (trade.PositionModify(symbol,lastprice-sl2*d5*Point(),lastprice+tp2*d5*Point())==false) trade.PositionClose(symbol);
         }
      if(signal2==-1) {
         trade.PositionOpen(symbol,ORDER_TYPE_SELL,lot,current_price.bid,current_price.bid+sl2*d5*Point(),current_price.bid-tp2*d5*Point(),"");
         PositionSelect(symbol);lastprice=PositionGetDouble(POSITION_PRICE_OPEN);
         if (trade.PositionModify(symbol,lastprice+sl2*d5*Point(),lastprice-tp2*d5*Point())==false) trade.PositionClose(symbol);
         }



}