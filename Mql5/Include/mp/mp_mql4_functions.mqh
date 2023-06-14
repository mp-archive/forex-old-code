//+------------------------------------------------------------------+
//|                                            mp_mql4_functions.mqh |
//|                                                               mp |
//|                                                                  |
//+------------------------------------------------------------------+


#define OP_BUY 0           //Buy 
#define OP_SELL 1          //Sell
#define OP_BUYLIMIT 2      //BUY LIMIT pending order 
#define OP_SELLLIMIT 3     //SELL LIMIT pending order  
#define OP_BUYSTOP 4       //BUY STOP pending order  
#define OP_SELLSTOP 5      //SELL STOP pending order  
#define OP_BUYSTOPLIMIT 6       //BUY STOP pending order  
#define OP_SELLSTOPLIMIT 7      //SELL STOP pending order  

//---
#define OBJPROP_TIME1 300
#define OBJPROP_PRICE1 301
#define OBJPROP_TIME2 302
#define OBJPROP_PRICE2 303
#define OBJPROP_TIME3 304
#define OBJPROP_PRICE3 305
//---
#define OBJPROP_RAY 310
#define OBJPROP_FIBOLEVELS 200
//---
 
#define OBJPROP_FIRSTLEVEL1 211 
#define OBJPROP_FIRSTLEVEL2 212
#define OBJPROP_FIRSTLEVEL3 213
#define OBJPROP_FIRSTLEVEL4 214
#define OBJPROP_FIRSTLEVEL5 215
#define OBJPROP_FIRSTLEVEL6 216
#define OBJPROP_FIRSTLEVEL7 217
#define OBJPROP_FIRSTLEVEL8 218
#define OBJPROP_FIRSTLEVEL9 219
#define OBJPROP_FIRSTLEVEL10 220
#define OBJPROP_FIRSTLEVEL11 221
#define OBJPROP_FIRSTLEVEL12 222
#define OBJPROP_FIRSTLEVEL13 223
#define OBJPROP_FIRSTLEVEL14 224
#define OBJPROP_FIRSTLEVEL15 225
#define OBJPROP_FIRSTLEVEL16 226
#define OBJPROP_FIRSTLEVEL17 227
#define OBJPROP_FIRSTLEVEL18 228
#define OBJPROP_FIRSTLEVEL19 229
#define OBJPROP_FIRSTLEVEL20 230
#define OBJPROP_FIRSTLEVEL21 231
#define OBJPROP_FIRSTLEVEL22 232
#define OBJPROP_FIRSTLEVEL23 233
#define OBJPROP_FIRSTLEVEL24 234
#define OBJPROP_FIRSTLEVEL25 235
#define OBJPROP_FIRSTLEVEL26 236
#define OBJPROP_FIRSTLEVEL27 237
#define OBJPROP_FIRSTLEVEL28 238
#define OBJPROP_FIRSTLEVEL29 239
#define OBJPROP_FIRSTLEVEL30 240
#define OBJPROP_FIRSTLEVEL31 241
//---
#define MODE_OPEN 0
#define MODE_CLOSE 3
#define MODE_VOLUME 4 
#define MODE_REAL_VOLUME 5
#define MODE_TRADES 0
#define MODE_HISTORY 1
#define SELECT_BY_POS 0
#define SELECT_BY_TICKET 1
//---
#define DOUBLE_VALUE 0
#define FLOAT_VALUE 1
#define LONG_VALUE INT_VALUE
//---
#define CHART_BAR 0
#define CHART_CANDLE 1
//---
#define MODE_ASCEND 0
#define MODE_DESCEND 1
//---
#define MODE_LOW 1
#define MODE_HIGH 2
#define MODE_TIME 5
#define MODE_BID 9
#define MODE_ASK 10
#define MODE_POINT 11
#define MODE_DIGITS 12
#define MODE_SPREAD 13
#define MODE_STOPLEVEL 14
#define MODE_LOTSIZE 15
#define MODE_TICKVALUE 16
#define MODE_TICKSIZE 17
#define MODE_SWAPLONG 18
#define MODE_SWAPSHORT 19
#define MODE_STARTING 20
#define MODE_EXPIRATION 21
#define MODE_TRADEALLOWED 22
#define MODE_MINLOT 23
#define MODE_LOTSTEP 24
#define MODE_MAXLOT 25
#define MODE_SWAPTYPE 26
#define MODE_PROFITCALCMODE 27
#define MODE_MARGINCALCMODE 28
#define MODE_MARGININIT 29
#define MODE_MARGINMAINTENANCE 30
#define MODE_MARGINHEDGED 31
#define MODE_MARGINREQUIRED 32
#define MODE_FREEZELEVEL 33
//---
#define EMPTY -1
//---
#define CharToStr CharToString
#define DoubleToStr DoubleToString
#define StrToDouble StringToDouble
#define StrToInteger (int)StringToInteger
#define StrToTime StringToTime
#define TimeToStr TimeToString 
#define StringGetChar StringGetCharacter
#define StringSetChar StringSetCharacter

//enum Enum_TimeFrames2 {P_M1,P_M3,P_M5,P_M10,P_M15,P_M30,P_M60};
enum Enum_TimeFrames2 {P_M1,P_M5,P_M15,P_M30,P_M60};
enum Enum_Currency {Current,EURUSD,USDJPY,USDCAD,EURGBP,AUDJPY,AUDUSD,GBPUSD};
//enum Enum_Currency {Current,EURUSD,USDJPY,USDCAD,EURGBP,AUDJPY,AUDUSD};
enum Enum_CurrHandling {Once=1,Allowhedge=2,Allowdouble=3};

