//+------------------------------------------------------------------+
//|                                                  MACD Sample.mq4 |
//|                      Copyright © 2005, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+

#define MAGIC_d2l 10010099

 
   extern bool enable_d2l_single=true;   
   bool enable_d2l_singleR=false;
   extern bool enable_d2l_multi=false;
   extern bool cancel_opposite=false;
   extern bool lots_increase=true; 
   extern bool limitorders=false;
   extern double   Lots_d2l = 0.1, Lots_min=0.1, Lots_p_th=0.1, Lots2=1.0;
   extern double   szorzo_d2l=1.0,   agression=2.0, szorzo_max=8.0;

   /* Daily 2 limit single settings */    extern double Movement =40,  TakeProfit = 20,   StopLoss =50;
                                          datetime utolsokotes_d2l,utolsocheck_d21,utolsoelimintate_d21;
                                          int      pendinghours_d2l=8;
                                          extern int      startinghour=10,expirehours_d2l=7;
                                          int      eleminatehour=23;
                                                   
   
   /* Daily 2 limit multi  settings */
   int      symbolscount=        10;   
                           //    na       ,OK!!    ,na      ,na      ,OK 2agr ,na      ,na      ,OK!!    ,OK!!      pend 8 exp 7 start8
   string   symbols[10]=         {"EURGBPFXF","EURUSDFXF","EURCHFFXF","EURJPYFXF","GBPUSDFXF","GBPCHFFXF","GBPJPYFXF","USDCHFFXF","USDJPYFXF","CHFJPYFXF"};
   bool     enabled_symbol[10]=  {true       ,false      ,false      ,false      ,true       ,false      ,false      ,true      ,false      ,false};
   bool     reverse_symbol[10]=  {false      ,false      ,false      ,false      ,false      ,false      ,false      ,false      ,false      ,true};
   int      magic_symbol[10]=    {10010000   ,10010001   ,10010002   ,10010003   ,10010004   ,10010005   ,10010006   ,10010007   ,10010008   ,10010009};
   double   move_symbol[10] =    {40         ,55         ,45         ,45         ,40         ,45         ,45         ,45         ,20         ,50      };
   double   takep_symbol[10] =   {20         ,20         ,45         ,45         ,20         ,45         ,45         ,20         ,15         ,15      };
   double   stopl_symbol[10] =   {50         ,55         ,45         ,45         ,50         ,45         ,45         ,50         ,50         ,70      };
   double   bid[10] ;
   double   ask[10] ;
   double   point[10];
   int      digits[10];
   int      spread[10];
   double   lastp_symbol[10]=    {0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0};
   double   szorzo_symbol[10]=   {1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0};
   int      last_tick_symbol[10][2]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
   
   int total;


//+------------------------------------------------------------------+
//|                                                             |
//+------------------------------------------------------------------+


int init()
   {utolsokotes_d2l=TimeCurrent()-25*60*60; utolsocheck_d21=TimeCurrent()-25*60*60; utolsoelimintate_d21=TimeCurrent()-25*60*60; return(0); }

int start()
   {
   if (TimeCurrent()>utolsokotes_d2l+23*60*60 && TimeHour(TimeCurrent())==startinghour-1 && lots_increase) 
      { Lots_d2l=NormalizeDouble(AccountEquity()/1000*Lots_p_th,2); }

   if (TimeCurrent()>utolsokotes_d2l+23*60*60 && TimeHour(TimeCurrent())==startinghour && enable_d2l_single) F_open_d2l_single();
   if (TimeCurrent()>utolsokotes_d2l+23*60*60 && TimeHour(TimeCurrent())==startinghour && enable_d2l_multi) F_open_d2l_multi();      
   if (TimeCurrent()>utolsokotes_d2l+23*60*60 && TimeHour(TimeCurrent())==startinghour && enable_d2l_singleR) F_open_d2l_singleR();

   if (1==2 && TimeCurrent()>utolsokotes_d2l+pendinghours_d2l*60*60 ) F_close_at_expire();
   if (cancel_opposite && TimeCurrent()>utolsocheck_d21+60*1) F_cancel_opposite();  
   if (1==2 && TimeHour(TimeCurrent())==eleminatehour) F_close_unsolved();
   return(0);
   }




//+------------------------------------------------------------------+
   

