
    double in_tp2=5.0;
    double in_sl2=15.0;
    double     in_shl=10.0,in_shm=3.0; 
   /* */ bool     set_hours=false;
         bool     set_days=false;
  
   
//---------------- CORE_SYSTEM -------------------------------
//------------------------------------------------------------
   //---------------- Testing -----------------------------------

    int        in_testfreq=1;  int testfrcnt=0;   // to make test faster
   

          double     tester_ts=0,tester_tp=0;
          double     tester_typ[30]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
          int        i_max_position,i_nr_tr,i_nr_tr2,
                     i_max_length,i_total_length,i_last_length;
          
   //---- skip variables ----------------------------------------
   
   bool skip_checkopen=false,skip_shapes_calc=false;
   
   
   //---- helper variables --------------------------------------
   
                                             datetime lastopen_i_m[30];       //ezt használjuk arra ha nem tud kötni
                                             datetime lastclose_i_m[30];      //ezt használjuk arra ha nem tud kötni 
                                             datetime lastloss_i_m[30];      //ezt használjuk arra ha nem tud kötni 
   int         last_ticket;                  int      last_ticket_i_m[30];
                                             bool     open_bool_i_m[30]    ={false,false,false,false,false,false,false,false,false,false};
                                             int      open_nr_i_m[30]    ={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
   
   int         signal1=0;               

   bool              signal_exists=false;
   int               signal_tempvalue=0;
   double            signal_tempvalueadx=0.0;
                     
   double     lots2,lots_martingal,lastprofit=0.0;
   double     tp_avg2;
   double     d5korr=1.0;
   double     nextlevel_up,nextlevel_down;

   datetime          lastopen,lastopen2,lastclose,lastloss;                     
   bool              open_bool=false,pending_bool=false,hedging_bool=false;
   int               open_nr=0,pending_nr=0,hedging_nr=0;
   int               open_array_ticket[200],pending_array_ticket[20],hedging_array_ticket[20];
   double            open_array_lot[200];
   double            open_array_price[200];
   double            open_hlp1=0.0,open_hlp2=0.0;
   int               open_type=0;
   double            open_last_price=0.0;
   double            open_first_price=0.0;
   double            open_avgprice=0.0;
   double            open_total_lot=0.0;
   double            open_total_profit=0.0;
   double            pricegoal=0.0;       //????
   int               section=0;        // 0: átlagáraz   1:    2: épít felfelé

   bool               b_lezar_signal=false;
   double            sh_c[100],sh_o[100],sh_h[100],sh_l[100],sh_oc[100],sh_b[100],sh_s[100],sh_cc[100],sh_sh[100],sh_sl[100];
         
   double   set_hour[24]={  0,0,0,1,
                            1,1,1,1,
                            0,1,1,0,
                            1,0,1,1,
                            1,0,1,1,
                            1,0,0,0  };
   double   hour_reverse=1;
   double set_day[7]={1,1,1,0,1,1,1};
      
   int               total=0;
   int               order_send=0;
   double            profitmaxpip,profitminpip,profitactpip,profitfallback,initialequity, bestprice;
   double            nextprice,next_sl,next_tp;  
     
///-------------------------------------------------------------------------------------------------------

bool b_compeetingbot=in_b_compeetingbot;
bool b_fivedigitbroker=in_b_fivedigitbroker;
bool b_run_multistrat=in_b_run_multistrat;
bool strat_1=in_strat_1;
bool strat_2=in_strat_2;
bool strat_3=in_strat_3;
bool strat_4=in_strat_4;
bool strat_5=in_strat_5;
bool strat_6=in_strat_6;
bool strat_7=in_strat_7;
bool strat_8=in_strat_8;
bool strat_9=in_strat_9;
bool strat_10=in_strat_10;
bool strat_11=in_strat_11;
bool strat_12=in_strat_12;
bool strat_13=in_strat_13;
bool strat_14=in_strat_14;
bool strat_15=in_strat_15;
bool strat_16=in_strat_16;
bool strat_17=in_strat_17;
bool strat_18=in_strat_18;
bool strat_19=in_strat_19;
bool strat_20=in_strat_20;

int test_strategies_to=in_test_strategies_to;
int MAGIC_Rf=in_MAGIC_Rf;
double maxspread=in_maxspread;
double ult_max_loss_percent=in_ult_max_loss_percent;
double ult_win_percent=in_ult_win_percent;
int ult_reverse=in_ult_reverse;
bool money_management=in_money_management;
bool b_aggressive=in_b_aggressive;
int hidden_equity=in_hidden_equity;
double lots=in_lots;
double lots_multipliyer=in_lots_multipliyer;
double lots_equityperlot=in_lots_equityperlot;
double martingal=in_martingal;
int strat_period=F_timeframes(in_strat_period);
//string Setup_Entry=in_Setup_Entry;
int tradinghour_start=in_tradinghour_start;
int tradinghour_end=in_tradinghour_end;
int tradinghour=in_tradinghour;
int tradingfridaytill=in_tradingfridaytill;
int tradingdayoyearmax=in_tradingdayoyearmax;
int entry_type=in_entry_type;
int entry_reverse=in_entry_reverse;
int entry_ordertype=in_entry_ordertype;
double entry_orderbridge=in_entry_orderbridge;
int entry_expire=in_entry_expire;
double delayminutes=in_delayminutes;
double delayminutesafterclose=in_delayminutesafterclose;
double delayminutesafterloss=in_delayminutesafterloss;
//string Setup_Building=in_Setup_Building;
bool increase_lots=in_increase_lots;
int increase_for_every=in_increase_for_every;
double increase_percent=in_increase_percent;
int step_type=in_step_type;
int step_up=in_step_up;
int step_down=in_step_down;
int step_down_first=in_step_down_first;
int step_down_minute=in_step_down_minute;
int step_max_nr=in_step_max_nr;
int step_max_nr_down=in_step_max_nr_down;
double step_movegoal=in_step_movegoal;
//double hedging_openafter=in_hedging_openafter;
//double hedging_losspip=in_hedging_losspip;
//string Setup_Profit=in_Setup_Profit;
double tp_price=in_tp_price;
double tp_avg=in_tp_avg;
double tp=in_tp;
bool b_letprofitrun=in_b_letprofitrun;
int fallbackpip_min=in_fallbackpip_min;
int fallbackpip_max=in_fallbackpip_max;
double fallbackpercent_max=in_fallbackpercent_max;
//string Setup_Loss=in_Setup_Loss;
double max_loss_percent=in_max_loss_percent;
double sl_price=in_sl_price;
double sl=in_sl;
double sl_trail=in_sl_trail;
double sl_step=in_sl_step;
double sl_step_first=in_sl_step_first;
double sl_onavgprice=in_sl_onavgprice;
int trailingstop_after_nr=in_trailingstop_after_nr;
int stop_after_nr=in_stop_after_nr;
//string Setup_Exit=in_Setup_Exit;
double stop_after_hour_tillsection=in_stop_after_hour_tillsection;
double stop_after_hour=in_stop_after_hour;
double stop_after_hour_minprofit=in_stop_after_hour_minprofit;
double stop_after_hour_minloss=in_stop_after_hour_minloss;
double stop_after_hour2=in_stop_after_hour2;
double stop_after_hour_minprofit2=in_stop_after_hour_minprofit2;
double stop_after_hour_minloss2=in_stop_after_hour_minloss2;
double stop_after_lastopen_min=in_stop_after_lastopen_min;
double stop_after_lastopen_minprofit=in_stop_after_lastopen_minprofit;
double stop_after_lastopen_maxprofit=in_stop_after_lastopen_maxprofit;
//double stop_st3_out=in_stop_st3_out;
//string Entry_type_nr_1=in_Entry_type_nr_1;
double signal_atr_max=in_signal_atr_max;
double signal_atr_min=in_signal_atr_min;
int atr_period=in_atr_period;
double signal_adx_limit=in_signal_adx_limit;
double signal_adx_max=in_signal_adx_max;
int adx_period=in_adx_period;
double signal_adx_limit2=in_signal_adx_limit2;
int adx_period2=in_adx_period2;
double signal_stoch_down=in_signal_stoch_down;
int stoch_period=in_stoch_period;
double rsi_limit_down=in_rsi_limit_down;
double rsi_min_down=in_rsi_min_down;
int rsi_period=in_rsi_period;
int bool_dev=in_bool_dev;
int bool_period=in_bool_period;
int bool_dev2=in_bool_dev2;
int bool_period2=in_bool_period2;
int bool_dev3=in_bool_dev3;
int bool_period3=in_bool_period3;
//string Entry_type_nr_1_extra=in_Entry_type_nr_1_extra;
int stepmin1=in_stepmin1;
double steppip1=in_steppip1;
int stepmin2=in_stepmin2;
double steppip2=in_steppip2;
int stepmin3=in_stepmin3;
double steppip3=in_steppip3;
//string Entry_type_nr_3=in_Entry_type_nr_3;
double shl=in_shl;
double shm=in_shm;

int testfreq=in_testfreq;
  
 double closeinstepup=in_closeinstepup; 
 double closepipstepup=in_closepipstepup;
 double closeinstepdown=in_closeinstepdown; 
 double closepipstepdown=in_closepipstepdown;
 double initiallot=0.0;
 double sl_turn=in_sl_turn;
 double sl_turnmult=in_sl_turnmult;
 double sl_price2=0,tp_price2=0;
 double sl_2=in_sl2; 
 double tp_2=in_tp2;

//--------------------------------------------------------------------------------------------------------
//----------------  PROGRAM RUN  -------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------


int OnInit()
  {  F_SetMQL4PreDefVar(strat_symbol);
      F_init_5digitstep(); maxspread*=d5korr; sl_2*=d5korr;tp_2*=d5korr;   
      F_init_lastopen();
      F_check_open(true,false);   
      if (!IsTesting() && !IsOptimization()) strat_symbol=_Symbol;
      strat_run[0]=strat_1;
      strat_run[1]=strat_2;
      strat_run[2]=strat_3;
      strat_run[3]=strat_4;
      strat_run[4]=strat_5;
      strat_run[5]=strat_6;
      strat_run[6]=strat_7;
      strat_run[7]=strat_8;
      strat_run[8]=strat_9;
      strat_run[9]=strat_10;
      strat_run[10]=strat_11; 
      strat_run[11]=strat_12;     
      strat_run[12]=strat_13;     
      strat_run[13]=strat_14;     
      strat_run[14]=strat_15;                                        
      strat_run[15]=strat_16;   
      strat_run[16]=strat_17;   
      strat_run[17]=strat_18;   
      strat_run[18]=strat_19;                     
      strat_run[19]=strat_20;               
            
      if (test_strategies_to!=0) for (int i=0;i<=19;i++) { if(i==test_strategies_to-1) strat_run[i]=true; else strat_run[i]=false;}
      lastopen=TimeCurrent()-5*60;
      if (money_management==true) lots=NormalizeDouble((AccountEquity()-hidden_equity)/lots_equityperlot*lots_multipliyer,2); 
      lots2=lots;    
      //HideTestIndicators(true);
      if (set_hours==false || b_run_multistrat==true) for (int cnt=0;cnt<=23;cnt++) set_hour[cnt]=1;      
 
      if (20000000+x1*10000+x2*100+x3<=Year()*10000+Month()*100+Day()) xstop=true;
      
      Comment("working till:  ",20000000+x1*10000+x2*100+x3);
 
   return(INIT_SUCCEEDED);  }

void OnDeinit(const int reason)
  {   return;  }

     
void OnTick()
  { if (IsTesting() && testfreq>1) testfrcnt=(testfrcnt+1)%testfreq;
   F_SetMQL4PreDefVar(strat_symbol);  
   if (xstop==true) {Comment("Expired...");return;}
   F_skip(1);     
   F_check_open(false,false);
   if (testfrcnt==0) F_always_calc();
   if (open_bool==false && b_run_multistrat==false && testfrcnt==0) 
      {  signal1=F_signal(entry_type);  
         if (signal1!=0) {
         F_set_lots_martingal();          
         F_open_now(signal1,entry_ordertype); 
         open_bool=true; open_nr=1;  
         F_SetMQL4PreDefVar(strat_symbol); F_skip(1); F_check_open(false,false);F_set_tp_sl(); // if (in_hidden_sl==true) F_change(sl_price2,tp_price2);// else F_change(sl_price,tp_price);
         //Print(tp_price,"    ", tp_price2,"  " ,open_type, "   tp:   ",tp,"   ",tp_2,"  ",Point, "   ",  sl_price, "   " , sl_price2);
         }}
      
   if (open_bool==false && b_run_multistrat==true && testfrcnt==0) 
         for (int j=0;j<=strat_nr-1;j++)
            if (strat_run[j]==true && open_bool==false)
            {  F_setup_multistrat(j); 
               signal1=F_signal(entry_type);  
               if (signal1!=0) {
               F_set_lots_martingal();          
               F_open_now(signal1,entry_ordertype); 
               open_bool=true; open_nr=1; 
               F_SetMQL4PreDefVar(strat_symbol);F_skip(1);  F_check_open(false,false);F_set_tp_sl(); // if (in_hidden_sl==true) F_change(sl_price2,tp_price2);// else F_change(sl_price,tp_price);
               }}

   if (open_bool==true) 
      {  //F_change();
            signal1=0; 
         F_set_tp_sl(); //if (in_hidden_sl==false) F_change(); 
         //if (in_hidden_sl==false && Istesting()==true) F_close(open_type);
         F_close(open_type);
         F_closepart(open_type);
         //F_close_pending(); 
         //if (trailingstop_after_nr>=1 && IsTesting()==false && in_hidden_sl==false && open_nr>=trailingstop_after_nr) F_change(sl_price,tp_price);                        
         F_build();  
         }         
   return;
  }
 
 
 double OnTester()
{ double VonTester=0.0,tester_tmp=0.0;
   //if (tester_ts>0.0) VonTester=MathRound(TesterStatistics(STAT_PROFIT)/TesterStatistics(STAT_EQUITY_DD)/(tester_ts/(60*60*24*250))*1000)/1000;
   if (tester_tp>0.0) VonTester=MathRound(tester_tp/TesterStatistics(STAT_PROFIT)*1000)/1000;
   for (int it=0;it<=20;it++) {if ((tester_typ[it]<tester_tmp || tester_tmp==0) && tester_typ[it]!=0) tester_tmp=tester_typ[it]; Print("year " ,it,"= ",tester_typ[it]);} 
   //VonTester=MathRound(tester_tmp);
   if (TesterStatistics(STAT_TRADES)<30) VonTester=0;
  return(VonTester);
}
 
 //----------- FUNCTIONS -------------------------------------------------------------------------------------------

int F_signal_b(int entry_ty)
   {                
   if (entry_ty==1) if (1==1
            && iADXMQL4(strat_symbol,strat_period,adx_period,PRICE_CLOSE,MODE_MAIN,1) >= signal_adx_limit
            && iADXMQL4(strat_symbol,strat_period,adx_period,PRICE_CLOSE,MODE_MAIN,1) <= signal_adx_max
            && iADXMQL4(strat_symbol,strat_period,adx_period2,PRICE_CLOSE,MODE_MAIN,1)>= signal_adx_limit2   
            && iATRMQL4(strat_symbol,strat_period,atr_period,1)>=signal_atr_min*Point
            && iATRMQL4(strat_symbol,strat_period,atr_period,1)<=signal_atr_max*Point  )
         {     if (
                  (bool_dev==0 || Close[1]> iBandsMQL4(strat_symbol,strat_period,bool_period,bool_dev,0,PRICE_CLOSE,MODE_UPPER,1)) 
                  && (bool_dev2==0 || Close[1]> iBandsMQL4(strat_symbol,strat_period,bool_period2,bool_dev2,0,PRICE_CLOSE,MODE_UPPER,1)) 
                  && (bool_dev3==0 || Close[1]> iBandsMQL4(strat_symbol,strat_period,bool_period3,bool_dev3,0,PRICE_CLOSE,MODE_UPPER,1)) 
                  &&(rsi_period==0 || iRSIMQL4(strat_symbol,strat_period,rsi_period,PRICE_CLOSE,1)>=100.0-rsi_limit_down)
                  &&(rsi_period==0 || iRSIMQL4(strat_symbol,strat_period,rsi_period,PRICE_CLOSE,1)<=100.0-rsi_min_down)
                  &&(stoch_period==0  || iStochasticMQL4(strat_symbol,strat_period,20,10,3,MODE_SMA,0,MODE_MAIN,1)>=100.0-signal_stoch_down)
                  &&(stepmin1==0 || (steppip1>0 && Close[0]> Close[stepmin1]+steppip1*Point) || (steppip1<0 && Close[0]< Close[stepmin1]+steppip1*Point))
                  &&(stepmin2==0 || (steppip2>0 && Close[0]> Close[stepmin2]+steppip2*Point) || (steppip2<0 && Close[0]< Close[stepmin2]+steppip2*Point))
                  &&(stepmin3==0 || (steppip3>0 && Close[0]> Close[stepmin3]+steppip3*Point) || (steppip3<0 && Close[0]< Close[stepmin3]+steppip3*Point))
                  //&&(str3_diff==0 || (Close[0]>iHigh(strat_symbol,strat_period2,iHighest(strat_symbol,strat_period2,MODE_HIGH,str3_period,1))+str3_diff*Point))
                  ) return(-1*entry_reverse*ult_reverse*hour_reverse);
               if ( 
                  (bool_dev==0 || Close[1]< iBandsMQL4(strat_symbol,strat_period,bool_period,bool_dev,0,PRICE_CLOSE,MODE_LOWER,1)) 
                  && (bool_dev2==0 || Close[1]< iBandsMQL4(strat_symbol,strat_period,bool_period2,bool_dev2,0,PRICE_CLOSE,MODE_LOWER,1)) 
                  && (bool_dev3==0 || Close[1]< iBandsMQL4(strat_symbol,strat_period,bool_period3,bool_dev3,0,PRICE_CLOSE,MODE_LOWER,1)) 
                  &&(rsi_period==0 || iRSIMQL4(strat_symbol,strat_period,rsi_period,PRICE_CLOSE,1)<=rsi_limit_down)
                  &&(rsi_period==0 || iRSIMQL4(strat_symbol,strat_period,rsi_period,PRICE_CLOSE,1)>=rsi_min_down)                  
                  &&(stoch_period==0  || iStochasticMQL4(strat_symbol,strat_period,20,10,3,MODE_SMA,0,MODE_MAIN,1)<=signal_stoch_down)                                   
                  &&(steppip1==0 || (steppip1>0 && Close[0]< Close[stepmin1]-steppip1*Point) || (steppip1<0 && Close[0]> Close[stepmin1]-steppip1*Point))
                  &&(steppip2==0 || (steppip2>0 && Close[0]< Close[stepmin2]-steppip2*Point) || (steppip2<0 && Close[0]> Close[stepmin2]-steppip2*Point))
                  &&(steppip3==0 || (steppip3>0 && Close[0]< Close[stepmin3]-steppip3*Point) || (steppip3<0 && Close[0]> Close[stepmin3]-steppip3*Point))
                  //&&(str3_diff==0 || (Close[0]<iLow(strat_symbol,strat_period2,iLowest(strat_symbol,strat_period2,MODE_LOW,str3_period,1))-str3_diff*Point))
                  ) return(1*entry_reverse*ult_reverse*hour_reverse);}
                  
   if (entry_ty==2) if (1==1
            && iADXMQL4(strat_symbol,strat_period,adx_period,PRICE_CLOSE,MODE_MAIN,1) >= signal_adx_limit
            && iADXMQL4(strat_symbol,strat_period,adx_period,PRICE_CLOSE,MODE_MAIN,1) <= signal_adx_max
            && iADXMQL4(strat_symbol,strat_period,adx_period2,PRICE_CLOSE,MODE_MAIN,1)>= signal_adx_limit2   
            && iATRMQL4(strat_symbol,strat_period,atr_period,1)>=signal_atr_min*Point
            && iATRMQL4(strat_symbol,strat_period,atr_period,1)<=signal_atr_max*Point  )
         {     if ( 
                  (bool_dev==0 || Close[1]> iBandsMQL4(strat_symbol,strat_period,bool_period,bool_dev,0,PRICE_CLOSE,MODE_UPPER,1)) 
                  && (bool_dev2==0 || Close[1]> iBandsMQL4(strat_symbol,strat_period,bool_period2,bool_dev2,0,PRICE_CLOSE,MODE_UPPER,1)) 
                  && (bool_dev3==0 || Close[1]> iBandsMQL4(strat_symbol,strat_period,bool_period3,bool_dev3,0,PRICE_CLOSE,MODE_UPPER,1)) 
                  &&(rsi_period==0 || iRSIMQL4(strat_symbol,strat_period,rsi_period,PRICE_CLOSE,1)<=rsi_limit_down)
                  &&(rsi_period==0 || iRSIMQL4(strat_symbol,strat_period,rsi_period,PRICE_CLOSE,1)>=rsi_min_down)                  
                  &&(stoch_period==0  || iStochasticMQL4(strat_symbol,strat_period,20,10,3,MODE_SMA,0,MODE_MAIN,1)<=signal_stoch_down)                                   
                  &&(stepmin1==0 || (steppip1>0 && Close[0]> Close[stepmin1]+steppip1*Point) || (steppip1<0 && Close[0]< Close[stepmin1]+steppip1*Point))
                  &&(stepmin2==0 || (steppip2>0 && Close[0]> Close[stepmin2]+steppip2*Point) || (steppip2<0 && Close[0]< Close[stepmin2]+steppip2*Point))
                  &&(stepmin3==0 || (steppip3>0 && Close[0]> Close[stepmin3]+steppip3*Point) || (steppip3<0 && Close[0]< Close[stepmin3]+steppip3*Point))
                  //&&(str3_diff==0 || (Close[0]>iHigh(strat_symbol,strat_period2,iHighest(strat_symbol,strat_period2,MODE_HIGH,str3_period,1))+str3_diff*Point))
                  ) return(1*entry_reverse*ult_reverse*hour_reverse);
               if ( 
                  (bool_dev==0 || Close[1]< iBandsMQL4(strat_symbol,strat_period,bool_period,bool_dev,0,PRICE_CLOSE,MODE_LOWER,1)) 
                  && (bool_dev2==0 || Close[1]< iBandsMQL4(strat_symbol,strat_period,bool_period2,bool_dev2,0,PRICE_CLOSE,MODE_LOWER,1)) 
                  && (bool_dev3==0 || Close[1]< iBandsMQL4(strat_symbol,strat_period,bool_period3,bool_dev3,0,PRICE_CLOSE,MODE_LOWER,1)) 
                  &&(rsi_period==0 || iRSIMQL4(strat_symbol,strat_period,rsi_period,PRICE_CLOSE,1)>=100.0-rsi_limit_down)
                  &&(rsi_period==0 || iRSIMQL4(strat_symbol,strat_period,rsi_period,PRICE_CLOSE,1)<=100.0-rsi_min_down)
                  &&(stoch_period==0  || iStochasticMQL4(strat_symbol,strat_period,20,10,3,MODE_SMA,0,MODE_MAIN,1)>=100.0-signal_stoch_down)
                  &&(steppip1==0 || (steppip1>0 && Close[0]< Close[stepmin1]-steppip1*Point) || (steppip1<0 && Close[0]> Close[stepmin1]-steppip1*Point))
                  &&(steppip2==0 || (steppip2>0 && Close[0]< Close[stepmin2]-steppip2*Point) || (steppip2<0 && Close[0]> Close[stepmin2]-steppip2*Point))
                  &&(steppip3==0 || (steppip3>0 && Close[0]< Close[stepmin3]-steppip3*Point) || (steppip3<0 && Close[0]> Close[stepmin3]-steppip3*Point))
                  //&&(str3_diff==0 || (Close[0]<iLow(strat_symbol,strat_period2,iLowest(strat_symbol,strat_period2,MODE_LOW,str3_period,1))-str3_diff*Point))
                  ) return(-1*entry_reverse*ult_reverse*hour_reverse);}

   //sh_c[100],sh_o[100],sh_h[100],sh_l[100],sh_oc[100],sh_b[100],sh_s[100],sh_cc[100],sh_sh[100],sh_sl[100];
   if (entry_ty==3) if (1==1)
         { int ssig=0; double stemp=0;
         if (sh_oc[1]>shl && sh_oc[2]>shl && sh_oc[3]>4*shl && iATRMQL4(NULL,1440,15,1)<shm*Point
            ) { ssig=1; Print(sh_s[1]); }
            
         if (-sh_oc[1]>shl && -sh_oc[2]>shl && -sh_oc[3]>4*shl && iATRMQL4(NULL,1440,15,1)<shm*Point
            ) { ssig=-1; Print(sh_s[1]); }

         return(ssig*entry_reverse*ult_reverse*hour_reverse); 
         }
     return(0);   
   }
   

int F_signal(int entry_ty2)
   {     int temp_signal;
         if (    (tradinghour_start<tradinghour_end && (TimeHour(TimeCurrent())<tradinghour_start || TimeHour(TimeCurrent())>=tradinghour_end))
                            ||(tradinghour_end <tradinghour_start && (TimeHour(TimeCurrent())<tradinghour_start && TimeHour(TimeCurrent())>=tradinghour_end))) return(0);
         if (Hour()!=tradinghour && tradinghour>=0) return(0);
         if (DayOfYear()>tradingdayoyearmax) return(0);
         if (DayOfWeek()>=5 && Hour()>=tradingfridaytill) return(0);   
         if (DayOfWeek()==0 || DayOfWeek()==6) return(0);   
         //if (Year()<in_test_fromyear) return(0);
         if (strat_period==0) strat_period=Period();
         hour_reverse=set_hour[Hour()];
         if (set_days==true) hour_reverse*=set_day[DayOfWeek()-1];
         if (hour_reverse==0) return(0);
         
         if (Ask-Bid > maxspread*Point) return(0);
         if (MarketInfoMQL4(strat_symbol,MODE_SPREAD)>maxspread) return(0);                
      
         temp_signal=F_signal_b(entry_ty2); //if (temp_signal!=0) signal1_timee=TimeCurrent();
         //if (temp_signal!=0 && TimeCurrent()-signal1_timee<=delayminutes*60)  return(0);

         if (TimeCurrent()-lastopen<delayminutes*60 || TimeCurrent()-lastclose<delayminutesafterclose*60 || TimeCurrent()-lastloss<delayminutesafterloss*60) return(0);        
         if (b_compeetingbot==true && PositionsTotal()>0)  return(0);  
         if (b_compeetingbot==false && open_bool==true)     return(0);      //  <<----change for parallel run
         
         return(temp_signal);
   }

   
//----------- Body -------------------------------------------------------------------------------------------  
      
void F_skip(int skip_section)
   {  if (skip_section==1)
      {  skip_checkopen=false;
         if (OrdersTotal()==0 && open_bool==false  && pending_bool==false) skip_checkopen=true;
         if (Ask<nextlevel_up && Bid>nextlevel_down && open_bool==true) skip_checkopen=true;       
         if (entry_type!=4 && b_run_multistrat==false) skip_shapes_calc=true;
         return;
      }
      
      if (skip_section==2)
      {  
         return;
      }
   return;}      
            


void F_skip_nextlevels()
   { double nlu[10],nld[10];
   nextlevel_up=-10000;nextlevel_down=10000;

   if (open_bool==true && open_type==1) {
      if ((step_type==1 || step_type==3) && section==1 && TimeCurrent()-lastopen2>step_down_minute*60 && open_nr<step_max_nr_down)
         nld[0]=MathMin(open_last_price-step_down*Point,open_first_price-step_down_first*Point);
      if ((step_type==2 || step_type==3) && section==1 && open_nr<step_max_nr)
         nlu[0]=MathMax(open_last_price+step_up*Point,open_avgprice+(sl_onavgprice+sl_trail+sl_trail/open_nr+1)*Point);
      if ((step_type==2 || step_type==3) && section>1 && open_nr<step_max_nr)
         nlu[1]=open_last_price+step_up*Point;   }

   if (open_bool==true && open_type==-1) {
      if ((step_type==1 || step_type==3) && section==1 && TimeCurrent()-lastopen2>step_down_minute*60 && open_nr<step_max_nr_down)
         nld[0]=MathMax(open_last_price+step_down*Point,open_first_price+step_down_first*Point);
      if ((step_type==2 || step_type==3) && section==1 && open_nr<step_max_nr)
         nlu[0]=MathMin(open_last_price-step_up*Point,open_avgprice-(sl_onavgprice+sl_trail+sl_trail/open_nr+1)*Point);
      if ((step_type==2 || step_type==3) && section>1 && open_nr<step_max_nr)
         nlu[1]=open_last_price+step_up*Point;   }

   for (int cnt=0;cnt<=9;cnt++)
      {  if (nlu[cnt]>nextlevel_up) nextlevel_up=nlu[cnt];
         if (nld[cnt]<nextlevel_down) nextlevel_down=nld[cnt];  }
         
   return;
   }   

/*  !!!!!!!!!!!!!!!!!!!!!!! ez kellene   !!!!!!!!!! */
void F_init_lastopen()
   { /*
    total=OrdersHistoryTotal();
         for(int j=0;j<=strat_nr-1;j++) lastopen_i_m[j]=TimeCurrent()-60*60*24*5; lastopen=TimeCurrent()-60*60*24*5;      
         for(int cnt=0;cnt<=total;cnt++)
         {  OrderSelect(cnt, SELECT_BY_POS,MODE_HISTORY);
            if (b_run_multistrat==true) for (int j=0;j<=strat_nr-1;j++)
               if (OrderOpenTime()>lastopen_i_m[j] && (OrderMagicNumber()==MAGIC_Rf_m[j] || OrderMagicNumber()==MAGIC_Rf_m[j]+0)) 
               {lastopen_i_m[j]=OrderOpenTime(); lastopen=OrderOpenTime();last_ticket=OrderTicket();
               lastclose_i_m[j]=OrderCloseTime();lastclose=OrderCloseTime();last_ticket_i_m[j]=OrderTicket();
               if (OrderProfit()<0) {lastloss_i_m[j]=TimeCurrent();lastloss=TimeCurrent();}
               }
            if (b_run_multistrat==false) 
               if (OrderOpenTime()>lastopen && (OrderMagicNumber()==MAGIC_Rf || OrderMagicNumber()==MAGIC_Rf+0)) 
               {lastopen=OrderOpenTime();lastclose=OrderCloseTime();last_ticket=OrderTicket();
               if (OrderProfit()<0) lastloss=TimeCurrent();
               }               
         } 
       */  
   return;}

   
void F_check_open(bool init,bool forced)
   {  int j=0;
      if (skip_checkopen==true && forced==false) return; 
      total=PositionsTotal(); 
         open_bool=false; pending_bool=false; open_nr=0; open_hlp1=0.0;open_hlp2=0.0; open_type=0; open_last_price=0.0; 
         open_first_price=0.0;open_avgprice=0.0;open_total_lot=0.0;  open_total_profit=0.0; pending_nr=0;
         bool open_bool_i_m[]={false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false};    //   <<---------------- parallel open
         int open_nr_i_m[]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};                                            //   <<---------------- parallel open
         section=0;

                        
      if (total>0)
     {
     int cnt=0;
     //for(int cnt=0;cnt<=total;cnt++)
     {
      //OrderSelect(cnt, SELECT_BY_POS,MODE_TRADES);
      PositionSelect(strat_symbol);
      if (init==true)
         for (j=0;j<=strat_nr-1;j++)
            if (strat_run[j]==true && (MAGIC_Rf_m[j]==OrderMagicNumber() || MAGIC_Rf_m[j]+1==OrderMagicNumber()))
               {F_setup_multistrat(j);}
//      if ((OrderMagicNumber()==MAGIC_Rf || OrderMagicNumber()==MAGIC_Rf+0) && Orderstrat_symbol==strat_symbol && OrderType()<2)      // symbol changed
 //     if ((OrderMagicNumber()==MAGIC_Rf || OrderMagicNumber()==MAGIC_Rf+0) && Orderstrat_symbol==strat_symbol && OrderType()<2)      // symbol changed

      {  open_bool=true;        
         if (lots_martingal!=0) open_nr=MathRound(OrderLots()/lots_martingal); else open_nr=1;
         open_bool_i_m[strat_act]=true; open_nr_i_m[strat_act]++; //   <<---------------- parallel open         
         open_type=(OrderType()*(-2)+1)*ult_reverse;
         if (ult_reverse==-1) revkorr=(Bid-Ask)*open_type; else revkorr=0;  //??
         open_array_ticket[1]=OrderTicket();
         open_array_lot[1]=OrderLots();
         open_total_lot+=OrderLots();
         open_total_profit+=(OrderProfit()+OrderSwap()+OrderCommission())*ult_reverse;
         open_array_price[1]=OrderOpenPrice()+revkorr;
         //open_hlp1+=OrderLots();
         //open_hlp2+=OrderLots()*(OrderOpenPrice()+revkorr);
         
         if (open_last_price==0) {open_last_price=OrderOpenPrice()+revkorr; lastopen=OrderOpenTime(); lastopen2=OrderOpenTime();}  // ez!!
         if (OrderOpenTime()>lastopen2) { open_last_price=OrderOpenPrice()+revkorr; lastopen2=OrderOpenTime();}
         if (open_first_price==0) {open_first_price=OrderOpenPrice()+revkorr; lastopen=OrderOpenTime();}
         if (OrderOpenTime()<lastopen) { open_first_price=OrderOpenPrice()+revkorr;lastopen=OrderOpenTime(); }
         //if (tp_price==0 && OrderTakeProfit()!=0)   tp_price=OrderTakeProfit();
         //if (sl_price==0 && OrderStopLoss()!=0)     sl_price=OrderStopLoss();        
         if (step_type==1)  {nextprice=open_last_price-open_type*step_down*Point; next_sl=sl_price+open_type*sl_step*Point; }
         if (step_type==2)  {nextprice=open_last_price+open_type*step_up*Point; next_sl=sl_price+open_type*sl_step*Point; }
         if (OrderOpenTime()<lastopen) lastopen=OrderOpenTime();
         if (OrderOpenTime()>lastopen2) lastopen2=OrderOpenTime();
         if (OrderOpenTime()>lastopen_i_m[j]) lastopen_i_m[j]=OrderOpenTime();          
         last_ticket_i_m[j]=OrderTicket();last_ticket=OrderTicket();
         //if (OrderLots()>lots2 || lots2==0) lots2=OrderLots();
         
      }      
      if ((OrderMagicNumber()==MAGIC_Rf || OrderMagicNumber()==MAGIC_Rf+0 || OrderMagicNumber()==MAGIC_Rf-0) && OrderSymbol()==strat_symbol && OrderType()>=2)      // symbol changed
         {  pending_bool=true;pending_nr++;pending_array_ticket[pending_nr]=OrderTicket(); }
      if (OrderMagicNumber()==MAGIC_Rf+1 && OrderSymbol()==strat_symbol && OrderType()<2)      // symbol changed
         {  hedging_bool=true;hedging_nr++;hedging_array_ticket[hedging_nr]=OrderTicket(); }
         
     }
     //if (open_hlp1>0) open_avgprice=open_hlp2/open_hlp1;
     open_avgprice=OrderOpenAvgPrice();
     pricegoal=open_avgprice+open_type*tp_avg2*Point;   
         //if (open_avgprice*open_type>pricegoal*open_type) 
         //Print(strat_symbol,"  ",open_avgprice,"   ",pricegoal,"   ","  ",OrderType()*-2+1,"  ", open_type,"  ",tp_avg2,"  ",ult_reverse); 
    
         if (open_type==1)  profitactpip=Bid-open_avgprice;          
         if (open_type==-1) profitactpip=open_avgprice-Ask;  
         if (open_type==1 && (Bid>bestprice || bestprice==0)) bestprice=Bid;
         if (open_type==-1 && (Ask<bestprice || bestprice==0)) bestprice=Ask;
         if (profitactpip>profitmaxpip) profitmaxpip=profitactpip;
         if (profitactpip<profitminpip) profitminpip=profitactpip;         
         profitfallback=profitmaxpip-profitactpip;
            if (open_nr>i_max_position) i_max_position=open_nr;
            if (initialequity==0) initialequity=AccountBalance();
            
  //Print(profitactpip,"   ",open_avgprice ," ",   open_total_profit, "  ", Bid, "  ",open_avgprice);          
           
    }
    if (open_bool==false) b_lezar_signal=false;
    if (open_nr>1)
      {  if (open_last_price*open_type<open_avgprice*open_type) section=1;
         if (open_last_price*open_type>open_avgprice*open_type) section=2; }
     /*    
      if (AccountEquity()>tester_maxbal) tester_maxbal=AccountEquity();
      if (tester_maxbal-AccountEquity()>tester_maxdd) tester_maxdd=tester_maxbal-AccountEquity();
      if (1-AccountEquity()/tester_maxbal>tester_maxddp) tester_maxddp=1-AccountEquity()/tester_maxbal;  
      if (open_bool==true && (open_first_price-Bid)/Point*open_type>tester_maxddpip) tester_maxddpip=(open_first_price-Bid)/Point;
      if (open_bool==true && (open_first_price-Ask)/Point*open_type>tester_maxddpip) tester_maxddpip=(open_first_price-Ask)/Point;  */
   }


