//+------------------------------------------------------------------+
//|                              Sávelemzés rákötéssel_egyirányú.mq4 |
//|                      Copyright © 2012, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2012, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

extern int kockazat_szazalek = 1;
extern int egyenleg = 5000;
extern double extopen = 0.00;
extern double extstop = 0.00;
extern double celar = 0.00;
extern int tav_szorzo = 1;

int gyertya;

double open = 0.00;
double stop = 0.00;
double stop_tav = 0.00;
double lotmeret = 0.00;
int irany = 0; //ha long, akkor1, ha short, akkor 2 
int magic = 201202;
int longorder;
int shortorder;
int ossz_pozi;
int a = 0;
int szam = 0;

int init()
  {

gyertya = iBars(NULL,0);
 open = extopen;
 stop = extstop;



   return(0);
  }




int deinit()
  {




   return(0);
  }




int start()
  {

if(open != 0)
   {
      ObjectCreate("open",1,NULL,0,open);
      ObjectSet("open",6,Green);
   }
 
if(stop != 0)
   {
      ObjectCreate("stop",1,NULL,0,stop);
      ObjectSet("stop",6,Red);
   }
 
 if(celar != 0)
   {
      ObjectCreate("celar",1,NULL,0,celar);
      ObjectSet("celar",6,Yellow);
   }
 
 
 
 stop_tav = MathAbs((open-stop)/Point);
 
 
 double point_ertek = MarketInfo(Symbol(),MODE_TICKVALUE);
 
 double max_kock = egyenleg/100*kockazat_szazalek;
 
 if(stop_tav != 0)
   {
     lotmeret = NormalizeDouble(max_kock/stop_tav/point_ertek,2);
     
         if(open > stop )
            {
               irany = 1;
            }
            else irany = 2;
   }
   
 //A jelenlegi charton megszámoljuk, hogy hány pozink van
 
 if( OrdersTotal() > 0 && ossz_pozi == szam)
   {for(int total = OrdersTotal()-1;total >=0;total--)
      {OrderSelect(total,SELECT_BY_POS,MODE_TRADES);
         if( OrderSymbol() == Symbol() && OrderMagicNumber() == magic)
            {
               ossz_pozi++;
               break;
            }
      }
   }szam = ossz_pozi-1;
 
 
 
 //zárás célár elérésekor

if(ossz_pozi > 0 && irany == 1 && Bid > celar)
   {
      CloseBuyOrders (magic);
      open = 0;
      stop = 0;
      celar = 0;
      ossz_pozi = 0;
      longorder = 0;
      ObjectDelete("stop");
      ObjectDelete("open");
      ObjectDelete("celar");
   }

if(ossz_pozi > 0 && irany == 2 && Ask < celar)
   {
      CloseSellOrders (magic);
      open = 0;
      stop = 0;
      celar = 0;
      ossz_pozi = 0;
      shortorder = 0;
      ObjectDelete("stop");
      ObjectDelete("open");
      ObjectDelete("celar");
   }  




//itt kell a stopokat kezelni, trailing stop távolság= stop_tav
if(ossz_pozi != 0)trailing (stop_tav);




if( ossz_pozi == 0 )
   {
      if( irany == 1 && iOpen(Symbol(),NULL,1) < open && iClose(Symbol(),NULL,1) > open && Ask > open)
         {
            longorder =OrderSend(Symbol(),OP_BUY,lotmeret,Ask,2,Bid-stop_tav*Point,0,0,magic,0,Green);
               if(longorder>0)
                  {if(OrderSelect(longorder,SELECT_BY_TICKET)&& a == 0)
                     {  
                        ossz_pozi++;
                        gyertya = Bars;
                        a = 1;
                     }
                  }
         }
      
      if( irany == 2 && iOpen(Symbol(),NULL,1) > open && iClose(Symbol(),NULL,1) < open && Bid < open) 
         {
            shortorder =OrderSend(Symbol(),OP_SELL,lotmeret,Bid,2,Ask+stop_tav*Point,0,0,magic,0,Red); 
               if(shortorder>0)
                  {if(OrderSelect(shortorder,SELECT_BY_TICKET) && a == 0)
                     {
                        ossz_pozi++;
                        gyertya = Bars;
                        a = 1;
                     }
                  }   
         }
   } 

double stopszint_long;   
double stopszint_short;  


if(ossz_pozi > 0)
   {
    if(irany == 1)
      {
        OrderSelect(longorder,SELECT_BY_TICKET,MODE_TRADES);
         stopszint_long = OrderStopLoss();
      }
    if(irany == 2)
      {
        OrderSelect(shortorder,SELECT_BY_TICKET,MODE_TRADES);
         stopszint_short = OrderStopLoss();
      }
   }


//stop zárás

if(ossz_pozi>0 && irany == 1 && Bid <= stopszint_long+1*Point)
   {
      CloseBuyOrders (magic);
      open = 0;
      stop = 0;
      celar = 0;
      ossz_pozi = 0;
      longorder = 0;
      ObjectDelete("stop");
      ObjectDelete("open");
      ObjectDelete("celar");
   }
   
if(ossz_pozi>0 && irany == 2 && Ask >= stopszint_short-1*Point)
   {
      CloseSellOrders (magic);
      open = 0;
      stop = 0;
      celar = 0;
      ossz_pozi = 0;
      shortorder = 0;
      ObjectDelete("stop");
      ObjectDelete("open");
      ObjectDelete("celar");
   }





double lotmenny;
double sulyAr;
double atlagAr;



if(ossz_pozi!=0 )
   {
      
      
      for(int i = OrdersTotal()-1; i>=0; i--)
         {
            if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
               {if( OrderSymbol() == Symbol() && OrderMagicNumber() == magic)
                  {
                     lotmenny +=OrderLots();
                     sulyAr   +=OrderOpenPrice()*OrderLots();
                  }          
               }   
         }      
         
             
    }        

if( lotmenny != 0 )
   {
      atlagAr = sulyAr/lotmenny;
      
   }
   
 //a célár megjelenítése rajzolással
if(atlagAr != 0)
    {  
      string celArNev = "atlagAr"+Bars;
      datetime gyTime = Time[0];
      //a rajz (nyíl) objektum létrehozása
      if(ObjectFind(celArNev)< 0)
      {
         ObjectCreate(celArNev,OBJ_ARROW,0,gyTime,atlagAr);
         //a rajz (nyíl) objektum alakjának meghatározása
         ObjectSet(celArNev,OBJPROP_ARROWCODE,4);
         //a rajz (nyíl) objektum alakjának színe
         ObjectSet(celArNev,OBJPROP_COLOR, Yellow );
      }
      else
      {
        ObjectMove( celArNev, 0, gyTime, atlagAr) ;     
      } 
     }
double nyitas_tav = tav_szorzo*stop_tav;
  
//rányitások

if( ossz_pozi>0 && irany == 1 && Bid > (atlagAr+nyitas_tav*Point)&& gyertya !=Bars && Ask <celar)
   {
    
         OrderSend(Symbol(),OP_BUY,lotmeret,Ask,2,0,0,0,magic,0,Green);
         gyertya =Bars;
         ossz_pozi ++;
   }
 
 
 
    
if( ossz_pozi>0 && irany == 2 && Ask < (atlagAr-nyitas_tav*Point) && gyertya !=Bars && Bid > celar)
      {
         OrderSend(Symbol(),OP_SELL,lotmeret,Bid,2,0,0,0,magic,0,Red);
         gyertya =Bars;
         ossz_pozi ++;
      }
   
double bekotott_lot = ossz_pozi*lotmeret;

Comment("Bekötött lot:     "+bekotott_lot+"\n",
        "Nyitott trade:    "+ossz_pozi+"\n",
        "Irány:            "+irany+"\n",
        "Átlagár:          "+atlagAr+"\n",
        "Nyitás táv:       "+nyitas_tav+"\n",
        "stopszint_short:  "+stopszint_short+"\n",
        "shortorder:       "+shortorder+"\n",
        "stopszint_long:   "+stopszint_long+"\n",
        "longorder:        "+longorder+"\n",
        "lotmenny:         "+lotmenny+"\n"
        );








   return(0);
  }

