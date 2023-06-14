//+------------------------------------------------------------------+
//   todo: 
//    
//          strat_act  --> F_setup_multisignal - ELÕKÉSZÍTVE
//          open_bool_i_m, open_nr_i_m / parallel open run  - ELÕKÉSZÍTVE  //  PENDING TORLEST KI KELL VENNI MAJD
//                b_compeetingstrategies   - NINCS ELÕKÉSZÍTVE
//          lastopen2_i_m   NINCS
//       
//   
//    BÉPÍTENI:
//       tp, sl, next_price-on limitorder   SAFE
//       ST MP strat,ST bárok vizsgálata.
//       ST több mutató több idõsoron
//       cél,limit,egyéb árak ahol történik valami,  a vizsgálatot ehhez kötni, ritkítani
//       mérni a devizapárok és devizák kitetségét <> competing bot
//       trailing mindig csak az átlag-re v a fölé huzza, ne fixxel
//       
//    FEJLESZTÉS:     
//       hedging máshogy (0-ra , vagy lépésenként)
//       biztonsági kapcs a 0,1 indításra mm nélkül
//       
//    JAVÍTANI:
//       stop_after_nr baromság !!!!!
//       sl_onavgprice ki lehetne venni eleve benne van a section 2black-nél v módosítani hogy tényleg csak az átlagot nézze.
//       sl és tp tényleges megadása biztonsági okokból
//       átlagárhoz a teljes profit, swap, comm figyelembevétele
//       tp beállítás  1 db ordernél is (most csak 2-re mûködik)
//       ultimate_reverse,  delete pending.
//       fallback profit nem mûködik
//       ??  F_set_tp_sl   ultimate_reverse
//
//    KIIRNI: test hossza, darabszám
//+------------------------------------------------------------------+

#property copyright "MP"
#property link      "nincs nem kell"

   extern bool       b_compeetingbot      =true;
   extern bool       b_fivedigitbroker    =true;
   extern bool       b_run_multistrat     =true;
                     
          string     program_name         ="NLV3C12";
   extern bool       strat_1=true;
   extern bool       strat_2=true;   
   extern bool       strat_3=false;    
   extern bool       strat_4=false;    
   extern bool       strat_5=true;   
   extern bool       strat_6=true;      
   extern bool       strat_7=false;   
   extern bool       strat_8=false;   
   extern bool       strat_9=false;   
   extern int        test_strategies_to   =0;                  // 0 nem tesztel   1-7 az adott számú stratégiát teszteli
 
   extern int        MAGIC_Rf             =10061000;           int        MAGIC_Rf_m[10]           ={10061100,10061200,10061300,10061400,10061500,10061600,10061700};
   extern double     maxspread            =2.4;
   extern double     ult_max_loss_percent =50.0; 
   extern int        ult_reverse          =1.0;                double   revkorr;
   extern bool       money_management     =true;
   extern bool       b_aggressive         =false;
   extern int        hidden_equity        =0;   
   extern double     lots                 =0.1;                                                       //1       2        3        4        5       6          7 
   extern double     lots_multipliyer     =3.2;
   extern double     lots_equityperlot    =1000000.0;          double     lots_equityperlot_m[10]  ={48000  ,42000    ,140000  ,69000   ,21000   ,14000   ,190000}; // 
                                                               double     lots_equityperlot_ma[10] ={30000  ,30000    ,30000   ,30000   ,30000   ,30000   ,30000}; // 
         string strat_symbol="USDJPY";                         string strat_symbol_m[10]           ={"USDJPY","USDJPY","USDJPY","USDJPY","USDJPY","USDJPY"};
                                                               int strat_nr=7; int strat_act;      //1      2        3        4        5       6      7 
                                                               bool strat_run[10]                  = {true  ,true    ,true    ,true   ,true   ,true   ,true};
         bool       b_signal2_trading=false;                   bool b_signal2_trading_m[10]        = {false ,false   ,false   ,false  ,false  ,false  ,false};
 
   //  V ---------------------------------------------------------------------------------------------------------------------------------------------------------------   
   //    ------------------ to change ----------------------------------------------------------------------------------------------------------------------------------   

   extern double     martingal    =0.0;                        double     martingal_m[10]          = {0.0   ,0.0     ,0.0     ,0.0    ,0.0    ,0.0    ,0.0};
   extern int        strat_period=0;                           int   strat_period_m[10]            = {5     ,15      ,5       ,1      ,1      ,1      ,1};       

   extern string     Setup_Entry="-------------------" ;  
   extern int        tradinghour_start       =0;               int   tradinghour_start_m[10]       = {12    ,11      ,7       ,23      ,7      ,0      ,7 };
   extern int        tradinghour_end         =0;               int   tradinghour_end_m[10]         = {22    ,23      ,22      ,5       ,22     ,4      ,22};
   extern int        tradinghour             =-1;              int   tradinghour_m[10]             = {-1    ,-1      ,-1      ,-1      ,-1     ,-1     ,-1};
   extern int        tradingfridaytill       =14;              int   tradingfridaytill_m[10]       = {24    ,14      ,14      ,14      ,14     ,14     ,14};
   extern int        tradingdayoyearmax      =352;             int   tradingdayoyearmax_m[10]      = {356   ,356     ,356     ,356     ,356    ,356    ,356};
                     
   extern int        entry_type        =1;                     int entry_type_m[10]                = {1     ,1       ,1       ,1       ,1       ,1       ,1};    //  nyitási stratégia
   extern int        entry_reverse     =1;                     int entry_reverse_m[10]             = {1     ,1       ,1       ,1       ,1       ,1       ,1};
   extern int        entry_ordertype   =1;                     int entry_ordertype_m[10]           = {1     ,1       ,1       ,1       ,1       ,1       ,1};    // 1: instant order  2: limit order   3: stop order   +3 two direction
   extern double     entry_orderbridge =0.0;                   double entry_orderbridge_m[10]      = {0.0   ,0.0     ,0.0     ,0.0     ,0.0     ,0.0     ,0.0};    
   extern int        entry_expire      =120;                   double entry_expire_m[10]           = {0     ,0       ,0       ,0       ,0       ,0       ,0};    
 
   extern double     delayminutes= 0.0;                        double delayminutes_m[10]           ={0.0    ,0.0     ,0.0     ,0.0  ,0.0  ,0.0  ,0.0};
   extern double     delayminutesafterclose= 0.0;              double delayminutesafterclose_m[10] ={0.0    ,0.0     ,0.0     ,0.0  ,0.0  ,0.0  ,0.0};
   extern double     delayminutesafterloss= 0.0;               double delayminutesafterloss_m[10]  ={0.0    ,0.0     ,0.0     ,0.0  ,0.0  ,0.0  ,0.0};
 
   
   extern string     Setup_Building="-------------------" ;  
   extern bool       increase_lots     =false;                 bool  increase_lots_m[10]           ={false  ,false   ,false   ,false   ,false   ,false   ,false};
   extern int        increase_for_every= 3;                    int   increase_for_every_m[10]      ={1      ,1       ,1       ,1       ,1       ,1       ,1}; 
   extern double     increase_percent  =0.1;                   double increase_percent_m[10]       ={1.0    ,1.0     ,1.0     ,1.0     ,1.0     ,1.0     ,1.0};

   extern int        step_type         =1;                     int step_type_m[10]                 ={1      ,1       ,1       ,1       ,1       ,1       ,1};      // 1: átlagáraz  2: épít     3: mind2
   extern int        step_up           =0;                     int step_up_m[10]                   ={20     ,25      ,30      ,35      ,30      ,30      ,30};
   extern int        step_down         =15;                    int step_down_m[10]                 ={20     ,25      ,30      ,35      ,30      ,30      ,30};
   extern int        step_down_first   =15;                    int step_down_first_m[10]           ={20     ,25      ,30      ,35      ,30      ,30      ,30};
   extern int        step_down_minute  =120;                   int step_down_minute_m[10]          ={120    ,120     ,120     ,120     ,120     ,90      ,120};
   extern int        step_max_nr       =3;                     int step_max_nr_m[10]               ={3      ,3       ,3       ,3       ,3       ,3       ,3};
   extern int        step_max_nr_down  =3;                     int step_max_nr_down_m[10]          ={3      ,3       ,3       ,3       ,3       ,3       ,3};
   extern double     step_movegoal     =0.0;                   double step_movegoal_m[10]          ={0.0    ,0.0     ,0.0     ,0.0     ,0.0     ,0.0     ,0.0};
   
   extern double     hedging_openafter    =0;                   double hedging_openafter_m[10]      ={0.0    ,0.0     ,0.0     ,0.0     ,0.0     ,0.0     ,0.0};
   extern double     hedging_losspip      =0.0;                 double  hedging_losspip_m[10]       ={0.0    ,0.0     ,0.0     ,0.0     ,0.0     ,0.0     ,0.0};
   
   extern string     Setup_Profit="-------------------" ;   
   extern double     tp_price          =0.0;                  double tp_price_m[10]                ={0.0    ,0.0     ,0.0     ,0.0     ,0.0     ,0.0     ,0.0};
   extern double     tp_avg            =20.0;                 double tp_avg_m[10]                  ={30.0   ,30.0    ,15.0     ,4.0    ,7.0     ,5.0     ,7.0};           
   extern double     tp                =0.0;                  double tp_m[10]                      ={0.0    ,0.0     ,0.0     ,0.0     ,0.0     ,0.0     ,0.0};
   extern bool       b_letprofitrun    =false;                bool b_letprofitrun_m[10]            ={false  ,false   ,false   ,false   ,false   ,false   ,false};
   extern int        fallbackpip_min    =6;                   int fallbackpip_min_m[10]            ={6      ,12      ,6       ,6       ,6       ,6       ,6};
   extern int        fallbackpip_max    =20;                  int fallbackpip_max_m[10]            ={20     ,40      ,20      ,20      ,20      ,20      ,20};
   extern double     fallbackpercent_max=0.2;                 double fallbackpercent_max_m[10]     ={0.2    ,0.4     ,0.2     ,0.2     ,0.2     ,0.2     ,0.2};
   
   extern string     Setup_Loss="-------------------" ;   
   extern double     max_loss_percent  =50.0;                 double    max_loss_percent_m[10]           ={50.0   ,50.0    ,50.0    ,50.0    ,50.0    ,50.0    ,50.0};      
   extern double     sl_price          =0.0;                  double    sl_price_m[10]                   ={0.0    ,0.0     ,0.0     ,0.0     ,0.0     ,0.0     ,0.0};
   extern double     sl                =0.0;                  double    sl_m[10]                         ={0.0    ,0.0     ,0.0     ,0.0     ,0.0     ,0.0     ,0.0};
   extern double     sl_trail          =0.0;                  double    sl_trail_m[10]                   ={0.0    ,0.0     ,0.0     ,0.0     ,0.0     ,0.0     ,0.0};
   extern double     sl_step           =5.0;                  double    sl_step_m[10]                    ={5.0    ,5.0     ,5.0     ,5.0     ,5.0     ,5.0     ,5.0};        
   extern double     sl_step_first     =30.0;                 double    sl_step_first_m[10]              ={30.0   ,30.0    ,30.0    ,30.0    ,30.0    ,30.0    ,30.0};        
   extern double     sl_onavgprice     =-2000.0;              double    sl_onavgprice_m[10]              ={-2000.0,-2000.0 ,-2000.0 ,-2000.0 ,-2000.0 ,-2000.0 ,-2000.0};
   extern int        trailingstop_after_nr=0;                 int       trailingstop_after_nr_m[10]      ={0      ,0       ,0       ,0       ,0       ,0       ,0};   
   extern int        stop_after_nr=1;                         int       stop_after_nr_m[10]              ={0      ,0       ,0       ,0       ,0       ,0       ,0};   

   extern string     Setup_Exit="-------------------" ;             
   extern double     stop_after_hour_tillsection = 1;         double    stop_after_hour_tillsection_m[10]={1   ,1    ,1    ,1    ,1    ,1    ,1};
   extern double     stop_after_hour = 0;                     double    stop_after_hour_m[10]            ={3   ,3    ,0    ,0    ,2    ,0    ,2};    //0,0,1,0
   extern double     stop_after_hour_minprofit = 0;           double    stop_after_hour_minprofit_m[10]  ={13  ,13   ,0    ,0    ,4    ,0    ,4};
   extern double     stop_after_hour_minloss = 0;             double    stop_after_hour_minloss_m[10]    ={0   ,0    ,0    ,0    ,0    ,0    ,0};
   extern double     stop_after_hour2 = 0;                    double    stop_after_hour2_m[10]           ={4   ,4    ,0    ,0    ,0    ,0    ,0};    //0,0,1,0
   extern double     stop_after_hour_minprofit2 = 0;          double    stop_after_hour_minprofit2_m[10] ={0   ,2    ,0    ,0    ,0    ,0    ,0};
   extern double     stop_after_hour_minloss2 = 0;            double    stop_after_hour_minloss2_m[10]   ={0   ,0    ,0    ,0    ,0    ,0    ,0};
   extern double     stop_after_lastopen_min = 0;             double    stop_after_lastopen_min_m[10]   ={0   ,0    ,0    ,0    ,0    ,0    ,0};
   extern double     stop_after_lastopen_minprofit = 0;       double    stop_after_lastopen_minprofit_m[10]   ={0   ,0    ,0    ,0    ,0    ,0    ,0};
   extern double     stop_after_lastopen_maxprofit = 0;       double    stop_after_lastopen_maxprofit_m[10]   ={0   ,0    ,0    ,0    ,0    ,0    ,0};
   extern double     stop_st3_out= 0;                         double    stop_st3_out_m[10]               ={0   ,0    ,0    ,0    ,0    ,0    ,0}; 

   
   extern string     Entry_type_nr_1="-------------------" ;
   extern double     signal_atr_max    =1000.0;                double     signal_atr_max_m[10]        ={1000.0 ,1000.0  ,1000.0  ,1000.0  ,1000.0  ,1000.0  ,1000.0};
   extern double     signal_atr_min    =0.0;                   double     signal_atr_min_m[10]        ={0.0    ,0.0     ,0.0     ,0.0     ,0.0     ,0.0     ,0.0};
   extern int        atr_period        =30;                    int        atr_period_m[10]            ={30     ,30      ,30      ,30      ,30      ,30      ,30};
   
   extern double     signal_adx_limit  =40.0;                  double     signal_adx_limit_m[10]      ={40.0   ,45.0    ,42.0    ,42.0    ,42.0    ,0.0     ,40.0};
   extern double     signal_adx_max    =100.0;                 double     signal_adx_max_m[10]        ={100.0  ,100.0   ,100.0   ,100.0   ,100.0   ,100.0   ,100.0};        ///new!!!!
   extern int        adx_period        =30;                    int        adx_period_m[10]            ={30     ,20      ,30      ,30      ,30      ,30      ,30};
   extern double     signal_adx_limit2 =45.0;                  double     signal_adx_limit2_m[10]     ={0      ,0       ,0       ,0       ,0       ,0       ,0};
   extern int        adx_period2       =20;                    int        adx_period2_m[10]           ={20     ,20      ,20      ,20      ,20      ,20      ,20};
   extern double     signal_stoch_down =100.0;                 double     signal_stoch_down_m[10]    ={100.0  ,100.0   ,100.0   ,100.0   ,100.0   ,100.0   ,100.0};
   extern int        stoch_period      =30;                    int        stoch_period_m[10]             ={30     ,30      ,30      ,30      ,30      ,30      ,30};
   extern double     rsi_limit_down    =100.0;                 double     rsi_limit_down_m[10]        ={100.0  ,30.0    ,27.0    ,30.0    ,24.0    ,20.0    ,100.0};
   extern double     rsi_min_down      =0.0;                   double     rsi_min_down_m[10]         ={0.0    ,0.0     ,0.0     ,0.0     ,0.0     ,0.0     ,0.0};         //new!!! min down value to buy
   extern int        rsi_period        =30;                    int        rsi_period_m[10]            ={30     ,30      ,30      ,20      ,30      ,30      ,30};
   extern int        bool_dev          =2;                     int        bool_dev_m[10]              ={2      ,2       ,0       ,2       ,2       ,0       ,3};
   extern int        bool_period       =30;                    int        bool_period_m[10]           ={20     ,30      ,30      ,20      ,20      ,20      ,30};
   extern int        bool_dev2         =0;                     int        bool_dev2_m[10]             ={0      ,0       ,0       ,0       ,0       ,0       ,0};
   extern int        bool_period2      =30;                    int        bool_period2_m[10]          ={20     ,20      ,20      ,20      ,20      ,20      ,20};
   extern int        bool_dev3         =0;                     int        bool_dev3_m[10]             ={0      ,0       ,0       ,0       ,0       ,0       ,0};
   extern int        bool_period3      =30;                    int        bool_period3_m[10]          ={20     ,20      ,20      ,20      ,20      ,20      ,20};



   extern string  Entry_type_nr_1_extra="-------------------" ;
   extern int     stepmin1= 0;                                 int         stepmin1_m[10]             ={0      ,0       ,0       ,0    ,0    ,0    ,0};
   extern double  steppip1= 0.0;                               double      steppip1_m[10]             ={0      ,0       ,0       ,0    ,0    ,0    ,0};
   extern int     stepmin2= 0;                                 int         stepmin2_m[10]             ={0      ,0       ,0       ,0    ,0    ,0    ,0};
   extern double  steppip2= 0.0;                               double      steppip2_m[10]             ={0      ,0       ,0       ,0    ,0    ,0    ,0};
   extern int     stepmin3= 0;                                 int         stepmin3_m[10]             ={0      ,0       ,0       ,0    ,0    ,0    ,0};
   extern double  steppip3= 0.0;                               double      steppip3_m[10]             ={0      ,0       ,0       ,0    ,0    ,0    ,0};

   extern string  Entry_type_nr_3="-------------------" ;
   extern double     st3_limit=40.0;                           double     st3_limit_m[10]             ={0.0    ,0.0     ,0.0     ,0.0  ,0.0  ,0.0  ,0.0};


   extern string   Other_single_setting="-------------------" ;
   /* */extern bool     set_hours=false;
   