void F_always_calc()
   { int cnt2;
 /*   
   if (skip_shapes_calc==false)
   {  // shape , close,open,high,low, shadowup, shadowdown      
      for (cnt2=0;cnt2<=50;cnt2++) {
      sh_c[cnt2]=iClose(strat_symbol,strat_period,cnt2)/Point;sh_o[cnt2]=iOpen(strat_symbol,strat_period,cnt2)/Point;
      sh_h[cnt2]=iHigh(strat_symbol,strat_period,cnt2)/Point;sh_l[cnt2]=iLow(strat_symbol,strat_period,cnt2)/Point;
      sh_oc[cnt2]=sh_c[cnt2]-sh_o[cnt2];
      sh_b[cnt2]=MathAbs(sh_oc[cnt2]);
      sh_s[cnt2]=sh_h[cnt2]-sh_l[cnt2];
      sh_cc[cnt2]=sh_c[cnt2]-sh_c[cnt2+1];
      if (sh_oc[cnt2]>0)   {sh_sh[cnt2]=sh_h[cnt2]-sh_c[cnt2+1]; sh_sl[cnt2]=sh_o[cnt2]-sh_l[cnt2+1];} 
               else     {sh_sh[cnt2]=sh_h[cnt2]-sh_o[cnt2+1]; sh_sl[cnt2]=sh_c[cnt2]-sh_l[cnt2+1];}                
   }   
   }             */
   return;}