void F_open_d2l_single()  {
               lastp_symbol[0]=0; 
               OrderSelect(last_tick_symbol[0][OP_BUY],SELECT_BY_TICKET);lastp_symbol[0]+=OrderProfit(); 
               OrderSelect(last_tick_symbol[0][OP_SELL],SELECT_BY_TICKET);lastp_symbol[0]+=OrderProfit();
               if (lastp_symbol[0]<0) szorzo_d2l=szorzo_d2l*agression;
               if (lastp_symbol[0]>0) szorzo_d2l=1.0;
               if (szorzo_d2l>szorzo_max) szorzo_d2l=szorzo_max;
   
   Lots2=Lots_d2l*szorzo_d2l; if (Lots2<Lots_min) Lots_d2l=Lots_min; 
   if (limitorders==false) {
      last_tick_symbol[0][OP_BUY]=OrderSend(Symbol(),OP_BUYSTOP, Lots2,Ask+Movement*Point,30,Ask+(Movement-StopLoss)*Point,Ask+(Movement+TakeProfit)*Point,"ea_d2l",MAGIC_d2l,TimeCurrent()+expirehours_d2l*60*60,Green);
      last_tick_symbol[0][OP_SELL]=OrderSend(Symbol(),OP_SELLSTOP,Lots2,Bid-Movement*Point,30,Bid-(Movement-StopLoss)*Point,Bid-(Movement+TakeProfit)*Point,"ea_d2l",MAGIC_d2l,TimeCurrent()+expirehours_d2l*60*60,Green)  ;      
      }
      else {
      last_tick_symbol[0][OP_BUY]=OrderSend(Symbol(),OP_BUYLIMIT,Lots2,Ask-Movement*Point,30,Ask-(Movement+StopLoss)*Point,Ask-(Movement-TakeProfit)*Point,"ea_d2l",MAGIC_d2l,TimeCurrent()+expirehours_d2l*60*60,Green);
      last_tick_symbol[0][OP_SELL]=OrderSend(Symbol(),OP_SELLLIMIT,Lots2,Bid+Movement*Point,30,Bid+(Movement+StopLoss)*Point,Bid+(Movement-TakeProfit)*Point,"ea_d2l",MAGIC_d2l,TimeCurrent()+expirehours_d2l*60*60,Green)  ;           
      }
   
   utolsokotes_d2l=TimeCurrent();utolsocheck_d21=TimeCurrent();
   return(0);}


void F_open_d2l_multi()
   { for (int i=0 ;i<10; i++) if (enabled_symbol[i]==true)
   {
         bid[i]    =MarketInfo(symbols[i],MODE_BID);
         ask[i]    =MarketInfo(symbols[i],MODE_ASK);
         point[i]  =MarketInfo(symbols[i],MODE_POINT);
         digits[i] =MarketInfo(symbols[i],MODE_DIGITS);
         spread[i] =MarketInfo(symbols[i],MODE_SPREAD);          
         
               lastp_symbol[i]=0; 
               OrderSelect(last_tick_symbol[i][OP_BUY],SELECT_BY_TICKET);lastp_symbol[i]+=OrderProfit();
               OrderSelect(last_tick_symbol[i][OP_SELL],SELECT_BY_TICKET);lastp_symbol[i]+=OrderProfit();
               if (lastp_symbol[i]<0) szorzo_symbol[i]=szorzo_symbol[i]*agression;
               if (lastp_symbol[i]>0) szorzo_symbol[i]=1.0;
               if (szorzo_symbol[i]>szorzo_max) szorzo_symbol[i]=szorzo_max;

         Lots2=Lots_d2l*szorzo_symbol[i]; if (Lots2<Lots_min) Lots_d2l=Lots_min;         
         if (enabled_symbol[i] && reverse_symbol[i]==false) {
                  last_tick_symbol[i][OP_BUY]=OrderSend(symbols[i],OP_BUYSTOP, Lots2,ask[i]+move_symbol[i]*point[i],3,ask[i]+(move_symbol[i]-stopl_symbol[i])*point[i],
                     ask[i]+(move_symbol[i]+takep_symbol[i])*point[i],"ea_d2l",magic_symbol[i],TimeCurrent()+expirehours_d2l*60*60,Green);
                  last_tick_symbol[i][OP_SELL]=OrderSend(symbols[i],OP_SELLSTOP,Lots2,bid[i]-move_symbol[i]*point[i],3,bid[i]-(move_symbol[i]-stopl_symbol[i])*point[i],
                  bid[i]-(move_symbol[i]+takep_symbol[i])*point[i],"ea_d2l",magic_symbol[i],TimeCurrent()+expirehours_d2l*60*60,Green)  ;      
         }
         
         if (enabled_symbol[i] && reverse_symbol[i]) {
                  last_tick_symbol[i][OP_SELL]=OrderSend(symbols[i],OP_SELLLIMIT, Lots2,ask[i]+move_symbol[i]*point[i],3,ask[i]+(move_symbol[i]+stopl_symbol[i])*point[i],
                     ask[i]+(move_symbol[i]-takep_symbol[i])*point[i],"ea_d2l",magic_symbol[i],TimeCurrent()+expirehours_d2l*60*60,Green);
                  last_tick_symbol[i][OP_BUY]=OrderSend(symbols[i],OP_BUYLIMIT,Lots2,bid[i]-move_symbol[i]*point[i],3,bid[i]-(move_symbol[i]+stopl_symbol[i])*point[i],
                  bid[i]-(move_symbol[i]-takep_symbol[i])*point[i],"ea_d2l",magic_symbol[i],TimeCurrent()+expirehours_d2l*60*60,Green)  ;      
         }         
         
   } utolsokotes_d2l=TimeCurrent(); utolsocheck_d21=TimeCurrent(); return(0);}
   
   
