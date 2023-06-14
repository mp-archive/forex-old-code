//+------------------------------------------------------------------+
#property copyright   "2013, MPeter6"                                    
#property version     "1.10"                                                     
#property description "This Expert Advisor is based on rsi,atr,bollinger and big 5min movements."
#property description "Must be run on GBPUSD M1."         
#property icon        "\\Images\\profit.ico";                                    


#include <mp\mp_mql4_functions.mqh>

    bool       in_b_compeetingbot      =true;
   input bool       five_digit_broker    =true;
    bool       in_b_run_multistrat     =true;
                     
          string     program_name         ="NLV3C12";
   input bool       strat1=true;
    bool       in_strat_2=false;   
    bool       in_strat_3=false;    
   input bool       strat2=true;    
   input bool       strat3=true;   
   input bool       strat4=true;   
    bool       in_strat_7=false;        //
    bool       in_strat_8=false;   
   input bool       strat5=true;   
    bool       in_strat_10=false;          //    
    bool       in_strat_11=false;      
    bool       in_strat_12=false;         //     
    bool       in_strat_13=false;      
   input bool       strat6=true;      
    bool       in_strat_15=false; 
    bool       in_strat_16=false;         //
    bool       in_strat_17=false;         //
    bool       in_strat_18=false;         //
    bool       in_strat_19=false;         //
    bool       in_strat_20=false;         //     
    int        in_test_strategies_to   =0;                  // 0 nem tesztel   1-7 az adott számú stratégiát teszteli

 
    int        in_MAGIC_Rf             =10061000;           int        MAGIC_Rf_m[30]           ={10001001,10001002,10001003,10001004,10001005,10001006,10001007,10001008,10001009,10001010,10001011,10001012,10001013,10001014,10001015,10001016,10001017,10001018,10001019,10001020};
    double     maximum_spread            =5.0;
    double     in_ult_max_loss_percent =50.0; 
    double     in_ult_win_percent=50.0;   

                                                         double   revkorr;
   input bool       moneymanagement     =true;
    bool       in_b_aggressive         =false;
    int        in_hidden_equity        =0;   
    bool       in_hidden_sl            =true;      
   input double     fix_lots                 =0.1;                                                      
   input double     multiplier_lots     =1.0;
    double     in_maxlot               =50.0;
   
                                                               int strat_nr=20; int strat_act;      //1      2        3        4        5       6      7 
                                                               bool strat_run[30]                  = {true  ,true    ,true    ,true   ,true   ,true   ,true,true   ,true,true   ,true,true   ,true ,true ,true ,true ,true ,true ,true ,true};
         bool       b_signal2_trading=false;                   bool b_signal2_trading_m[30]        = {false ,false   ,false   ,false  ,false  ,false,false  ,false,false  ,false,false  ,false  ,false,false,false,false,false,false,false};
 
 
   double in_maxspread=maximum_spread;
   bool   in_money_management=moneymanagement;
   double in_lots=fix_lots;

   double in_lots_multipliyer=MathMin(multiplier_lots,10)*1.1;
   bool       in_b_fivedigitbroker    =five_digit_broker;

   //  V ---------------------------------------------------------------------------------------------------------------------------------------------------------------   
   //    ------------------ to change ----------------------------------------------------------------------------------------------------------------------------------   

    Enum_TimeFrames2 in_strat_period=P_M1;
    int in_test_fromyear=201300;
    Enum_Currency strat_symbol_e=Current;
    string strat_symbol=F_Curr(strat_symbol_e,Symbol());                                 //string strat_symbol_m[10]           ={"USDJPY","USDJPY","USDJPY","USDJPY","USDJPY","USDJPY"};

 
 
   //    -------------  INNETÕL KELL VÁLTOZTATNI

 double in_lots_equityperlot=15000;      double lots_equityperlot_m[30]={10000     ,10000 ,10000 ,10000 ,10000 ,10000 ,10000 ,10000 ,10000 ,10000 ,10000 ,10000 ,10000 ,10000 ,10000 ,10000 ,10000 ,10000 ,10000 ,10000 ,10000 ,10000 ,10000};
   //    -------------  INNETÕL KELL VÁLTOZTATNI
   