//   extern string     Settings_str3="-------------------" ;
//   extern int     strat_period2= 60;                           int         strat_period2_m[10]        ={60     ,60      ,60      ,60   ,60   ,60   ,60};
//   extern int     str3_period= 30;                             int         str3_period_m[10]          ={3      ,3       ,3       ,3    ,3    ,3    ,3};
//   extern double  str3_diff = 15;                              double      str3_diff_m[10]            ={0.0    ,0.0     ,0.0     ,0.0  ,0.0  ,0.0  ,0.0};
  // lent is ki van szedve 
  
   
//---------------- CORE_SYSTEM -------------------------------
//------------------------------------------------------------

#import "mt4_helper_v0101.dll"
  string h_currtimelabel();
#import
   
   //---------------- Testing -----------------------------------
   extern string     Test_settings="-------------------" ;
   extern bool       test_entry_order_type=false;    // a bridge és a time nem a multistratból jön teszt esetén
   extern bool       test_record_curr_stat=true;
          double     test_data[14];
   extern string     tde="";  // test delimiter
   extern bool       test_lines=false;   
   extern bool       tester_createrfile=false;
   extern bool       tester_openfile=false;
   extern int        tester_openfilenr=0;
          bool       tester_firstw=false;
   
      
          string     tester_file_namew,tester_file_namer,tester_currtimelabel;
          int        tester_filew,tester_filer;   
          double     tester_ineq,tester_maxbal,tester_maxdd,tester_maxddp,tester_maxddpip;
          datetime   tester_dfrom,tester_dto;
          string     tester_pnames[50];         //   <---nincs használva
          string     tester_pdata[50];          //   <---nincs használva        
   extern string     tester_codein="";
          int        i_max_position,i_nr_tr,i_nr_tr2,
                     i_max_length,i_total_length,i_last_length;
          
   //---- skip variables ----------------------------------------
   
   bool skip_checkopen,skip_str3_calc;
   
   
   //---- helper variables --------------------------------------
   
   int         signal1=0;                    int      signal1_m[10]        ={0   ,0    ,0    ,0    ,0    ,0};
   double      signal1_price=0.0;            double   signal1_price_m[10]  ={0.0 ,0.0  ,0.0  ,0.0  ,0.0  ,0.0};
   double      signal1_pricem=0.0;           double   signal1_pricem_m[10] ={0.0 ,0.0  ,0.0  ,0.0  ,0.0  ,0.0};
   double      signal1_adxm=0.0;             double   signal1_adxm_m[10]   ={0.0 ,0.0  ,0.0  ,0.0  ,0.0  ,0.0};
   datetime    signal1_time;                 datetime signal1_time_m[10];
   datetime    signal1_timee;                datetime signal1_timee_m[10];    //ezt használjuk arra ha nem tud kötni
                                             datetime lastopen_i_m[10];       //ezt használjuk arra ha nem tud kötni
                                             datetime lastclose_i_m[10];      //ezt használjuk arra ha nem tud kötni 
                                             datetime lastloss_i_m[10];      //ezt használjuk arra ha nem tud kötni 
   int         last_ticket;                  int      last_ticket_i_m[10];
                                             bool     open_bool_i_m[10]    ={false,false,false,false,false,false,false,false,false,false};
                                             int      open_nr_i_m[10]    ={0,0,0,0,0,0,0,0,0,0};
   
   int         signal2=0;                    int      signal2_m[10]        ={0   ,0    ,0    ,0    ,0    ,0};

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
   double            st3_tick[100];
   double            st3_tick_ch[100];
   double            st3_dir;
         
   double   set_hour[24]={  0,0,0,1,
                            1,1,1,1,
                            0,1,1,0,
                            1,0,1,1,
                            1,0,1,1,
                            1,0,0,0  };
   double   hour_reverse=1;
      
   int               total=0;
   int               order_send=0;
   double            profitmaxpip,profitminpip,profitactpip,profitfallback,initialequity, bestprice;
   double            nextprice,next_sl,next_tp;  
   
   string            file_name;
   int               file;

//--------------------------------------------------------------------------------------------------------
//----------------  PROGRAM RUN  -------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------

int init()
  {   if ((IsTesting() || IsOptimization())&& tester_openfile==true) F_tester_file(2,0);     // 1: write    2:read  //  0: open file   1: read-write 2: close
      F_init_5digitstep(); maxspread*=d5korr;
         if (test_entry_order_type==true) entry_orderbridge *=d5korr;      
      F_init_lastopen();
      F_check_open(true); 
      //file_name = program_name + Symbol() + Period(); 
      file_name = program_name +".csv";
      if (IsTesting() && !IsOptimization()) 
         {  file=FileOpen(file_name,FILE_CSV|FILE_WRITE,CharToStr(9));
            FileWrite(file,"ticket"+tde,"magic"+tde,"direction"+tde,"number"+tde,"posopen"+tde,"wday"+tde,"minutes"+tde,"hour"+tde,"day"+tde,"closereason"+tde,"profitactpip"+tde,"profitmaxpip"+tde,"profitminpip"+tde,"profitfallback"+tde,
            "RSIM1"+tde,"RSIM5"+tde,"RSIH1"+tde,"RSID1"+tde,"ATRM1"+tde,"ATRM5"+tde,"ATRH1"+tde,"ATRD1"+tde,"ADXM1"+tde,"ADXM5"+tde,"ADXH1"+tde,"ADXD1"+tde); 
         }
      if (IsOptimization()){ file=FileOpen(file_name+"_OP",FILE_CSV|FILE_READ|FILE_WRITE,CharToStr(9)); FileSeek(file, 0, SEEK_END);}
      F_display_init();      
      if (b_run_multistrat==false) {strat_symbol=Symbol();} // strat_period=Period();}
      strat_run[0]=strat_1;
      strat_run[1]=strat_2;
      strat_run[2]=strat_3;
      strat_run[3]=strat_4;
      strat_run[4]=strat_5;
      strat_run[5]=strat_6;
      strat_run[6]=strat_7;
      strat_run[7]=strat_8;
      strat_run[8]=strat_9;
      if (test_strategies_to!=0) for (int i=0;i<=9;i++) { if(i==test_strategies_to) strat_run[i-1]=true; else strat_run[i-1]=false;}
      lastopen=TimeCurrent()-5*60;
      if (money_management==true) lots=NormalizeDouble((AccountEquity()-hidden_equity)/lots_equityperlot*lots_multipliyer,2); lots2=lots;    
      HideTestIndicators(true);
      tester_firstw=true; if ((IsTesting() || IsOptimization()) && tester_createrfile==true && b_run_multistrat==false) {F_tester_file(1,0); }   // 1: write    2:read  //  0: open file   1: read-write 2: close
      if (set_hours==false || b_run_multistrat==true) for (int cnt=0;cnt<=23;cnt++) set_hour[cnt]=1;
   return(0);  }


