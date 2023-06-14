//+------------------------------------------------------------------+
//|                                               Moving Average.mq4 |
//|                      Copyright © 2005, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#define MAGICMA  20050610

//-------------------------------------------------------------------------
// Test and Optimisation Parameters
extern int     VarOptimTest      = 0;    // 0 -  standard optimisation, 
                                         // 1 - test run of the selected sets        
                                         // 2 - generation of set-files
extern int     Counter           = 1;    // counter    
extern string  nameEA            = "MA"; // Expert Advisor name
int FilePtr                      = 0;    // File pointer
//-------------------------------------------------------------------------
extern double Lots               = 0.1;
extern double MaximumRisk        = 0;
extern double DecreaseFactor     = 3;
extern int    MovingPeriod       = 12;
extern int    MovingShift        = 6;


int str, data;
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init() 
{
// BLOCK OF THE OPTIMISATION AND TESTING FUNCTION CALL
   if(IsOptimization() && VarOptimTest !=0)
      {
      if (VarOptimTest == 1 && Counter !=0) _ReadParametrs();
      if (VarOptimTest == 2 && Counter !=0)
         {_ReadParametrs(); _WriteSet();}
      }   
//#####################################################################

return(0);
}
//+------------------------------------------------------------------+
//| Start function                                                   |
//+------------------------------------------------------------------+
void start()
  {
   //Print(str,"  !!!!!!!!!!!!!!! ", data);
   if(IsOptimization() && VarOptimTest ==2) return(0);
//---- check for history and trading
   if(Bars<100 || IsTradeAllowed()==false) return;
//---- calculate open orders by current symbol
   if(CalculateCurrentOrders(Symbol())==0) CheckForOpen();
   else                                    CheckForClose();
//----
  }
//+------------------------------------------------------------------+
//| reading the parameters
//+------------------------------------------------------------------+
void  _ReadParametrs()
{
   string FileName="test.csv";
   int handle=FileOpen(FileName,FILE_READ||FILE_CSV);//,''); 
   if(handle<1) return(0);
   FileSeek(handle,0,SEEK_SET);
   int str = StrToInteger(FileReadString(handle)); 
   int data = StrToInteger(FileReadString(handle)); 
   if (data < Counter) 
      {
      Alert("Incorrect number of test runs entered. Sorry");
      return(0);
      }
   // file pointer (FilePtr variable) is used to speed up the process
   if (Counter > 1) 
      {
      FilePtr = GlobalVariableGet("FilePtr");
      FileSeek(handle,FilePtr, SEEK_SET);
      }
   for (int x=1; x <= str; x++)
      {
      string s = FileReadString(handle); 
      string ds = FileReadString(handle); 

      s=StringTrimLeft(s);s=StringTrimRight(s);
      ds = StringTrimLeft(ds);ds=StringTrimRight(ds);
      double d = StrToDouble(ds);

      if (s == "Lots"){Lots=d;continue;}
      if (s == "MaximumRisk"){MaximumRisk=d;continue;}
      if (s == "DecreaseFactor"){DecreaseFactor=d;continue;}
      if (s == "MovingPeriod"){MovingPeriod=d;continue;}
      if (s == "MovingShift"){MovingShift=d;continue;}
      }

   FilePtr = FileTell(handle); 
   GlobalVariableSet("FilePtr",FilePtr);
   
   //FileClose(handle);
return(0);
}
//+------------------------------------------------------------------+
//| generation of set-files 
//+------------------------------------------------------------------+
void  _WriteSet ()
{
   string FileName=nameEA+"_"+Symbol()+Period()+"_"+Counter+".set";
   int handle=FileOpen(FileName,FILE_WRITE|FILE_CSV);
   if(handle<1) return(0);

   FileWrite(handle,"VarOptimTest="+0);
   FileWrite(handle,"VarOptimTest,F="+0);
   FileWrite(handle,"VarOptimTest,1="+0);
   FileWrite(handle,"VarOptimTest,2="+0);
   FileWrite(handle,"VarOptimTest,3="+0);
   
   FileWrite(handle,"Counter="+0);
   FileWrite(handle,"Counter,F="+0);
   FileWrite(handle,"Counter,1="+1);
   FileWrite(handle,"Counter,2="+1);
   FileWrite(handle,"Counter,3="+100);

   FileWrite(handle,"nameEA="+nameEA+"_"+Symbol()+Period()+"_"+Counter);

   FileWrite(handle,"Lots="+Lots);
   FileWrite(handle,"Lots,F="+0);
   FileWrite(handle,"Lots,1="+0.00000000);
   FileWrite(handle,"Lots,2="+0.00000000);
   FileWrite(handle,"Lots,3="+0.00000000);
   
   FileWrite(handle,"MaximumRisk="+MaximumRisk);
   FileWrite(handle,"MaximumRisk,F="+0);
   FileWrite(handle,"MaximumRisk,1="+0.02000000);
   FileWrite(handle,"MaximumRisk,2="+0.00000000);
   FileWrite(handle,"MaximumRisk,3="+0.00000000);
   
   FileWrite(handle,"DecreaseFactor="+DecreaseFactor);
   FileWrite(handle,"DecreaseFactor,F="+0);
   FileWrite(handle,"DecreaseFactor,1="+3);
   FileWrite(handle,"DecreaseFactor,2="+3);
   FileWrite(handle,"DecreaseFactor,3="+3);
   
   FileWrite(handle,"MovingPeriod="+MovingPeriod);
   FileWrite(handle,"MovingPeriod,F="+1);
   FileWrite(handle,"MovingPeriod,1="+10);
   FileWrite(handle,"MovingPeriod,2="+1);
   FileWrite(handle,"MovingPeriod,3="+20);
   
   FileWrite(handle,"MovingShift="+MovingShift);
   FileWrite(handle,"MovingShift,F="+1);
   FileWrite(handle,"MovingShift,1="+2);
   FileWrite(handle,"MovingShift,2="+1);
   FileWrite(handle,"MovingShift,3="+4);
   
   FileClose(handle);
return(0);
}
//+------------------------------------------------------------------+
//| Calculate open positions                                         |
//+------------------------------------------------------------------+
int CalculateCurrentOrders(string symbol)
  {
   int buys=0,sells=0;
//----
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==MAGICMA)
        {
         if(OrderType()==OP_BUY)  buys++;
         if(OrderType()==OP_SELL) sells++;
        }
     }
