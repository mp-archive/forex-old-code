//+------------------------------------------------------------------+
//   új:   1  lezárt ha nem tud építeni      2 a kötési ind értékek kiiratása
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

#property copyright "MP"
#property link      "nincs nem kell"

   extern bool       b_fivedigitbroker    =true;
                     
          string     program_name="NoLossV3_follower";
          string     strat_symbol="USDJPY";             
   
   
   extern string     Setup_enter="-------------------" ;  
  
   extern double     maxspread         =2.4;
   extern int        entry_type        =0;          
   extern double     lots              =0.01;                  int strat_nr=2;  
   extern int        MAGIC_Rf          =6000;                  int        MAGIC_Rf_m[10]           ={6000,6001};        
   
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
   extern int        trailingstop      =1;                      
   extern int        trailingstop_after_nr   =0;                 

   extern string     Setup_exit_extra="-------------------" ;             
   extern double     stop_after_hour = 0;                    
   extern double     stop_after_hour_minprofit = 0;           
   extern double     stop_after_hour_minloss = 0;            
   extern double     stop_after_hour2 = 0;                    
   extern double     stop_after_hour_minprofit2 = 0;         
   extern double     stop_after_hour_minloss2 = 0;         
   
   
   //----- CORE_SYSTEM ---------------------
   
   //int         j=0;
   int         signal1=0;                    int      signal1_m[10]        ={0   ,0    ,0    ,0    ,0    ,0};
   double      signal1_price=0.0;            double   signal1_price_m[10]  ={0.0 ,0.0  ,0.0  ,0.0  ,0.0  ,0.0};
   double      signal1_pricem=0.0;           double   signal1_pricem_m[10] ={0.0 ,0.0  ,0.0  ,0.0  ,0.0  ,0.0};
   double      signal1_adxm=0.0;             double   signal1_adxm_m[10]   ={0.0 ,0.0  ,0.0  ,0.0  ,0.0  ,0.0};
   datetime    signal1_time;                 datetime signal1_time_m[10];
   datetime    signal1_timee;                datetime signal1_timee_m[10];       //ezt használjuk arra ha nem tud kötni
   datetime    lastopen_i;                   datetime lastopen_i_m[10];       //ezt használjuk arra ha nem tud kötni
   int         last_ticket_i;                int      last_ticket_i_m[10];
   
   int         signal2=0;                    int      signal2_m[10]        ={0   ,0    ,0    ,0    ,0    ,0};

   bool              signal_exists=false;
   int               signal_tempvalue=0;
   double            signal_tempvalueadx=0.0;
                     
   double     lots2,lots_martingal;
   double     average_win2;

   datetime          lastopen,lastopen2,lastclose;                     
   bool              open_bool=false,pending_bool=false;
   int               open_nr=0,pending_nr=0;
   int               open_array_ticket[200],pending_array_ticket[200];
   double            open_array_lot[200];
   double            open_array_price[200];
   double            open_hlp1=0.0,open_hlp2=0.0;
   int               open_type=0;
   double            open_last_price=0.0;
   double            open_first_price=0.0;
   double            open_avgprice=0.0;
   double            open_total_lot=0.0;
   double            open_total_profit=0.0;
   double            pricegoal=0.0;

   bool               b_lezar_signal=false;
   
   int               total=0;
   int               order_send=0;
   double            profitmaxpip,profitminpip,profitactpip,profitfallback,initialequity, bestprice;
   double            nextprice,next_sl,next_tp;  
   
   string            file_name;
   int               file;
   int               i_max_position,i_nr_tr,i_nr_tr2,
                     i_max_length,i_total_length,i_last_length;
   double            test_data[14];
                     
                   

//--------------------------------------------------------------------------------------------------------


int init()
  {   F_init_5digitstep();
       if (b_fivedigitbroker==true) maxspread*=10;
      F_init_lastopen();
      F_check_open(true); 
      F_display_init();      
      strat_symbol=Symbol();    
      lastopen=TimeCurrent()-25*60*60;
      MAGIC_Rf_m[0]=MAGIC_Rf;
      MAGIC_Rf_m[1]=MAGIC_Rf+1;      
   return(0);  }


 int deinit()
  {   return(0);  }


