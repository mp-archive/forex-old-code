//+------------------------------------------------------------------+
//|                                      oa_NLV3_Core_12t20_R116.mq5 |
//|                                                               mp |
//|                                                                  |
//--------------------------------------------------------------------
// initiallot  to init
// init  / tp-sl / ne nyisson duplán / reverse positin / takarítás 
//+------------------------------------------------------------------+
#property copyright "mp"
#property link      ""
#property version   "1.00"


#include <mp\mp_mql4_functions.mqh>

   input int        in_maxpos               =1;  
   input Enum_CurrHandling  in_curr_handling =3;
   //input bool       in_b_compeetingbot      =true;
   input bool       in_b_fivedigitbroker    =true;
   input bool       in_b_run_multistrat     =true;
                     
   string           program_name="NLV3C12";
   input bool       in_strat_1=true;
   input bool       in_strat_2=true;   
   input bool       in_strat_3=true;    
   input bool       in_strat_4=true;    
   input bool       in_strat_5=true;   
   input bool       in_strat_6=true;      
   input bool       in_strat_7=true;  
   input bool       in_strat_8=true;   
   input bool       in_strat_9=true;   
   input bool       in_strat_10=true;      
   input bool       in_strat_11=true;      
   input bool       in_strat_12=true;      
   input bool       in_strat_13=true;      
   input bool       in_strat_14=true;      
   input bool       in_strat_15=true; 
   input bool       in_strat_16=true; 
   input bool       in_strat_17=true; 
   input bool       in_strat_18=true; 
   input bool       in_strat_19=true; 
   input bool       in_strat_20=true;       
   input int        in_test_strategies_to   =0;                  // 0 nem tesztel   -20-tól 20-ig az adott számú stratégiát teszteli vagy kihagyja

 
   input int        in_MAGIC_Rf             =101000;           int MAGIC_Rf_m[30]={0,0,0,0};
   input double     in_maxspread            =10.0;
   input double     in_ult_max_loss_percent =100.0; 
   input double     in_ult_win_percent      =100.0;   
   input double     in_ult_delayminutesafterloss=0;   

                                                         double   revkorr;
   input bool       in_money_management     =true;
   input bool       in_b_aggressive         =true;
   input int        in_hidden_equity        =0;   
   input bool       in_hidden_sl            =true;      
   input double     in_lots                 =0.1;                                                      
   input double     in_lots_multipliyer     =1.0;
   input double     in_lots_adjust          =1.0;   
         double     in_maxlot               =50.0, in_maxequityperlot=2500;
                                                               int strat_nr=20; int strat_act;      //1      2        3        4        5       6      7 
                                                               bool strat_run[30]                  = {true  ,true    ,true    ,true   ,true   ,true   ,true,true   ,true,true   ,true,true   ,true ,true ,true ,true ,true ,true ,true ,true};
         bool       b_signal2_trading=false;                   bool b_signal2_trading_m[30]        = {false ,false   ,false   ,false  ,false  ,false,false  ,false,false  ,false,false  ,false  ,false,false,false,false,false,false,false};
 
   //  V ---------------------------------------------------------------------------------------------------------------------------------------------------------------   
   //    ------------------ to change ----------------------------------------------------------------------------------------------------------------------------------   

   input Enum_TimeFrames2 in_strat_period=P_M1;
   input int in_test_fromyear=201300;
   input Enum_Currency strat_symbol_e=Current;
   string strat_symbol=F_Curr(strat_symbol_e,Symbol());                                 //string strat_symbol_m[10]           ={"USDJPY","USDJPY","USDJPY","USDJPY","USDJPY","USDJPY"};

 
input double in_lots_equityperlot=15000;      double lots_equityperlot_m[30]={10000    ,10000    ,10000    ,10000    ,10000    ,10000    ,10000    ,10000    ,10000    ,10000    ,10000    ,10000    ,10000    ,10000    ,10000    ,10000    ,10000    ,10000    ,10000    ,10000};
   //    -------------  INNETÕL KELL VÁLTOZTATNI