int deinit()
  {if (IsTesting() || IsOptimization()) 
      FileWrite(file,Symbol(),strat_period,"entry",entry_type," ",entry_ordertype," opened:",i_nr_tr ,"opened2:",i_nr_tr2,"LONGEST:",NormalizeDouble(i_max_length/60/60,2),"TOTALhour:" ,NormalizeDouble(i_total_length/60/60,2)); 
      FileClose(file);  
      if ((IsTesting() || IsOptimization()) && tester_createrfile==true) 
         {F_tester_file(1,1); F_tester_file(1,2);  }   // 1: write    2:read  //  0: open file   1: read-write 2: close
      if ((IsTesting() || IsOptimization()) && tester_openfile==true) F_tester_file(2,2);  // 1: write    2:read  //  0: open file   1: read-write 2: close
      HideTestIndicators(false);
   return(0);  }


int start()
  {
   if ((StringSubstr(Symbol(),0,6)!=strat_symbol && IsTesting()==false && IsOptimization()==false)) { F_display_alert(); return(0);}     
   F_display(); 
   F_skip(1);     
   F_check_open(false);
   F_always_calc();
   if (open_bool==false && b_run_multistrat==false) 
      {  F_set_signal1();            
         F_open_now(signal2*signal1,entry_ordertype); }   
      
   if (open_bool==false && b_run_multistrat==true) 
         for (int j=0;j<=strat_nr-1;j++)
            if (strat_run[j]==true && open_bool==false)
            {  F_setup_multistrat(j); 
               F_setup_multisignal(j,1);
               F_set_signal1();               
               F_open_now(signal2*signal1,entry_ordertype);
               F_setup_multisignal(j,-1);
               }
      if ((IsTesting() || IsOptimization()) && tester_createrfile==true && b_run_multistrat==true && test_strategies_to!=0 && tester_firstw==true) 
      { tester_firstw=false; F_tester_file(1,0);}
               

   if (open_bool==true) 
      {  //F_change();
            signal1=0; signal1_m[0]=0;signal1_m[1]=0;signal1_m[2]=0;signal1_m[3]=0;signal1_m[4]=0;
         F_set_tp_sl();
         F_hedge();         
         F_close(open_type);
         F_close_pending(); 
         //if (step_type==1 && IsTesting()==false) F_change();       
         //if (step_type==2 && IsTesting()==false) F_change_trailing();                        
         if (trailingstop_after_nr>=1 && IsTesting()==false && open_nr>=trailingstop_after_nr) F_change_trailing();                        
         F_build();  
         //F_change();
         F_skip_nextlevels();            
         }         
   return(0);
  }
 
 
 //----------- FUNCTIONS -------------------------------------------------------------------------------------------

int F_signal(int entry_ty)
   {       
   if (    (tradinghour_start<tradinghour_end && (TimeHour(TimeCurrent())<tradinghour_start || TimeHour(TimeCurrent())>=tradinghour_end))
                      ||(tradinghour_end <tradinghour_start && (TimeHour(TimeCurrent())<tradinghour_start && TimeHour(TimeCurrent())>=tradinghour_end))) return(0);
   if (Hour()!=tradinghour && tradinghour>=0) return(0);
   if (DayOfYear()>tradingdayoyearmax) return(0);
   if (DayOfWeek()>=5 && Hour()>=tradingfridaytill) return(0);   
   if (DayOfWeek()==0 || DayOfWeek()==6) return(0);   
   if (strat_period==0) strat_period=Period();
   hour_reverse=set_hour[Hour()];
   if (hour_reverse==0) return(0);
       
   if (entry_ty==1) if (TimeCurrent()-lastopen>=delayminutes*60 && TimeCurrent()-lastclose>=delayminutesafterclose*60 && TimeCurrent()-lastloss>=delayminutesafterloss*60
            && iADX(Symbol(),strat_period,adx_period,PRICE_CLOSE,MODE_MAIN,1) >= signal_adx_limit
            && iADX(Symbol(),strat_period,adx_period,PRICE_CLOSE,MODE_MAIN,1) <= signal_adx_max
            && iADX(Symbol(),strat_period,adx_period2,PRICE_CLOSE,MODE_MAIN,1)>= signal_adx_limit2   
            && iATR(Symbol(),strat_period,atr_period,1)>=signal_atr_min*Point
            && iATR(Symbol(),strat_period,atr_period,1)<=signal_atr_max*Point  )
         {     if (
                  (bool_dev==0 || Close[1]> iBands(Symbol(),strat_period,bool_period,bool_dev,0,PRICE_CLOSE,MODE_UPPER,1)) 
                  && (bool_dev2==0 || Close[1]> iBands(Symbol(),strat_period,bool_period2,bool_dev2,0,PRICE_CLOSE,MODE_UPPER,1)) 
                  && (bool_dev3==0 || Close[1]> iBands(Symbol(),strat_period,bool_period3,bool_dev3,0,PRICE_CLOSE,MODE_UPPER,1)) 
                  &&(rsi_period==0 || iRSI(Symbol(),strat_period,rsi_period,PRICE_CLOSE,1)>=100.0-rsi_limit_down)
                  &&(rsi_period==0 || iRSI(Symbol(),strat_period,rsi_period,PRICE_CLOSE,1)<=100.0-rsi_min_down)
                  &&(stoch_period==0  || iStochastic(Symbol(),strat_period,20,10,3,MODE_SMA,0,MODE_MAIN,1)>=100.0-signal_stoch_down)
                  &&(stepmin1==0 || (steppip1>0 && Close[0]> Close[stepmin1]+steppip1*Point) || (steppip1<0 && Close[0]< Close[stepmin1]+steppip1*Point))
                  &&(stepmin2==0 || (steppip2>0 && Close[0]> Close[stepmin2]+steppip2*Point) || (steppip2<0 && Close[0]< Close[stepmin2]+steppip2*Point))
                  &&(stepmin3==0 || (steppip3>0 && Close[0]> Close[stepmin3]+steppip3*Point) || (steppip3<0 && Close[0]< Close[stepmin3]+steppip3*Point))
                  //&&(str3_diff==0 || (Close[0]>iHigh(Symbol(),strat_period2,iHighest(Symbol(),strat_period2,MODE_HIGH,str3_period,1))+str3_diff*Point))
                  ) return(-1*entry_reverse*ult_reverse*hour_reverse);
               if ( 
                  (bool_dev==0 || Close[1]< iBands(Symbol(),strat_period,bool_period,bool_dev,0,PRICE_CLOSE,MODE_LOWER,1)) 
                  && (bool_dev2==0 || Close[1]< iBands(Symbol(),strat_period,bool_period2,bool_dev2,0,PRICE_CLOSE,MODE_LOWER,1)) 
                  && (bool_dev3==0 || Close[1]< iBands(Symbol(),strat_period,bool_period3,bool_dev3,0,PRICE_CLOSE,MODE_LOWER,1)) 
                  &&(rsi_period==0 || iRSI(Symbol(),strat_period,rsi_period,PRICE_CLOSE,1)<=rsi_limit_down)
                  &&(rsi_period==0 || iRSI(Symbol(),strat_period,rsi_period,PRICE_CLOSE,1)>=rsi_min_down)                  
                  &&(stoch_period==0  || iStochastic(Symbol(),strat_period,20,10,3,MODE_SMA,0,MODE_MAIN,1)<=signal_stoch_down)                                   
                  &&(steppip1==0 || (steppip1>0 && Close[0]< Close[stepmin1]-steppip1*Point) || (steppip1<0 && Close[0]> Close[stepmin1]-steppip1*Point))
                  &&(steppip2==0 || (steppip2>0 && Close[0]< Close[stepmin2]-steppip2*Point) || (steppip2<0 && Close[0]> Close[stepmin2]-steppip2*Point))
                  &&(steppip3==0 || (steppip3>0 && Close[0]< Close[stepmin3]-steppip3*Point) || (steppip3<0 && Close[0]> Close[stepmin3]-steppip3*Point))
                  //&&(str3_diff==0 || (Close[0]<iLow(Symbol(),strat_period2,iLowest(Symbol(),strat_period2,MODE_LOW,str3_period,1))-str3_diff*Point))
                  ) return(1*entry_reverse*ult_reverse*hour_reverse);}
                  
   if (entry_ty==2) if (TimeCurrent()-lastopen>=delayminutes*60 && TimeCurrent()-lastclose>=delayminutesafterclose*60 && TimeCurrent()-lastloss>=delayminutesafterloss*60
            && iADX(Symbol(),strat_period,adx_period,PRICE_CLOSE,MODE_MAIN,1) >= signal_adx_limit
            && iADX(Symbol(),strat_period,adx_period,PRICE_CLOSE,MODE_MAIN,1) <= signal_adx_max
            && iADX(Symbol(),strat_period,adx_period2,PRICE_CLOSE,MODE_MAIN,1)>= signal_adx_limit2   
            && iATR(Symbol(),strat_period,atr_period,1)>=signal_atr_min*Point
            && iATR(Symbol(),strat_period,atr_period,1)<=signal_atr_max*Point  )
         {     if ( 
                  (bool_dev==0 || Close[1]> iBands(Symbol(),strat_period,bool_period,bool_dev,0,PRICE_CLOSE,MODE_UPPER,1)) 
                  && (bool_dev2==0 || Close[1]> iBands(Symbol(),strat_period,bool_period2,bool_dev2,0,PRICE_CLOSE,MODE_UPPER,1)) 
                  && (bool_dev3==0 || Close[1]> iBands(Symbol(),strat_period,bool_period3,bool_dev3,0,PRICE_CLOSE,MODE_UPPER,1)) 
                  &&(rsi_period==0 || iRSI(Symbol(),strat_period,rsi_period,PRICE_CLOSE,1)<=rsi_limit_down)
                  &&(rsi_period==0 || iRSI(Symbol(),strat_period,rsi_period,PRICE_CLOSE,1)>=rsi_min_down)                  
                  &&(stoch_period==0  || iStochastic(Symbol(),strat_period,20,10,3,MODE_SMA,0,MODE_MAIN,1)<=signal_stoch_down)                                   
                  &&(stepmin1==0 || (steppip1>0 && Close[0]> Close[stepmin1]+steppip1*Point) || (steppip1<0 && Close[0]< Close[stepmin1]+steppip1*Point))
                  &&(stepmin2==0 || (steppip2>0 && Close[0]> Close[stepmin2]+steppip2*Point) || (steppip2<0 && Close[0]< Close[stepmin2]+steppip2*Point))
                  &&(stepmin3==0 || (steppip3>0 && Close[0]> Close[stepmin3]+steppip3*Point) || (steppip3<0 && Close[0]< Close[stepmin3]+steppip3*Point))
                  //&&(str3_diff==0 || (Close[0]>iHigh(Symbol(),strat_period2,iHighest(Symbol(),strat_period2,MODE_HIGH,str3_period,1))+str3_diff*Point))
                  ) return(1*entry_reverse*ult_reverse*hour_reverse);
               if ( 
                  (bool_dev==0 || Close[1]< iBands(Symbol(),strat_period,bool_period,bool_dev,0,PRICE_CLOSE,MODE_LOWER,1)) 
                  && (bool_dev2==0 || Close[1]< iBands(Symbol(),strat_period,bool_period2,bool_dev2,0,PRICE_CLOSE,MODE_LOWER,1)) 
                  && (bool_dev3==0 || Close[1]< iBands(Symbol(),strat_period,bool_period3,bool_dev3,0,PRICE_CLOSE,MODE_LOWER,1)) 
                  &&(rsi_period==0 || iRSI(Symbol(),strat_period,rsi_period,PRICE_CLOSE,1)>=100.0-rsi_limit_down)
                  &&(rsi_period==0 || iRSI(Symbol(),strat_period,rsi_period,PRICE_CLOSE,1)<=100.0-rsi_min_down)
                  &&(stoch_period==0  || iStochastic(Symbol(),strat_period,20,10,3,MODE_SMA,0,MODE_MAIN,1)>=100.0-signal_stoch_down)
                  &&(steppip1==0 || (steppip1>0 && Close[0]< Close[stepmin1]-steppip1*Point) || (steppip1<0 && Close[0]> Close[stepmin1]-steppip1*Point))
                  &&(steppip2==0 || (steppip2>0 && Close[0]< Close[stepmin2]-steppip2*Point) || (steppip2<0 && Close[0]> Close[stepmin2]-steppip2*Point))
                  &&(steppip3==0 || (steppip3>0 && Close[0]< Close[stepmin3]-steppip3*Point) || (steppip3<0 && Close[0]> Close[stepmin3]-steppip3*Point))
                  //&&(str3_diff==0 || (Close[0]<iLow(Symbol(),strat_period2,iLowest(Symbol(),strat_period2,MODE_LOW,str3_period,1))-str3_diff*Point))
                  ) return(-1*entry_reverse*ult_reverse*hour_reverse);}

   if (entry_ty==3) if (TimeCurrent()-lastopen>=delayminutes*60 && TimeCurrent()-lastclose>=delayminutesafterclose*60 && TimeCurrent()-lastloss>=delayminutesafterloss*60)
         {     if (st3_dir>=st3_limit) return(1*entry_reverse*ult_reverse*hour_reverse);
               if (st3_dir<=-st3_limit) return(-1*entry_reverse*ult_reverse*hour_reverse);}

     return(0);   
   }
   
   
