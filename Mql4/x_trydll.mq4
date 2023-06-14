//+------------------------------------------------------------------+
//|                                                     x_trydll.mq4 |
//|                        Copyright 2012, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2012, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#import "trydll6.dll"
   int DoSomething(int a,int b);
#import


int a,b,c;


int init()
  {
   a=4;b=3;
   c=DoSomething(a,b);
   Print("HelloPrint " + c);
   Alert("HelloAlert " + c);
   return(0);
  }


int deinit()
  {
   return(0);
  }


int start()
  {
   return(0);
  }


