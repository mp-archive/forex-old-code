//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

#property copyright "MP"
#property link      "nincs nem kell"

   extern bool       b_fivedigitbroker    =true;
                     
          string     program_name         ="NoLossV3_follower";
          string     strat_symbol="USDJPY";             
 
                    
   extern double     lots              =0.01;                   
   extern int        MAGIC_Rf          =6000;              
   
   extern string     Setup_building="-------------------" ;  
     
   extern int        step              =300;                    
   extern int        step_minute       =60;                   
   extern int        step_max_nr       =30;                    
   extern int        step_type         =2;                   
   
   extern string     Setup_profit="-------------------" ;   
   extern double     average_win       =0.0;                       
   extern double     tp                =0.0;
   extern double     tp_price          =0.0;
   
   
   extern string     Setup_loss="-------------------" ;   
   extern double     max_loss_percent  =20.0;                   
   extern double     sl                =60.0;     
   extern double     sl_price          =0.0;   
   extern double     sl_step           =15.0;                    
   extern bool       trailingstop      =true;                      
   extern int        trailingstop_after_nr   =0;                 

   extern string     Setup_exit_extra="-------------------" ;             
   extern double     stop_after_hour = 0;                    
   extern double     stop_after_hour_minprofit = 0;           
   extern double     stop_after_hour_minloss = 0;            
   extern double     stop_after_hour2 = 0;                    
   extern double     stop_after_hour_minprofit2 = 0;         
   extern double     stop_after_hour_minloss2 = 0;         
   
   
   //----- CORE_SYSTEM ---------------------
   
   datetime          lastopen,lastclose;                     
   bool              open_bool=false;
   int               open_nr=0,pending_nr=0;
   int               open_array_ticket[200],pending_array_ticket[200];
   double            open_array_lot[200];
   double            open_array_price[200];
   double               open_hlp1=0.0,open_hlp2=0.0;
   int               open_type=0;
   double            open_last_price=0.0;
   double            open_first_price=0.0;   
   double            open_avgprice=0.0;
   double            open_total_lot=0.0;
   double            open_total_profit=0.0;
   //double            pricegoal=0.0;

   bool               b_lezar_signal=false;
   
   int               total=0;
   int               order_send=0;
   double            profitmaxpip,profitactpip,profitfallback,initialequity, bestprice;
   double            nextprice,next_sl,next_tp;
   
   int               i_max_position,i_nr_tr,i_nr_tr2,
                     i_max_length,i_total_length,i_last_length;
    
    int szamol=0;               

//--------------------------------------------------------------------------------------------------------


int init()
  {   F_init_5digitstep();
      strat_symbol=Symbol();    
      lastopen=TimeCurrent()-24*60*60;
      F_check_open(); 
      F_display_init();      
   return(0);  }



int start()
  {
   F_display();      
   F_check_open();
          //  szamol+=1;
   if (open_bool==true) 
      {  F_close(open_type);
         F_set_tp_sl();
         F_change();       
         F_build(open_type,open_last_price,step,step_type);   
         }        
   return(0);
  }
 
 int deinit()
  {   return(0);  }

 
 //----------- STRATEGIE 1 -------------------------------------------------------------------------------------------

   
