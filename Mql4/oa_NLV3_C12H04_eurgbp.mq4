//+------------------------------------------------------------------+

#property copyright "MP"
#property link      "nincs nem kell"

   extern bool       b_compeetingbot      =true;
   extern bool       b_fivedigitbroker    =true;
   extern bool       b_run_multistrat     =true;
                     
          string     program_name         ="NLV3C12";
   extern bool       strat_1=true;
   extern bool       strat_2=false;   
   extern bool       strat_3=false;    
   extern bool       strat_4=true;    
   extern bool       strat_5=true;   
    bool       strat_6=false;      
    bool       strat_7=false;   
    bool       strat_8=false;   
    bool       strat_9=false;   
   extern int        test_strategies_to   =0;                  // 0 nem tesztel   1-7 az adott számú stratégiát teszteli
   extern string     infostr="-----  2,2 risky --- 2,3 mlong -----";
 
   extern int        MAGIC_Rf             =10064000;           int        MAGIC_Rf_m[10]           ={10064100,10064200,10064300,10064400,10064500,10064600,10064700,10064800,10064900};
   extern double     maxspread            =2.5;
   extern double     ult_max_loss_percent =50.0; 
   extern int        ult_reverse          =1.0;                double   revkorr;
   extern bool       money_management     =true;
   extern bool       b_aggressive         =false;
   extern int        hidden_equity        =0;   
   extern double     lots                 =0.1;                                                    //1      2 l170   3  l227   4       5        6        7        8
   extern double     lots_multipliyer     =1.1;
   extern double     lots_equityperlot    =1000000.0;          double     lots_equityperlot_m[10]  ={8000   ,31038   ,33403   ,19423   ,16351   ,100000  ,100000  ,100000}; // 
                                                               double     lots_equityperlot_ma[10] ={30000  ,30000   ,60000   ,30000   ,30000   ,30000   ,30000   ,30000}; // 
         string strat_symbol="EURGBP";                         string strat_symbol_m[10]           ={"EURGBP","EURGBP","EURGBP","EURGBP","EURGBP","EURGBP","EURGBP"};
                                                               int strat_nr=5; int strat_act;      //1      2        3        4        5       6      7 
                                                               bool strat_run[10]                  = {true  ,true    ,true    ,true   ,true   ,true   ,true    ,true};
         bool       b_signal2_trading=false;                   bool b_signal2_trading_m[10]        = {false ,false   ,false   ,false  ,false  ,false  ,false   ,false};
 
   //  V ---------------------------------------------------------------------------------------------------------------------------------------------------------------   
   //    ------------------ to change ----------------------------------------------------------------------------------------------------------------------------------   