string F_Curr(Enum_Currency curr_in,string def)
   {
   switch(curr_in)
      {
      case EURUSD: return("EURUSD");
      case USDJPY: return("USDJPY");
      case EURGBP: return("EURGBP");
      case USDCAD: return("USDCAD");
      case AUDJPY: return("AUDJPY");
      case AUDUSD: return("AUDUSD");
      case GBPUSD: return("GBPUSD");  
      case Current: return(def);
      default: return(def);      
      }
   }


int F_timeframes(Enum_TimeFrames2 p_in)
   {
   switch(p_in)
      {
      case P_M1: return(1);
      //case P_M3: return(3);
      case P_M5: return(5);
      //case P_M10: return(10);
      case P_M15: return(15);
      case P_M30: return(30);
      case P_M60: return(60);
      default: return(1);      
      }
   }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ENUM_TIMEFRAMES TFMigrate(int tf)
  {
   switch(tf)
     {
      case 0: return(PERIOD_CURRENT);
      case 1: return(PERIOD_M1);
      case 5: return(PERIOD_M5);
      case 15: return(PERIOD_M15);
      case 30: return(PERIOD_M30);
      case 60: return(PERIOD_H1);
      case 240: return(PERIOD_H4);
      case 1440: return(PERIOD_D1);
      case 10080: return(PERIOD_W1);
      case 43200: return(PERIOD_MN1);
      
      case 2: return(PERIOD_M2);
      case 3: return(PERIOD_M3);
      case 4: return(PERIOD_M4);      
      case 6: return(PERIOD_M6);
      case 10: return(PERIOD_M10);
      case 12: return(PERIOD_M12);
      case 16385: return(PERIOD_H1);
      case 16386: return(PERIOD_H2);
      case 16387: return(PERIOD_H3);
      case 16388: return(PERIOD_H4);
      case 16390: return(PERIOD_H6);
      case 16392: return(PERIOD_H8);
      case 16396: return(PERIOD_H12);
      case 16408: return(PERIOD_D1);
      case 32769: return(PERIOD_W1);
      case 49153: return(PERIOD_MN1);      
      default: return(PERIOD_CURRENT);
     }
  }
  
  