void F_set_signal1()
   {     signal_tempvalue=F_signal(entry_type); signal_tempvalueadx=iADX(Symbol(),strat_period,adx_period,PRICE_CLOSE,MODE_MAIN,1);
         if ((signal1==0 && signal_tempvalue!=0) || signal1== -signal_tempvalue || (signal1!=0 && signal_tempvalue==0 && b_signal2_trading==false)) 
            { signal1_price=Close[0]; signal1_pricem=Close[0]; signal1_adxm=signal_tempvalueadx; signal1_time=TimeCurrent(); signal1=signal_tempvalue; }
          
         if (signal1!=0) 
            {  if (signal1==1 && Close[0]<signal1_pricem) signal1_pricem=Close[0];
               if (signal1==-1 && Close[0]>signal1_pricem) signal1_pricem=Close[0];
               if (signal1_adxm<signal_tempvalueadx) signal1_adxm=signal_tempvalueadx; }

         signal2=0;       
         if (b_signal2_trading==false) signal2=1;
         if (b_signal2_trading==true 
               && signal_tempvalueadx<signal1_adxm-1 
               && TimeCurrent()-signal1_time<3*60*60
               ) signal2=1; 
   }  
    
 
//----------- Body -------------------------------------------------------------------------------------------  
/*void F_check_signal1()
   {  signal_exists=false;
      if(signal1!=0) signal_exists=true;
      for (int j2=0;j2<=strat_nr-1;j2++) if (signal1_m[j2]!=0 && strat_run[j2]==true) signal_exists=true;   }*/     
      
void F_skip(int skip_section)
   {  if (skip_section==1)
      {  skip_checkopen=false;
         if (OrdersTotal()==0 && open_bool==false  && pending_bool==false) skip_checkopen=true;
         if (Ask<nextlevel_up && Bid>nextlevel_down && open_bool==true) skip_checkopen=true;
         
         skip_str3_calc=false;
         if (entry_type!=3 && b_run_multistrat==false) skip_str3_calc=true;
         return(0);
      }
      
      if (skip_section==2)
      {  
         return(0);
      }
   return(0);}      
            


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
         
   return(0);
   }   