void F_check_open()
   {  total=OrdersTotal(); 
         open_bool=false; open_nr=0; open_hlp1=0.0;open_hlp2=0.0; open_type=0; open_last_price=0.0; open_first_price=0.0; open_avgprice=0.0;
         open_total_lot=0.0;  open_total_profit=0.0; pending_nr=0; tp_price=0; sl_price=0;
      if (total>0)
     {for(int cnt=0;cnt<=total;cnt++)
     {
      OrderSelect(cnt, SELECT_BY_POS,MODE_TRADES);
      if (OrderSymbol()==Symbol() && OrderType()<2)      // symbol changed
      {  open_bool=true;
         open_nr++;
         open_type=OrderType()*(-2)+1;
         open_array_ticket[open_nr]=OrderTicket();
         open_array_lot[open_nr]=OrderLots();
         open_total_lot+=OrderLots();
         open_total_profit+=(OrderProfit()+OrderSwap()+OrderCommission());
         open_array_price[open_nr]=OrderOpenPrice();
         open_hlp1+=OrderLots();
         open_hlp2+=OrderLots()*OrderOpenPrice();
         
         if (open_last_price==0) {open_last_price=OrderOpenPrice(); lastopen=OrderOpenTime(); lastopen=OrderOpenTime();}  // ez!!
         if (OrderOpenPrice()*open_type<open_last_price*open_type && step_type==1) open_last_price=OrderOpenPrice();
         if (OrderOpenPrice()*open_type>open_last_price*open_type && step_type==2) open_last_price=OrderOpenPrice();
         
         if (open_first_price==0) open_first_price=OrderOpenPrice();
         if (OrderOpenPrice()*open_type<open_first_price*open_type && step_type==2) open_first_price=OrderOpenPrice();
         if (OrderOpenPrice()*open_type>open_first_price*open_type && step_type==1) open_first_price=OrderOpenPrice();
         
         if (tp_price==0 && OrderTakeProfit()!=0)   tp_price=OrderTakeProfit();
         if (sl_price==0 && OrderStopLoss()!=0)     sl_price=OrderStopLoss();
         
         if (step_type==1)  {nextprice=open_last_price-open_type*step*Point; next_sl=sl_price+open_type*sl_step*Point; }
         if (step_type==2)  {nextprice=open_last_price+open_type*step*Point; next_sl=sl_price+open_type*sl_step*Point; }
         
         if (OrderOpenTime()<lastopen) lastopen=OrderOpenTime();
         if (OrderOpenTime()>lastopen) lastopen=OrderOpenTime();

      }      
      if (OrderSymbol()==Symbol() && OrderType()>=2)      // symbol changed
      {  pending_nr++;
         pending_array_ticket[pending_nr]=OrderTicket();
      }
     }
     if (open_hlp1>0) open_avgprice=open_hlp2/open_hlp1;
     if (average_win!=0 && tp==0) tp_price=open_avgprice+open_type*average_win*Point;   
         if (open_type==1)  profitactpip=Bid-open_avgprice;          
         if (open_type==-1) profitactpip=open_avgprice-Ask;  
         if ((open_type==1 && Bid>bestprice) || bestprice==0) bestprice=Bid;
         if ((open_type==-1 && Ask<bestprice) || bestprice==0) bestprice=Ask;
         if (profitactpip>profitmaxpip) profitmaxpip=profitactpip;
         profitfallback=profitmaxpip-profitactpip;
            if (open_nr>i_max_position) i_max_position=open_nr;
    }
    if (open_bool==false) b_lezar_signal=false;
   }


void F_set_tp_sl()
   {  if (open_nr==0) return(0);
      if (tp_price==0 && tp!=0 && open_type==1)  tp_price=open_first_price+tp*Point;
      if (tp_price==0 && tp!=0 && open_type==-1) tp_price=open_first_price-tp*Point;      
      if (sl_price==0 && sl!=0 && open_type==1)  sl_price=open_first_price-sl*Point;   
      if (sl_price==0 && sl!=0 && open_type==-1)  sl_price=open_first_price+sl*Point;    
      if (trailingstop==true && open_type==1 && Bid-sl*Point>sl_price+sl_step*Point) sl_price=Bid-sl*Point;
      if (trailingstop==true && open_type==-1 && Ask+sl*Point<sl_price-sl_step*Point) sl_price=Ask+sl*Point;
      return(0);
   }


void F_change()
   {  for(int cnt=0;cnt<=open_nr;cnt++)
      { OrderSelect(open_array_ticket[cnt],SELECT_BY_TICKET);
    /*    if ((OrderTakeProfit()!=tp_price || OrderStopLoss()!=sl_price) && tp_price!=0 && sl_price!=0) 
            OrderModify(OrderTicket(),OrderOpenPrice(),sl_price,tp_price,0,Green);
        if (OrderTakeProfit()!=tp_price && tp_price!=0) 
            OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),tp_price,0,Green);
        if (OrderStopLoss()!=sl_price && sl_price!=0) 
            OrderModify(OrderTicket(),OrderOpenPrice(),sl_price,OrderTakeProfit(),0,Green); 
    */        
       if ((OrderTakeProfit()!=tp_price || OrderStopLoss()!=sl_price)) 
            OrderModify(OrderTicket(),OrderOpenPrice(),sl_price,tp_price,0,Green);      
        }              
   return(0);  }

   
