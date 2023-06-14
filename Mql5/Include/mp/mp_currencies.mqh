//+------------------------------------------------------------------+
//|                                                mp_currencies.mqh |
//|                                                               mp |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "mp"
#property link      ""

      enum enum_currencies {current=0,EURUSD=1,USDCAD=2,AUDJPY=3};
      string set_currencies[]={NULL,"EURUSD","USDCAD","AUDJPY"};
   input enum_currencies currencies;

   
string F_symbol()
   {   
   string symbol_=NULL;
   symbol_=set_currencies[currencies]; symbol_=(symbol_!=NULL)?symbol_:_Symbol;
   return(symbol_);
   }