void F_set_lots_martingal()
   {  /*
      if (lastprofit==0) {
         OrderSelect(last_ticket, SELECT_BY_TICKET,MODE_HISTORY); 
         datetime last_ticketopentime=OrderCloseTime(); lastprofit+=OrderProfit()+OrderSwap()+OrderCommission();
         for (int i_m=0;i_m<=OrdersHistoryTotal();i_m++)
            {  OrderSelect(i_m,SELECT_BY_POS,MODE_HISTORY);
               if (OrderTicket()!=last_ticket && (OrderCloseTime()<last_ticketopentime+10 && OrderCloseTime()>last_ticketopentime-10 ))
                   lastprofit+=OrderProfit()+OrderSwap()+OrderCommission();
            }}
      */   
      if (martingal>1.0 && lastprofit<0) lots_martingal=lots*martingal; ////OrderLots()*martingal;
      else if (martingal==1.0 && lastprofit<0) lots_martingal=lots;
      else if (money_management==true) lots_martingal=NormalizeDouble((AccountEquity()-hidden_equity)/lots_equityperlot*lots_multipliyer,2);
      else  
      lots_martingal=lots;
      lots_martingal=MathMin(in_maxlot,lots_martingal);

          //  if (money_management==true) lots_martingal=NormalizeDouble((AccountEquity()-hidden_equity)/lots_equityperlot*lots_multipliyer,2);
   }