int start()
  {
   F_display();      
   F_check_open(false);

   if (open_bool==false) 
      {   }                ///   <------------- kell
      
   if (open_bool==true) 
      {  F_set_tp_sl();         
         F_close(open_type);
         if (trailingstop==1) F_change_trailing();                        
         F_build(open_type,open_last_price,step,step_type);   
         }         
   return(0);
  }
 
 
 //----------- RUN 1 -------------------------------------------------------------------------------------------



void F_init_lastopen()
   {  total=OrdersHistoryTotal();
      for (int j=0;j<=strat_nr-1;j++)
         {  lastopen_i_m[j]=TimeCurrent()-60*60*24*5;
            for(int cnt=0;cnt<=total;cnt++)
            { OrderSelect(cnt, SELECT_BY_POS,MODE_HISTORY);
              if (OrderOpenTime()>lastopen_i_m[j]) { lastopen_i_m[j]=OrderOpenTime(); last_ticket_i_m[j]=OrderTicket();}}}
   return(0);}

   
void F_check_open()
   {  total=OrdersTotal(); 
         open_bool=false; pending_bool=false; open_nr=0; open_hlp1=0.0;open_hlp2=0.0; open_type=0; open_last_price=0.0; 
         open_first_price=0.0;open_avgprice=0.0;open_total_lot=0.0;  open_total_profit=0.0; pending_nr=0;
      if (total>0)
     {for(int cnt=0;cnt<=total;cnt++)
     {
      OrderSelect(cnt, SELECT_BY_POS,MODE_TRADES);
      if ((OrderMagicNumber()==MAGIC_Rf || entry_type=0) && OrderSymbol()==Symbol() && OrderType()<2)      // symbol changed
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
         
         if (open_last_price==0) {open_last_price=OrderOpenPrice(); lastopen=OrderOpenTime(); lastopen2=OrderOpenTime();}  // ez!!
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
         if (OrderOpenTime()>lastopen2) lastopen2=OrderOpenTime();
         last_ticket_i_m[j]=OrderTicket();last_ticket_i=OrderTicket();
         if (OrderLots()>lots2 || lots2==0) lots2=OrderLots();
      }      
      if ((OrderMagicNumber()==MAGIC_Rf || entry_type=0 && OrderSymbol()==Symbol() && OrderType()>=2)      // symbol changed
         {  pending_bool=true;pending_nr++;pending_array_ticket[pending_nr]=OrderTicket(); }
     }
     if (open_hlp1>0) open_avgprice=open_hlp2/open_hlp1;
     pricegoal=open_avgprice+open_type*average_win2*Point;   
         if (open_type==1)  profitactpip=Bid-open_avgprice;          
         if (open_type==-1) profitactpip=open_avgprice-Ask;  
         if (open_type==1 && (Bid>bestprice || bestprice==0)) bestprice=Bid;
         if (open_type==-1 && (Ask<bestprice || bestprice==0)) bestprice=Ask;
         if (profitactpip>profitmaxpip) profitmaxpip=profitactpip;
         if (profitactpip<profitminpip) profitminpip=profitactpip;         
         profitfallback=profitmaxpip-profitactpip;
            if (open_nr>i_max_position) i_max_position=open_nr;
    }
    if (open_bool==false) b_lezar_signal=false;
   }