void F_build(int order_type,double order_last_price,int order_step,int build_type)
   {  if (open_nr>=step_max_nr) return(0);
   
     if (build_type==1){         // átlagáraz... akkor épít ha bukóban van
      if (order_type==1 && Ask<=order_last_price-order_step*Point && TimeCurrent()-lastopen>step_minute*60)   { 
            open_nr++;
            open_array_ticket[open_nr]=OrderSend(Symbol(),OP_BUY,lots,Ask,3,sl_price,tp_price,"",MAGIC_Rf,0,Green); 
            lastopen=TimeCurrent();
            F_check_open(); }           
      if (order_type==-1 && Bid>=order_last_price+order_step*Point && TimeCurrent()-lastopen>step_minute*60)  { 
            open_nr++;     
            open_array_ticket[open_nr]=OrderSend(Symbol(),OP_SELL,lots,Bid,3,sl_price,tp_price,"",MAGIC_Rf,0,Green);
            lastopen=TimeCurrent(); 
            F_check_open(); }}   

            
     if (build_type==2){         // akkor épít ha nyerõben van
      if (order_type==1 && Ask>=order_last_price+order_step*Point && TimeCurrent()-lastopen>step_minute*60)   { 
            open_nr++;
            open_array_ticket[open_nr]=OrderSend(Symbol(),OP_BUY,lots,Ask,3,sl_price,tp_price,"",MAGIC_Rf,0,Green); 
            lastopen=TimeCurrent();
            F_check_open(); }           
      if (order_type==-1 && Bid<=order_last_price-order_step*Point && TimeCurrent()-lastopen>step_minute*60)  { 
            open_nr++;     
            open_array_ticket[open_nr]=OrderSend(Symbol(),OP_SELL,lots,Bid,3,sl_price,tp_price,"",MAGIC_Rf,0,Green);
            lastopen=TimeCurrent(); 
            F_check_open(); }}   

      return(0);}
   
        
   
void F_close(int order_type)
   {  bool b_lezar=false;          
      if (AccountEquity()/AccountBalance()<=(1.00-max_loss_percent/100)) b_lezar=true;
      if (profitactpip>=average_win*Point ) b_lezar=true;    

      if (TimeCurrent()-lastopen>=stop_after_hour*3600 && stop_after_hour!=0 && stop_after_hour_minloss==0 && profitactpip>=stop_after_hour_minprofit*Point) b_lezar=true;    
      if (TimeCurrent()-lastopen>=stop_after_hour2*3600 && stop_after_hour2!=0 && stop_after_hour_minloss2==0 && profitactpip>=stop_after_hour_minprofit2*Point) b_lezar=true;    
      if (TimeCurrent()-lastopen>=stop_after_hour*3600 && stop_after_hour!=0 && stop_after_hour_minloss!=0 && stop_after_hour_minprofit==0 && profitactpip<=stop_after_hour_minloss*Point) b_lezar=true;    
      if (TimeCurrent()-lastopen>=stop_after_hour2*3600 && stop_after_hour2!=0 && stop_after_hour_minloss2!0 && stop_after_hour_minprofit2==0 && profitactpip<=stop_after_hour_minloss2*Point) b_lezar=true;    
      if (trailingstop==true && open_nr>=trailingstop_after_nr && sl!=0 && order_type==1 && Bid<=bestprice-sl*Point) b_lezar=true; 
      if (trailingstop==true && open_nr>=trailingstop_after_nr && sl!=0 && order_type==-1 && Ask>=bestprice+sl*Point) b_lezar=true; 

      if ((-profitactpip)>=sl*Point && sl!=0) b_lezar=true;    // átlagárhoz képest

      if (order_type==1 && ((Bid<=sl_price && sl_price!=0) || (Ask>=tp_price && tp_price!=0))) b_lezar=true; 
      if (order_type==-1 && ((Ask>=sl_price && sl_price!=0) || (Bid<=tp_price && tp_price!=0))) b_lezar=true;       
        
         if (b_lezar==true) b_lezar_signal=true;
        
         if (b_lezar==true || b_lezar_signal==true)       
         {for(int cnt=0;cnt<=open_nr;cnt++)
            {  OrderSelect(open_array_ticket[cnt],SELECT_BY_TICKET);
               if (order_type==1) OrderClose(OrderTicket(),OrderLots(),Bid,3,Red); 
               if (order_type==-1) OrderClose(OrderTicket(),OrderLots(),Ask,3,Red); 
            }
            i_last_length=TimeCurrent()-lastopen;
                        if (TimeDayOfWeek(lastopen)>TimeDayOfWeek(TimeCurrent()) && NormalizeDouble(i_last_length/60/60,2)>48) i_last_length-=48*60*60;
            if (i_last_length>i_max_length) i_max_length=i_last_length;
            i_total_length+=i_last_length;
            i_nr_tr++;i_nr_tr2+=open_nr;
         }
   return(0);}

