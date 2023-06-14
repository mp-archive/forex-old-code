//+------------------------------------------------------------------+
//|                                                        test4.mq5 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Include                                                          |
//+------------------------------------------------------------------+
#include <Expert\Expert.mqh>
//--- available signals
#include <Expert\Signal\SignalRSI.mqh>
#include <Expert\Signal\SignalFrAMA.mqh>
#include <Expert\Signal\SignalMA.mqh>
//--- available trailing
#include <Expert\Trailing\TrailingParabolicSAR.mqh>
//--- available money management
#include <Expert\Money\MoneyFixedMargin.mqh>
//+------------------------------------------------------------------+
//| Inputs                                                           |
//+------------------------------------------------------------------+
//--- inputs for expert
input string             Expert_Title                 ="test4";     // Document name
ulong                    Expert_MagicNumber           =31177;       // 
bool                     Expert_EveryTick             =false;       // 
//--- inputs for main signal
input int                Signal_ThresholdOpen         =10;          // Signal threshold value to open [0...100]
input int                Signal_ThresholdClose        =10;          // Signal threshold value to close [0...100]
input double             Signal_PriceLevel            =0.0;         // Price level to execute a deal
input double             Signal_StopLevel             =50.0;        // Stop Loss level (in points)
input double             Signal_TakeLevel             =50.0;        // Take Profit level (in points)
input int                Signal_Expiration            =4;           // Expiration of pending orders (in bars)
input int                Signal_RSI_PeriodRSI         =8;           // Relative Strength Index(8,...) Period of calculation
input ENUM_APPLIED_PRICE Signal_RSI_Applied           =PRICE_CLOSE; // Relative Strength Index(8,...) Prices series
input double             Signal_RSI_Weight            =1.0;         // Relative Strength Index(8,...) Weight [0...1.0]
input int                Signal_FraMA_PeriodMA        =12;          // Fractal Adaptive Moving Average Period of averaging
input int                Signal_FraMA_Shift           =0;           // Fractal Adaptive Moving Average Time shift
input ENUM_APPLIED_PRICE Signal_FraMA_Applied         =PRICE_CLOSE; // Fractal Adaptive Moving Average Prices series
input double             Signal_FraMA_Weight          =1.0;         // Fractal Adaptive Moving Average Weight [0...1.0]
input int                Signal_MA_PeriodMA           =12;          // Moving Average(12,0,...) Period of averaging
input int                Signal_MA_Shift              =0;           // Moving Average(12,0,...) Time shift
input ENUM_MA_METHOD     Signal_MA_Method             =MODE_SMA;    // Moving Average(12,0,...) Method of averaging
input ENUM_APPLIED_PRICE Signal_MA_Applied            =PRICE_CLOSE; // Moving Average(12,0,...) Prices series
input double             Signal_MA_Weight             =1.0;         // Moving Average(12,0,...) Weight [0...1.0]
//--- inputs for trailing
input double             Trailing_ParabolicSAR_Step   =0.02;        // Speed increment
input double             Trailing_ParabolicSAR_Maximum=0.2;         // Maximum rate
//--- inputs for money
input double             Money_FixMargin_Percent=10.0;        // Percentage of margin
//+------------------------------------------------------------------+
//| Global expert object                                             |
//+------------------------------------------------------------------+
CExpert ExtExpert;
//+------------------------------------------------------------------+
//| Initialization function of the expert                            |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- Initializing expert
   if(!ExtExpert.Init(Symbol(),Period(),Expert_EveryTick,Expert_MagicNumber))
     {
      //--- failed
      printf(__FUNCTION__+": error initializing expert");
      ExtExpert.Deinit();
      return(INIT_FAILED);
     }
//--- Creating signal
   CExpertSignal *signal=new CExpertSignal;
   if(signal==NULL)
     {
      //--- failed
      printf(__FUNCTION__+": error creating signal");
      ExtExpert.Deinit();
      return(INIT_FAILED);
     }
//---
   ExtExpert.InitSignal(signal);
   signal.ThresholdOpen(Signal_ThresholdOpen);
   signal.ThresholdClose(Signal_ThresholdClose);
   signal.PriceLevel(Signal_PriceLevel);
   signal.StopLevel(Signal_StopLevel);
   signal.TakeLevel(Signal_TakeLevel);
   signal.Expiration(Signal_Expiration);
   
   
   
   