//---- return orders volume
   if(buys>0) return(buys);
   else       return(-sells);
  }
//+------------------------------------------------------------------+
//| Calculate optimal lot size                                       |
//+------------------------------------------------------------------+
double LotsOptimized()
  {
   double lot=Lots;
   int    orders=HistoryTotal();     // history orders total
   int    losses=0;                  // number of losses orders without a break
//---- select lot size
   lot=NormalizeDouble(AccountFreeMargin()*MaximumRisk/1000.0,1);
//---- calcuulate number of losses orders without a break
   if(DecreaseFactor>0)
     {
      for(int i=orders-1;i>=0;i--)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==false) { Print("Error in history!"); break; }
         if(OrderSymbol()!=Symbol() || OrderType()>OP_SELL) continue;
         //----
         if(OrderProfit()>0) break;
         if(OrderProfit()<0) losses++;
        }
      if(losses>1) lot=NormalizeDouble(lot-lot*losses/DecreaseFactor,1);
     }
//---- return lot size
   if(lot<0.1) lot=0.1;
   lot=Lots;
   return(lot);
  }
//+------------------------------------------------------------------+
//| Check for open order conditions                                  |
//+------------------------------------------------------------------+
void CheckForOpen()
  {
   double ma;
   int    res;
//---- go trading only for first tiks of new bar
   if(Volume[0]>1) return;
//---- get Moving Average 
   ma=iMA(NULL,0,MovingPeriod,MovingShift,MODE_SMA,PRICE_CLOSE,0);
//---- sell conditions
   if(Open[1]>ma && Close[1]<ma)  
     {
      res=OrderSend(Symbol(),OP_SELL,LotsOptimized(),Bid,3,0,0,"",MAGICMA,0,Red);
      return;
     }
//---- buy conditions
   if(Open[1]<ma && Close[1]>ma)  
     {
      res=OrderSend(Symbol(),OP_BUY,LotsOptimized(),Ask,3,0,0,"",MAGICMA,0,Blue);
      return;
     }
//----
  }
//+------------------------------------------------------------------+
//| Check for close order conditions                                 |
//+------------------------------------------------------------------+
void CheckForClose()
  {
   double ma;
//---- go trading only for first tiks of new bar
   if(Volume[0]>1) return;
//---- get Moving Average 
   ma=iMA(NULL,0,MovingPeriod,MovingShift,MODE_SMA,PRICE_CLOSE,0);
//----
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)        break;
      if(OrderMagicNumber()!=MAGICMA || OrderSymbol()!=Symbol()) continue;
      //---- check order type 
      if(OrderType()==OP_BUY)
        {
         if(Open[1]>ma && Close[1]<ma) OrderClose(OrderTicket(),OrderLots(),Bid,3,White);
         break;
        }
      if(OrderType()==OP_SELL)
        {
         if(Open[1]<ma && Close[1]>ma) OrderClose(OrderTicket(),OrderLots(),Ask,3,White);
         break;
        }
     }
//----
  }