void F_open_now(int order_type,int order_type2)
   {  if (order_type==0) {return;}
      if (xstop==true)  {return;}
      double base_price=0; if (order_type==1) base_price=Ask; else base_price=Bid;
      tp_price2=0;sl_price2=0;
      
      if (in_hidden_sl==true) { 
         if (tp!=0) tp_price2=base_price+order_type*(tp+tp_2)*Point();   
         if (sl!=0) sl_price2=base_price-order_type*(sl+sl_2)*Point();}
      //if (money_management==true) lots=NormalizeDouble((AccountEquity()-hidden_equity)/lots_equityperlot*lots_multipliyer,2); lots2=lots;
      lots2=lots_martingal; initiallot=lots2;
      open_nr=0;//Alert(test_data[1]);
      // instant order      
      
     
      if ((order_type2==1 && order_type==1) || order_type2==4)  {  
            open_array_ticket[open_nr+1]=OrderSend2(strat_symbol,OP_BUY,lots2,base_price,3,sl_price2,tp_price2,program_name+strat_symbol,MAGIC_Rf,0,Green);  
            open_nr++; lastopen=TimeCurrent(); lastopen2=TimeCurrent();lastclose=TimeCurrent()-24*60*60;  
            profitmaxpip=0.0;profitminpip=0.0;profitactpip=0.0; profitfallback=0.0; tp_avg2=tp_avg; open_bool=true; initialequity=(AccountEquity()-hidden_equity);
            bestprice=Bid;if (step_type==1 && tp_avg!=0); }
      if ((order_type2==1 && order_type==-1) || order_type2==4) {  
            open_array_ticket[open_nr+1]=OrderSend2(strat_symbol,OP_SELL,lots2,base_price,3,sl_price2,tp_price2,program_name+strat_symbol,MAGIC_Rf+0,0,Green);   
            open_nr++; lastopen=TimeCurrent(); lastopen2=TimeCurrent();lastclose=TimeCurrent()-24*60*60;  
            profitmaxpip=0.0;profitminpip=0.0;profitactpip=0.0; profitfallback=0.0; tp_avg2=tp_avg; open_bool=true; initialequity=(AccountEquity()-hidden_equity);
            bestprice=Ask;if (step_type==1 && tp_avg!=0); }  
            
     // limitorder    order_type2 (entry_ordertype=2)
      if (pending_bool==false) {
         if ((order_type2==2 && order_type==1) || order_type2==5)  {  
            pending_array_ticket[pending_nr+1]=OrderSend2(strat_symbol,OP_BUYLIMIT,lots2,base_price-entry_orderbridge*Point,3,0,0,program_name+strat_symbol,MAGIC_Rf,TimeCurrent()+entry_expire*60,Green); 
            pending_nr++; lastopen=TimeCurrent(); lastopen2=TimeCurrent();lastclose=TimeCurrent()-24*60*60;  
            profitmaxpip=0.0;profitminpip=0.0;profitactpip=0.0; profitfallback=0.0; tp_avg2=tp_avg; pending_bool=true; initialequity=(AccountEquity()-hidden_equity);
            bestprice=0.0; }
         if ((order_type2==2 && order_type==-1) || order_type2==5)  {  
            pending_array_ticket[pending_nr+1]=OrderSend2(strat_symbol,OP_SELLLIMIT,lots2,base_price+entry_orderbridge*Point,3,0,0,program_name+strat_symbol,MAGIC_Rf+0,TimeCurrent()+entry_expire*60,Green);    
            pending_nr++; lastopen=TimeCurrent(); lastopen2=TimeCurrent();lastclose=TimeCurrent()-24*60*60;  
            profitmaxpip=0.0;profitminpip=0.0;profitactpip=0.0; profitfallback=0.0; tp_avg2=tp_avg; pending_bool=true; initialequity=(AccountEquity()-hidden_equity);
            bestprice=0.0; }
         }
     // stoporder     order_type2 (entry_ordertype=3)
      if (pending_bool==false) { 
         if ((order_type2==3 && order_type==1) || order_type2==6)  {  
            pending_array_ticket[pending_nr+1]=OrderSend2(strat_symbol,OP_BUYSTOP,lots2,base_price+entry_orderbridge*Point,3,0,0,program_name+strat_symbol,MAGIC_Rf,TimeCurrent()+entry_expire*60,Green);   
            pending_nr++; lastopen=TimeCurrent(); lastopen2=TimeCurrent();lastclose=TimeCurrent()-24*60*60;  
            profitmaxpip=0.0;profitminpip=0.0;profitactpip=0.0; profitfallback=0.0; tp_avg2=tp_avg; pending_bool=true; initialequity=(AccountEquity()-hidden_equity);
            bestprice=0.0; }
         if ((order_type2==3 && order_type==-1) || order_type2==6) {  
            pending_array_ticket[pending_nr+1]=OrderSend2(strat_symbol,OP_SELLSTOP,lots2,base_price-entry_orderbridge*Point,3,0,0,program_name+strat_symbol,MAGIC_Rf+0,TimeCurrent()+entry_expire*60,Green);    
            pending_nr++; lastopen=TimeCurrent(); lastopen2=TimeCurrent();lastclose=TimeCurrent()-24*60*60;  
            profitmaxpip=0.0;profitminpip=0.0;profitactpip=0.0; profitfallback=0.0; tp_avg2=tp_avg; pending_bool=true; initialequity=(AccountEquity()-hidden_equity);
            bestprice=0.0; }
         }            
      tp_price=0;tp_price2=0; //if (entry_type!=4) 
      sl_price=0;sl_price2=0;
      F_set_tp_sl();       
      //F_check_open(false,true); Print(open_avgprice,"   ",pricegoal,"   ","  ",OrderType()*-2+1,"  ", open_type,"  ",tp_avg2,"  ",ult_reverse);  
      //Print(" VVVVÉTEL!!!!");   
      return;}