//--- Creating filter CSignalRSI
   CSignalRSI *filter0=new CSignalRSI;
   if(filter0==NULL)
     {
      //--- failed
      printf(__FUNCTION__+": error creating filter0");
      ExtExpert.Deinit();
      return(INIT_FAILED);
     }
   signal.AddFilter(filter0);
//--- Set filter parameters
   filter0.PeriodRSI(Signal_RSI_PeriodRSI);
   filter0.Applied(Signal_RSI_Applied);
   filter0.Weight(Signal_RSI_Weight);
   
   
   
   
//--- Creating filter CSignalFrAMA
   CSignalFrAMA *filter1=new CSignalFrAMA;
   if(filter1==NULL)
     {
      //--- failed
      printf(__FUNCTION__+": error creating filter1");
      ExtExpert.Deinit();
      return(INIT_FAILED);
     }
   signal.AddFilter(filter1);
//--- Set filter parameters
   filter1.PeriodMA(Signal_FraMA_PeriodMA);
   filter1.Shift(Signal_FraMA_Shift);
   filter1.Applied(Signal_FraMA_Applied);
   filter1.Weight(Signal_FraMA_Weight);
   
   
   
   
//--- Creating filter CSignalMA
   CSignalMA *filter2=new CSignalMA;
   if(filter2==NULL)
     {
      //--- failed
      printf(__FUNCTION__+": error creating filter2");
      ExtExpert.Deinit();
      return(INIT_FAILED);
     }
   signal.AddFilter(filter2);
//--- Set filter parameters
   filter2.PeriodMA(Signal_MA_PeriodMA);
   filter2.Shift(Signal_MA_Shift);
   filter2.Method(Signal_MA_Method);
   filter2.Applied(Signal_MA_Applied);
   filter2.Weight(Signal_MA_Weight);
//--- Creation of trailing object
   CTrailingPSAR *trailing=new CTrailingPSAR;
   if(trailing==NULL)
     {
      //--- failed
      printf(__FUNCTION__+": error creating trailing");
      ExtExpert.Deinit();
      return(INIT_FAILED);
     }
     
     
     
//--- Add trailing to expert (will be deleted automatically))
   if(!ExtExpert.InitTrailing(trailing))
     {
      //--- failed
      printf(__FUNCTION__+": error initializing trailing");
      ExtExpert.Deinit();
      return(INIT_FAILED);
     }
//--- Set trailing parameters
   trailing.Step(Trailing_ParabolicSAR_Step);
   trailing.Maximum(Trailing_ParabolicSAR_Maximum);
   
   
   
//--- Creation of money object
   CMoneyFixedMargin *money=new CMoneyFixedMargin;
   if(money==NULL)
     {
      //--- failed
      printf(__FUNCTION__+": error creating money");
      ExtExpert.Deinit();
      return(INIT_FAILED);
     }
//--- Add money to expert (will be deleted automatically))
   if(!ExtExpert.InitMoney(money))
     {
      //--- failed
      printf(__FUNCTION__+": error initializing money");
      ExtExpert.Deinit();
      return(INIT_FAILED);
     }
//--- Set money parameters
   money.Percent(Money_FixMargin_Percent);
//--- Check all trading objects parameters
   if(!ExtExpert.ValidationSettings())
     {
      //--- failed
      ExtExpert.Deinit();
      return(INIT_FAILED);
     }
     
     
     
     
//--- Tuning of all necessary indicators
   if(!ExtExpert.InitIndicators())
     {
      //--- failed
      printf(__FUNCTION__+": error initializing indicators");
      ExtExpert.Deinit();
      return(INIT_FAILED);
     }
//--- ok
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Deinitialization function of the expert                          |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   ExtExpert.Deinit();
  }
//+------------------------------------------------------------------+
//| "Tick" event handler function                                    |
//+------------------------------------------------------------------+
void OnTick()
  {
   ExtExpert.OnTick();
  }
//+------------------------------------------------------------------+
//| "Trade" event handler function                                   |
//+------------------------------------------------------------------+
void OnTrade()
  {
   ExtExpert.OnTrade();
  }
//+------------------------------------------------------------------+
//| "Timer" event handler function                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
   ExtExpert.OnTimer();
  }
//+------------------------------------------------------------------+
