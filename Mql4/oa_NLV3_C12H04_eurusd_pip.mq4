//+------------------------------------------------------------------+

#property copyright "MP"
#property link      "nincs nem kell"

   extern bool       b_compeetingbot      =true;
   extern bool       b_fivedigitbroker    =true;
   extern bool       b_run_multistrat     =true;
                     
          string     program_name         ="NLV3C12";
   extern bool       strat_1=false;
   extern bool       strat_2=true;   
   extern bool       strat_3=false;    
   extern bool       strat_4=false;    
   extern bool       strat_5=false;   
   extern bool       strat_6=false;      
    bool       strat_7=false;   
    bool       strat_8=false;   
    bool       strat_9=false;   
   extern int        test_strategies_to   =0;                  // 0 nem tesztel   1-7 az adott számú stratégiát teszteli
   extern string     infostr="----- pip1//pip1m//pip2//pip3//pip4//pip4m -----";
 
   extern int        MAGIC_Rf             =10071000;           int        MAGIC_Rf_m[10]           ={10071100,10071200,10071300,10071400,10071500,10071600,10071700,10071800,10071900};
   extern double     maxspread            =1.9;
   extern double     ult_max_loss_percent =10.0; 
   extern int        ult_reverse          =1.0;                double   revkorr;
   extern bool       money_management     =true;
   extern bool       b_aggressive         =false;
   extern int        hidden_equity        =0;   
   extern double     lots                 =0.1;                                                    //1       2        3        4        5       6        7        8
   extern double     lots_multipliyer     =1.0;
   extern double     lots_equityperlot    =6000.0;          double     lots_equityperlot_m[10]  ={6000   ,6000    ,6000    ,6000    ,6000    ,6000    ,6000   ,6000}; // 
                                                               double     lots_equityperlot_ma[10] ={30000  ,30000   ,60000   ,30000   ,30000   ,30000   ,30000   ,30000}; // 
         string strat_symbol="EURUSD";                         string strat_symbol_m[10]           ={"EURUSD","EURUSD","EURUSD","EURUSD","EURUSD","EURUSD","EURUSD","EURUSD"};
                                                               int strat_nr=6; int strat_act;      //1      2        3        4        5       6      7 
                                                               bool strat_run[10]                  = {true  ,true    ,true    ,true   ,true   ,true   ,true    ,true};
         bool       b_signal2_trading=false;                   bool b_signal2_trading_m[10]        = {false ,false   ,false   ,false  ,false  ,false  ,false   ,false};
 
   //  V ---------------------------------------------------------------------------------------------------------------------------------------------------------------   
   //    ------------------ to change ----------------------------------------------------------------------------------------------------------------------------------   

//pip1//pip1m//pip2//pip3//pip4//pip4m