void F_close_at_expire()
   {if (OrdersTotal()>0)
         for (int cnt=1; cnt<=OrdersTotal();cnt++) {
            OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
            if (OrderType()>1 && (OrderMagicNumber()==MAGIC_d2l || (OrderMagicNumber()>=magic_symbol[0] && OrderMagicNumber()<=magic_symbol[symbolscount-1]))) 
            OrderDelete(OrderTicket()); }
   return(0);}

void F_close_unsolved()
   {  utolsocheck_d21=TimeCurrent();
      if (OrdersTotal()>0)         
         for (int i=0; i<10;i++) 
            {
            if  ( (enable_d2l_single==true && i==0) ||
                  (enable_d2l_multi==true && enabled_symbol[i]) ) {
                           if (OrderSelect(last_tick_symbol[i][OP_BUY],SELECT_BY_TICKET)==true) 
                              if (OrderType()<2) OrderClose(OrderTicket(),OrderLots(),Bid,3,Red); 
                           if (OrderSelect(last_tick_symbol[i][OP_SELL],SELECT_BY_TICKET)==true)                        
                              if (OrderType()<2) OrderClose(OrderTicket(),OrderLots(),Ask,3,Red); 
                                                }
            if (enable_d2l_multi==false) break;
            }
   return(0);}   
   
void F_cancel_opposite()
   {  utolsocheck_d21=TimeCurrent();
      if (OrdersTotal()>0)         
         for (int i=0; i<10;i++) 
            {
            if  ( (enable_d2l_single==true && i==0) ||
                  (enable_d2l_multi==true && enabled_symbol[i]) ) {
                           if (OrderSelect(last_tick_symbol[i][OP_BUY],SELECT_BY_TICKET)==true) 
                              if (OrderType()<2) {
                                 OrderSelect(last_tick_symbol[i][OP_SELL],SELECT_BY_TICKET);
                                 if (OrderType()>1)                                
                                 OrderDelete(last_tick_symbol[i][OP_SELL]);   }
                           if (OrderSelect(last_tick_symbol[i][OP_SELL],SELECT_BY_TICKET)==true)                        
                              if (OrderType()<2) {
                                 OrderSelect(last_tick_symbol[i][OP_BUY],SELECT_BY_TICKET);
                                 if (OrderType()>1)
                                 OrderDelete(last_tick_symbol[i][OP_BUY]); }
                                                }
            if (enable_d2l_multi==false) break;
            }
   return(0);}
   

void F_open_d2l_singleR()  {
               lastp_symbol[0]=0; 
               OrderSelect(last_tick_symbol[0][OP_BUY],SELECT_BY_TICKET);lastp_symbol[0]+=OrderProfit(); 
               OrderSelect(last_tick_symbol[0][OP_SELL],SELECT_BY_TICKET);lastp_symbol[0]+=OrderProfit();
               if (lastp_symbol[0]<0) szorzo_d2l=szorzo_d2l*agression;
               if (lastp_symbol[0]>0) szorzo_d2l=1.0;
               if (szorzo_d2l>szorzo_max) szorzo_d2l=szorzo_max;
   
   Lots2=Lots_d2l*szorzo_d2l; if (Lots2<Lots_min) Lots_d2l=Lots_min; 
   last_tick_symbol[0][OP_SELL]=OrderSend(Symbol(),OP_SELLLIMIT,Lots2,Ask+Movement*Point,3,Ask+(Movement+StopLoss)*Point,Ask+(Movement-TakeProfit)*Point,"own_d2l_single",MAGIC_d2l,TimeCurrent()+expirehours_d2l*60*60,Green);
   last_tick_symbol[0][OP_BUY]=OrderSend(Symbol(),OP_BUYLIMIT,Lots2,Bid-Movement*Point,3,Bid-(Movement+StopLoss)*Point,Bid-(Movement-TakeProfit)*Point,"own_d2l_single",MAGIC_d2l,TimeCurrent()+expirehours_d2l*60*60,Green)  ;      
   utolsokotes_d2l=TimeCurrent();utolsocheck_d21=TimeCurrent();
   return(0);}


