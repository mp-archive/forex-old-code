//+------------------------------------------------------------------+
//|                                                        x_new.mq4 |
//|                                                               mp |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "mp"
#property link      ""
double lot=0.1;

int init()
  {   return(0);  }

int deinit()
  {   return(0);  }


int start()
  {   
  if (iRSI("EURUSD",PERIOD_H1,20,PRICE_CLOSE,1)>60 && OrdersTotal()==0)
  OrderSend("EURUSD",OP_BUY,lot,Ask,3,Ask-300*Point,Ask+200*Point,"",100000,0,Green); 
//  OrderSend(Symbol(),OP_BUY,lot,Ask,3,Ask-300*Point,Ask+200*Point,"",100000,0,Green); 
  return(0);  
  }



