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
//#include "initmql4.mqh"
   
   input int        entry_type        =1;     
   input double sl2=30,tp2=20;
   input ENUM_TIMEFRAMES   timeframe=0;

   int handle_ma,signal;
   double d5=10;
   double ma[];
   
   MqlTradeRequest  request;    
   MqlTradeResult   result;

/* ---------------------- */

int OnInit()
  {
   return(INIT_SUCCEEDED);
  }


void OnDeinit(const int reason)
  {

   
  }

void OnTick()
  {

   handle_ma=iMA(NULL,timeframe,21,0,MODE_EMA,PRICE_CLOSE);
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
MqlTick last_tick;
SymbolInfoTick(_Symbol,last_tick);
double Ask=last_tick.ask;


request.action=TRADE_ACTION_DEAL;
request.magic=6000;
request.symbol=_Symbol;
request.volume=0.01;
request.price=SYMBOL_TRADE_EXECUTION_MARKET;
request.sl=Ask-signal2*sl2*Point();
request.tp=Ask+signal2*sl2*Point();
request.deviation=3.0*d5;
if (signal==1) request.type=ORDER_TYPE_BUY; 
if (signal==-1) request.type=ORDER_TYPE_SELL;
request.type_filling=ORDER_FILLING_FOK;

OrderSend(request,result);

}