void F_open_now(int order_type)
   {  if (order_type==0) {return(0);}
      if (Ask-Bid > maxspread*Point) {return(0);}
      if (MarketInfo(Symbol(),MODE_SPREAD)>maxspread) {return(0);}

      if (order_type==1 && order_type==1)  {  
            open_array_ticket[open_nr+1]=OrderSend(Symbol(),OP_BUY,lots2,Ask,3,0,0,program_name+strat_symbol,MAGIC_Rf,0,Green);  
            open_nr++; lastopen=TimeCurrent(); lastopen2=TimeCurrent();lastopen_i=TimeCurrent();lastclose=TimeCurrent()-24*60*60;  
            profitmaxpip=0.0;profitminpip=0.0;profitactpip=0.0; profitfallback=0.0; average_win2=average_win; open_bool=true; initialequity=AccountEquity();
            bestprice=Bid;if (step_type==1 && average_win!=0) F_change_avgprice();}
      if (order_type==1 && order_type==-1) {  
            open_array_ticket[open_nr+1]=OrderSend(Symbol(),OP_SELL,lots2,Bid,3,0,0,program_name+strat_symbol,MAGIC_Rf,0,Green);   
            open_nr++; lastopen=TimeCurrent(); lastopen2=TimeCurrent();lastopen_i=TimeCurrent();lastclose=TimeCurrent()-24*60*60;  
            profitmaxpip=0.0;profitminpip=0.0;profitactpip=0.0; profitfallback=0.0; average_win2=average_win; open_bool=true; initialequity=AccountEquity();
            bestprice=Ask;if (step_type==1 && average_win!=0) F_change_avgprice();}  
            
      tp_price=0;sl_price=0;F_set_tp_sl();            
      return(0);}

   
void F_build(int order_type,double order_last_price,int order_step,int build_type)
   {  if (open_nr>=step_max_nr) return(0);
   
     if (build_type==1){         // átlagáraz... akkor épít ha bukóban van
      if (order_type==1 && Ask<=order_last_price-order_step*Point && TimeCurrent()-lastopen2>step_minute*60)   { 
            if (increase_lots && MathMod(open_nr,increase_for_every)==0) lots2=NormalizeDouble(lots2+lots*increase_percent,2);
            open_nr++;
            open_array_ticket[open_nr]=OrderSend(Symbol(),OP_BUY,lots2,Ask,3,0,0,"",MAGIC_Rf,0,Green); 
            lastopen2=TimeCurrent();
            average_win2+=step_movegoal;
            F_check_open(false);  F_change_avgprice();}           
      if (order_type==-1 && Bid>=order_last_price+order_step*Point && TimeCurrent()-lastopen2>step_minute*60)  { 
            if (increase_lots && MathMod(open_nr,increase_for_every)==0) lots2=NormalizeDouble(lots2+lots*increase_percent,2);
            open_nr++;     
            open_array_ticket[open_nr]=OrderSend(Symbol(),OP_SELL,lots2,Bid,3,0,0,"",MAGIC_Rf,0,Green);
            lastopen2=TimeCurrent(); 
            average_win2+=step_movegoal;
            F_check_open(false);  F_change_avgprice();}}   
            
     if (build_type==2){         // akkor épít ha nyerõben van
      if (order_type==1 && Ask>=order_last_price+order_step*Point && TimeCurrent()-lastopen2>step_minute*60)   { 
            if (increase_lots && MathMod(open_nr,increase_for_every)==0) lots2=NormalizeDouble(lots2+lots*increase_percent,2);
            open_nr++;
            open_array_ticket[open_nr]=OrderSend(Symbol(),OP_BUY,lots2,Ask,3,0,0,"",MAGIC_Rf,0,Green); 
            lastopen2=TimeCurrent();
            average_win2+=step_movegoal;
            F_check_open(false); }           
      if (order_type==-1 && Bid<=order_last_price-order_step*Point && TimeCurrent()-lastopen2>step_minute*60)  { 
            if (increase_lots && MathMod(open_nr,increase_for_every)==0) lots2=NormalizeDouble(lots2+lots*increase_percent,2);
            open_nr++;     
            open_array_ticket[open_nr]=OrderSend(Symbol(),OP_SELL,lots2,Bid,3,0,0,"",MAGIC_Rf,0,Green);
            lastopen2=TimeCurrent(); 
            average_win2+=step_movegoal;
            F_check_open(false); }}   
    return(0);}
   