void CloseBuyOrders (int magic)
   {
      for(int i = OrdersTotal()-1;i>=0;i--)
         {OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
            if(OrderSymbol() == Symbol() && OrderType() == OP_BUY && OrderMagicNumber() == magic)
               {
                  OrderClose(OrderTicket(),OrderLots(),Bid,1,Yellow);
               }
         }
   return (0);
} 
    
    
void CloseSellOrders (int magic)
   {
      for(int n = OrdersTotal()-1;n>=0;n--)
         {OrderSelect(n,SELECT_BY_POS,MODE_TRADES);
            if(OrderSymbol() == Symbol() && OrderType() == OP_SELL && OrderMagicNumber() == magic)
               {
                  OrderClose(OrderTicket(),OrderLots(),Ask,1,Yellow);
               }
         }
   return (0);
} 


//trailingstop


void trailing (int TrailingStop)



{
  double stop_tav = MathAbs((extopen-extstop)/Point);
  int Total = OrdersTotal();
  int i;
  if(irany == 1)
   {i = longorder;}
   else i = shortorder;
  
  TrailingStop = stop_tav;
  
 
      OrderSelect(i, SELECT_BY_TICKET, MODE_TRADES);

            if( TrailingStop > 0) 
            {                 
               if(OrderSymbol() == Symbol() && Bid - OrderOpenPrice() > Point * TrailingStop) 
               {
                  if(OrderSymbol() == Symbol() && OrderStopLoss() < Bid - Point * TrailingStop) 
                  {
                     OrderModify(OrderTicket(), OrderOpenPrice(), Bid - Point * TrailingStop, OrderTakeProfit(), 0, MediumSeaGreen);
                    
                  }
               }
            }


            if( TrailingStop > 0) 
            {                 
               if(OrderSymbol() == Symbol() && (OrderOpenPrice() - Ask) > (Point * TrailingStop)) 
               {
                  if(OrderSymbol() == Symbol() && (OrderStopLoss() > (Ask + Point * TrailingStop)) || (OrderStopLoss() == 0)) 
                  {
                     OrderModify(OrderTicket(), OrderOpenPrice(), Ask + Point * TrailingStop, OrderTakeProfit(), 0, Green);
                    
                  }
               }
             }  
 
 
 return (0);   
 
 }          
 