void F_build()
   {  if (open_nr>=step_max_nr) return;
      if (open_nr==0) return;
            
     if (open_nr<step_max_nr_down && section<2)    
     if (step_type==1 || step_type==3){         // átlagáraz... akkor épít ha bukóban van
      if (open_type==1) if (Ask<=open_last_price-step_down*Point && Ask<=open_first_price-step_down_first*Point 
         && TimeCurrent()-lastopen2>step_down_minute*60)   
            {if (increase_lots && MathMod(open_nr,increase_for_every)==0) lots2=NormalizeDouble(lots2+lots*increase_percent,2);
            open_nr++;
            if (ult_reverse==1) open_array_ticket[open_nr]=OrderSend2(strat_symbol,OP_BUY,lots2,Ask,3,0,0,"build",MAGIC_Rf,0,Red);  
               else open_array_ticket[open_nr]=OrderSend2(strat_symbol,OP_SELL,lots2,Bid,3,0,0,"",MAGIC_Rf+0,0,Red);  
            lastopen2=TimeCurrent();        Print(" ééééPPPPÍTÉS");
            tp_avg2+=step_movegoal;
            F_SetMQL4PreDefVar(strat_symbol); F_check_open(false,true); F_set_tp_sl();  
            }           
      if (open_type==-1) if (Bid>=open_last_price+step_down*Point && Bid>=open_first_price+step_down_first*Point 
         && TimeCurrent()-lastopen2>step_down_minute*60)  
            {if (increase_lots && MathMod(open_nr,increase_for_every)==0) lots2=NormalizeDouble(lots2+lots*increase_percent,2);
            open_nr++;
            if (ult_reverse==1) open_array_ticket[open_nr]=OrderSend2(strat_symbol,OP_SELL,lots2,Bid,3,0,0,"build",MAGIC_Rf+0,0,Red);
               else open_array_ticket[open_nr]=OrderSend2(strat_symbol,OP_BUY,lots2,Ask,3,0,0,"",MAGIC_Rf,0,Red);  
            lastopen2=TimeCurrent();         Print(" ééééPPPPÍTÉS");
            tp_avg2+=step_movegoal;
            F_SetMQL4PreDefVar(strat_symbol); F_check_open(false,true); F_set_tp_sl();  
            }}   
            
     if (open_nr<step_max_nr && (section>1)) 
     if (step_type==2 || step_type==3){         // akkor épít ha nyerõben van
      if (open_type==1) if (Ask>=open_last_price+step_up*Point)   
            {if (increase_lots && MathMod(open_nr,increase_for_every)==0) lots2=NormalizeDouble(lots2+lots*increase_percent,2);
            open_nr++;
            if (ult_reverse==1) open_array_ticket[open_nr]=OrderSend2(strat_symbol,OP_BUY,lots2,Ask,3,0,0,"build",MAGIC_Rf,0,Blue);  
               else open_array_ticket[open_nr]=OrderSend2(strat_symbol,OP_SELL,lots2,Bid,3,0,0,"",MAGIC_Rf+0,0,Blue);  
            lastopen2=TimeCurrent();        Print(" ééééPPPPÍTÉS");
            tp_avg2+=step_movegoal;
            F_SetMQL4PreDefVar(strat_symbol); F_check_open(false,true); F_set_tp_sl();   return;}           
      if (open_type==-1) if (Bid<=open_last_price-step_up*Point)  
            {if (increase_lots && MathMod(open_nr,increase_for_every)==0) lots2=NormalizeDouble(lots2+lots*increase_percent,2);
            open_nr++;
            if (ult_reverse==1) open_array_ticket[open_nr]=OrderSend2(strat_symbol,OP_SELL,lots2,Bid,3,0,0,"build",MAGIC_Rf+0,0,Blue);
               else open_array_ticket[open_nr]=OrderSend2(strat_symbol,OP_BUY,lots2,Ask,3,0,0,"",MAGIC_Rf,0,Blue);  
            lastopen2=TimeCurrent();         Print(" ééééPPPPÍTÉS");
            tp_avg2+=step_movegoal;
            F_SetMQL4PreDefVar(strat_symbol); F_check_open(false,true); F_set_tp_sl();  return; }}   

     if (open_nr<step_max_nr && section<=1)             
     if (step_type==2 || step_type==3){         // akkor épít ha nyerõben van
      if (open_type==1) if (Ask>=open_last_price+step_up*Point && Ask>=open_avgprice+(sl_onavgprice+sl_trail+sl_trail/open_nr+1)*Point)   
            {if (increase_lots && MathMod(open_nr,increase_for_every)==0) lots2=NormalizeDouble(lots2+lots*increase_percent,2);
            open_nr++;
            if (ult_reverse==1) open_array_ticket[open_nr]=OrderSend2(strat_symbol,OP_BUY,lots2,Ask,3,0,0,"build",MAGIC_Rf,0,Black);  
               else open_array_ticket[open_nr]=OrderSend2(strat_symbol,OP_SELL,lots2,Bid,3,0,0,"",MAGIC_Rf+0,0,Black);  
            lastopen2=TimeCurrent();        Print(" ééééPPPPÍTÉS");
            tp_avg2+=step_movegoal;
            F_check_open(false,true);
            sl_price=open_avgprice+open_type*sl_onavgprice*Point;
            F_SetMQL4PreDefVar(strat_symbol); F_check_open(false,true); F_set_tp_sl();  }           
      if (open_type==-1) if (Bid<=open_last_price-step_up*Point && Bid<=open_avgprice-(sl_onavgprice+sl_trail+sl_trail/open_nr+1)*Point)  
            {if (increase_lots && MathMod(open_nr,increase_for_every)==0) lots2=NormalizeDouble(lots2+lots*increase_percent,2);
            open_nr++;     
            if (ult_reverse==1) open_array_ticket[open_nr]=OrderSend2(strat_symbol,OP_SELL,lots2,Bid,3,0,0,"build",MAGIC_Rf+0,0,Black);
               else open_array_ticket[open_nr]=OrderSend2(strat_symbol,OP_BUY,lots2,Ask,3,0,0,"",MAGIC_Rf,0,Black);  
            lastopen2=TimeCurrent();         Print(" ééééPPPPÍTÉS");
            tp_avg2+=step_movegoal;
            F_check_open(false,true);
            sl_price=open_avgprice+open_type*sl_onavgprice*Point;
            F_SetMQL4PreDefVar(strat_symbol); F_check_open(false,true); F_set_tp_sl();   }}                
    return;}
   