void F_set_tp_sl()
   {  if (open_nr==0) return(0);
      if (tp_price==0 && tp!=0 && open_type==1)  tp_price=open_first_price+tp*Point;
      if (tp_price==0 && tp!=0 && open_type==-1) tp_price=open_first_price-tp*Point;      
      if (sl_price==0 && sl!=0 && open_type==1)  sl_price=open_first_price-sl*Point;   
      if (sl_price==0 && sl!=0 && open_type==-1)  sl_price=open_first_price+sl*Point;    
      if (trailingstop==1 && open_type==1 && Bid-sl*Point>=sl_price+sl_step*Point 
         && Bid-sl*Point>=open_first_price+sl_step_first*Point) sl_price=Bid-sl*Point;
      if (trailingstop==1 && open_type==-1 && Ask+sl*Point<=sl_price-sl_step*Point 
         && Ask+sl*Point<=open_first_price-sl_step_first*Point) sl_price=Ask+sl*Point;
      return(0);
   }

void F_change_trailing()
   {  for(int cnt=0;cnt<=open_nr;cnt++)
      { OrderSelect(open_array_ticket[cnt],SELECT_BY_TICKET);
       if ((OrderTakeProfit()!=tp_price || OrderStopLoss()!=sl_price)) 
            OrderModify(OrderTicket(),OrderOpenPrice(),sl_price,tp_price,0,Green);      
        }              
   return(0);  }

   
void F_change_avgprice()
   {  
      int st_small=2; if (b_fivedigitbroker==true) st_small*=10;
      if ((IsTesting()==false && IsOptimization()==false) || false==true)
      for(int cnt=0;cnt<=open_nr;cnt++)
      { OrderSelect(open_array_ticket[cnt],SELECT_BY_TICKET);
         OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),open_avgprice+open_type*(average_win2+st_small)*Point,0,Green);}
   return(0);  }
         
   