ENUM_ORDER_TYPE OrderType(int ordernumber)
  {
   switch(ordernumber)
     {
     case 0: return(ORDER_TYPE_BUY);
     case 1: return(ORDER_TYPE_SELL);
     case 2: return(ORDER_TYPE_BUY_LIMIT);
     case 3: return(ORDER_TYPE_SELL_LIMIT);
     case 4: return(ORDER_TYPE_BUY_STOP);
     case 5: return(ORDER_TYPE_SELL_STOP);    
     case 6: return(ORDER_TYPE_BUY_STOP_LIMIT);         
     case 7: return(ORDER_TYPE_SELL_STOP_LIMIT); 
     default: return(ORDER_TYPE_BUY);       
     }
  }
  
  
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ENUM_MA_METHOD MethodMigrate(int method)
  {
   switch(method)
     {
      case 0: return(MODE_SMA);
      case 1: return(MODE_EMA);
      case 2: return(MODE_SMMA);
      case 3: return(MODE_LWMA);
      default: return(MODE_SMA);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ENUM_APPLIED_PRICE PriceMigrate(int price)
  {
   switch(price)
     {
      case 1: return(PRICE_CLOSE);
      case 2: return(PRICE_OPEN);
      case 3: return(PRICE_HIGH);
      case 4: return(PRICE_LOW);
      case 5: return(PRICE_MEDIAN);
      case 6: return(PRICE_TYPICAL);
      case 7: return(PRICE_WEIGHTED);
      default: return(PRICE_CLOSE);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ENUM_STO_PRICE StoFieldMigrate(int field)
  {
   switch(field)
     {
      case 0: return(STO_LOWHIGH);
      case 1: return(STO_CLOSECLOSE);
      default: return(STO_LOWHIGH);
     }
  }

//+------------------------------------------------------------------+
enum ALLIGATOR_MODE  { MODE_GATORJAW=1,   MODE_GATORTEETH, MODE_GATORLIPS };
enum ADX_MODE        { MODE_MAIN,         MODE_PLUSDI, MODE_MINUSDI };
enum UP_LOW_MODE     { MODE_BASE,         MODE_UPPER,      MODE_LOWER };
enum ICHIMOKU_MODE   { MODE_TENKANSEN=1,  MODE_KIJUNSEN, MODE_SENKOUSPANA, MODE_SENKOUSPANB, MODE_CHINKOUSPAN };
//enum MAIN_SIGNAL_MODE{ MODE_MAIN,         MODE_SIGNAL };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CopyBufferMQL4(int handle,int index,int shift)
  {
   double buf[];
   switch(index)
     {
      case 0: if(CopyBuffer(handle,0,shift,1,buf)>0)
         return(buf[0]); break;
      case 1: if(CopyBuffer(handle,1,shift,1,buf)>0)
         return(buf[0]); break;
      case 2: if(CopyBuffer(handle,2,shift,1,buf)>0)
         return(buf[0]); break;
      case 3: if(CopyBuffer(handle,3,shift,1,buf)>0)
         return(buf[0]); break;
      case 4: if(CopyBuffer(handle,4,shift,1,buf)>0)
         return(buf[0]); break;
      default: break;
     }
   return(EMPTY_VALUE);
  }
//+------------------------------------------------------------------+



//-----------------------------------

double iACMQL4(string symbol,
               int tf,
               int shift)
  {
   ENUM_TIMEFRAMES timeframe=TFMigrate(tf);
   int handle=iAC(symbol,timeframe);
   if(handle<0)
     {
      Print("The iAC object is not created: Error",GetLastError());
      return(-1);
     }
   else
      return(CopyBufferMQL4(handle,0,shift));
  }
  
  
double iADMQL4(string symbol,
               int tf,
               int shift)
  {
   ENUM_TIMEFRAMES timeframe=TFMigrate(tf);
   int handle=(int)iAD(symbol,timeframe,VOLUME_TICK);
   if(handle<0)
     {
      Print("The iAD object is not created: Error",GetLastError());
      return(-1);
     }
   else
      return(CopyBufferMQL4(handle,0,shift));
  }
  
  
double iAlligatorMQL4(string symbol,
                      int tf,
                      int jaw_period,
                      int jaw_shift,
                      int teeth_period,
                      int teeth_shift,
                      int lips_period,
                      int lips_shift,
                      int method,
                      int price,
                      int mode,
                      int shift)
  {
   ENUM_TIMEFRAMES timeframe=TFMigrate(tf);
   ENUM_MA_METHOD ma_method=MethodMigrate(method);
   ENUM_APPLIED_PRICE applied_price=PriceMigrate(price);
   int handle=iAlligator(symbol,timeframe,jaw_period,jaw_shift,
                         teeth_period,teeth_shift,
                         lips_period,lips_shift,
                         ma_method,applied_price);
   if(handle<0)
     {
      Print("The iAlligator object is not created: Error",GetLastError());
      return(-1);
     }
   else
      return(CopyBufferMQL4(handle,mode-1,shift));
  }
  
  
double iADXMQL4(string symbol,
                int tf,
                int period,
                int price,
                int mode,
                int shift)
  {
   ENUM_TIMEFRAMES timeframe=TFMigrate(tf);
   int handle=iADX(symbol,timeframe,period);
   if(handle<0)
     {
      Print("The iADX object is not created: Error",GetLastError());
      return(-1);
     }
   else
      return(CopyBufferMQL4(handle,mode,shift));
  }
  
  
double iATRMQL4(string symbol,
                int tf,
                int period,
                int shift)
  {
   ENUM_TIMEFRAMES timeframe=TFMigrate(tf);
   int handle=iATR(symbol,timeframe,period);
   if(handle<0)
     {
      Print("The iATR object is not created: Error",GetLastError());
      return(-1);
     }
   else
      return(CopyBufferMQL4(handle,0,shift));
  }
  
  
double iAOMQL4(string symbol,
               int tf,
               int shift)
  {
   ENUM_TIMEFRAMES timeframe=TFMigrate(tf);
   int handle=iAO(symbol,timeframe);
   if(handle<0)
     {
      Print("The iAO object is not created: Error",GetLastError());
      return(-1);
     }
   else
      return(CopyBufferMQL4(handle,0,shift));
  }
  
  
double iBearsPowerMQL4(string symbol,
                       int tf,
                       int period,
                       int price,
                       int shift)
  {
   ENUM_TIMEFRAMES timeframe=TFMigrate(tf);
   int handle=iBearsPower(symbol,timeframe,period);
   if(handle<0)
     {
      Print("The iBearsPower object is not created: Error",GetLastError());
      return(-1);
     }
   else
      return(CopyBufferMQL4(handle,0,shift));
  }
  
  
double iBandsMQL4(string symbol,
                  int tf,
                  int period,
                  double deviation,
                  int bands_shift,
                  int method,
                  int mode,
                  int shift)
  {
   ENUM_TIMEFRAMES timeframe=TFMigrate(tf);
   ENUM_MA_METHOD ma_method=MethodMigrate(method);
   int handle=iBands(symbol,timeframe,period,
                     bands_shift,deviation,ma_method);
   if(handle<0)
     {
      Print("The iBands object is not created: Error",GetLastError());
      return(-1);
     }
   else
      return(CopyBufferMQL4(handle,mode,shift));
  }


double iBullsPowerMQL4(string symbol,
                       int tf,
                       int period,
                       int price,
                       int shift)
  {
   ENUM_TIMEFRAMES timeframe=TFMigrate(tf);
   int handle=iBullsPower(symbol,timeframe,period);
   if(handle<0)
     {
      Print("The iBullsPower object is not created: Error",GetLastError());
      return(-1);
     }
   else
      return(CopyBufferMQL4(handle,0,shift));
  }
  
  
double iCCIMQL4(string symbol,
                int tf,
                int period,
                int price,
                int shift)
  {
   ENUM_TIMEFRAMES timeframe=TFMigrate(tf);
   ENUM_APPLIED_PRICE applied_price=PriceMigrate(price);
   int handle=iCCI(symbol,timeframe,period,price);
   if(handle<0)
     {
      Print("The iCCI object is not created: Error",GetLastError());
      return(-1);
     }
   else
      return(CopyBufferMQL4(handle,0,shift));
  }
  
/*  
int iCustom(string symbol,
            ENUM_TIMEFRAMES period,
            string name
            )
  */          
            
double iDeMarkerMQL4(string symbol,
                     int tf,
                     int period,
                     int shift)
  {
   ENUM_TIMEFRAMES timeframe=TFMigrate(tf);
   int handle=iDeMarker(symbol,timeframe,period);
   if(handle<0)
     {
      Print("The iDeMarker object is not created: Error",GetLastError());
      return(-1);
     }
   else
      return(CopyBufferMQL4(handle,0,shift));
  }
  
  
  
double EnvelopesMQL4(string symbol,
                     int tf,
                     int ma_period,
                     int method,
                     int ma_shift,
                     int price,
                     double deviation,
                     int mode,
                     int shift)
  {
   ENUM_TIMEFRAMES timeframe=TFMigrate(tf);
   ENUM_MA_METHOD ma_method=MethodMigrate(method);
   ENUM_APPLIED_PRICE applied_price=PriceMigrate(price);
   int handle=iEnvelopes(symbol,timeframe,
                         ma_period,ma_shift,ma_method,
                         applied_price,deviation);
   if(handle<0)
     {
      Print("The iEnvelopes object is not created: Error",GetLastError());
      return(-1);
     }
   else
      return(CopyBufferMQL4(handle,mode-1,shift));
  }


double iForceMQL4(string symbol,
                  int tf,
                  int period,
                  int method,
                  int price,
                  int shift)
  {
   ENUM_TIMEFRAMES timeframe=TFMigrate(tf);
   ENUM_MA_METHOD ma_method=MethodMigrate(method);
   int handle=iForce(symbol,timeframe,period,ma_method,VOLUME_TICK);
   if(handle<0)
     {
      Print("The iForce object is not created: Error",GetLastError());
      return(-1);
     }
   else
      return(CopyBufferMQL4(handle,0,shift));
  }
  
  
double iFractalsMQL4(string symbol,
                     int tf,
                     int mode,
                     int shift)
  {
   ENUM_TIMEFRAMES timeframe=TFMigrate(tf);
   int handle=iFractals(symbol,timeframe);
   if(handle<0)
     {
      Print("The iFractals object is not created: Error",GetLastError());
      return(-1);
     }
   else
      return(CopyBufferMQL4(handle,mode-1,shift));
  }
  
  
double iGatorMQL4(string symbol,
                  int tf,
                  int jaw_period,
                  int jaw_shift,
                  int teeth_period,
                  int teeth_shift,
                  int lips_period,
                  int lips_shift,
                  int method,
                  int price,
                  int mode,
                  int shift)
  {
   ENUM_TIMEFRAMES timeframe=TFMigrate(tf);
   ENUM_MA_METHOD ma_method=MethodMigrate(method);
   ENUM_APPLIED_PRICE applied_price=PriceMigrate(price);
   int handle=iGator(symbol,timeframe,jaw_period,jaw_shift,
                     teeth_period,teeth_shift,
                     lips_period,lips_shift,
                     ma_method,applied_price);
   if(handle<0)
     {
      Print("The iGator object is not created: Error",GetLastError());
      return(-1);
     }
   else
      return(CopyBufferMQL4(handle,mode-1,shift));
  }
  
  
double iIchimokuMQL4(string symbol,
                     int tf,
                     int tenkan_sen,
                     int kijun_sen,
                     int senkou_span_b,
                     int mode,
                     int shift)
  {
   ENUM_TIMEFRAMES timeframe=TFMigrate(tf);
   int handle=iIchimoku(symbol,timeframe,
                        tenkan_sen,kijun_sen,senkou_span_b);
   if(handle<0)
     {
      Print("The iIchimoku object is not created: Error",GetLastError());
      return(-1);
     }
   else
      return(CopyBufferMQL4(handle,mode-1,shift));
  }
  
  
double iBWMFIMQL4(string symbol,
                  int tf,
                  int shift)
  {
   ENUM_TIMEFRAMES timeframe=TFMigrate(tf);
   int handle=(int)iBWMFI(symbol,timeframe,VOLUME_TICK);
   if(handle<0)
     {
      Print("The iBWMFI object is not created: Error",GetLastError());
      return(-1);
     }
   else
      return(CopyBufferMQL4(handle,0,shift));
  }
  
  
double iMomentumMQL4(string symbol,
                     int tf,
                     int period,
                     int price,
                     int shift)
  {
   ENUM_TIMEFRAMES timeframe=TFMigrate(tf);
   ENUM_APPLIED_PRICE applied_price=PriceMigrate(price);
   int handle=iMomentum(symbol,timeframe,period,applied_price);
   if(handle<0)
     {
      Print("The iMomentum object is not created: Error",GetLastError());
      return(-1);
     }
   else
      return(CopyBufferMQL4(handle,0,shift));
  }


double iMFIMQL4(string symbol,
                int tf,
                int period,
                int shift)
  {
   ENUM_TIMEFRAMES timeframe=TFMigrate(tf);
   int handle=(int)iMFI(symbol,timeframe,period,VOLUME_TICK);
   if(handle<0)
     {
      Print("The iMFI object is not created: Error",GetLastError());
      return(-1);
     }
   else
      return(CopyBufferMQL4(handle,0,shift));
  }
  
  
double iMAMQL4(string symbol,
               int tf,
               int period,
               int ma_shift,
               int method,
               int price,
               int shift)
  {
   ENUM_TIMEFRAMES timeframe=TFMigrate(tf);
   ENUM_MA_METHOD ma_method=MethodMigrate(method);
   ENUM_APPLIED_PRICE applied_price=PriceMigrate(price);
   int handle=iMA(symbol,timeframe,period,ma_shift,
                  ma_method,applied_price);
   if(handle<0)
     {
      Print("The iMA object is not created: Error",GetLastError());
      return(-1);
     }
   else
      return(CopyBufferMQL4(handle,0,shift));
  }
  
  
double iMAOnArrayMQL4(double &array[],
                      int total,
                      int period,
                      int ma_shift,
                      int ma_method,
                      int shift)
  {
   double buf[],arr[];
   if(total==0) total=ArraySize(array);
   if(total>0 && total<=period) return(0);
   if(shift>total-period-ma_shift) return(0);
   switch(ma_method)
     {
      case MODE_SMA :
        {
         total=ArrayCopy(arr,array,0,shift+ma_shift,period);
         if(ArrayResize(buf,total)<0) return(0);
         double sum=0;
         int    i,pos=total-1;
         for(i=1;i<period;i++,pos--)
            sum+=arr[pos];
         while(pos>=0)
           {
            sum+=arr[pos];
            buf[pos]=sum/period;
            sum-=arr[pos+period-1];
            pos--;
           }
         return(buf[0]);
        }
      case MODE_EMA :
        {
         if(ArrayResize(buf,total)<0) return(0);
         double pr=2.0/(period+1);
         int    pos=total-2;
         while(pos>=0)
           {
            if(pos==total-2) buf[pos+1]=array[pos+1];
            buf[pos]=array[pos]*pr+buf[pos+1]*(1-pr);
            pos--;
           }
         return(buf[shift+ma_shift]);
        }
      case MODE_SMMA :
        {
         if(ArrayResize(buf,total)<0) return(0);
         double sum=0;
         int    i,k,pos;
         pos=total-period;
         while(pos>=0)
           {
            if(pos==total-period)
              {
               for(i=0,k=pos;i<period;i++,k++)
                 {
                  sum+=array[k];
                  buf[k]=0;
                 }
              }
            else sum=buf[pos+1]*(period-1)+array[pos];
            buf[pos]=sum/period;
            pos--;
           }
         return(buf[shift+ma_shift]);
        }
      case MODE_LWMA :
        {
         if(ArrayResize(buf,total)<0) return(0);
         double sum=0.0,lsum=0.0;
         double price;
         int    i,weight=0,pos=total-1;
         for(i=1;i<=period;i++,pos--)
           {
            price=array[pos];
            sum+=price*i;
            lsum+=price;
            weight+=i;
           }
         pos++;
         i=pos+period;
         while(pos>=0)
           {
            buf[pos]=sum/weight;
            if(pos==0) break;
            pos--;
            i--;
            price=array[pos];
            sum=sum-lsum+price*period;
            lsum-=array[i];
            lsum+=price;
           }
         return(buf[shift+ma_shift]);
        }
      default: return(0);
     }
   return(0);
  }  
  
double iOsMAMQL4(string symbol,
                 int tf,
                 int fast_ema_period,
                 int slow_ema_period,
                 int signal_period,
                 int price,
                 int shift)
  {
   ENUM_TIMEFRAMES timeframe=TFMigrate(tf);
   ENUM_APPLIED_PRICE applied_price=PriceMigrate(price);
   int handle=iOsMA(symbol,timeframe,
                    fast_ema_period,slow_ema_period,
                    signal_period,applied_price);
   if(handle<0)
     {
      Print("The iOsMA object is not created: Error",GetLastError());
      return(-1);
     }
   else
      return(CopyBufferMQL4(handle,0,shift));
  }
  
  
double iMACDMQL4(string symbol,
                 int tf,
                 int fast_ema_period,
                 int slow_ema_period,
                 int signal_period,
                 int price,
                 int mode,
                 int shift)
  {
   ENUM_TIMEFRAMES timeframe=TFMigrate(tf);
   ENUM_APPLIED_PRICE applied_price=PriceMigrate(price);
   int handle=iMACD(symbol,timeframe,
                    fast_ema_period,slow_ema_period,
                    signal_period,applied_price);
   if(handle<0)
     {
      Print("The iMACD object is not created: Error ",GetLastError());
      return(-1);
     }
   else
      return(CopyBufferMQL4(handle,mode,shift));
  }
  
  
double iOBVMQL4(string symbol,
                int tf,
                int price,
                int shift)
  {
   ENUM_TIMEFRAMES timeframe=TFMigrate(tf);
   int handle=iOBV(symbol,timeframe,VOLUME_TICK);
   if(handle<0)
     {
      Print("The iOBV object is not created: Error",GetLastError());
      return(-1);
     }
   else
      return(CopyBufferMQL4(handle,0,shift));
  }
  
  
 
double iSARMQL4(string symbol,
                int tf,
                double step,
                double maximum,
                int shift)
  {
   ENUM_TIMEFRAMES timeframe=TFMigrate(tf);
   int handle=iSAR(symbol,timeframe,step,maximum);
   if(handle<0)
     {
      Print("The iSAR object is not created: Error",GetLastError());
      return(-1);
     }
   else
      return(CopyBufferMQL4(handle,0,shift));
  }
  
  
double iRSIMQL4(string symbol,
                int tf,
                int period,
                int price,
                int shift)
  {
   ENUM_TIMEFRAMES timeframe=TFMigrate(tf);
   ENUM_APPLIED_PRICE applied_price=PriceMigrate(price);
   int handle=iRSI(symbol,timeframe,period,applied_price);
   if(handle<0)
     {
      Print("The iRSI object is not created: Error",GetLastError());
      return(-1);
     }
   else
      return(CopyBufferMQL4(handle,0,shift));
  }



double iRVIMQL4(string symbol,
                int tf,
                int period,
                int mode,
                int shift)
  {
   ENUM_TIMEFRAMES timeframe=TFMigrate(tf);
   int handle=iRVI(symbol,timeframe,period);
   if(handle<0)
     {
      Print("The iRVI object is not created: Error",GetLastError());
      return(-1);
     }
   else
      return(CopyBufferMQL4(handle,mode,shift));
  }
  
  
  
double iStdDevMQL4(string symbol,
                   int tf,
                   int ma_period,
                   int ma_shift,
                   int method,
                   int price,
                   int shift)
  {
   ENUM_TIMEFRAMES timeframe=TFMigrate(tf);
   ENUM_MA_METHOD ma_method=MethodMigrate(method);
   ENUM_APPLIED_PRICE applied_price=PriceMigrate(price);
   int handle=iStdDev(symbol,timeframe,ma_period,ma_shift,
                      ma_method,applied_price);
   if(handle<0)
     {
      Print("The iStdDev object is not created: Error",GetLastError());
      return(-1);
     }
   else
      return(CopyBufferMQL4(handle,0,shift));
  }


double iStochasticMQL4(string symbol,
                       int tf,
                       int Kperiod,
                       int Dperiod,
                       int slowing,
                       int method,
                       int field,
                       int mode,
                       int shift)
  {
   ENUM_TIMEFRAMES timeframe=TFMigrate(tf);
   ENUM_MA_METHOD ma_method=MethodMigrate(method);
   ENUM_STO_PRICE price_field=StoFieldMigrate(field);
   int handle=iStochastic(symbol,timeframe,Kperiod,Dperiod,
                          slowing,ma_method,price_field);
   if(handle<0)
     {
      Print("The iStochastic object is not created: Error",GetLastError());
      return(-1);
     }
   else
      return(CopyBufferMQL4(handle,mode,shift));
  }
  
  
double iWPRMQL4(string symbol,
                int tf,
                int period,
                int shift)
  {
   ENUM_TIMEFRAMES timeframe=TFMigrate(tf);
   int handle=iWPR(symbol,timeframe,period);
   if(handle<0)
     {
      Print("The iWPR object is not created: Error",GetLastError());
      return(-1);
     }
   else
      return(CopyBufferMQL4(handle,0,shift));
  }



///-----------------------------------------------------------------------------------------------------------
///-----------------------------------------------------------------------------------------------------------
///-----------------------------------------------------------------------------------------------------------
///-----------------------------------------------------------------------------------------------------------

bool IsTesting() {return MQL5InfoInteger(MQL5_TESTING); };
bool IsOptimization() {return MQL5InfoInteger(MQL5_OPTIMIZATION); };
  
string CharToStr(int char_code){return CharToString(char_code); };
 
double AccountBalance() { return AccountInfoDouble(ACCOUNT_BALANCE); };
double AccountCredit() { return AccountInfoDouble(ACCOUNT_CREDIT); };
double AccountEquity() { return AccountInfoDouble(ACCOUNT_EQUITY); };
double AccountFreeMargin() { return AccountInfoDouble(ACCOUNT_FREEMARGIN); };
double AccountMargin() { return AccountInfoDouble(ACCOUNT_MARGIN); };
double AccountProfit() { return AccountInfoDouble(ACCOUNT_PROFIT); };
int AccountLeverage() { return AccountInfoInteger(ACCOUNT_LEVERAGE); };
int AccountNumber() { return AccountInfoInteger(ACCOUNT_LOGIN); };
double AccountStopoutLevel() { return AccountInfoDouble(ACCOUNT_MARGIN_SO_SO); };
int AccountStopoutMode() { return AccountInfoInteger(ACCOUNT_MARGIN_SO_MODE); };
string AccountCompany() { return AccountInfoString(ACCOUNT_COMPANY); };
string AccountCurrency() { return AccountInfoString(ACCOUNT_CURRENCY); };
string AccountName() { return AccountInfoString(ACCOUNT_NAME); };
string AccountServer() { return AccountInfoString(ACCOUNT_SERVER); };

int Day(){MqlDateTime tm; TimeCurrent(tm);return(tm.day);};
int DayOfWeek(){MqlDateTime tm;TimeCurrent(tm);return(tm.day_of_week);};
int DayOfYear(){MqlDateTime tm;TimeCurrent(tm);return(tm.day_of_year);}
int Hour(){MqlDateTime tm;TimeCurrent(tm);return(tm.hour);};
int Minute(){MqlDateTime tm;TimeCurrent(tm);return(tm.min);};
int Month(){MqlDateTime tm;TimeCurrent(tm);return(tm.mon);};
int Seconds(){MqlDateTime tm;TimeCurrent(tm);return(tm.sec);};
int TimeDay(datetime date){MqlDateTime tm;TimeToStruct(date,tm);return(tm.day);};
int TimeDayOfWeek(datetime date){MqlDateTime tm;TimeToStruct(date,tm);return(tm.day_of_week);};
int TimeDayOfYear(datetime date){MqlDateTime tm;TimeToStruct(date,tm);return(tm.day_of_year);};
int TimeHour(datetime date){MqlDateTime tm;TimeToStruct(date,tm);return(tm.hour);};
int TimeMinute(datetime date){MqlDateTime tm;TimeToStruct(date,tm);return(tm.min);};
int TimeMonth(datetime date){MqlDateTime tm;TimeToStruct(date,tm);return(tm.mon);};
int TimeSeconds(datetime date){MqlDateTime tm;TimeToStruct(date,tm);return(tm.sec);};
int TimeYear(datetime date){MqlDateTime tm;TimeToStruct(date,tm);return(tm.year);};
int Year(){MqlDateTime tm;TimeCurrent(tm);return(tm.year);};

 
double Ask,Bid,Open[202],Close[202],High[202],Low[202],Volume[202],Digits,Point;
int Bars ;
datetime Time[];
void F_SetMQL4PreDefVar(string symbol99,int count=200)
   {
   MqlTick last_tick;
   SymbolInfoTick(symbol99,last_tick);
   Bid=last_tick.bid;
   Ask=last_tick.ask;
   Digits=MarketInfoMQL4(symbol99,MODE_DIGITS);  
   Point=MarketInfoMQL4(symbol99,MODE_POINT);
   Bars=Bars(symbol99,_Period);   
      // number of elements to copy
   ArraySetAsSeries(Close,true);CopyClose(symbol99,_Period,0,count,Close);
   ArraySetAsSeries(High,true);CopyHigh(symbol99,_Period,0,count,High);
   ArraySetAsSeries(Low,true);CopyLow(symbol99,_Period,0,count,Low);
   ArraySetAsSeries(Open,true);CopyOpen(symbol99,_Period,0,count,Open);
   ArraySetAsSeries(Time,true);CopyTime(symbol99,_Period,0,count,Time);
   //ArraySetAsSeries(Volume,true);CopyTickVolume(symbol99,_Period,0,count,Volume);

   }
   
   
double MarketInfoMQL4(string symbol,
                      int type)
  {
   switch(type)
     {
      case MODE_LOW:
         return(SymbolInfoDouble(symbol,SYMBOL_LASTLOW));
      case MODE_HIGH:
         return(SymbolInfoDouble(symbol,SYMBOL_LASTHIGH));
      case MODE_TIME:
         return(SymbolInfoInteger(symbol,SYMBOL_TIME));
      case MODE_BID:
         return(Bid);
      case MODE_ASK:
         return(Ask);
      case MODE_POINT:
         return(SymbolInfoDouble(symbol,SYMBOL_POINT));
      case MODE_DIGITS:
         return(SymbolInfoInteger(symbol,SYMBOL_DIGITS));
      case MODE_SPREAD:
         return(SymbolInfoInteger(symbol,SYMBOL_SPREAD));
      case MODE_STOPLEVEL:
         return(SymbolInfoInteger(symbol,SYMBOL_TRADE_STOPS_LEVEL));
      case MODE_LOTSIZE:
         return(SymbolInfoDouble(symbol,SYMBOL_TRADE_CONTRACT_SIZE));
      case MODE_TICKVALUE:
         return(SymbolInfoDouble(symbol,SYMBOL_TRADE_TICK_VALUE));
      case MODE_TICKSIZE:
         return(SymbolInfoDouble(symbol,SYMBOL_TRADE_TICK_SIZE));
      case MODE_SWAPLONG:
         return(SymbolInfoDouble(symbol,SYMBOL_SWAP_LONG));
      case MODE_SWAPSHORT:
         return(SymbolInfoDouble(symbol,SYMBOL_SWAP_SHORT));
      case MODE_STARTING:
         return(0);
      case MODE_EXPIRATION:
         return(0);
      case MODE_TRADEALLOWED:
         return(0);
      case MODE_MINLOT:
         return(SymbolInfoDouble(symbol,SYMBOL_VOLUME_MIN));
      case MODE_LOTSTEP:
         return(SymbolInfoDouble(symbol,SYMBOL_VOLUME_STEP));
      case MODE_MAXLOT:
         return(SymbolInfoDouble(symbol,SYMBOL_VOLUME_MAX));
      case MODE_SWAPTYPE:
         return(SymbolInfoInteger(symbol,SYMBOL_SWAP_MODE));
      case MODE_PROFITCALCMODE:
         return(SymbolInfoInteger(symbol,SYMBOL_TRADE_CALC_MODE));
      case MODE_MARGINCALCMODE:
         return(0);
      case MODE_MARGININIT:
         return(0);
      case MODE_MARGINMAINTENANCE:
         return(0);
      case MODE_MARGINHEDGED:
         return(0);
      case MODE_MARGINREQUIRED:
         return(0);
      case MODE_FREEZELEVEL:
         return(SymbolInfoInteger(symbol,SYMBOL_TRADE_FREEZE_LEVEL));

      default: return(0);
     }
   return(0);
  }   
  
  
  
  ///-----------------------------------------------------------------------------------------------------------
  ///-----------------------------------------------------------------------------------------------------------
  ///-----------------------------------------------------------------------------------------------------------
  
#include <Trade\Trade.mqh>
#include <Trade\PositionInfo.mqh>
#include <Trade\AccountInfo.mqh>
  
  
void GSetLastSendOrder()
   { GlobalVariableSet("G_lastsendorder",TimeCurrent());
   Print("/OrderSend:   "+ MQL5InfoString(MQL5_PROGRAM_NAME) +"  " + Symbol());}   
datetime GGetLastSendOrder()
   {  if (GlobalVariableCheck("G_lastsendorder")==false) GlobalVariableSet("G_lastsendorder",TimeCurrent()-24*60*60);
   return(GlobalVariableGet("G_lastsendorder")); }  
  
  
int OrderSend2(string symbol99, int cmd99, double volume99, double price99, int slippage99, double stoploss99, double takeprofit99, 
      string comment99=NULL, int magic99=0, datetime expiration99=0, color arrow_color99=CLR_NONE)
     {
     CTrade trade;  
     trade.SetExpertMagicNumber(magic99);
     trade.PositionOpen(symbol99,OrderType(cmd99),volume99,price99,stoploss99,takeprofit99,comment99);
     GSetLastSendOrder();
     return(1);
     }
  
/*  
int OrderSend3(string symbol99, int cmd99, double volume99, double price99, int slippage99, double stoploss99, double takeprofit99, 
      string comment99=NULL, int magic99=0, datetime expiration99=0, color arrow_color99=CLR_NONE)
   {
   int ticket99;
   bool result99;
   MqlTradeRequest   m_request;         // request data
   MqlTradeResult    m_result;          // result data   

   if (cmd99<2) m_request.action=TRADE_ACTION_DEAL; else m_request.action=TRADE_ACTION_PENDING;
   m_request.symbol      =symbol99;
   m_request.magic       =magic99;
   m_request.volume      =volume99;
   m_request.type        =OrderType(cmd99);
   //m_request.type        =ORDER_TYPE_BUY;
   m_request.price       =price99;
   //if (stoploss99!=0)   
   m_request.sl          =stoploss99;
   //if (takeprofit99!=0) 
   m_request.tp          =takeprofit99;
   m_request.deviation   =slippage99;
   m_request.comment     =comment99;
   
   result99=OrderSend(m_request,m_result);
   
   //if (stoploss99!=0.0 || takeprofit99!=0.0) 
   //{ m_request.action=TRADE_ACTION_SLTP; OrderSend(m_request,m_result); }
   if (result99==true) { if (cmd99<2) ticket99=m_result.order; ticket99=m_result.deal;} else ticket99=0;
   return(ticket99);      
   }
*/

bool OrderModify(string symbol99, double stoploss99, double takeprofit99)
{  
   /*
   int ticket99;
   bool result99;
   MqlTradeRequest   m_request;         // request data
   MqlTradeResult    m_result; 
   m_request.action=TRADE_ACTION_SLTP;
   m_request.magic=PositionGetInteger(POSITION_IDENTIFIER);
   m_request.sl          =stoploss99;
   m_request.tp          =takeprofit99;
   result99=OrderSend(m_request,m_result);
   Print(m_result.retcode);
   return(result99);
   */
   CTrade trade;   
   return(trade.PositionModify(Symbol(),stoploss99,takeprofit99));
}





void OrderClose2(string symbol99, double volume2)
{
   PositionSelect(symbol99);
   double volume=volume2;
   if (volume==0) volume=PositionGetDouble(POSITION_VOLUME); 
   if (volume!=0)   
   {
   if (PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY)
   OrderSend2(symbol99,OP_SELL,volume,Bid,30000,0,0,"",0,0,Green); 
   else OrderSend2(symbol99,OP_BUY,volume,Ask,30000,0,0,"",0,0,Green);  
   GSetLastSendOrder();
   }
   return;
}   


void OrderClose3(string symbol99, double volume2,string comment99)
{
   PositionSelect(symbol99);
   double volume=volume2;
   if (volume==0) volume=PositionGetDouble(POSITION_VOLUME); 
   if (volume!=0)   
   {
   if (PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY)
   OrderSend2(symbol99,OP_SELL,volume,Bid,30000,0,0,comment99,0,0,Green); 
   else OrderSend2(symbol99,OP_BUY,volume,Ask,30000,0,0,comment99,0,0,Green);  
   GSetLastSendOrder();
   }
   return;
}   






int OrderMagicNumber() {return(PositionGetInteger(POSITION_MAGIC));}
string OrderSymbol() {return(PositionGetString(POSITION_SYMBOL));}
int OrderType() 
   {switch (PositionGetInteger(POSITION_TYPE))
      {
      case POSITION_TYPE_BUY:  return(0); 
      case POSITION_TYPE_SELL: return(1);
      default: return(0);
      }
   }
   
int OrderType2() 
   {switch (PositionGetInteger(POSITION_TYPE))
      {
      case POSITION_TYPE_BUY:  return(1); 
      case POSITION_TYPE_SELL: return(-1);
      default: return(0);
      }
   }   
   
int OrderTicket() {return(PositionGetInteger(POSITION_IDENTIFIER));}
double OrderLots() {return(PositionGetDouble(POSITION_VOLUME));}
double OrderProfit() {return(PositionGetDouble(POSITION_PROFIT));}
double OrderSwap() {return(PositionGetDouble(POSITION_SWAP));}
double OrderCommission() {return(PositionGetDouble(POSITION_COMMISSION));}   
double OrderOpenPrice() {return(PositionGetDouble(POSITION_PRICE_OPEN));}
double OrderOpenAvgPrice() {return(PositionGetDouble(POSITION_PRICE_OPEN));}
double OrderCurrentPrice() {return(PositionGetDouble(POSITION_PRICE_CURRENT));}
datetime OrderOpenTime() {return(PositionGetInteger(POSITION_TIME));}
double OrderTakeProfit() {return(PositionGetDouble(POSITION_TP));}
double OrderStopLoss() {return(PositionGetDouble(POSITION_SL));}

/* 
bool OrderClose( int ticket, double lots, double price, int slippage, color Color=CLR_NONE);
bool OrderModify( int ticket, double price, double stoploss, double takeprofit, datetime expiration, color arrow_color=CLR_NONE) ;
 
*/