double martingal=0;   double martingal_m[10]={0,0,0,0,0};
int strat_period=5;   int strat_period_m[10]={5,5,5,1,1};
int tradinghour_start=11;   int tradinghour_start_m[10]={11,10,12,23,0};
int tradinghour_end=20;   int tradinghour_end_m[10]={20,16,22,5,4};
int tradinghour=-1;   int tradinghour_m[10]={-1,-1,-1,-1,-1};
int tradingfridaytill=15;   int tradingfridaytill_m[10]={15,15,24,14,14};
int tradingdayoyearmax=356;   int tradingdayoyearmax_m[10]={356,356,356,356,356};
int entry_type=1;   int entry_type_m[10]={1,1,1,1,1};
int entry_reverse=1;   int entry_reverse_m[10]={1,1,1,1,1};
int entry_ordertype=1;   int entry_ordertype_m[10]={1,1,1,1,1};
double entry_orderbridge=0;   double entry_orderbridge_m[10]={0,0,0,0,0};
int entry_expire=0;   int entry_expire_m[10]={0,0,0,0,0};
double delayminutes=0;   double delayminutes_m[10]={0,0,0,0,0};
double delayminutesafterclose=0;   double delayminutesafterclose_m[10]={0,0,0,0,0};
double delayminutesafterloss=0;   double delayminutesafterloss_m[10]={0,0,0,0,0};
bool increase_lots=false;   bool increase_lots_m[10]={false,false,false,false,false};
int increase_for_every=1;   int increase_for_every_m[10]={1,1,1,1,1};
double increase_percent=1;   double increase_percent_m[10]={1,1,1,1,1};
int step_type=1;   int step_type_m[10]={1,1,1,1,1};
int step_up=0;   int step_up_m[10]={0,0,20,35,30};
int step_down=35;   int step_down_m[10]={35,35,20,35,30};
int step_down_first=35;   int step_down_first_m[10]={35,35,20,35,30};
int step_down_minute=20;   int step_down_minute_m[10]={20,120,120,120,90};
int step_max_nr=3;   int step_max_nr_m[10]={3,5,3,3,3};
int step_max_nr_down=3;   int step_max_nr_down_m[10]={3,5,3,3,3};
double step_movegoal=0;   double step_movegoal_m[10]={0,0,0,0,0};
double hedging_openafter=0;   double hedging_openafter_m[10]={0,0,0,0,0};
double hedging_losspip=0;   double hedging_losspip_m[10]={0,0,0,0,0};
double tp_price=0;   double tp_price_m[10]={0,0,0,0,0};
double tp_avg=3;   double tp_avg_m[10]={3,30,30,4,5};
double tp=0;   double tp_m[10]={0,0,0,0,0};
bool b_letprofitrun=false;   bool b_letprofitrun_m[10]={false,false,false,false,false};
int fallbackpip_min=6;   int fallbackpip_min_m[10]={6,12,6,6,6};
int fallbackpip_max=20;   int fallbackpip_max_m[10]={20,40,20,20,20};
double fallbackpercent_max=0.2;   double fallbackpercent_max_m[10]={0.2,0.4,0.2,0.2,0.2};
double max_loss_percent=15;   double max_loss_percent_m[10]={15,50,50,50,50};
double sl_price=0;   double sl_price_m[10]={0,0,0,0,0};
double sl=0;   double sl_m[10]={0,0,0,0,0};
double sl_trail=0;   double sl_trail_m[10]={0,0,0,0,0};
double sl_step=0;   double sl_step_m[10]={0,0,5,5,5};
double sl_step_first=0;   double sl_step_first_m[10]={0,0,30,30,30};
double sl_onavgprice=-2000;   double sl_onavgprice_m[10]={-2000,-2000,-2000,-2000,-2000};
int trailingstop_after_nr=0;   int trailingstop_after_nr_m[10]={0,0,0,0,0};
int stop_after_nr=0;   int stop_after_nr_m[10]={0,0,0,0,0};
double stop_after_hour_tillsection=1;   double stop_after_hour_tillsection_m[10]={1,1,1,1,1};
double stop_after_hour=3;   double stop_after_hour_m[10]={3,3,3,0,0};
double stop_after_hour_minprofit=2;   double stop_after_hour_minprofit_m[10]={2,12,13,0,0};
double stop_after_hour_minloss=0;   double stop_after_hour_minloss_m[10]={0,0,0,0,0};
double stop_after_hour2=0;   double stop_after_hour2_m[10]={0,4,4,0,0};
double stop_after_hour_minprofit2=0;   double stop_after_hour_minprofit2_m[10]={0,2,0,0,0};
double stop_after_hour_minloss2=0;   double stop_after_hour_minloss2_m[10]={0,0,0,0,0};
double stop_after_lastopen_min=0;   double stop_after_lastopen_min_m[10]={0,0,0,0,0};
double stop_after_lastopen_minprofit=0;   double stop_after_lastopen_minprofit_m[10]={0,0,0,0,0};
double stop_after_lastopen_maxprofit=0;   double stop_after_lastopen_maxprofit_m[10]={0,0,0,0,0};
double stop_st3_out=0;   double stop_st3_out_m[10]={0,0,0,0,0};
double signal_atr_max=15;   double signal_atr_max_m[10]={15,1000,1000,1000,1000};
double signal_atr_min=5;   double signal_atr_min_m[10]={5,0,0,0,0};
int atr_period=30;   int atr_period_m[10]={30,30,30,30,30};
double signal_adx_limit=30;   double signal_adx_limit_m[10]={30,42,40,42,0};
double signal_adx_max=35;   double signal_adx_max_m[10]={35,100,100,100,100};
int adx_period=30;   int adx_period_m[10]={30,30,30,30,30};
double signal_adx_limit2=0;   double signal_adx_limit2_m[10]={0,0,0,0,0};
int adx_period2=20;   int adx_period2_m[10]={20,20,20,20,20};
double signal_stoch_down=100;   double signal_stoch_down_m[10]={100,100,100,100,100};
int stoch_period=30;   int stoch_period_m[10]={30,20,30,30,30};
double rsi_limit_down=65;   double rsi_limit_down_m[10]={65,31,100,30,20};
double rsi_min_down=55;   double rsi_min_down_m[10]={55,0,0,0,0};
int rsi_period=30;   int rsi_period_m[10]={30,30,30,20,30};
int bool_dev=2;   int bool_dev_m[10]={2,2,2,2,0};
int bool_period=20;   int bool_period_m[10]={20,20,20,20,20};
int bool_dev2=0;   int bool_dev2_m[10]={0,0,0,0,0};
int bool_period2=20;   int bool_period2_m[10]={20,20,20,20,20};
int bool_dev3=0;   int bool_dev3_m[10]={0,0,0,0,0};
int bool_period3=20;   int bool_period3_m[10]={20,20,20,20,20};
int stepmin1=0;   int stepmin1_m[10]={0,0,0,0,0};
double steppip1=0;   double steppip1_m[10]={0,0,0,0,0};
int stepmin2=0;   int stepmin2_m[10]={0,0,0,0,0};
double steppip2=0;   double steppip2_m[10]={0,0,0,0,0};
int stepmin3=0;   int stepmin3_m[10]={0,0,0,0,0};
double steppip3=0;   double steppip3_m[10]={0,0,0,0,0};
double st3_limit=0;   double st3_limit_m[10]={0,0,0,0,0};


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