void F_close(int order_type)
   {  bool b_lezar=false; int b_lezar_kod=0;         
      if (AccountEquity()/initialequity<=(1.00-max_loss_percent/100)) { b_lezar=true; b_lezar_kod=1;}
      if (AccountEquity()/initialequity<=(1.00-ult_max_loss_percent/100)) { b_lezar=true; b_lezar_kod=2;}
      if (b_letprofitrun==false && profitactpip>=average_win2*Point ) { b_lezar=true; b_lezar_kod=3;}   
      if (b_letprofitrun==true && profitmaxpip>=average_win2*Point && profitfallback>=fallbackpip_min*Point && profitmaxpip>0.0)
            if (profitfallback>=fallbackpip_max*Point || profitfallback/profitmaxpip>fallbackpercent_max) { b_lezar=true; b_lezar_kod=4;}     
      if (TimeCurrent()-lastopen>=stop_after_hour*3600 && stop_after_hour!=0 && stop_after_hour_minloss==0 && profitactpip>=stop_after_hour_minprofit*Point) { b_lezar=true; b_lezar_kod=5;}    
      if (TimeCurrent()-lastopen>=stop_after_hour2*3600 && stop_after_hour2!=0 && stop_after_hour_minloss2==0 && profitactpip>=stop_after_hour_minprofit2*Point) { b_lezar=true; b_lezar_kod=6;}    
      if (TimeCurrent()-lastopen>=stop_after_hour*3600 && stop_after_hour!=0 && stop_after_hour_minloss!=0 && stop_after_hour_minprofit==0 && profitactpip<=stop_after_hour_minloss*Point){ b_lezar=true; b_lezar_kod=7;}    
      if (TimeCurrent()-lastopen>=stop_after_hour2*3600 && stop_after_hour2!=0 && stop_after_hour_minloss2!0 && stop_after_hour_minprofit2==0 && profitactpip<=stop_after_hour_minloss2*Point){ b_lezar=true; b_lezar_kod=8;}    
      if (trailingstop==1 && open_nr>=trailingstop_after_nr && sl!=0 && order_type==1 && Bid<=bestprice-sl*Point) { b_lezar=true; b_lezar_kod=9;}
      if (trailingstop==1 && open_nr>=trailingstop_after_nr && sl!=0 && order_type==-1 && Ask>=bestprice+sl*Point){ b_lezar=true; b_lezar_kod=10;}
      if ((-profitactpip)>=sl*Point && sl!=0) { b_lezar=true; b_lezar_kod=11;}    // átlagárhoz képest
      if (order_type==1 && ((Bid<=sl_price && sl_price!=0) || (Ask>=tp_price && tp_price!=0))) { b_lezar=true; b_lezar_kod=12;} 
      if (order_type==-1 && ((Ask>=sl_price && sl_price!=0) || (Bid<=tp_price && tp_price!=0))) { b_lezar=true; b_lezar_kod=13;}     
      
      if (TimeCurrent()-lastopen2>=stop_after_lastopen_min*60 && stop_after_lastopen_min!=0 && profitactpip>=stop_after_lastopen_minprofit*Point) { b_lezar=true; b_lezar_kod=14;}    
      
         if (b_lezar==true) b_lezar_signal=true;
        
         if (b_lezar==true || b_lezar_signal==true)       
         {for(int cnt=1;cnt<=open_nr;cnt++)
            {  OrderSelect(open_array_ticket[cnt],SELECT_BY_TICKET);
               if (order_type==1) OrderClose(OrderTicket(),OrderLots(),Bid,3,Red); 
               if (order_type==-1) OrderClose(OrderTicket(),OrderLots(),Ask,3,Red); 
            }
            i_last_length=TimeCurrent()-lastopen;
                        if (TimeDayOfWeek(lastopen)>TimeDayOfWeek(TimeCurrent()) && NormalizeDouble(i_last_length/60/60,2)>48) i_last_length-=48*60*60;
            if (i_last_length>i_max_length) i_max_length=i_last_length;
            i_total_length+=i_last_length;
            i_nr_tr++;i_nr_tr2+=open_nr;
            if (IsTesting() && !IsOptimization()) 
              { if (tde=="")
                FileWrite(file,open_array_ticket[1],MAGIC_Rf,order_type,open_nr,TimeToStr(lastopen,TIME_DATE|TIME_SECONDS),TimeDayOfWeek(lastopen),NormalizeDouble(i_last_length/60,2),NormalizeDouble(i_last_length/60/60,2),
                NormalizeDouble(i_last_length/60/60/24,2),b_lezar_kod+tde,profitactpip/Point,profitmaxpip/Point,profitminpip/Point,profitfallback/Point,test_data[1],test_data[2],test_data[3],test_data[4],test_data[5],test_data[6],
                test_data[7],test_data[8],test_data[9],test_data[10],test_data[11],test_data[12]); 
                else
                FileWrite(file,open_array_ticket[1]+tde,MAGIC_Rf+tde,order_type+tde,open_nr+tde,TimeToStr(lastopen,TIME_DATE|TIME_SECONDS)+tde,TimeDayOfWeek(lastopen)+tde,NormalizeDouble(i_last_length/60,2)+tde,NormalizeDouble(i_last_length/60/60,2)+tde,
                NormalizeDouble(i_last_length/60/60/24,2)+tde,b_lezar_kod+tde,profitactpip/Point+tde,profitmaxpip/Point+tde,profitminpip/Point+tde,profitfallback/Point+tde,test_data[1]+tde,test_data[2]+tde,test_data[3]+tde,test_data[4]+tde,test_data[5]+tde,test_data[6]+tde,
                test_data[7]+tde,test_data[8]+tde,test_data[9]+tde,test_data[10]+tde,test_data[11]+tde,test_data[12]+tde); 
              }
         }
   return(0);}

///-------------------------------------------------------------