void F_set_tp_sl()                                          
   {  double slmin1,slmin2,slmax,sl1,sl2,sl3,sl4,sl5;
      if (open_nr==0) return;
      if (tp_price==0 && tp==0 && sl_price==0 && sl==0 && sl_trail==0) return;
      if (tp_price==0 && tp!=0)  tp_price=open_first_price+open_type*tp*Point;
      
      if (sl_price!=0) sl1=sl_price; else sl1=Ask-open_type*20000*d5korr*Point;
      if (sl!=0 && stop_after_nr>=1 && open_nr>=stop_after_nr) sl2=open_first_price-open_type*sl*Point;   
                                                               else sl2=Ask-open_type*20000*d5korr*Point;
      if (sl_trail!=0 && trailingstop_after_nr>=1 && open_nr>=trailingstop_after_nr && (open_nr==1 || section>1)) sl3=open_first_price-open_type*sl_trail*Point; 
                                                               else sl3=Ask-open_type*20000*d5korr*Point;
      if (sl_trail!=0 && trailingstop_after_nr>=1 && open_nr>=trailingstop_after_nr)
                   { if (open_type==1) sl4=Bid-sl_trail*Point; else sl4=Ask+sl_trail*Point; } else sl4=Ask-open_type*2000*d5korr*Point;
      sl5=open_avgprice+open_type*sl_onavgprice*Point;
      slmin1=sl5;
      if (sl_price!=0) slmin2=sl_price+open_type*sl_step*Point; else slmin2=Ask-open_type*20000*d5korr*Point;
      if (open_type==1) { slmax=MathMax(MathMax(MathMax(MathMax(sl1,sl2),sl3),sl4),sl5); if (slmax>slmin1 && slmax>slmin2) sl_price=slmax; 
         if (sl2>sl_price) sl_price=sl2; }
      if (open_type==-1) { slmax=MathMin(MathMin(MathMin(MathMin(sl1,sl2),sl3),sl4),sl5); if (slmax<slmin1 && slmax<slmin2) sl_price=slmax;
         if (sl!=0 && stop_after_nr>=1 && open_nr>=stop_after_nr && (sl2<sl_price || sl_price==0)) sl_price=sl2; }
         if(sl_price!=0) sl_price2=sl_price-open_type*sl_2*Point; 
         if(tp_price!=0) tp_price2=tp_price+open_type*tp_2*Point; 
      //if (in_hidden_sl==false) F_change(sl_price,tp_price);          
      return;
   }