double lots_equityperlot_ma[30]={10400    ,5800    ,4500    ,7700    ,7500    ,8500    ,6300    ,6900    ,5100    ,3900    ,3500    ,3500    ,6000    ,4700    ,6500    ,3900    ,3900    ,3900    ,3900    ,5000};
Enum_TimeFrames2 strat_period_m[30]={P_M5    ,P_M1    ,P_M5    ,P_M5    ,P_M1    ,P_M5    ,P_M1    ,P_M5    ,P_M1    ,P_M1    ,P_M1    ,P_M1    ,P_M1    ,P_M1    ,P_M1    ,P_M1    ,P_M1    ,P_M1    ,P_M1    ,P_M1};
Enum_Currency strat_symbol_m[30]={GBPUSD    ,GBPUSD    ,GBPUSD    ,GBPUSD    ,GBPUSD    ,GBPUSD    ,GBPUSD    ,GBPUSD    ,GBPUSD    ,GBPUSD    ,GBPUSD    ,GBPUSD    ,GBPUSD    ,GBPUSD    ,GBPUSD    ,GBPUSD    ,GBPUSD    ,GBPUSD    ,GBPUSD    ,GBPUSD};
 double in_martingal=0;       double martingal_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
 int in_ult_reverse=1;       int ult_reverse_m[30]={1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1};

 int in_tradinghour_start=0;      int tradinghour_start_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
 int in_tradinghour_end=25;      int tradinghour_end_m[30]={25    ,25    ,25    ,25    ,25    ,25    ,25    ,25    ,25    ,25    ,25    ,25    ,25    ,25    ,25    ,25    ,25    ,25    ,25    ,25};
 int in_tradinghour=2;      int tradinghour_m[30]={2    ,18    ,21    ,15    ,8    ,14    ,12    ,12    ,7    ,22    ,10    ,16    ,12    ,13    ,8    ,13    ,22    ,22    ,22    ,22};
 int in_tradingfridaytill=16;      int tradingfridaytill_m[30]={16    ,18    ,16    ,16    ,18    ,16    ,18    ,16    ,18    ,18    ,16    ,16    ,16    ,16    ,16    ,16    ,18    ,18    ,18    ,18};
 int in_tradingdayoyearmax=365;      int tradingdayoyearmax_m[30]={365    ,400    ,365    ,365    ,400    ,365    ,400    ,365    ,400    ,400    ,365    ,365    ,365    ,365    ,365    ,365    ,400    ,400    ,400    ,400};
 int in_entry_type=1;      int entry_type_m[30]={1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1};
 int in_entry_reverse=1;      int entry_reverse_m[30]={1    ,-1    ,-1    ,1    ,-1    ,-1    ,-1    ,-1    ,-1    ,-1    ,-1    ,1    ,-1    ,-1    ,1    ,-1    ,-1    ,-1    ,-1    ,-1};
 int in_entry_ordertype=1;      int entry_ordertype_m[30]={1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1};
 double in_entry_orderbridge=0;      double entry_orderbridge_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
 int in_entry_expire=120;      int entry_expire_m[30]={120    ,120    ,120    ,120    ,120    ,120    ,120    ,120    ,120    ,120    ,120    ,120    ,120    ,120    ,120    ,120    ,120    ,120    ,120    ,120};
 double in_delayminutes=0;      double delayminutes_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
 double in_delayminutesafterclose=20;      double delayminutesafterclose_m[30]={20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,40    ,20    ,20    ,20    ,20};
 double in_delayminutesafterloss=60;      double delayminutesafterloss_m[30]={60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,300    ,60    ,60    ,60    ,60};
 bool in_increase_lots=false;      bool increase_lots_m[30]={false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false};
 int in_increase_for_every=3;      int increase_for_every_m[30]={3    ,3    ,3    ,3    ,3    ,3    ,3    ,3    ,3    ,3    ,3    ,3    ,3    ,3    ,3    ,3    ,3    ,3    ,3    ,3};
 double in_increase_percent=0.1;      double increase_percent_m[30]={0.1    ,0.1    ,0.1    ,0.1    ,0.1    ,0.1    ,0.1    ,0.1    ,0.1    ,0.1    ,0.1    ,0.1    ,0.1    ,0.1    ,0.1    ,0.1    ,0.1    ,0.1    ,0.1    ,0.1};
 int in_step_type=1;      int step_type_m[30]={1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,3    ,1    ,1    ,1    ,1};
 int in_step_up=10;      int step_up_m[30]={10    ,5    ,10    ,10    ,5    ,10    ,5    ,10    ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,8    ,5    ,5    ,5    ,5};
 int in_step_down=30;      int step_down_m[30]={30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30};
 int in_step_down_first=70;      int step_down_first_m[30]={70    ,60    ,70    ,70    ,60    ,70    ,60    ,70    ,60    ,60    ,70    ,70    ,70    ,70    ,70    ,70    ,60    ,60    ,60    ,60};
 int in_step_down_minute=60;      int step_down_minute_m[30]={60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60};
 int in_step_max_nr=1;      int step_max_nr_m[30]={1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1};
 int in_step_max_nr_down=1;      int step_max_nr_down_m[30]={1    ,3    ,1    ,1    ,3    ,1    ,3    ,1    ,3    ,3    ,1    ,1    ,1    ,1    ,1    ,1    ,3    ,3    ,3    ,3};
 double in_step_movegoal=0;      double step_movegoal_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
 double in_hedging_openafter=0;      double hedging_openafter_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
 double in_hedging_losspip=0;      double hedging_losspip_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
 double in_tp_price=0;      double tp_price_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
 double in_tp_avg=2000;      double tp_avg_m[30]={2000    ,2000    ,2000    ,2000    ,2000    ,2000    ,2000    ,2000    ,2000    ,2000    ,2000    ,2000    ,2000    ,2000    ,2000    ,2000    ,2000    ,2000    ,2000    ,2000};
 double in_tp=23;      double tp_m[30]={23    ,20    ,13    ,18    ,20    ,8    ,10    ,8    ,20    ,10    ,8    ,8    ,13    ,13    ,8    ,2000    ,10    ,10    ,10    ,10};
 bool in_b_letprofitrun=false;      bool b_letprofitrun_m[30]={false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false};
 int in_fallbackpip_min=6;      int fallbackpip_min_m[30]={6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6};
 int in_fallbackpip_max=20;      int fallbackpip_max_m[30]={20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20};
 double in_fallbackpercent_max=0.2;      double fallbackpercent_max_m[30]={0.2    ,0.2    ,0.2    ,0.2    ,0.2    ,0.2    ,0.2    ,0.2    ,0.2    ,0.2    ,0.2    ,0.2    ,0.2    ,0.2    ,0.2    ,0.2    ,0.2    ,0.2    ,0.2    ,0.2};
 double in_max_loss_percent=50;      double max_loss_percent_m[30]={50    ,50    ,50    ,50    ,50    ,50    ,50    ,50    ,50    ,50    ,50    ,50    ,50    ,50    ,50    ,50    ,50    ,50    ,50    ,50};
 double in_sl_price=0;      double sl_price_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
 double in_sl=45;      double sl_m[30]={45    ,25    ,45    ,30    ,35    ,45    ,35    ,45    ,35    ,35    ,25    ,25    ,25    ,15    ,35    ,20    ,35    ,35    ,35    ,35};
 double in_sl_trail=8;      double sl_trail_m[30]={8    ,0    ,8    ,8    ,0    ,8    ,0    ,8    ,0    ,0    ,8    ,8    ,8    ,8    ,8    ,10    ,0    ,0    ,0    ,0};
 double in_sl_step=1;      double sl_step_m[30]={1    ,0    ,1    ,1    ,0    ,1    ,0    ,1    ,0    ,0    ,1    ,1    ,1    ,1    ,1    ,1    ,0    ,0    ,0    ,0};
 double in_sl_step_first=1;      double sl_step_first_m[30]={1    ,0    ,1    ,1    ,0    ,1    ,0    ,1    ,0    ,0    ,1    ,1    ,1    ,1    ,1    ,1    ,0    ,0    ,0    ,0};
 double in_sl_onavgprice=10;      double sl_onavgprice_m[30]={10    ,0    ,10    ,10    ,0    ,10    ,0    ,10    ,0    ,0    ,10    ,10    ,10    ,10    ,10    ,-2000    ,0    ,0    ,0    ,0};
 int in_trailingstop_after_nr=0;      int trailingstop_after_nr_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
 int in_stop_after_nr=1;      int stop_after_nr_m[30]={1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1};
 double in_closeinstepup=0;      double closeinstepup_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,9    ,0    ,0    ,0    ,0};
 double in_closepipstepup=0;      double closepipstepup_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,5    ,0    ,0    ,0    ,0};
 double in_closeinstepdown=0;      double closeinstepdown_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
 double in_closepipstepdown=0;      double closepipstepdown_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
 double in_sl_turn=0;      double sl_turn_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
 double in_sl_turnmult=0;      double sl_turnmult_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
 double in_stop_after_hour_tillsection=1;      double stop_after_hour_tillsection_m[30]={1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1};
 double in_stop_after_hour=0;      double stop_after_hour_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
 double in_stop_after_hour_minprofit=0;      double stop_after_hour_minprofit_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
 double in_stop_after_hour_minloss=0;      double stop_after_hour_minloss_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
 double in_stop_after_hour2=0;      double stop_after_hour2_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
 double in_stop_after_hour_minprofit2=0;      double stop_after_hour_minprofit2_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
 double in_stop_after_hour_minloss2=0;      double stop_after_hour_minloss2_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
 double in_stop_after_lastopen_min=0;      double stop_after_lastopen_min_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
 double in_stop_after_lastopen_minprofit=0;      double stop_after_lastopen_minprofit_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
 double in_stop_after_lastopen_maxprofit=0;      double stop_after_lastopen_maxprofit_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
 double in_signal_atr_max=1000;      double signal_atr_max_m[30]={1000    ,1000    ,1000    ,1000    ,1000    ,1000    ,1000    ,1000    ,1000    ,1000    ,2    ,2    ,4    ,2    ,2    ,2    ,1000    ,1000    ,1000    ,1000};
 double in_signal_atr_min=0;      double signal_atr_min_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
 int in_atr_period=30;      int atr_period_m[30]={30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30};
 double in_signal_adx_limit=0;      double signal_adx_limit_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
 double in_signal_adx_max=100;      double signal_adx_max_m[30]={100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100};
 int in_adx_period=30;      int adx_period_m[30]={30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30};
 double in_signal_adx_limit2=0;      double signal_adx_limit2_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
 int in_adx_period2=20;      int adx_period2_m[30]={20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20};
 double in_signal_stoch_down=100;      double signal_stoch_down_m[30]={100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100};
 int in_stoch_period=30;      int stoch_period_m[30]={30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30};
 double in_rsi_limit_down=24;      double rsi_limit_down_m[30]={24    ,100    ,23    ,23    ,100    ,22    ,100    ,23    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100};
 double in_rsi_min_down=0;      double rsi_min_down_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
 int in_rsi_period=10;      int rsi_period_m[30]={10    ,30    ,10    ,10    ,30    ,10    ,30    ,10    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30};
 int in_bool_dev=0;      int bool_dev_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,10    ,8    ,18    ,10    ,16    ,10    ,0    ,0    ,0    ,0};
 int in_bool_period=20;      int bool_period_m[30]={20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20};
 int in_bool_dev2=0;      int bool_dev2_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,8    ,8    ,8    ,8    ,8    ,16    ,0    ,0    ,0    ,0};
 int in_bool_period2=30;      int bool_period2_m[30]={30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30};
 int in_bool_dev3=0;      int bool_dev3_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,6    ,6    ,6    ,6    ,6    ,6    ,0    ,0    ,0    ,0};
 int in_bool_period3=40;      int bool_period3_m[30]={40    ,40    ,40    ,40    ,40    ,40    ,40    ,40    ,40    ,40    ,40    ,40    ,40    ,40    ,40    ,40    ,40    ,40    ,40    ,40};
 int in_stepmin1=0;      int stepmin1_m[30]={0    ,5    ,0    ,0    ,5    ,0    ,5    ,0    ,5    ,5    ,0    ,0    ,0    ,0    ,0    ,0    ,5    ,5    ,5    ,5};
 double in_steppip1=0;      double steppip1_m[30]={0    ,11    ,0    ,0    ,8    ,0    ,14    ,0    ,11    ,11    ,0    ,0    ,0    ,0    ,0    ,0    ,11    ,11    ,11    ,11};
 int in_stepmin2=0;      int stepmin2_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,25    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
 double in_steppip2=0;      double steppip2_m[30]={0    ,20    ,0    ,0    ,20    ,0    ,20    ,0    ,20    ,20    ,0    ,0    ,0    ,0    ,0    ,0    ,20    ,20    ,20    ,20};
 int in_stepmin3=0;      int stepmin3_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
 double in_steppip3=0;      double steppip3_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
 
//---------   EDDIG VAN CSERE 
 
 
 
 

 
 
 bool in_strat_1=strat1;
 bool in_strat_4=strat2;
 bool in_strat_5=strat3;
 bool in_strat_6=strat4;
 bool in_strat_9=strat5;
 bool in_strat_14=strat6;

 
 
 
   int x1=13;
   int x2=12;
   int x3=15;
   bool xstop=false;
 
 
 
 #include <mp\expert\oa_nlv04_b01_v59sl.mq5>


/*
megoldandó:
   tp,sl
   init values (lot)
   mult curr 



*/