void F_setup_multistrat(int nr)
   {
   strat_symbol      =strat_symbol_m[nr];
   strat_period      =strat_preiod_m[nr];
   b_signal2_trading=b_signal2_trading_m[nr];
   tradinghour_start =tradinghour_start_m[nr];
   tradinghour_end   =tradinghour_end_m[nr];
   tradinghour       =tradinghour_m[nr];  
   tradingfridaytill =tradingfridaytill_m[nr];
   tradingdayoyearmax=tradingdayoyearmax_m[nr];
   
   entry_type        =entry_type_m[nr];
   entry_reverse     =entry_reverse_m[nr];
   if (test_entry_order_type==false) entry_ordertype   =entry_ordertype_m[nr];
   if (test_entry_order_type==false) entry_orderbridge =entry_orderbridge_m[nr];
   if (test_entry_order_type==false) entry_expire      =entry_expire_m[nr];     

   lots_equityperlot =lots_equityperlot_m[nr];
   martingal         =martingal_m[nr];
   mult_martingal    =mult_martingal_m[nr];
   
   if (b_aggressive==true) lots_equityperlot =lots_equityperlot_ma[nr];
   MAGIC_Rf          =MAGIC_Rf_m[nr];

   increase_lots           =increase_lots_m[nr];
   increase_for_every      = increase_for_every_m[nr];
   increase_percent        =increase_percent_m[nr];
   
   step                    =step_m[nr];
   step_minute             =step_minute_m[nr]  ;
   step_max_nr             =step_max_nr_m[nr]  ;
   step_movegoal           =step_movegoal_m[nr]   ;
   step_type               =step_type_m[nr];
   
   average_win             =average_win_m[nr];        
   tp                      =tp_m[nr];
   tp_price                =tp_price_m[nr];
    
   b_letprofitrun          =b_letprofitrun_m[nr];
   fallbackpip_min         =fallbackpip_min_m[nr];
   fallbackpip_max         =fallbackpip_max_m[nr] ;
   fallbackpercent_max     =fallbackpercent_max_m[nr] ;
   
   max_loss_percent        =max_loss_percent_m[nr];  
   sl                      =sl_m[nr];
   sl_price                =sl_price_m[nr];
   sl_step                 =sl_step_m[nr];           
   sl_step_first           =sl_step_first_m[nr];           
   trailingstop            =trailingstop_m[nr];
   trailingstop_after_nr   =trailingstop_after_nr_m[nr];   
   
   stop_after_hour            =stop_after_hour_m[nr];
   stop_after_hour_minprofit  =stop_after_hour_minprofit_m[nr];
   stop_after_hour_minloss    =stop_after_hour_minloss_m[nr];
   stop_after_hour2           =stop_after_hour2_m[nr];
   stop_after_hour_minprofit2 =stop_after_hour_minprofit2_m[nr];
   stop_after_hour_minloss2 = stop_after_hour_minloss2_m[nr];

   signal_atr_max    =signal_atr_max_m[nr];    
   signal_atr_min    =signal_atr_min_m[nr];  
   atr_preiod        =atr_preiod_m[nr]; 
       
   signal_adx_limit  =signal_adx_limit_m[nr];
   signal_adx_max    =signal_adx_max_m[nr];  
   adx_preiod        =adx_preiod_m[nr];
   signal_adx_limit2 =signal_adx_limit2_m[nr];
   adx_preiod2       =adx_preiod2_m[nr] ;
   signal_stoch_down =signal_stoch_limit_m[nr];
   stoch_preiod      =adx_stoch_m[nr];   
   rsi_limit_down    =rsi_limit_down_m[nr];
   rsi_min_down      =rsi_limit_min_m[nr];
   rsi_period        =rsi_period_m[nr];
   bool_dev          =bool_dev_m[nr];
   bool_preiod       =bool_preiod_m[nr];
   
   stepmin1    =stepmin1_m[nr];
   steppip1    =steppip1_m[nr];
   stepmin2    =stepmin2_m[nr];
   steppip2    =steppip2_m[nr];
   stepmin3    =stepmin3_m[nr];
   steppip3    =steppip3_m[nr];
   
   delayminutes   =  delayminutes_m[nr];
      
      F_init_5digitstep();      
   return(0); }



void F_init_5digitstep()
   {  if (b_fivedigitbroker==true)
      {  if (test_entry_order_type==false) entry_orderbridge *=10;
         step              *=10;
         step_movegoal     *=10;
         average_win       *=10;
         fallbackpip_min   *=10;
         fallbackpip_max   *=10;
         tp        *=10;       
         sl        *=10;
         sl_step   *=10;         
         stop_after_hour_minprofit *=10;
         stop_after_hour_minprofit2 *=10;
         stop_after_hour_minloss *=10;
         stop_after_hour_minloss2 *=10;
         signal_atr_max*=10;
         signal_atr_min*=10;
         steppip1*=10; steppip2*=10; steppip3*=10;
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

void F_display_alert()
   {
      ObjectSetText("label1","Wrong symbol or timeframe",8,"Arial",Red);  
      ObjectSetText("label2","",8,"Arial",LightYellow);   
   }