double martingal=1;   double martingal_m[10]={1,1,1,1,2,1};
int strat_period=1;   int strat_period_m[10]={1,1,1,1,1,1};
int tradinghour_start=0;   int tradinghour_start_m[10]={0,0,0,0,0,0};
int tradinghour_end=0;   int tradinghour_end_m[10]={0,0,0,0,0,0};
int tradinghour=-1;   int tradinghour_m[10]={-1,-1,-1,-1,-1,-1};
int tradingfridaytill=14;   int tradingfridaytill_m[10]={14,14,14,14,14,14};
int tradingdayoyearmax=352;   int tradingdayoyearmax_m[10]={352,352,352,352,352,352};
int entry_type=3;   int entry_type_m[10]={3,3,3,3,3,3};
int entry_reverse=1;   int entry_reverse_m[10]={1,1,1,1,1,1};
int entry_ordertype=1;   int entry_ordertype_m[10]={1,1,1,1,1,1};
double entry_orderbridge=0;   double entry_orderbridge_m[10]={0,0,0,0,0,0};
int entry_expire=120;   int entry_expire_m[10]={120,120,120,120,120,120};
double delayminutes=0;   double delayminutes_m[10]={0,0,0,0,0,0};
double delayminutesafterclose=0;   double delayminutesafterclose_m[10]={0,0,120,10,10,10};
double delayminutesafterloss=180;   double delayminutesafterloss_m[10]={180,180,180,180,180,180};
bool increase_lots=false;   bool increase_lots_m[10]={false,false,false,false,false,false};
int increase_for_every=3;   int increase_for_every_m[10]={3,3,3,3,3,3};
double increase_percent=0.1;   double increase_percent_m[10]={0.1,0.1,0.1,0.1,0.1,0.1};
int step_type=1;   int step_type_m[10]={1,1,1,1,1,1};
int step_up=0;   int step_up_m[10]={0,0,0,0,0,0};
int step_down=15;   int step_down_m[10]={15,15,15,15,15,15};
int step_down_first=15;   int step_down_first_m[10]={15,15,15,15,15,15};
int step_down_minute=120;   int step_down_minute_m[10]={120,120,120,120,120,120};
int step_max_nr=1;   int step_max_nr_m[10]={1,1,1,1,1,1};
int step_max_nr_down=1;   int step_max_nr_down_m[10]={1,1,1,1,1,1};
double step_movegoal=0;   double step_movegoal_m[10]={0,0,0,0,0,0};
double hedging_openafter=0;   double hedging_openafter_m[10]={0,0,0,0,0,0};
double hedging_losspip=0;   double hedging_losspip_m[10]={0,0,0,0,0,0};
double tp_price=0;   double tp_price_m[10]={0,0,0,0,0,0};
double tp_avg=10;   double tp_avg_m[10]={10,10,10,5,8,8};
double tp=0;   double tp_m[10]={0,0,0,0,0,0};
bool b_letprofitrun=false;   bool b_letprofitrun_m[10]={false,false,false,false,false,false};
int fallbackpip_min=2;   int fallbackpip_min_m[10]={2,2,2,2,2,2};
int fallbackpip_max=10;   int fallbackpip_max_m[10]={10,10,10,10,10,10};
double fallbackpercent_max=0.2;   double fallbackpercent_max_m[10]={0.2,0.2,0.2,0.2,0.2,0.2};
double max_loss_percent=50;   double max_loss_percent_m[10]={50,50,50,50,50,50};
double sl_price=0;   double sl_price_m[10]={0,0,0,0,0,0};
double sl=18;   double sl_m[10]={18,12,60,30,21,21};
double sl_trail=0;   double sl_trail_m[10]={0,0,0,0,0,0};
double sl_step=5;   double sl_step_m[10]={5,5,5,5,5,5};
double sl_step_first=30;   double sl_step_first_m[10]={30,30,30,30,30,30};
double sl_onavgprice=-2000;   double sl_onavgprice_m[10]={-2000,-2000,-2000,-2000,-2000,-2000};
int trailingstop_after_nr=0;   int trailingstop_after_nr_m[10]={0,0,0,0,0,0};
int stop_after_nr=1;   int stop_after_nr_m[10]={1,1,1,1,1,1};
double stop_after_hour_tillsection=1;   double stop_after_hour_tillsection_m[10]={1,1,1,1,1,1};
double stop_after_hour=0;   double stop_after_hour_m[10]={0,0,0,0,0,0};
double stop_after_hour_minprofit=0;   double stop_after_hour_minprofit_m[10]={0,0,0,0,0,0};
double stop_after_hour_minloss=0;   double stop_after_hour_minloss_m[10]={0,0,0,0,0,0};
double stop_after_hour2=0;   double stop_after_hour2_m[10]={0,0,0,0,0,0};
double stop_after_hour_minprofit2=0;   double stop_after_hour_minprofit2_m[10]={0,0,0,0,0,0};
double stop_after_hour_minloss2=0;   double stop_after_hour_minloss2_m[10]={0,0,0,0,0,0};
double stop_after_lastopen_min=0;   double stop_after_lastopen_min_m[10]={0,0,0,0,0,0};
double stop_after_lastopen_minprofit=0;   double stop_after_lastopen_minprofit_m[10]={0,0,0,0,0,0};
double stop_after_lastopen_maxprofit=0;   double stop_after_lastopen_maxprofit_m[10]={0,0,0,0,0,0};
double stop_st3_out=0;   double stop_st3_out_m[10]={0,0,0,0,0,0};
double signal_atr_max=1000;   double signal_atr_max_m[10]={1000,1000,1000,1000,1000,1000};
double signal_atr_min=0;   double signal_atr_min_m[10]={0,0,0,0,0,0};
int atr_period=30;   int atr_period_m[10]={30,30,30,30,30,30};
double signal_adx_limit=40;   double signal_adx_limit_m[10]={40,40,40,40,40,40};
double signal_adx_max=100;   double signal_adx_max_m[10]={100,100,100,100,100,100};
int adx_period=30;   int adx_period_m[10]={30,30,30,30,30,30};
double signal_adx_limit2=45;   double signal_adx_limit2_m[10]={45,45,45,45,45,45};
int adx_period2=20;   int adx_period2_m[10]={20,20,20,20,20,20};
double signal_stoch_down=100;   double signal_stoch_down_m[10]={100,100,100,100,100,100};
int stoch_period=30;   int stoch_period_m[10]={30,30,30,30,30,30};
double rsi_limit_down=100;   double rsi_limit_down_m[10]={100,100,100,100,100,100};
double rsi_min_down=0;   double rsi_min_down_m[10]={0,0,0,0,0,0};
int rsi_period=30;   int rsi_period_m[10]={30,30,30,30,30,30};
int bool_dev=2;   int bool_dev_m[10]={2,2,2,2,2,2};
int bool_period=30;   int bool_period_m[10]={30,30,30,30,30,30};
int bool_dev2=0;   int bool_dev2_m[10]={0,0,0,0,0,0};
int bool_period2=30;   int bool_period2_m[10]={30,30,30,30,30,30};
int bool_dev3=0;   int bool_dev3_m[10]={0,0,0,0,0,0};
int bool_period3=30;   int bool_period3_m[10]={30,30,30,30,30,30};
int stepmin1=0;   int stepmin1_m[10]={0,0,0,0,0,0};
double steppip1=0;   double steppip1_m[10]={0,0,0,0,0,0};
int stepmin2=0;   int stepmin2_m[10]={0,0,0,0,0,0};
double steppip2=0;   double steppip2_m[10]={0,0,0,0,0,0};
int stepmin3=0;   int stepmin3_m[10]={0,0,0,0,0,0};
double steppip3=0;   double steppip3_m[10]={0,0,0,0,0,0};
double st3_limit=25;   double st3_limit_m[10]={25,25,30,35,31,31};


   extern string   Other_single_setting="-------------------" ;
   /* */extern bool     set_hours=false;
   
//   extern string     Settings_str3="-------------------" ;
//   extern int     strat_period2= 60;                           int         strat_period2_m[10]        ={60     ,60      ,60      ,60   ,60   ,60   ,60};
//   extern int     str3_period= 30;                             int         str3_period_m[10]          ={3      ,3       ,3       ,3    ,3    ,3    ,3};
//   extern double  str3_diff = 15;                              double      str3_diff_m[10]            ={0.0    ,0.0     ,0.0     ,0.0  ,0.0  ,0.0  ,0.0};
  // lent is ki van szedve 
  
   
//---------------- CORE_SYSTEM -------------------------------
//------------------------------------------------------------
#include "oa_NLV3_Core_12t18IN_R116.mq4"          