void F_init_lastopen()
   {  total=OrdersHistoryTotal();
         for(int j=0;j<=strat_nr-1;j++) lastopen_i_m[j]=TimeCurrent()-60*60*24*5; lastopen=TimeCurrent()-60*60*24*5;      
         for(int cnt=0;cnt<=total;cnt++)
         {  OrderSelect(cnt, SELECT_BY_POS,MODE_HISTORY);
            if (b_run_multistrat==true) for (j=0;j<=strat_nr-1;j++)
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
   return(0);}

   
void F_check_open(bool init)
   {  if (skip_checkopen==true) return(0); 
      total=OrdersTotal(); 
         open_bool=false; pending_bool=false; open_nr=0; open_hlp1=0.0;open_hlp2=0.0; open_type=0; open_last_price=0.0; 
         open_first_price=0.0;open_avgprice=0.0;open_total_lot=0.0;  open_total_profit=0.0; pending_nr=0;
         open_bool_i_m[10]={false,false,false,false,false,false,false,false,false,false};    //   <<---------------- parallel open
         open_nr_i_m[10]  ={0,0,0,0,0,0,0,0,0,0};                                            //   <<---------------- parallel open
         section=0;
                        
      if (total>0)
     {for(int cnt=0;cnt<=total;cnt++)
     {
      OrderSelect(cnt, SELECT_BY_POS,MODE_TRADES);
            if (init==true)
            for (int j=0;j<=strat_nr-1;j++)
            if (strat_run[j]==true && (MAGIC_Rf_m[j]==OrderMagicNumber() || MAGIC_Rf_m[j]+1==OrderMagicNumber()))
            {F_setup_multistrat(j);}
      if ((OrderMagicNumber()==MAGIC_Rf || OrderMagicNumber()==MAGIC_Rf+0) && OrderSymbol()==Symbol() && OrderType()<2)      // symbol changed
      {  open_bool=true;        
         open_nr++;
         open_bool_i_m[strat_act]=true; open_nr_i_m[strat_act]++; //   <<---------------- parallel open         
         open_type=(OrderType()*(-2)+1)*ult_reverse;
         if (ult_reverse==-1) revkorr=(Bid-Ask)*open_type; else revkorr=0;  //??
         open_array_ticket[open_nr]=OrderTicket();
         open_array_lot[open_nr]=OrderLots();
         open_total_lot+=OrderLots();
         open_total_profit+=(OrderProfit()+OrderSwap()+OrderCommission())*ult_reverse;
         open_array_price[open_nr]=OrderOpenPrice()+revkorr;
         open_hlp1+=OrderLots();
         open_hlp2+=OrderLots()*(OrderOpenPrice()+revkorr);
         
         if (open_last_price==0) {open_last_price=OrderOpenPrice()+revkorr; lastopen=OrderOpenTime(); lastopen2=OrderOpenTime();}  // ez!!
         if (OrderOpenTime()>lastopen2) { open_last_price=OrderOpenPrice()+revkorr; lastopen2=OrderOpenTime();}
         if (open_first_price==0) {open_first_price=OrderOpenPrice()+revkorr; lastopen=OrderOpenTime();}
         if (OrderOpenTime()<lastopen) { open_first_price=OrderOpenPrice()+revkorr;lastopen=OrderOpenTime(); }
         if (tp_price==0 && OrderTakeProfit()!=0)   tp_price=OrderTakeProfit();
         if (sl_price==0 && OrderStopLoss()!=0)     sl_price=OrderStopLoss();        
         if (step_type==1)  {nextprice=open_last_price-open_type*step_down*Point; next_sl=sl_price+open_type*sl_step*Point; }
         if (step_type==2)  {nextprice=open_last_price+open_type*step_up*Point; next_sl=sl_price+open_type*sl_step*Point; }
         if (OrderOpenTime()<lastopen) lastopen=OrderOpenTime();
         if (OrderOpenTime()>lastopen2) lastopen2=OrderOpenTime();
         if (OrderOpenTime()>lastopen_i_m[j]) lastopen_i_m[j]=OrderOpenTime(); 
         last_ticket_i_m[j]=OrderTicket();last_ticket=OrderTicket();
         if (OrderLots()>lots2 || lots2==0) lots2=OrderLots();
      }      
      if ((OrderMagicNumber()==MAGIC_Rf || OrderMagicNumber()==MAGIC_Rf+0 || OrderMagicNumber()==MAGIC_Rf-0) && OrderSymbol()==Symbol() && OrderType()>=2)      // symbol changed
         {  pending_bool=true;pending_nr++;pending_array_ticket[pending_nr]=OrderTicket(); }
      if (OrderMagicNumber()==MAGIC_Rf+1 && OrderSymbol()==Symbol() && OrderType()<2)      // symbol changed
         {  hedging_bool=true;hedging_nr++;hedging_array_ticket[hedging_nr]=OrderTicket(); }
         
     }
     if (open_hlp1>0) open_avgprice=open_hlp2/open_hlp1;
     pricegoal=open_avgprice+open_type*tp_avg2*Point;   
         if (open_type==1)  profitactpip=Bid-open_avgprice;          
         if (open_type==-1) profitactpip=open_avgprice-Ask;  
         if (open_type==1 && (Bid>bestprice || bestprice==0)) bestprice=Bid;
         if (open_type==-1 && (Ask<bestprice || bestprice==0)) bestprice=Ask;
         if (profitactpip>profitmaxpip) profitmaxpip=profitactpip;
         if (profitactpip<profitminpip) profitminpip=profitactpip;         
         profitfallback=profitmaxpip-profitactpip;
            if (open_nr>i_max_position) i_max_position=open_nr;
            if (initialequity==0) initialequity=AccountBalance();
    }
    if (open_bool==false) b_lezar_signal=false;
    if (open_nr>1)
      {  if (open_last_price*open_type<open_avgprice*open_type) section=1;
         if (open_last_price*open_type>open_avgprice*open_type) section=2; }
         
      if (AccountEquity()>tester_maxbal) tester_maxbal=AccountEquity();
      if (tester_maxbal-AccountEquity()>tester_maxdd) tester_maxdd=tester_maxbal-AccountEquity();
      if (1-AccountEquity()/tester_maxbal>tester_maxddp) tester_maxddp=1-AccountEquity()/tester_maxbal;  
      if (open_bool==true && (open_first_price-Bid)/Point*open_type>tester_maxddpip) tester_maxddpip=(open_first_price-Bid)/Point;
      if (open_bool==true && (open_first_price-Ask)/Point*open_type>tester_maxddpip) tester_maxddpip=(open_first_price-Ask)/Point;                       
   }


void F_always_calc()
   {
   if (skip_str3_calc==false) { 
      st3_dir=0.0;
      for (int cnt2=50;cnt2>=1;cnt2--)
         {
          st3_tick[cnt2]=st3_tick[cnt2-1];
          st3_tick_ch[cnt2]=st3_tick_ch[cnt2-1];
          if (st3_dir>0 && st3_tick_ch[cnt2]>=0)  st3_dir+=1;
          if (st3_dir==0  && st3_tick_ch[cnt2]>0)   st3_dir+=1;
          if (st3_dir<0 && st3_tick_ch[cnt2]<=0)  st3_dir-=1;
          if (st3_dir==0  && st3_tick_ch[cnt2]<0)   st3_dir-=1;          
          if (st3_dir*st3_tick_ch[cnt2]<0)      st3_dir=0;
         }
      st3_tick[0]=Close[0];
      st3_tick_ch[0]=(st3_tick[0]-st3_tick[1])/Point;
          if (st3_dir>0 && st3_tick_ch[cnt2]>=0)  st3_dir+=1;
          if (st3_dir==0  && st3_tick_ch[cnt2]>0)   st3_dir+=1;
          if (st3_dir<0 && st3_tick_ch[cnt2]<=0)  st3_dir-=1;
          if (st3_dir==0  && st3_tick_ch[cnt2]<0)   st3_dir-=1;          
          if (st3_dir*st3_tick_ch[cnt2]<0)      st3_dir=0;        }
   return(0);}


void F_set_lots_martingal()
   {  
      if (lastprofit==0) {
         OrderSelect(last_ticket, SELECT_BY_TICKET,MODE_HISTORY); 
         datetime last_ticketopentime=OrderCloseTime(); lastprofit+=OrderProfit()+OrderSwap()+OrderCommission();
         for (int i_m=0;i_m<=OrdersHistoryTotal();i_m++)
            {  OrderSelect(i_m,SELECT_BY_POS,MODE_HISTORY);
               if (OrderTicket()!=last_ticket && (OrderCloseTime()<last_ticketopentime+10 && OrderCloseTime()>last_ticketopentime-10 ))
                   lastprofit+=OrderProfit()+OrderSwap()+OrderCommission();
            }}
         
      if (martingal>1.0 && lastprofit<0) lots_martingal=OrderLots()*martingal;
      else if (martingal==1.0 && lastprofit<0) lots_martingal=OrderLots();
      else if (money_management==true) lots_martingal=NormalizeDouble((AccountEquity()-hidden_equity)/lots_equityperlot*lots_multipliyer,2);
      else lots_martingal=lots;
   }



void F_open_now(int order_type,int order_type2)
   {  if (order_type==0) {return(0);}
      if (order_type!=0 && b_compeetingbot==true && OrdersTotal()>0)      {signal1_timee=TimeCurrent(); return(0);}
      if (order_type!=0 && b_compeetingbot==false && open_bool==true)     {signal1_timee=TimeCurrent(); return(0);}    //  <<----change for parallel run
      if (order_type!=0 && TimeCurrent()-signal1_timee<=delayminutes*60)  {return(0);}
      if (Ask-Bid > maxspread*Point) {return(0);}
      if (MarketInfo(Symbol(),MODE_SPREAD)>maxspread) {return(0);}
      //if (money_management==true) lots=NormalizeDouble((AccountEquity()-hidden_equity)/lots_equityperlot*lots_multipliyer,2); lots2=lots;
      F_set_lots_martingal(); lots2=lots_martingal;
      F_load_test_data(); //Alert(test_data[1]);
      // instant order      
      if ((order_type2==1 && order_type==1) || order_type2==4)  {  
            open_array_ticket[open_nr+1]=OrderSend(Symbol(),OP_BUY,lots2,Ask,3,0,0,program_name+strat_symbol,MAGIC_Rf,0,Green);  
            open_nr++; lastopen=TimeCurrent(); lastopen2=TimeCurrent();lastclose=TimeCurrent()-24*60*60;  
            profitmaxpip=0.0;profitminpip=0.0;profitactpip=0.0; profitfallback=0.0; tp_avg2=tp_avg; open_bool=true; initialequity=(AccountEquity()-hidden_equity);
            bestprice=Bid;if (step_type==1 && tp_avg!=0) F_change_avgprice();}
      if ((order_type2==1 && order_type==-1) || order_type2==4) {  
            open_array_ticket[open_nr+1]=OrderSend(Symbol(),OP_SELL,lots2,Bid,3,0,0,program_name+strat_symbol,MAGIC_Rf+0,0,Green);   
            open_nr++; lastopen=TimeCurrent(); lastopen2=TimeCurrent();lastclose=TimeCurrent()-24*60*60;  
            profitmaxpip=0.0;profitminpip=0.0;profitactpip=0.0; profitfallback=0.0; tp_avg2=tp_avg; open_bool=true; initialequity=(AccountEquity()-hidden_equity);
            bestprice=Ask;if (step_type==1 && tp_avg!=0) F_change_avgprice();}  
     // limitorder    order_type2 (entry_ordertype=2)
      if (pending_bool==false) {
         if ((order_type2==2 && order_type==1) || order_type2==5)  {  
            pending_array_ticket[pending_nr+1]=OrderSend(Symbol(),OP_BUYLIMIT,lots2,Ask-entry_orderbridge*Point,3,0,0,program_name+strat_symbol,MAGIC_Rf,TimeCurrent()+entry_expire*60,Green); 
            pending_nr++; lastopen=TimeCurrent(); lastopen2=TimeCurrent();lastclose=TimeCurrent()-24*60*60;  
            profitmaxpip=0.0;profitminpip=0.0;profitactpip=0.0; profitfallback=0.0; tp_avg2=tp_avg; pending_bool=true; initialequity=(AccountEquity()-hidden_equity);
            bestprice=0.0; }
         if ((order_type2==2 && order_type==-1) || order_type2==5)  {  
            pending_array_ticket[pending_nr+1]=OrderSend(Symbol(),OP_SELLLIMIT,lots2,Bid+entry_orderbridge*Point,3,0,0,program_name+strat_symbol,MAGIC_Rf+0,TimeCurrent()+entry_expire*60,Green);    
            pending_nr++; lastopen=TimeCurrent(); lastopen2=TimeCurrent();lastclose=TimeCurrent()-24*60*60;  
            profitmaxpip=0.0;profitminpip=0.0;profitactpip=0.0; profitfallback=0.0; tp_avg2=tp_avg; pending_bool=true; initialequity=(AccountEquity()-hidden_equity);
            bestprice=0.0; }
         }
     // stoporder     order_type2 (entry_ordertype=3)
      if (pending_bool==false) { 
         if ((order_type2==3 && order_type==1) || order_type2==6)  {  
            pending_array_ticket[pending_nr+1]=OrderSend(Symbol(),OP_BUYSTOP,lots2,Ask+entry_orderbridge*Point,3,0,0,program_name+strat_symbol,MAGIC_Rf,TimeCurrent()+entry_expire*60,Green);   
            pending_nr++; lastopen=TimeCurrent(); lastopen2=TimeCurrent();lastclose=TimeCurrent()-24*60*60;  
            profitmaxpip=0.0;profitminpip=0.0;profitactpip=0.0; profitfallback=0.0; tp_avg2=tp_avg; pending_bool=true; initialequity=(AccountEquity()-hidden_equity);
            bestprice=0.0; }
         if ((order_type2==3 && order_type==-1) || order_type2==6) {  
            pending_array_ticket[pending_nr+1]=OrderSend(Symbol(),OP_SELLSTOP,lots2,Bid-entry_orderbridge*Point,3,0,0,program_name+strat_symbol,MAGIC_Rf+0,TimeCurrent()+entry_expire*60,Green);    
            pending_nr++; lastopen=TimeCurrent(); lastopen2=TimeCurrent();lastclose=TimeCurrent()-24*60*60;  
            profitmaxpip=0.0;profitminpip=0.0;profitactpip=0.0; profitfallback=0.0; tp_avg2=tp_avg; pending_bool=true; initialequity=(AccountEquity()-hidden_equity);
            bestprice=0.0; }
         }            
      tp_price=0;sl_price=0;F_set_tp_sl();            
      return(0);}


void F_build()
   {  if (open_nr>=step_max_nr) return(0);

     if (open_nr<step_max_nr_down && section<2)    
     if (step_type==1 || step_type==3){         // átlagáraz... akkor épít ha bukóban van
      if (open_type==1) if (Ask<=open_last_price-step_down*Point && Ask<=open_first_price-step_down_first*Point 
         && TimeCurrent()-lastopen2>step_down_minute*60)   
            {if (increase_lots && MathMod(open_nr,increase_for_every)==0) lots2=NormalizeDouble(lots2+lots*increase_percent,2);
            open_nr++;
            if (ult_reverse==1) open_array_ticket[open_nr]=OrderSend(Symbol(),OP_BUY,lots2,Ask,3,0,0,"",MAGIC_Rf,0,Red);  
               else open_array_ticket[open_nr]=OrderSend(Symbol(),OP_SELL,lots2,Bid,3,0,0,"",MAGIC_Rf+0,0,Red);  
            lastopen2=TimeCurrent();
            tp_avg2+=step_movegoal;
            F_check_open(false);F_set_tp_sl(); F_change_avgprice(); F_lines_objects(); }           
      if (open_type==-1) if (Bid>=open_last_price+step_down*Point && Bid>=open_first_price+step_down_first*Point 
         && TimeCurrent()-lastopen2>step_down_minute*60)  
            {if (increase_lots && MathMod(open_nr,increase_for_every)==0) lots2=NormalizeDouble(lots2+lots*increase_percent,2);
            open_nr++;
            if (ult_reverse==1) open_array_ticket[open_nr]=OrderSend(Symbol(),OP_SELL,lots2,Bid,3,0,0,"",MAGIC_Rf+0,0,Red);
               else open_array_ticket[open_nr]=OrderSend(Symbol(),OP_BUY,lots2,Ask,3,0,0,"",MAGIC_Rf,0,Red);  
            lastopen2=TimeCurrent(); 
            tp_avg2+=step_movegoal;
            F_check_open(false);F_set_tp_sl(); F_change_avgprice(); F_lines_objects();            
            }}   
            
     if (open_nr<step_max_nr && (section>1)) 
     if (step_type==2 || step_type==3){         // akkor épít ha nyerõben van
      if (open_type==1) if (Ask>=open_last_price+step_up*Point)   
            {if (increase_lots && MathMod(open_nr,increase_for_every)==0) lots2=NormalizeDouble(lots2+lots*increase_percent,2);
            open_nr++;
            if (ult_reverse==1) open_array_ticket[open_nr]=OrderSend(Symbol(),OP_BUY,lots2,Ask,3,0,0,"",MAGIC_Rf,0,Blue);  
               else open_array_ticket[open_nr]=OrderSend(Symbol(),OP_SELL,lots2,Bid,3,0,0,"",MAGIC_Rf+0,0,Blue);  
            lastopen2=TimeCurrent();
            tp_avg2+=step_movegoal;
            F_check_open(false);F_set_tp_sl(); F_lines_objects(); return(0);}           
      if (open_type==-1) if (Bid<=open_last_price-step_up*Point)  
            {if (increase_lots && MathMod(open_nr,increase_for_every)==0) lots2=NormalizeDouble(lots2+lots*increase_percent,2);
            open_nr++;
            if (ult_reverse==1) open_array_ticket[open_nr]=OrderSend(Symbol(),OP_SELL,lots2,Bid,3,0,0,"",MAGIC_Rf+0,0,Blue);
               else open_array_ticket[open_nr]=OrderSend(Symbol(),OP_BUY,lots2,Ask,3,0,0,"",MAGIC_Rf,0,Blue);  
            lastopen2=TimeCurrent(); 
            tp_avg2+=step_movegoal;
            F_check_open(false);F_set_tp_sl(); F_lines_objects(); return(0); }}   

     if (open_nr<step_max_nr && section<=1)             
     if (step_type==2 || step_type==3){         // akkor épít ha nyerõben van
      if (open_type==1) if (Ask>=open_last_price+step_up*Point && Ask>=open_avgprice+(sl_onavgprice+sl_trail+sl_trail/open_nr+1)*Point)   
            {if (increase_lots && MathMod(open_nr,increase_for_every)==0) lots2=NormalizeDouble(lots2+lots*increase_percent,2);
            open_nr++;
            if (ult_reverse==1) open_array_ticket[open_nr]=OrderSend(Symbol(),OP_BUY,lots2,Ask,3,0,0,"",MAGIC_Rf,0,Black);  
               else open_array_ticket[open_nr]=OrderSend(Symbol(),OP_SELL,lots2,Bid,3,0,0,"",MAGIC_Rf+0,0,Black);  
            lastopen2=TimeCurrent();
            tp_avg2+=step_movegoal;
            F_check_open(false);
            sl_price=open_avgprice+open_type*sl_onavgprice*Point;
            F_set_tp_sl(); F_lines_objects(); }           
      if (open_type==-1) if (Bid<=open_last_price-step_up*Point && Bid<=open_avgprice-(sl_onavgprice+sl_trail+sl_trail/open_nr+1)*Point)  
            {if (increase_lots && MathMod(open_nr,increase_for_every)==0) lots2=NormalizeDouble(lots2+lots*increase_percent,2);
            open_nr++;     
            if (ult_reverse==1) open_array_ticket[open_nr]=OrderSend(Symbol(),OP_SELL,lots2,Bid,3,0,0,"",MAGIC_Rf+0,0,Black);
               else open_array_ticket[open_nr]=OrderSend(Symbol(),OP_BUY,lots2,Ask,3,0,0,"",MAGIC_Rf,0,Black);  
            lastopen2=TimeCurrent(); 
            tp_avg2+=step_movegoal;
            F_check_open(false);
            sl_price=open_avgprice+open_type*sl_onavgprice*Point;
            F_set_tp_sl(); F_lines_objects(); }}   
    return(0);}
   




void F_hedge()
   {  bool close_hedging=false;
      if (open_nr==0 && hedging_nr==0) return(0);
      if (hedging_openafter==0 && hedging_nr==0) return(0);
     
      if (open_nr>0 && hedging_nr==0 && hedging_openafter>0 && open_type==1 && Bid<open_first_price-open_type*ult_reverse*hedging_openafter*Point)
         {OrderSend(Symbol(),OP_SELL,open_total_lot,Bid,3,0,0,"",MAGIC_Rf+1,0,Blue);  return(0);}
      if (open_nr>0 && hedging_nr==0 && hedging_openafter>0 && open_type==-1 && Ask>open_first_price-open_type*ult_reverse*hedging_openafter*Point)
         {OrderSend(Symbol(),OP_BUY,open_total_lot,Ask,3,0,0,"",MAGIC_Rf+1,0,Blue);   return(0);}
      
      if (hedging_nr==0) return(0);
      if (open_nr==0 && hedging_nr>0) close_hedging=true;           
      if (hedging_nr>0 && open_type==1 && Ask>open_first_price-open_type*ult_reverse*(hedging_openafter-hedging_losspip)*Point) close_hedging=true;
      if (hedging_nr>0 && open_type==-1 && Bid<open_first_price-open_type*ult_reverse*(hedging_openafter-hedging_losspip)*Point) close_hedging=true;
      
     
      if (close_hedging==true) 
      {  for (int cnt=0;cnt<=hedging_nr;cnt++)   
         {OrderSelect(hedging_array_ticket[cnt],SELECT_BY_TICKET);
         if (open_type==-1*ult_reverse) OrderClose(OrderTicket(),OrderLots(),Bid,3,Red); 
         if (open_type==1*ult_reverse) OrderClose(OrderTicket(),OrderLots(),Ask,3,Red);    }
         hedging_nr=0;hedging_bool=false;}
      
      return(0);   
   }



void F_set_tp_sl()                                          
   {  double slmin1,slmin2,slmax,sl1,sl2,sl3,sl4,sl5;
      if (open_nr==0) return(0);
      if (tp_price==0 && tp!=0)  tp_price=open_first_price+open_type*tp*Point;
      
      if (sl_price!=0) sl1=sl_price; else sl1=Ask-open_type*2000*d5korr*Point;
      if (sl!=0 && stop_after_nr>=1 && open_nr>=stop_after_nr) sl2=open_first_price-open_type*sl*Point;   
                                                               else sl2=Ask-open_type*2000*d5korr*Point;
      if (sl_trail!=0 && trailingstop_after_nr>=1 && open_nr>=trailingstop_after_nr && (open_nr==1 || section>1)) sl3=open_first_price-open_type*sl_trail*Point; 
                                                               else sl3=Ask-open_type*2000*d5korr*Point;
      if (sl_trail!=0 && trailingstop_after_nr>=1 && open_nr>=trailingstop_after_nr)
                   { if (open_type==1) sl4=Bid-sl_trail*Point; else sl4=Ask+sl_trail*Point; } else sl4=Ask-open_type*2000*d5korr*Point;
      sl5=open_avgprice+open_type*sl_onavgprice*Point;
      slmin1=sl5;
      if (sl_price!=0) slmin2=sl_price+open_type*sl_step*Point; else slmin2=Ask-open_type*2000*d5korr*Point;
      if (open_type==1) { slmax=MathMax(MathMax(MathMax(MathMax(sl1,sl2),sl3),sl4),sl5); if (slmax>slmin1 && slmax>slmin2) sl_price=slmax; 
         if (sl2>sl_price) sl_price=sl2; }
      if (open_type==-1) { slmax=MathMin(MathMin(MathMin(MathMin(sl1,sl2),sl3),sl4),sl5); if (slmax<slmin1 && slmax<slmin2) sl_price=slmax;
         if (sl!=0 && stop_after_nr>=1 && open_nr>=stop_after_nr && (sl2<sl_price || sl_price==0)) sl_price=sl2; }
      F_lines_objects();
       //Alert("nr:",open_nr*open_type,"  1:",sl1,"  2:",sl2,"  3:",sl3,"  4:",sl4,"  max:",slmax,"  min1:",slmin1,"  min2:",slmin2,"  sl:",sl_price,"  tp:",tp_price,"  avg:",open_avgprice);
      return(0);
   }


void F_change_trailing()
   {  if (!(sl_trail>0 && trailingstop_after_nr>=1 && open_nr>=trailingstop_after_nr)) return(0);
      for(int cnt=0;cnt<=open_nr;cnt++)
      { OrderSelect(open_array_ticket[cnt],SELECT_BY_TICKET);
       if ((OrderTakeProfit()!=tp_price || OrderStopLoss()!=sl_price)) 
            OrderModify(OrderTicket(),OrderOpenPrice(),sl_price,tp_price,0,Green);  }              
   return(0);  }

   
void F_change_avgprice()
   {  int st_small=2; st_small*=d5korr;
      if ((IsTesting()==false && IsOptimization()==false) || false==true)
      for(int cnt=0;cnt<=open_nr;cnt++)
      { OrderSelect(open_array_ticket[cnt],SELECT_BY_TICKET);
         OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),open_avgprice+open_type*(tp_avg2+st_small)*Point,0,Green);}
   return(0);  }