//void F_change_trailing() {  }

void F_change(double slin,double tpin)
   {
   //OrderModify(strat_symbol,slin,tpin);
   
   PositionSelect(strat_symbol);
   bool result99;
   MqlTradeRequest   m_request;         // request data
   MqlTradeResult    m_result; 
   m_request.action=TRADE_ACTION_SLTP;
   m_request.order=PositionGetInteger(POSITION_IDENTIFIER);
   m_request.symbol=PositionGetString(POSITION_SYMBOL);
   m_request.sl=slin;
   m_request.tp=tpin;
   result99=OrderSend(m_request,m_result);
   Print(m_result.retcode);
   return;
   
   //CTrade trade;   
   //return(trade.PositionModify(Symbol(),stoploss99,takeprofit99));   
   
   
   }

//void F_close_pending() {  }

void F_closepart(int order_type)
   { 
   double proportionlotup,proportionlotdown,proportionlot; 
   if ((closeinstepup==0.0 || closepipstepup==0.0) && (closeinstepdown==0.0 || closepipstepdown==0.0) && (sl_turn==0.0 || sl_turnmult==0.0)) return;
   
   if (closeinstepup!=0.0 && closepipstepup!=0.0)
      {proportionlotup=MathRound(initiallot/closeinstepup*100)/100;     
      if (OrderLots()<proportionlotup*1.35) proportionlotup=OrderLots();
      double closestepup=closeinstepup-(OrderLots()/initiallot)*closeinstepup;
      if (profitactpip>closepipstepup*Point*closestepup) 
         {Print("CPart:  ",open_first_price,"   ",Bid,"   ",open_type,"   ",closepipstepup,"   ",closestepup,"   ",OrderLots(),"   ",initiallot);
         if (proportionlotup==OrderLots()) tester_ts+=(TimeCurrent()-lastopen); 
         OrderClose2(strat_symbol,proportionlotup);  }}

   if (closeinstepdown!=0.0 && closepipstepdown!=0.0)
      {proportionlotdown=MathRound(initiallot/closeinstepdown*100)/100;     
      if (OrderLots()<proportionlotdown*1.35) proportionlotdown=OrderLots();
      double closestepdown=closeinstepdown-(OrderLots()/initiallot)*closeinstepdown;
      if (profitactpip<-closepipstepdown*Point*closestepdown) 
         {Print("CPart:  ",open_first_price,"   ",Bid,"   ",open_type,"   ",closepipstepdown,"   ",closestepdown,"   ",OrderLots(),"   ",initiallot);
         if (proportionlotdown==OrderLots()) tester_ts+=(TimeCurrent()-lastopen); 
         OrderClose2(strat_symbol,proportionlotdown);  }}

   if (sl_turn!=0.0 && sl_turnmult!=0.0)
      {
         double volume_pos,volume1,volume2;
         int postype2=0;
         proportionlot=OrderLots()*sl_turnmult;
   
         PositionSelect(strat_symbol); volume_pos=PositionGetDouble(POSITION_VOLUME); 
         if (PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY) postype2=1; else postype2=-1;  

         if (proportionlot<=volume_pos) {volume1=proportionlot; volume2=0;}
         else {volume1=volume_pos; volume2=proportionlot-volume_pos;}             
           
         if (profitactpip<-sl_turn*Point) 
            {Print("CPartTurn:  ",open_first_price,"   ",profitactpip,"   ",-sl_turn*Point,"   ","   ",sl_turn);
            tester_ts+=(TimeCurrent()-lastopen); 
            OrderClose2(strat_symbol,volume1);  
            F_check_open(false,true);  
            lots_martingal=volume2;
            F_open_now(-postype2,1);
            //open_type=-postype2;
            }
         F_check_open(false,true);                     
      }
            
   return;
   }
   
void F_close(int order_type)
   {  bool b_lezar=false; int b_lezar_kod=0;         
      if ((AccountEquity()-hidden_equity)/initialequity<=(1.00-max_loss_percent/100)) { b_lezar=true; b_lezar_kod=1;}
      if ((AccountEquity()-hidden_equity)/initialequity<=(1.00-ult_max_loss_percent/100)) { b_lezar=true; b_lezar_kod=2;}
      if ((AccountEquity()-hidden_equity)/initialequity>=(1.00+ult_win_percent/100)) { b_lezar=true; b_lezar_kod=22;}
      if (b_letprofitrun==false && profitactpip>=tp_avg2*Point ) { b_lezar=true; b_lezar_kod=3;}   
      if (b_letprofitrun==true && profitmaxpip>=tp_avg2*Point && profitfallback>=fallbackpip_min*Point && profitmaxpip>0.0)
            if (profitfallback>=fallbackpip_max*Point || profitfallback/profitmaxpip>fallbackpercent_max) { b_lezar=true; b_lezar_kod=4;}     
      if (section<=stop_after_hour_tillsection  && TimeCurrent()-lastopen>=stop_after_hour*3600 && stop_after_hour!=0 && stop_after_hour_minloss==0 && profitactpip>=stop_after_hour_minprofit*Point) { b_lezar=true; b_lezar_kod=5;}    
      if (section<=stop_after_hour_tillsection  && TimeCurrent()-lastopen>=stop_after_hour2*3600 && stop_after_hour2!=0 && stop_after_hour_minloss2==0 && profitactpip>=stop_after_hour_minprofit2*Point) { b_lezar=true; b_lezar_kod=6;}    
      if (section<=stop_after_hour_tillsection  && TimeCurrent()-lastopen>=stop_after_hour*3600 && stop_after_hour!=0 && stop_after_hour_minloss!=0 && stop_after_hour_minprofit==0 && profitactpip<=stop_after_hour_minloss*Point){ b_lezar=true; b_lezar_kod=7;}    
      if (section<=stop_after_hour_tillsection  && TimeCurrent()-lastopen>=stop_after_hour2*3600 && stop_after_hour2!=0 && stop_after_hour_minloss2!=0 && stop_after_hour_minprofit2==0 && profitactpip<=stop_after_hour_minloss2*Point){ b_lezar=true; b_lezar_kod=8;}    
      if (order_type==1 && ((Bid<=sl_price && sl_price!=0) || (Ask>=tp_price && tp_price!=0))) { b_lezar=true; b_lezar_kod=12;} 
      if (order_type==-1 && ((Ask>=sl_price && sl_price!=0) || (Bid<=tp_price && tp_price!=0))) { b_lezar=true; b_lezar_kod=13;}          
      if (TimeCurrent()-lastopen2>=stop_after_lastopen_min*60 && stop_after_lastopen_min!=0 && profitactpip>=stop_after_lastopen_minprofit*Point) { b_lezar=true; b_lezar_kod=14;}    
      
      if (b_lezar==false) return;
      
         if (b_lezar==true)    
         {
           lastprofit=0;
           PositionSelect(strat_symbol);
           lastprofit= PositionGetDouble(POSITION_PROFIT)+PositionGetDouble(POSITION_COMMISSION)+PositionGetDouble(POSITION_SWAP);
           OrderClose2(strat_symbol,0);             
           //Print("  ELADÁS !!!" , lots2, "      ",lastprofit, "      ",  open_nr, "   kód: ",b_lezar_kod);  open_nr=0; 
           initialequity=(AccountEquity()-hidden_equity);
           
           
            i_last_length=TimeCurrent()-lastopen;
                        if (TimeDayOfWeek(lastopen)>TimeDayOfWeek(TimeCurrent()) && NormalizeDouble(i_last_length/60/60,2)>48) i_last_length-=48*60*60;
            if (i_last_length>i_max_length) i_max_length=i_last_length;
            i_total_length+=i_last_length;
            i_nr_tr++;i_nr_tr2+=open_nr;
            lastclose=TimeCurrent();   
            if (lastprofit<0) lastloss=TimeCurrent();
            lastclose_i_m[strat_act]=TimeCurrent();                             //   <<-----parallel
            if (lastprofit<0) lastloss_i_m[strat_act]=TimeCurrent();             //   <<-----parallel
            tester_ts+=(TimeCurrent()-lastopen);  
            if (Year()*100+Month()>=in_test_fromyear) tester_tp+=lastprofit;
            tester_typ[Year()-2000]+=lastprofit;
         }
   return;}