///-------------------------------------------------------------

void F_init_5digitstep()
   {  if (b_fivedigitbroker==true)
      {  step              *=10;
         average_win       *=10;
         tp        *=10;       
         sl        *=10;
         sl_step   *=10;
         stop_after_hour_minprofit *=10;
         stop_after_hour_minprofit2 *=10;
         stop_after_hour_minloss *=10;
         stop_after_hour_minloss2 *=10;
      }
   return(0);  }
   
   
void F_display_init()
   {
      ObjectDelete("label1");
      ObjectCreate("label1", OBJ_LABEL, 0, 0, 0);// Creating obj.   
      ObjectSet("label1", OBJPROP_CORNER, 0);    // Reference corner   
      ObjectSet("label1", OBJPROP_XDISTANCE, 4);// X coordinate   
      ObjectSet("label1", OBJPROP_YDISTANCE, 15);// Y coordinate   
      ObjectSetText("label1","Time: " + TimeToStr(TimeCurrent(),TIME_DATE|TIME_SECONDS),8,"Arial",LightYellow);  
      
      ObjectDelete("label2");
      ObjectCreate("label2", OBJ_LABEL, 0, 0, 0);// Creating obj.   
      ObjectSet("label2", OBJPROP_CORNER, 0);    // Reference corner   
      ObjectSet("label2", OBJPROP_XDISTANCE, 4);// X coordinate   
      ObjectSet("label2", OBJPROP_YDISTANCE, 30);// Y coordinate   
      ObjectSetText("label2","Digits: " + Digits + "    5digitsetting: " + (4+ b_fivedigitbroker) + "    Spread: " + DoubleToStr(MarketInfo(Symbol(),MODE_SPREAD),1),8,"Arial",LightYellow);   

      ObjectDelete("label3");
      ObjectCreate("label3", OBJ_LABEL, 0, 0, 0);// Creating obj.   
      ObjectSet("label3", OBJPROP_CORNER, 0);    // Reference corner   
      ObjectSet("label3", OBJPROP_XDISTANCE, 4);// X coordinate   
      ObjectSet("label3", OBJPROP_YDISTANCE, 45);// Y coordinate   
      ObjectSetText("label3","",8,"Arial",LightYellow);   

   }   
   
void F_display()
   {
      if (open_nr==0) ObjectSetText("label1","Account: " + AccountNumber() + "     Open position: " + open_nr,8,"Arial",LightYellow);  
      if (open_nr!=0) 
      ObjectSetText("label1","Account: " + AccountNumber() + "     Open position: " + open_nr + " Open type: " + open_type + " Open: " + open_bool
            ,8,"Arial",LightYellow);  
      ObjectSetText("label2","  Last: " + DoubleToStr(open_last_price,4) + " (" + DoubleToStr(nextprice,4)+ ")  Sl: " + DoubleToStr(sl_price,4)+ " (" + DoubleToStr(next_sl,4) + ")  Tp: " + DoubleToStr(tp_price,4)
            ,8,"Arial",LightYellow);   
      ObjectSetText("label3","  Digits: " + Digits + "    5digitsetting: " + (4+ b_fivedigitbroker) + "    Spread: " + DoubleToStr(MarketInfo(Symbol(),MODE_SPREAD),1)
  //    ObjectSetText("label3","" + TimeCurrent() + "  " + szamol
            ,8,"Arial",LightYellow);   
   }