void F_close_pending()
   { if (open_nr>0)
     if (pending_nr>0)
     for(int cnt=0;cnt<=pending_nr+10;cnt++)
      {  Alert(open_nr," ",pending_nr," ",pending_array_ticket[0]," ",pending_array_ticket[1]," ",pending_array_ticket[2]," ",pending_array_ticket[3]," ");
         if (OrderSelect(pending_array_ticket[cnt],SELECT_BY_TICKET)) OrderDelete(OrderTicket());  }   
         return(0);   }
         
   
void F_close(int order_type)
   {  bool b_lezar=false; int b_lezar_kod=0;         
      if ((AccountEquity()-hidden_equity)/initialequity<=(1.00-max_loss_percent/100)) { b_lezar=true; b_lezar_kod=1;}
      if ((AccountEquity()-hidden_equity)/initialequity<=(1.00-ult_max_loss_percent/100)) { b_lezar=true; b_lezar_kod=2;}
      if (b_letprofitrun==false && profitactpip>=tp_avg2*Point ) { b_lezar=true; b_lezar_kod=3;}   
      if (b_letprofitrun==true && profitmaxpip>=tp_avg2*Point && profitfallback>=fallbackpip_min*Point && profitmaxpip>0.0)
            if (profitfallback>=fallbackpip_max*Point || profitfallback/profitmaxpip>fallbackpercent_max) { b_lezar=true; b_lezar_kod=4;}     
      if (section<=stop_after_hour_tillsection  && TimeCurrent()-lastopen>=stop_after_hour*3600 && stop_after_hour!=0 && stop_after_hour_minloss==0 && profitactpip>=stop_after_hour_minprofit*Point) { b_lezar=true; b_lezar_kod=5;}    
      if (section<=stop_after_hour_tillsection  && TimeCurrent()-lastopen>=stop_after_hour2*3600 && stop_after_hour2!=0 && stop_after_hour_minloss2==0 && profitactpip>=stop_after_hour_minprofit2*Point) { b_lezar=true; b_lezar_kod=6;}    
      if (section<=stop_after_hour_tillsection  && TimeCurrent()-lastopen>=stop_after_hour*3600 && stop_after_hour!=0 && stop_after_hour_minloss!=0 && stop_after_hour_minprofit==0 && profitactpip<=stop_after_hour_minloss*Point){ b_lezar=true; b_lezar_kod=7;}    
      if (section<=stop_after_hour_tillsection  && TimeCurrent()-lastopen>=stop_after_hour2*3600 && stop_after_hour2!=0 && stop_after_hour_minloss2!0 && stop_after_hour_minprofit2==0 && profitactpip<=stop_after_hour_minloss2*Point){ b_lezar=true; b_lezar_kod=8;}    
      if (order_type==1 && ((Bid<=sl_price && sl_price!=0) || (Ask>=tp_price && tp_price!=0))) { b_lezar=true; b_lezar_kod=12;} 
      if (order_type==-1 && ((Ask>=sl_price && sl_price!=0) || (Bid<=tp_price && tp_price!=0))) { b_lezar=true; b_lezar_kod=13;}          
      if (TimeCurrent()-lastopen2>=stop_after_lastopen_min*60 && stop_after_lastopen_min!=0 && profitactpip>=stop_after_lastopen_minprofit*Point) { b_lezar=true; b_lezar_kod=14;}    
      if (stop_st3_out!=0 && st3_dir*open_type<=-stop_st3_out) { b_lezar=true; b_lezar_kod=15;}  
      
      if (b_lezar==false) return(0);
      
         if (b_lezar==true && b_lezar_signal==false) lastprofit=0;       
         if (b_lezar==true) b_lezar_signal=true;        
         
         if (b_lezar==true || b_lezar_signal==true)       
         {for(int cnt=1;cnt<=open_nr;cnt++)
            {  OrderSelect(open_array_ticket[cnt],SELECT_BY_TICKET);
               if (order_type==1*ult_reverse) OrderClose(OrderTicket(),OrderLots(),Bid,3,Red); 
               if (order_type==-1*ult_reverse) OrderClose(OrderTicket(),OrderLots(),Ask,3,Red); 
               lastprofit+=OrderProfit()+OrderSwap()+OrderCommission();
            }
            i_last_length=TimeCurrent()-lastopen;
                        if (TimeDayOfWeek(lastopen)>TimeDayOfWeek(TimeCurrent()) && NormalizeDouble(i_last_length/60/60,2)>48) i_last_length-=48*60*60;
            if (i_last_length>i_max_length) i_max_length=i_last_length;
            i_total_length+=i_last_length;
            i_nr_tr++;i_nr_tr2+=open_nr;
            lastclose=TimeCurrent();
            if (OrderProfit()<0) lastloss=TimeCurrent();
            lastclose_i_m[strat_act]=TimeCurrent();                                 //   <<-----parallel
            if (OrderProfit()<0) lastloss_i_m[strat_act]=TimeCurrent();             //   <<-----parallel
            
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

///--------------------------------------------------------------------------------------------------------------


void F_setup_multisignal(int nr,int type)
   {if (type==1) 
      {  strat_act=nr;
         signal1=signal1_m[nr];
         signal1_price=signal1_price_m[nr];
         signal1_pricem=signal1_pricem_m[nr];
         signal1_adxm=signal1_adxm_m[nr];
         signal1_time=signal1_time_m[nr];
         signal1_timee=signal1_timee_m[nr];
         signal2=signal2_m[nr];   
         lastopen=lastopen_i_m[nr]; 
         lastclose=lastclose_i_m[nr];
         lastloss=lastloss_i_m[nr];     
         last_ticket=last_ticket_i_m[nr];
         //open_bool=open_bool_i_m[nr];      //valamiért nagyon lelassítja
         open_nr=open_nr_i_m[nr];          //valamiért nagyon lelassítja
         }
    if (type==-1) 
      {  strat_act=nr;
         signal1_m[nr]=signal1;
         signal1_price_m[nr]=signal1_price;
         signal1_pricem_m[nr]=signal1_pricem;
         signal1_adxm_m[nr]=signal1_adxm;
         signal1_time_m[nr]=signal1_time;
         signal1_timee_m[nr]=signal1_timee;         
         signal2_m[nr]=signal2;   
         lastopen_i_m[nr]=lastopen; 
         lastclose_i_m[nr]=lastclose;   
         lastloss_i_m[nr]=lastloss;    
         last_ticket_i_m[nr]=last_ticket;
         open_bool_i_m[nr]=open_bool;
         open_nr_i_m[nr]=open_nr;
         }
   }


void F_setup_multistrat(int nr)
   {
   strat_symbol      =strat_symbol_m[nr];
   strat_period      =strat_period_m[nr];
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
   hedging_openafter       =hedging_openafter_m[nr];
   hedging_losspip         =hedging_losspip_m[nr];
   
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
   //trailingstop          =trailingstop_m[nr];
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
   stop_st3_out               =stop_st3_out_m[nr];

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
   
   stepmin1    =stepmin1_m[nr];
   steppip1    =steppip1_m[nr];
   stepmin2    =stepmin2_m[nr];
   steppip2    =steppip2_m[nr];
   stepmin3    =stepmin3_m[nr];
   steppip3    =steppip3_m[nr];
   
   st3_limit   =st3_limit_m[nr];
    
   delayminutes   =  delayminutes_m[nr];
   delayminutesafterclose=delayminutesafterclose_m[nr];
   delayminutesafterloss=delayminutesafterloss_m[nr];
   F_init_5digitstep();      
   return(0); }


void F_init_5digitstep()
   {  if (b_fivedigitbroker==true)
      {  d5korr=10.0;
         if (test_entry_order_type==false) entry_orderbridge *=10;
         step_up           *=10;
         step_down         *=10;         
         step_down_first   *=10;
         step_movegoal     *=10;
         hedging_openafter *=10;
         hedging_losspip   *=10;
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
      }
   return(0);  }
   

//--------------------------------------------------------------------------------------------------
//--------------- display -------------------------------------------------------------------------- 
   
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
      ObjectSetText("label3","  Digits: " + Digits + "    5digitsetting: " + (4+ b_fivedigitbroker) + "    Spread: " + DoubleToStr(MarketInfo(Symbol(),MODE_SPREAD),1) + "   Pips: " +  DoubleToStr(st3_dir,0)
  //    ObjectSetText("label3","" + TimeCurrent() + "  " + szamol
            ,8,"Arial",LightYellow);   
   }

void F_display_alert()
   {  ObjectSetText("label1","Wrong symbol or timeframe",8,"Arial",Red);  
      ObjectSetText("label2","",8,"Arial",LightYellow);   }

   
//--------------------------------------------------------------------------------------------------
//--------------- testing -------------------------------------------------------------------------- 
 void F_lines_objects()
 { if (!(IsTesting() && test_lines)) return(0);
   if(open_avgprice!= 0)
    { string atlag = "atlagar"+Bars;
      if(ObjectFind(atlag)< 0)
      {  ObjectCreate(atlag,OBJ_ARROW,0,TimeCurrent(),open_avgprice);
         ObjectSet(atlag,OBJPROP_ARROWCODE,4);ObjectSet(atlag,OBJPROP_COLOR,Yellow);}} 
    //  else ObjectMove(atlag,0,TimeCurrent(),open_avgprice);
      
   if(sl_price!= 0)
    { string stop = "stop"+Bars;
      if(ObjectFind(stop)< 0)
      {  ObjectCreate(stop,OBJ_ARROW,0,TimeCurrent(),sl_price);
         ObjectSet(stop,OBJPROP_ARROWCODE,4);ObjectSet(stop,OBJPROP_COLOR,Red);}} 
    //  else ObjectMove(stop,0,TimeCurrent(),sl_price);     
    // Alert(open_nr," ",open_avgprice,"   ",sl_price); 
  return(0);}

void F_load_test_data()
   { //if(test_record_curr_stat==false) return(0);
   //if (open_nr==0 && pending_nr==0) {test_data[0]=0; return(0);}
   //if (open_nr>0) test_data[0]=open_array_ticket[1];
   //if (open_nr==0 && pending_nr>0) test_data[0]=pending_array_ticket[1];  
   test_data[0]=open_array_ticket[1]; 
   test_data[1]=iRSI(Symbol(),PERIOD_M1,20,PRICE_CLOSE,0);            // rsi_M1_20, adx, atr
   test_data[2]=iRSI(Symbol(),PERIOD_M5,20,PRICE_CLOSE,0);            // rsi_M1_20
   test_data[3]=iRSI(Symbol(),PERIOD_H1,20,PRICE_CLOSE,0);            // rsi_M1_20
   test_data[4]=iRSI(Symbol(),PERIOD_D1,20,PRICE_CLOSE,0);            // rsi_M1_20   
   test_data[5]=iATR(Symbol(),PERIOD_M1,20,0); 
   test_data[6]=iATR(Symbol(),PERIOD_M5,20,0);     
   test_data[7]=iATR(Symbol(),PERIOD_H1,20,0);        
   test_data[8]=iATR(Symbol(),PERIOD_D1,20,0);             
   test_data[9]=iADX(Symbol(),PERIOD_M1,20,PRICE_CLOSE,MODE_MAIN,1);    
   test_data[10]=iADX(Symbol(),PERIOD_M5,20,PRICE_CLOSE,MODE_MAIN,1);    
   test_data[11]=iADX(Symbol(),PERIOD_H1,20,PRICE_CLOSE,MODE_MAIN,1);    
   test_data[12]=iADX(Symbol(),PERIOD_D1,20,PRICE_CLOSE,MODE_MAIN,1);    
   return(0);
   }
 
 
void F_tester_file(int _todo,int _stage)     // 1: write    2:read  //  0: open file   1: read-write 2: close
{  string stemp;
if (_stage==0)       // open file      tester_openfilenr
   {
   if (_todo==1) { 
      tester_pnames[1]="";tester_pdata[1]=""; tester_currtimelabel=h_currtimelabel();
      tester_ineq=AccountEquity();tester_maxbal=AccountEquity();tester_maxdd=0.0;tester_maxddp=0.0;tester_maxddpip=0.0;
      tester_dfrom=TimeCurrent();
      //tester_dto=TimeCurrent();
      tester_file_namew="tNLV3_"+ Symbol() + "_" + tester_currtimelabel + "_" + tester_codein;
      tester_filew=FileOpen(tester_file_namew,FILE_CSV|FILE_WRITE|FILE_READ,CharToStr(61));   // 59;   61=              
      FileWrite(tester_filew,"b_compeetingbot",b_compeetingbot);
      FileWrite(tester_filew,"b_fivedigitbroker",b_fivedigitbroker);
      FileWrite(tester_filew,"b_run_multistrat",b_run_multistrat);
      FileWrite(tester_filew,"strat_1",strat_1);
      FileWrite(tester_filew,"strat_2",strat_2);
      FileWrite(tester_filew,"strat_3",strat_3);
      FileWrite(tester_filew,"strat_4",strat_4);
      FileWrite(tester_filew,"strat_5",strat_5);
      FileWrite(tester_filew,"strat_6",strat_6);
      FileWrite(tester_filew,"strat_7",strat_7);
      FileWrite(tester_filew,"test_strategies_to",test_strategies_to);
      FileWrite(tester_filew,"MAGIC_Rf",MAGIC_Rf);
      FileWrite(tester_filew,"maxspread",maxspread/d5korr);
      FileWrite(tester_filew,"ult_max_loss_percent",ult_max_loss_percent);
      FileWrite(tester_filew,"ult_reverse",ult_reverse);
      FileWrite(tester_filew,"money_management",money_management);
      FileWrite(tester_filew,"b_aggressive",b_aggressive);
      FileWrite(tester_filew,"hidden_equity",hidden_equity);
      FileWrite(tester_filew,"lots",lots);
      FileWrite(tester_filew,"lots_multipliyer",lots_multipliyer);
      FileWrite(tester_filew,"lots_equityperlot",lots_equityperlot);
      FileWrite(tester_filew,"martingal",martingal);
      FileWrite(tester_filew,"strat_period",strat_period);
      FileWrite(tester_filew,"tradinghour_start",tradinghour_start);
      FileWrite(tester_filew,"tradinghour_end",tradinghour_end);
      FileWrite(tester_filew,"tradinghour",tradinghour);
      FileWrite(tester_filew,"tradingfridaytill",tradingfridaytill);
      FileWrite(tester_filew,"tradingdayoyearmax",tradingdayoyearmax);
      FileWrite(tester_filew,"entry_type",entry_type);
      FileWrite(tester_filew,"entry_reverse",entry_reverse);
      FileWrite(tester_filew,"entry_ordertype",entry_ordertype);
      FileWrite(tester_filew,"entry_orderbridge",entry_orderbridge);
      FileWrite(tester_filew,"entry_expire",entry_expire);
      FileWrite(tester_filew,"delayminutes",delayminutes);
      FileWrite(tester_filew,"delayminutesafterclose",delayminutesafterclose);
      FileWrite(tester_filew,"delayminutesafterloss",delayminutesafterloss);            
      FileWrite(tester_filew,"increase_lots",increase_lots);
      FileWrite(tester_filew,"increase_for_every",increase_for_every);
      FileWrite(tester_filew,"increase_percent",increase_percent);
      FileWrite(tester_filew,"step_type",step_type);
      FileWrite(tester_filew,"step_up",step_up/d5korr);
      FileWrite(tester_filew,"step_down",step_down/d5korr);
      FileWrite(tester_filew,"step_down_first",step_down_first/d5korr);
      FileWrite(tester_filew,"step_down_minute",step_down_minute);
      FileWrite(tester_filew,"step_max_nr",step_max_nr);
      FileWrite(tester_filew,"step_max_nr_down",step_max_nr_down);
      FileWrite(tester_filew,"step_movegoal",step_movegoal/d5korr);
      FileWrite(tester_filew,"hedging_openafter",hedging_openafter/d5korr);         // new
      FileWrite(tester_filew,"hedging_losspip",hedging_losspip/d5korr);             // new
      FileWrite(tester_filew,"tp_price",tp_price);
      FileWrite(tester_filew,"tp_avg",tp_avg/d5korr);
      FileWrite(tester_filew,"tp",tp/d5korr);
      FileWrite(tester_filew,"b_letprofitrun",b_letprofitrun);
      FileWrite(tester_filew,"fallbackpip_min",fallbackpip_min/d5korr);
      FileWrite(tester_filew,"fallbackpip_max",fallbackpip_max/d5korr);
      FileWrite(tester_filew,"fallbackpercent_max",fallbackpercent_max);
      FileWrite(tester_filew,"max_loss_percent",max_loss_percent);
      FileWrite(tester_filew,"sl_price",sl_price);
      FileWrite(tester_filew,"sl",sl/d5korr);
      FileWrite(tester_filew,"sl_trail",sl_trail/d5korr);
      FileWrite(tester_filew,"sl_step",sl_step/d5korr);
      FileWrite(tester_filew,"sl_step_first",sl_step_first);
      FileWrite(tester_filew,"sl_onavgprice",sl_onavgprice/d5korr);
      FileWrite(tester_filew,"trailingstop_after_nr",trailingstop_after_nr);
      FileWrite(tester_filew,"stop_after_nr",stop_after_nr);
      FileWrite(tester_filew,"stop_after_hour_tillsection",stop_after_hour_tillsection);
      FileWrite(tester_filew,"stop_after_hour",stop_after_hour);
      FileWrite(tester_filew,"stop_after_hour_minprofit",stop_after_hour_minprofit/d5korr);
      FileWrite(tester_filew,"stop_after_hour_minloss",stop_after_hour_minloss/d5korr);
      FileWrite(tester_filew,"stop_after_hour2",stop_after_hour2);
      FileWrite(tester_filew,"stop_after_hour_minprofit2",stop_after_hour_minprofit2/d5korr);
      FileWrite(tester_filew,"stop_after_hour_minloss2",stop_after_hour_minloss2/d5korr);
      FileWrite(tester_filew,"stop_after_lastopen_min",stop_after_lastopen_min);
      FileWrite(tester_filew,"stop_after_lastopen_minprofit",stop_after_lastopen_minprofit/d5korr);
      FileWrite(tester_filew,"stop_after_lastopen_maxprofit",stop_after_lastopen_maxprofit/d5korr);
      FileWrite(tester_filew,"stop_st3_out",stop_st3_out);
      FileWrite(tester_filew,"signal_atr_max",signal_atr_max/d5korr);
      FileWrite(tester_filew,"signal_atr_min",signal_atr_min/d5korr);
      FileWrite(tester_filew,"atr_period",atr_period);
      FileWrite(tester_filew,"signal_adx_limit",signal_adx_limit);
      FileWrite(tester_filew,"signal_adx_max",signal_adx_max);
      FileWrite(tester_filew,"adx_period",adx_period);
      FileWrite(tester_filew,"signal_adx_limit2",signal_adx_limit2);
      FileWrite(tester_filew,"adx_period2",adx_period2);
      FileWrite(tester_filew,"signal_stoch_down",signal_stoch_down);
      FileWrite(tester_filew,"stoch_period",stoch_period);
      FileWrite(tester_filew,"rsi_limit_down",rsi_limit_down);
      FileWrite(tester_filew,"rsi_min_down",rsi_min_down);
      FileWrite(tester_filew,"rsi_period",rsi_period);
      FileWrite(tester_filew,"bool_dev",bool_dev);
      FileWrite(tester_filew,"bool_period",bool_period);
      FileWrite(tester_filew,"bool_dev2",bool_dev2);
      FileWrite(tester_filew,"bool_period2",bool_period2);
      FileWrite(tester_filew,"bool_dev3",bool_dev3);
      FileWrite(tester_filew,"bool_period3",bool_period3);
      FileWrite(tester_filew,"stepmin1",stepmin1);
      FileWrite(tester_filew,"steppip1",steppip1/d5korr);
      FileWrite(tester_filew,"stepmin2",stepmin2);
      FileWrite(tester_filew,"steppip2",steppip2/d5korr);
      FileWrite(tester_filew,"stepmin3",stepmin3);
      FileWrite(tester_filew,"steppip3",steppip3/d5korr);
      FileWrite(tester_filew,"st3_limit",st3_limit);
      }
   if (_todo==2) { tester_file_namer="f"+ (1000 + tester_openfilenr);      //  read
      tester_filer=FileOpen(tester_file_namer,FILE_CSV|FILE_READ,CharToStr(59));
      tester_pnames[1]="";tester_pdata[1]=""; 
      stemp=FileReadString(tester_filer); // b_compeetingbot=FileReadInteger (tester_filer);
      stemp=FileReadString(tester_filer); // b_fivedigitbroker=StrToInteger(FileReadString(tester_filer));
      stemp=FileReadString(tester_filer); // b_run_multistrat=StrToInteger(FileReadString(tester_filer));
      stemp=FileReadString(tester_filer); // strat_1=StrToInteger(FileReadString(tester_filer));
      stemp=FileReadString(tester_filer); // strat_2=StrToInteger(FileReadString(tester_filer));
      stemp=FileReadString(tester_filer); // strat_3=StrToInteger(FileReadString(tester_filer));
      stemp=FileReadString(tester_filer); // strat_4=StrToInteger(FileReadString(tester_filer));
      stemp=FileReadString(tester_filer); // strat_5=StrToInteger(FileReadString(tester_filer));
      stemp=FileReadString(tester_filer); // strat_6=StrToInteger(FileReadString(tester_filer));
      stemp=FileReadString(tester_filer); // strat_7=StrToInteger(FileReadString(tester_filer));
      stemp=FileReadString(tester_filer); // test_strategies_to=StrToInteger(FileReadString(tester_filer));
      stemp=FileReadString(tester_filer); // MAGIC_Rf=StrToInteger(FileReadString(tester_filer));
      stemp=FileReadString(tester_filer); // maxspread=StrToDouble(FileReadString(tester_filer));
      stemp=FileReadString(tester_filer); // ult_max_loss_percent=StrToDouble(FileReadString(tester_filer));
      stemp=FileReadString(tester_filer); // ult_reverse=StrToInteger(FileReadString(tester_filer));
      stemp=FileReadString(tester_filer); // money_management=StrToInteger(FileReadString(tester_filer));
      stemp=FileReadString(tester_filer); // b_aggressive=StrToInteger(FileReadString(tester_filer));
      stemp=FileReadString(tester_filer); // hidden_equity=StrToInteger(FileReadString(tester_filer));
      lots=StrToDouble(FileReadString(tester_filer));
      lots_multipliyer=StrToDouble(FileReadString(tester_filer));
      lots_equityperlot=StrToDouble(FileReadString(tester_filer));
      martingal=StrToDouble(FileReadString(tester_filer));
      strat_period=StrToInteger(FileReadString(tester_filer));
      tradinghour_start=StrToInteger(FileReadString(tester_filer));
      tradinghour_end=StrToInteger(FileReadString(tester_filer));
      tradinghour=StrToInteger(FileReadString(tester_filer));
      tradingfridaytill=StrToInteger(FileReadString(tester_filer));
      tradingdayoyearmax=StrToInteger(FileReadString(tester_filer));
      entry_type=StrToInteger(FileReadString(tester_filer));
      entry_reverse=StrToInteger(FileReadString(tester_filer));
      entry_ordertype=StrToInteger(FileReadString(tester_filer));
      entry_orderbridge=StrToDouble(FileReadString(tester_filer));
      entry_expire=StrToInteger(FileReadString(tester_filer));
      delayminutes=StrToInteger(FileReadString(tester_filer));
      delayminutesafterclose=StrToInteger(FileReadString(tester_filer));
      delayminutesafterloss=StrToInteger(FileReadString(tester_filer));      
      increase_lots=StrToInteger(FileReadString(tester_filer));
      increase_for_every=StrToInteger(FileReadString(tester_filer));
      increase_percent=StrToDouble(FileReadString(tester_filer));
      step_type=StrToInteger(FileReadString(tester_filer));
      step_up=StrToInteger(FileReadString(tester_filer));
      step_down=StrToInteger(FileReadString(tester_filer));
      step_down_first=StrToInteger(FileReadString(tester_filer));
      step_down_minute=StrToInteger(FileReadString(tester_filer));
      step_max_nr=StrToInteger(FileReadString(tester_filer));
      step_max_nr_down=StrToInteger(FileReadString(tester_filer));
      step_movegoal=StrToDouble(FileReadString(tester_filer));
      hedging_openafter=StrToDouble(FileReadString(tester_filer));            // new
      hedging_losspip=StrToDouble(FileReadString(tester_filer));              // new
      tp_price=StrToDouble(FileReadString(tester_filer));
      tp_avg=StrToDouble(FileReadString(tester_filer));
      tp=StrToDouble(FileReadString(tester_filer));
      b_letprofitrun=StrToInteger(FileReadString(tester_filer));
      fallbackpip_min=StrToInteger(FileReadString(tester_filer));
      fallbackpip_max=StrToInteger(FileReadString(tester_filer));
      fallbackpercent_max=StrToDouble(FileReadString(tester_filer));
      max_loss_percent=StrToDouble(FileReadString(tester_filer));
      sl_price=StrToDouble(FileReadString(tester_filer));
      sl=StrToDouble(FileReadString(tester_filer));
      sl_trail=StrToDouble(FileReadString(tester_filer));
      sl_step=StrToDouble(FileReadString(tester_filer));
      sl_step_first=StrToDouble(FileReadString(tester_filer));
      sl_onavgprice=StrToDouble(FileReadString(tester_filer));
      trailingstop_after_nr=StrToInteger(FileReadString(tester_filer));
      stop_after_nr=StrToInteger(FileReadString(tester_filer));
      stop_after_hour_tillsection=StrToDouble(FileReadString(tester_filer));
      stop_after_hour=StrToDouble(FileReadString(tester_filer));
      stop_after_hour_minprofit=StrToDouble(FileReadString(tester_filer));
      stop_after_hour_minloss=StrToDouble(FileReadString(tester_filer));
      stop_after_hour2=StrToDouble(FileReadString(tester_filer));
      stop_after_hour_minprofit2=StrToDouble(FileReadString(tester_filer));
      stop_after_hour_minloss2=StrToDouble(FileReadString(tester_filer));
      stop_after_lastopen_min=StrToDouble(FileReadString(tester_filer));
      stop_after_lastopen_minprofit=StrToDouble(FileReadString(tester_filer));
      stop_after_lastopen_maxprofit=StrToDouble(FileReadString(tester_filer));
      stop_st3_out=StrToDouble(FileReadString(tester_filer));
      signal_atr_max=StrToDouble(FileReadString(tester_filer));
      signal_atr_min=StrToDouble(FileReadString(tester_filer));
      atr_period=StrToInteger(FileReadString(tester_filer));
      signal_adx_limit=StrToDouble(FileReadString(tester_filer));
      signal_adx_max=StrToDouble(FileReadString(tester_filer));
      adx_period=StrToInteger(FileReadString(tester_filer));
      signal_adx_limit2=StrToDouble(FileReadString(tester_filer));
      adx_period2=StrToInteger(FileReadString(tester_filer));
      signal_stoch_down=StrToDouble(FileReadString(tester_filer));
      stoch_period=StrToInteger(FileReadString(tester_filer));
      rsi_limit_down=StrToDouble(FileReadString(tester_filer));
      rsi_min_down=StrToDouble(FileReadString(tester_filer));
      rsi_period=StrToInteger(FileReadString(tester_filer));
      bool_dev=StrToDouble(FileReadString(tester_filer));
      bool_period=StrToInteger(FileReadString(tester_filer));
      bool_dev2=StrToDouble(FileReadString(tester_filer));
      bool_period2=StrToInteger(FileReadString(tester_filer));
      bool_dev3=StrToDouble(FileReadString(tester_filer));
      bool_period3=StrToInteger(FileReadString(tester_filer));
      stepmin1=StrToInteger(FileReadString(tester_filer));
      steppip1=StrToDouble(FileReadString(tester_filer));
      stepmin2=StrToInteger(FileReadString(tester_filer));
      steppip2=StrToDouble(FileReadString(tester_filer));
      stepmin3=StrToInteger(FileReadString(tester_filer));
      steppip3=StrToDouble(FileReadString(tester_filer));
      st3_limit=StrToDouble(FileReadString(tester_filer));
         stemp=FileReadString(tester_filer);
         stemp=FileReadString(tester_filer);
         stemp=FileReadString(tester_filer);
         stemp=FileReadString(tester_filer);
      tester_codein=FileReadString(tester_filer);         
         stemp=FileReadString(tester_filer);
         stemp=FileReadString(tester_filer);
         stemp=FileReadString(tester_filer);
         stemp=FileReadString(tester_filer);
         stemp=FileReadString(tester_filer);
         stemp=FileReadString(tester_filer);
      }
   return(0);}
   
if (_stage==2)        // close file
   { if (_todo==1) FileClose(tester_filew); else FileClose(tester_filer); return(0);}
     
if (_stage==1) {      // read-write file
   if (_todo==1) 
   {  FileWrite(tester_filew,"--Result--");                  
      FileWrite(tester_filew,"Symbol",Symbol());
      FileWrite(tester_filew,"TimeStamp",tester_currtimelabel);
      FileWrite(tester_filew,"in_file",tester_file_namer);
      FileWrite(tester_filew,"in_code",tester_codein);          
      FileWrite(tester_filew,"tperiod_from",TimeToStr(tester_dfrom,TIME_DATE));
         tester_dto=TimeCurrent();
      FileWrite(tester_filew,"tperiod_to",TimeToStr(tester_dto,TIME_DATE));      
      FileWrite(tester_filew,"tester_ineq",tester_ineq);      
      FileWrite(tester_filew,"tester_profit",AccountEquity()-tester_ineq);      
      FileWrite(tester_filew,"tester_maxdd",tester_maxdd);      
      FileWrite(tester_filew,"tester_maxddp",tester_maxddp*100);  
      FileWrite(tester_filew,"tester_maxddpip",tester_maxddpip/d5korr);    
      FileWrite(tester_filew,"tester_longeshour",NormalizeDouble(i_max_length/60/60,2));    
      FileWrite(tester_filew,"tester_totalhour",NormalizeDouble(i_total_length/60/60,2));          
   }
   return(0);}
}

          