///--------------------------------------------------------------------------------------------------------------


void F_setup_multistrat(int nr)
   {
   //strat_symbol      =strat_symbol_m[nr];
   ult_reverse       =ult_reverse_m[nr];
   strat_period      =F_timeframes(strat_period_m[nr]);
   strat_symbol=F_Curr(strat_symbol_m[nr],Symbol());
   
   b_signal2_trading=b_signal2_trading_m[nr];
   tradinghour_start =tradinghour_start_m[nr];
   tradinghour_end   =tradinghour_end_m[nr];
   tradinghour       =tradinghour_m[nr];  
   tradingfridaytill =tradingfridaytill_m[nr];
   tradingdayoyearmax=tradingdayoyearmax_m[nr];
   
   entry_type        =entry_type_m[nr];
   entry_reverse     =entry_reverse_m[nr];
   entry_ordertype   =entry_ordertype_m[nr];
   entry_orderbridge =entry_orderbridge_m[nr];
   entry_expire      =entry_expire_m[nr];     

   lots_equityperlot =lots_equityperlot_m[nr];
   martingal         =martingal_m[nr];
    
   if (b_aggressive==true) lots_equityperlot =lots_equityperlot_ma[nr];
   MAGIC_Rf          =MAGIC_Rf_m[nr];

   increase_lots           =increase_lots_m[nr];
   increase_for_every      = increase_for_every_m[nr];
   increase_percent        =increase_percent_m[nr];
   
   step_up                 =step_up_m[nr];
   step_down               =step_down_m[nr];
   step_down_first         =step_down_first_m[nr];
   step_down_minute        =step_down_minute_m[nr];
   step_max_nr             =step_max_nr_m[nr];
   step_max_nr_down        =step_max_nr_down_m[nr];
   step_movegoal           =step_movegoal_m[nr];
   step_type               =step_type_m[nr];
   //hedging_openafter       =hedging_openafter_m[nr];
   //hedging_losspip         =hedging_losspip_m[nr];
   
   tp_avg                  =tp_avg_m[nr];        
   tp                      =tp_m[nr];
   tp_price                =tp_price_m[nr];
    
   b_letprofitrun          =b_letprofitrun_m[nr];
   fallbackpip_min         =fallbackpip_min_m[nr];
   fallbackpip_max         =fallbackpip_max_m[nr] ;
   fallbackpercent_max     =fallbackpercent_max_m[nr] ;
   
   max_loss_percent        =max_loss_percent_m[nr];  
   sl                      =sl_m[nr];
   sl_trail                =sl_trail_m[nr];
   sl_price                =sl_price_m[nr];
   sl_step                 =sl_step_m[nr];           
   sl_step_first           =sl_step_first_m[nr]; 
   sl_onavgprice           =sl_onavgprice_m[nr];               

      closeinstepup=closeinstepup_m[nr];  
      closepipstepup=closepipstepup_m[nr];  
      closeinstepdown=closeinstepdown_m[nr];  
      closepipstepdown=closepipstepdown_m[nr];  
      sl_turn=sl_turn_m[nr]; 
      sl_turnmult=sl_turnmult_m[nr]; 
  
   trailingstop_after_nr   =trailingstop_after_nr_m[nr];   
   stop_after_hour_tillsection=stop_after_hour_tillsection_m[nr];
   stop_after_nr           =stop_after_nr_m[nr];   
   stop_after_hour            =stop_after_hour_m[nr];
   stop_after_hour_minprofit  =stop_after_hour_minprofit_m[nr];
   stop_after_hour_minloss    =stop_after_hour_minloss_m[nr];
   stop_after_hour2           =stop_after_hour2_m[nr];
   stop_after_hour_minprofit2 =stop_after_hour_minprofit2_m[nr];
   stop_after_hour_minloss2   = stop_after_hour_minloss2_m[nr];
   stop_after_lastopen_min    = stop_after_lastopen_min_m[nr];
   stop_after_lastopen_minprofit =stop_after_lastopen_minprofit_m[nr];
   stop_after_lastopen_maxprofit = stop_after_lastopen_maxprofit_m[nr];   
   
   signal_atr_max    =signal_atr_max_m[nr];    
   signal_atr_min    =signal_atr_min_m[nr];  
   atr_period        =atr_period_m[nr]; 
       
   signal_adx_limit  =signal_adx_limit_m[nr];
   signal_adx_max    =signal_adx_max_m[nr];  
   adx_period        =adx_period_m[nr];
   signal_adx_limit2 =signal_adx_limit2_m[nr];
   adx_period2       =adx_period2_m[nr] ;
   signal_stoch_down =signal_stoch_down_m[nr];
   stoch_period      =stoch_period_m[nr];   
   rsi_limit_down    =rsi_limit_down_m[nr];
   rsi_min_down      =rsi_min_down_m[nr];
   rsi_period        =rsi_period_m[nr];
   bool_dev          =bool_dev_m[nr];
   bool_period       =bool_period_m[nr];
   bool_dev2          =bool_dev2_m[nr];
   bool_period2       =bool_period2_m[nr];   
   bool_dev3          =bool_dev3_m[nr];
   bool_period3       =bool_period3_m[nr];   
   
   stepmin1    =stepmin1_m[nr];
   steppip1    =steppip1_m[nr];
   stepmin2    =stepmin2_m[nr];
   steppip2    =steppip2_m[nr];
   stepmin3    =stepmin3_m[nr];
   steppip3    =steppip3_m[nr];
       
   delayminutes   =  delayminutes_m[nr];
   delayminutesafterclose=delayminutesafterclose_m[nr];
   delayminutesafterloss=delayminutesafterloss_m[nr];
   F_init_5digitstep();      
   return; }


void F_init_5digitstep()
   {  if (b_fivedigitbroker==true)
      {  d5korr=10.0;
         entry_orderbridge *=10;
         step_up           *=10;
         step_down         *=10;         
         step_down_first   *=10;
         step_movegoal     *=10;
         //hedging_openafter *=10;
         //hedging_losspip   *=10;
         tp_avg       *=10;
         fallbackpip_min   *=10;
         fallbackpip_max   *=10;
         tp        *=10;       
         sl        *=10;
         sl_trail  *=10;         
         sl_step   *=10;     
         sl_onavgprice*=10;    
         stop_after_hour_minprofit *=10;
         stop_after_hour_minprofit2 *=10;
         stop_after_hour_minloss *=10;
         stop_after_hour_minloss2 *=10;
         stop_after_lastopen_minprofit *=10;
         stop_after_lastopen_maxprofit *=10;
         signal_atr_max*=10;
         signal_atr_min*=10;
         steppip1*=10; steppip2*=10; steppip3*=10;  
         closepipstepup*=10;
         closepipstepdown*=10;  
         sl_turn*=10;    
              
      }
   return;  }
   