double lots_equityperlot_ma[30]={14000    ,26000    ,18350    ,17850    ,9800    ,21350    ,8950    ,13000    ,10500    ,11550    ,5250    ,19400    ,14100    ,8600    ,14300    ,18450    ,20550    ,5000    ,10600    ,12600};
Enum_TimeFrames2 strat_period_m[30]={P_M1    ,P_M1    ,P_M1    ,P_M1    ,P_M1    ,P_M1    ,P_M1    ,P_M1    ,P_M1    ,P_M1    ,P_M1    ,P_M1    ,P_M1    ,P_M1    ,P_M1    ,P_M1    ,P_M1    ,P_M1    ,P_M1    ,P_M1};
Enum_Currency strat_symbol_m[30]={EURUSD    ,EURGBP    ,EURGBP    ,EURUSD    ,EURGBP    ,EURUSD    ,EURGBP    ,USDCAD    ,EURGBP    ,EURUSD    ,EURUSD    ,GBPUSD    ,EURUSD    ,GBPUSD    ,EURUSD    ,EURUSD    ,AUDUSD    ,GBPUSD    ,EURUSD    ,USDCAD};
input double in_martingal=0;       double martingal_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input int in_ult_reverse=1;       int ult_reverse_m[30]={1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1};

input int in_tradinghour_start=0;      int tradinghour_start_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input int in_tradinghour_end=25;      int tradinghour_end_m[30]={25    ,25    ,25    ,25    ,25    ,25    ,25    ,25    ,25    ,25    ,25    ,25    ,25    ,25    ,25    ,25    ,25    ,25    ,25    ,25};
input int in_tradinghour=23;      int tradinghour_m[30]={23    ,13    ,14    ,18    ,12    ,8    ,9    ,19    ,15    ,16    ,21    ,22    ,17    ,10    ,13    ,14    ,12    ,13    ,12    ,23};
input int in_tradingfridaytill=16;      int tradingfridaytill_m[30]={16    ,16    ,16    ,16    ,16    ,16    ,16    ,16    ,16    ,16    ,16    ,16    ,16    ,16    ,16    ,16    ,16    ,16    ,16    ,16};
input int in_tradingdayoyearmax=365;      int tradingdayoyearmax_m[30]={365    ,365    ,365    ,365    ,365    ,365    ,365    ,365    ,365    ,365    ,365    ,365    ,365    ,365    ,365    ,365    ,365    ,365    ,365    ,365};
input int in_entry_type=1;      int entry_type_m[30]={1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1};
input int in_entry_reverse=1;      int entry_reverse_m[30]={1    ,1    ,1    ,-1    ,-1    ,1    ,-1    ,-1    ,1    ,1    ,-1    ,1    ,1    ,-1    ,1    ,1    ,1    ,1    ,1    ,1};
input int in_entry_ordertype=1;      int entry_ordertype_m[30]={1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1};
input double in_entry_orderbridge=0;      double entry_orderbridge_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input int in_entry_expire=120;      int entry_expire_m[30]={120    ,120    ,120    ,120    ,120    ,120    ,120    ,120    ,120    ,120    ,120    ,120    ,120    ,120    ,120    ,120    ,120    ,120    ,120    ,120};
input double in_delayminutes=0;      double delayminutes_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input double in_delayminutesafterclose=20;      double delayminutesafterclose_m[30]={20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20};
input double in_delayminutesafterloss=60;      double delayminutesafterloss_m[30]={60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60};
input bool in_increase_lots=false;      bool increase_lots_m[30]={false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false};
input int in_increase_for_every=3;      int increase_for_every_m[30]={3    ,3    ,3    ,3    ,3    ,3    ,3    ,3    ,3    ,3    ,3    ,3    ,3    ,3    ,3    ,3    ,3    ,3    ,3    ,3};
input double in_increase_percent=0.1;      double increase_percent_m[30]={0.1    ,0.1    ,0.1    ,0.1    ,0.1    ,0.1    ,0.1    ,0.1    ,0.1    ,0.1    ,0.1    ,0.1    ,0.1    ,0.1    ,0.1    ,0.1    ,0.1    ,0.1    ,0.1    ,0.1};
input int in_step_type=1;      int step_type_m[30]={1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1};
input int in_step_up=5;      int step_up_m[30]={5    ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,5};
input int in_step_down=30;      int step_down_m[30]={30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30};
input int in_step_down_first=70;      int step_down_first_m[30]={70    ,70    ,70    ,70    ,70    ,70    ,70    ,70    ,70    ,70    ,70    ,70    ,70    ,70    ,70    ,70    ,70    ,70    ,70    ,70};
input int in_step_down_minute=60;      int step_down_minute_m[30]={60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60};
input int in_step_max_nr=1;      int step_max_nr_m[30]={1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1};
input int in_step_max_nr_down=1;      int step_max_nr_down_m[30]={1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1};
input double in_step_movegoal=0;      double step_movegoal_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input double in_hedging_openafter=0;      double hedging_openafter_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input double in_hedging_losspip=0;      double hedging_losspip_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input double in_tp_price=0;      double tp_price_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input double in_tp_avg=2000;      double tp_avg_m[30]={2000    ,2000    ,2000    ,2000    ,2000    ,2000    ,2000    ,2000    ,2000    ,2000    ,2000    ,2000    ,2000    ,2000    ,2000    ,2000    ,2000    ,2000    ,2000    ,2000};
input double in_tp=25;      double tp_m[30]={25    ,35    ,35    ,15    ,25    ,35    ,15    ,25    ,35    ,35    ,15    ,35    ,15    ,35    ,35    ,35    ,35    ,15    ,15    ,25};
input bool in_b_letprofitrun=false;      bool b_letprofitrun_m[30]={false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false};
input int in_fallbackpip_min=6;      int fallbackpip_min_m[30]={6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6};
input int in_fallbackpip_max=20;      int fallbackpip_max_m[30]={20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20};
input double in_fallbackpercent_max=0.2;      double fallbackpercent_max_m[30]={0.2    ,0.2    ,0.2    ,0.2    ,0.2    ,0.2    ,0.2    ,0.2    ,0.2    ,0.2    ,0.2    ,0.2    ,0.2    ,0.2    ,0.2    ,0.2    ,0.2    ,0.2    ,0.2    ,0.2};
input double in_max_loss_percent=50;      double max_loss_percent_m[30]={50    ,50    ,50    ,50    ,50    ,50    ,50    ,50    ,50    ,50    ,50    ,50    ,50    ,50    ,50    ,50    ,50    ,50    ,50    ,50};
input double in_sl_price=0;      double sl_price_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input double in_sl=140;      double sl_m[30]={140    ,140    ,140    ,140    ,140    ,140    ,140    ,140    ,140    ,80    ,110    ,140    ,140    ,80    ,110    ,110    ,110    ,140    ,110    ,140};
input double in_sl_trail=8;      double sl_trail_m[30]={8    ,8    ,8    ,8    ,8    ,8    ,8    ,8    ,8    ,8    ,8    ,8    ,8    ,8    ,8    ,8    ,8    ,8    ,8    ,8};
input double in_sl_step=1;      double sl_step_m[30]={1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1};
input double in_sl_step_first=1;      double sl_step_first_m[30]={1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1};
input double in_sl_onavgprice=10;      double sl_onavgprice_m[30]={10    ,10    ,10    ,10    ,10    ,10    ,10    ,10    ,10    ,10    ,10    ,10    ,10    ,10    ,10    ,10    ,10    ,10    ,10    ,10};
input int in_trailingstop_after_nr=0;      int trailingstop_after_nr_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input int in_stop_after_nr=1;      int stop_after_nr_m[30]={1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1};
input double in_closeinstepup=0;      double closeinstepup_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input double in_closepipstepup=0;      double closepipstepup_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input double in_closeinstepdown=0;      double closeinstepdown_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input double in_closepipstepdown=0;      double closepipstepdown_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input double in_sl_turn=0;      double sl_turn_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input double in_sl_turnmult=0;      double sl_turnmult_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input int in_closefridaynight=0;      int closefridaynight_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input double in_stop_after_hour_tillsection=1;      double stop_after_hour_tillsection_m[30]={1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1};
input double in_stop_after_hour=0;      double stop_after_hour_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input double in_stop_after_hour_minprofit=0;      double stop_after_hour_minprofit_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input double in_stop_after_hour_minloss=0;      double stop_after_hour_minloss_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input double in_stop_after_hour2=0;      double stop_after_hour2_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input double in_stop_after_hour_minprofit2=0;      double stop_after_hour_minprofit2_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input double in_stop_after_hour_minloss2=0;      double stop_after_hour_minloss2_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input double in_stop_after_lastopen_min=0;      double stop_after_lastopen_min_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input double in_stop_after_lastopen_minprofit=0;      double stop_after_lastopen_minprofit_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input double in_stop_after_lastopen_maxprofit=0;      double stop_after_lastopen_maxprofit_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input double in_signal_atr_max=2;      double signal_atr_max_m[30]={2    ,2    ,4    ,1000    ,1000    ,1000    ,4    ,1000    ,1000    ,1000    ,1000    ,4    ,1000    ,1000    ,2    ,4    ,1000    ,1000    ,2    ,1000};
input double in_signal_atr_min=0;      double signal_atr_min_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input int in_atr_period=30;      int atr_period_m[30]={30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30};
input double in_signal_adx_limit=0;      double signal_adx_limit_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,40    ,0    ,0};
input double in_signal_adx_max=100;      double signal_adx_max_m[30]={100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100};
input int in_adx_period=30;      int adx_period_m[30]={30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30};
input double in_signal_adx_limit2=0;      double signal_adx_limit2_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input int in_adx_period2=20;      int adx_period2_m[30]={20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20};
input double in_signal_stoch_down=100;      double signal_stoch_down_m[30]={100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100};
input int in_stoch_period=30;      int stoch_period_m[30]={30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30};
input double in_rsi_limit_down=100;      double rsi_limit_down_m[30]={100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,26    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100};
input double in_rsi_min_down=0;      double rsi_min_down_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input int in_rsi_period=30;      int rsi_period_m[30]={30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30};
input int in_bool_dev=22;      int bool_dev_m[30]={22    ,12    ,24    ,0    ,0    ,0    ,18    ,0    ,0    ,0    ,0    ,24    ,0    ,0    ,8    ,12    ,0    ,0    ,8    ,0};
input int in_bool_period=20;      int bool_period_m[30]={20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20};
input int in_bool_dev2=6;      int bool_dev2_m[30]={6    ,6    ,6    ,0    ,0    ,0    ,6    ,0    ,0    ,0    ,0    ,6    ,0    ,0    ,6    ,6    ,0    ,2    ,6    ,0};
input int in_bool_period2=30;      int bool_period2_m[30]={30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30};
input int in_bool_dev3=6;      int bool_dev3_m[30]={6    ,6    ,6    ,0    ,0    ,0    ,6    ,0    ,0    ,0    ,0    ,6    ,0    ,0    ,6    ,6    ,0    ,0    ,6    ,0};
input int in_bool_period3=40;      int bool_period3_m[30]={40    ,40    ,40    ,40    ,40    ,40    ,40    ,40    ,40    ,40    ,40    ,40    ,40    ,40    ,40    ,40    ,40    ,40    ,40    ,40};
input int in_stepmin1=0;      int stepmin1_m[30]={0    ,0    ,0    ,8    ,13    ,8    ,0    ,13    ,3    ,8    ,0    ,0    ,8    ,13    ,0    ,0    ,3    ,0    ,0    ,3};
input double in_steppip1=0;      double steppip1_m[30]={0    ,0    ,0    ,8    ,18    ,8    ,0    ,18    ,13    ,18    ,0    ,0    ,18    ,18    ,0    ,0    ,8    ,0    ,0    ,8};
input int in_stepmin2=0;      int stepmin2_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input double in_steppip2=0;      double steppip2_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input int in_stepmin3=0;      int stepmin3_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input double in_steppip3=0;      double steppip3_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input int in_monday=1;      int monday_m[30]={1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1};
input int in_tuesday=1;      int tuesday_m[30]={1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1};
input int in_wednesday=1;      int wednesday_m[30]={1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1};
input int in_thursday=1;      int thursday_m[30]={1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1};
input int in_friday=1;      int friday_m[30]={1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1};
input int in_saturday=1;      int saturday_m[30]={1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1};












//---------   EDDIG VAN CSERE 
 
 
 #include <mp\expert\oa_nlv04_b01_v70mod.mq5>


 