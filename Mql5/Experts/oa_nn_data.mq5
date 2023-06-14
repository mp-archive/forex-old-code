//+------------------------------------------------------------------+
//|                                                   oa_nn_data.mq5 |
//|                                                               mp |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "mp"
#property link      "http://www.mql5.com"
#property version   "1.00"

#include <mp\mp_mql4_functions.mqh>
#include <Trade\Trade.mqh>
#include <Trade\PositionInfo.mqh>
#include <Trade\AccountInfo.mqh>

input int frequency=150;
input int rsi_period=20;
input int stoch_period=20;
input int adx_period=20;
input int atr_period=20;
input int bool_preiod=20;
input double lot=0.1,d5=10.0;
input int rndmin=30;
bool bopen=false;
double bbalance;

   double ticket,lastprice;
   MqlTick current_price;
   CPositionInfo current_order;
   CAccountInfo account_info;
   CTrade trade;  
   datetime lastopen;

input int tp=30;
input int sl=30;

string file_name="test_data2013.csv";
int afile;


int OnInit()
  {
   afile=FileOpen(file_name,FILE_CSV|FILE_WRITE);
   if(afile<0)
     {
      Print("Failed to open the file by the absolute path ");
      Print("Error code ",GetLastError());
     }   
   
   bbalance=AccountInfoDouble(ACCOUNT_BALANCE);
   MathSrand(GetTickCount()); 
   return(INIT_SUCCEEDED);   
  }


void OnDeinit(const int reason)
  {
   FileClose(afile);
  }

void OnTick()
  {
  if (PositionsTotal()==0) 
     {
        Sleep(NormalizeDouble(MathRand()/32767*1000*60*rndmin,0));
        F_write(1);bopen=true;
     }
     else
     {
       if (bopen==true) {F_write(2);bopen=false;}
     }
    
  }
// -----------  

void F_write(int phase)
  {
   MqlTick current_price;
   CPositionInfo current_order;
   CAccountInfo account_info;
   CTrade trade;    
   switch(phase)
     {
      case 1:
        {

         F_SetMQL4PreDefVar(200);
         if(MathRand()<32767/2) 
            {trade.PositionOpen(Symbol(),ORDER_TYPE_BUY,lot,current_price.ask,current_price.ask-sl*d5*Point(),current_price.ask+tp*d5*Point(),"");
            PositionSelect(Symbol());lastprice=PositionGetDouble(POSITION_PRICE_OPEN);  ticket=PositionGetInteger(POSITION_IDENTIFIER);                           
            if (trade.PositionModify(Symbol(),lastprice-sl*d5*Point(),lastprice+tp*d5*Point())==false) trade.PositionClose(Symbol());
            }
         else 
            {trade.PositionOpen(Symbol(),ORDER_TYPE_SELL,lot,current_price.ask,current_price.ask+sl*d5*Point(),current_price.ask-tp*d5*Point(),"");
            PositionSelect(Symbol());lastprice=PositionGetDouble(POSITION_PRICE_OPEN);  ticket=PositionGetInteger(POSITION_IDENTIFIER);                    
            if (trade.PositionModify(Symbol(),lastprice+sl*d5*Point(),lastprice-tp*d5*Point())==false) trade.PositionClose(Symbol());
            }
         FileWrite(afile,ticket,"00openprice",PositionGetDouble(POSITION_PRICE_OPEN));
         FileWrite(afile,ticket,"01ordertype",PositionGetInteger(POSITION_TYPE));        
         FileWrite(afile,ticket,"02rsiM5",iRSIMQL4(Symbol(),5,rsi_period,PRICE_CLOSE,1));
         FileWrite(afile,ticket,"03stochM5",iStochasticMQL4(Symbol(),5,30,5,3,MODE_SMA,0,MODE_MAIN,1));
         FileWrite(afile,ticket,"04adxM5",iADXMQL4(Symbol(),5,adx_period,PRICE_CLOSE,MODE_MAIN,1));
         FileWrite(afile,ticket,"05atrM5",iATRMQL4(Symbol(),5,atr_period,1));
         FileWrite(afile,ticket,"06boolM5",iBandsMQL4(Symbol(),5,bool_preiod,2,0,PRICE_CLOSE,MODE_UPPER,1));
         FileWrite(afile,ticket,"07rsiH1",iRSIMQL4(Symbol(),60,rsi_period,PRICE_CLOSE,1));
         FileWrite(afile,ticket,"08stochH1",iStochasticMQL4(Symbol(),60,30,5,3,MODE_SMA,0,MODE_MAIN,1));
         FileWrite(afile,ticket,"09adxH1",iADXMQL4(Symbol(),60,adx_period,PRICE_CLOSE,MODE_MAIN,1));
         FileWrite(afile,ticket,"10atrH1",iATRMQL4(Symbol(),60,atr_period,1));
         FileWrite(afile,ticket,"11boolH1",iBandsMQL4(Symbol(),60,bool_preiod,2,0,PRICE_CLOSE,MODE_UPPER,1));
         FileWrite(afile,ticket,"12CO1",Close[1]-Close[2]);
         FileWrite(afile,ticket,"13CO5",Close[1]-Close[6]);
         FileWrite(afile,ticket,"14CO10",Close[1]-Close[11]);
         FileWrite(afile,ticket,"15CO20",Close[1]-Close[21]);
         FileWrite(afile,ticket,"16CO120",Close[1]-Close[121]);
         FileWrite(afile,ticket,"17CL10",Close[1]-mlow(1,11));
         FileWrite(afile,ticket,"18CL30",Close[1]-mlow(1,31));
         FileWrite(afile,ticket,"19CL90",Close[1]-mlow(1,91));
         FileWrite(afile,ticket,"20CH10",Close[1]-mhigh(1,11));
         FileWrite(afile,ticket,"21CH30",Close[1]-mhigh(1,31));
         FileWrite(afile,ticket,"22CH90",Close[1]-mhigh(1,91));
        }
      case 2:
        {
         ///if (bbalance<AccountInfoDouble(ACCOUNT_BALANCE)) 
         FileWrite(afile,ticket,"90win",(bbalance<AccountInfoDouble(ACCOUNT_BALANCE))*1);   Print("jfdlséj");  
         bbalance=AccountInfoDouble(ACCOUNT_BALANCE);
        }
     }
   return;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double mlow(int x,int y)
  {
   double temp=9999.9;
   for(int z=x; z<=y; z++)
      if(Low[z]<temp) temp=Low[z];
   return(temp);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double mhigh(int x,int y)
  {
   double temp=0;
   for(int z=x; z<=y; z++)
      if(High[z]>temp) temp=High[z];
   return(temp);
  }
//+------------------------------------------------------------------+
