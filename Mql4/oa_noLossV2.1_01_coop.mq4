//+------------------------------------------------------------------+

//F_signal(int entry_ty)
//int F_signal_extra3(int tip_ell,int atl1,int atl2,int atl3,double korr)
//if (OrderOpenTime()<lastopen) lastopen=OrderOpenTime();  (check open)
//if (entry_type==3) if (TimeCurrent()-lastopen>=60*Period()-5) b_lezar=true;

//+------------------------------------------------------------------+
#property copyright "MP"
#property link      "nincs nem kell"

   extern bool       b_compeetingbot      =true;
   extern bool       b_fivedigitbroker    =true;
   extern bool       b_run_multistrat     =true;
                     
          string     program_name         ="NoLossV2.1_01_coop";
   extern bool       money_management     =true;
   extern bool       b_aggressive         =false;
   extern double     lots_multipliyer     =1.0;

  // multi settings  USDCAD   25%DD  2009.01.01-    -------------------------------------------------------------------------------//
                     string strat_symbol="USDCAD";             string strat_symbol_m[10]           ={"USDCAD","USDCAD","USDCAD","USDCAD"};
 
                                                               int strat_nr=3;
                                                               bool strat_run[10]                  ={true   ,true    ,true};
                     extern int strat_period=60;                int   strat_preiod_m[10]            ={5      ,15      ,5};
   extern bool       b_signal2_trading=false;                  bool  b_signal2_trading_m[10]       ={false  ,false   ,false};
 
   extern int        tradinghour_start       =0;               int   tradinghour_start_m[10]       ={7      ,9       ,23};
   extern int        tradinghour_end         =0;               int   tradinghour_end_m[10]         ={23     ,23      ,2};
   extern int        tradingdayoyearmax      =366;             int   tradingdayoyearmax_m[10]      ={356    ,366     ,366};
                     
   extern int        entry_type        =3;                     int entry_type_m[10]                ={1      ,1       ,1};
   extern int        entry_reverse     =1;                     int entry_reverse_m[10]             ={1      ,1       ,1};
   extern double     lots              =0.1;                      
   extern double     lots_equityperlot =1000000.0;             double     lots_equityperlot_m[10]  ={9000    ,4000    ,5300}; // 
                                                               double     lots_equityperlot_ma[10] ={9000    ,4000    ,5300}; // 
   extern int        MAGIC_Rf          =10050011;              int        MAGIC_Rf_m[10]           ={10050011,10050012,10050013};
   
   
   extern string     Setup_profit="-------------------" ;   
   extern double     average_win       =20.0;                 double average_win_m[10]             ={31.0   ,20.0    ,7.0};           
   
   extern string     Setup_loss="-------------------" ;   
   extern double     max_loss_percent  =50.0;                 double    max_loss_percent_m[10]           ={50.0   ,50.0    ,50.0};       
   extern double     stopp_loss  =0.0;                        double    stopp_loss_m[10]                 ={0.0    ,0.0     ,0.0};
   extern double     stop_after_hour = 0;                     double    stop_after_hour_m[10]            ={3      ,0       ,4};    //0,0,1,0
   extern double     stop_after_hour_minprofit = 0;           double    stop_after_hour_minprofit_m[10]  ={12     ,0       ,4};
   extern double     stop_after_hour_minloss = 0;             double    stop_after_hour_minloss_m[10]    ={0      ,0       ,0};
   extern double     stop_after_hour2 = 0;                    double    stop_after_hour2_m[10]           ={4      ,0       ,6};    //0,0,1,0
   extern double     stop_after_hour_minprofit2 = 0;          double    stop_after_hour_minprofit2_m[10] ={4      ,0       ,2};
   extern double     stop_after_hour_minloss2 = 0;            double    stop_after_hour_minloss2_m[10]   ={0      ,0       ,0};
   
   extern string     Settings="-------------------" ;
   extern double     signal_atr_max    =1000.0;                double     signal_atr_max_m[10]           ={1000.0 ,20.0    ,1000.0};
   extern double     signal_atr_min    =0.0;                   double     signal_atr_min_m[10]           ={0.0    ,0.0     ,0.0};
   extern int        atr_preiod        =30;                    int        atr_preiod_m[10]               ={30     ,30      ,30};
   
   extern double     signal_adx_limit  =0.0;                  double     signal_adx_limit_m[10]         ={40.0   ,40.0    ,40.0};       ///min to act
   extern double     signal_adx_max    =100.0;                   double     signal_adx_max_m[10]           ={0.0    ,0.0     ,0.0};        ///new!!!!
   extern int        adx_preiod        =30;                    int        adx_preiod_m[10]               ={30     ,30      ,20};
   extern double     signal_adx_limit2 =0.0;                  double     signal_adx_limit2_m[10]        ={0      ,0       ,0};
   extern int        adx_preiod2       =30;                    int        adx_preiod2_m[10]              ={20     ,20      ,20};
   extern double     signal_stoch_down =100.0;                 double     signal_stoch_limit_m[10]       ={100.0  ,100.0   ,100.0};       //max down value to buy
   extern int        stoch_preiod      =30;                    int        adx_stoch_m[10]                ={30     ,30      ,30};
   extern double     rsi_limit_down    =100.0;                 double     rsi_limit_down_m[10]           ={100.0  ,30.0    ,100.0};       //max down value to buy
   extern double     rsi_min_down      =0.0;                   double     rsi_limit_min_m[10]            ={0.0    ,0.0     ,0.0};         //new!!! min down value to buy
   extern int        rsi_period        =30;                    int        rsi_period_m[10]               ={30     ,25      ,20};
   extern int        bool_dev          =0;                     int        bool_dev_m[10]                 ={2      ,2       ,2};
   extern int        bool_preiod       =30;                    int        bool_preiod_m[10]              ={20     ,25      ,30};


   extern string     Settings_strat3="-------------------" ;
   extern int        str3_type=1;
   extern int        str3_ma1=10;
   extern int        str3_ma2=20;
   extern int        str3_ma3=20;   
   extern double     str3_korr=0.0;   


   extern double  delayminutes= 0.0;                           double      delayminutes_m[10]            ={0.0    ,0.0     ,0.0};
   
   
   
   
   //--- other 
   
   int         signal1=0;                    int      signal1_m[10]        ={0   ,0    ,0    ,0    ,0    ,0};
   double      signal1_price=0.0;            double   signal1_price_m[10]  ={0.0 ,0.0  ,0.0  ,0.0  ,0.0  ,0.0};
   double      signal1_pricem=0.0;           double   signal1_pricem_m[10] ={0.0 ,0.0  ,0.0  ,0.0  ,0.0  ,0.0};
   double      signal1_adxm=0.0;             double   signal1_adxm_m[10]  ={0.0 ,0.0  ,0.0  ,0.0  ,0.0  ,0.0};
   datetime    signal1_time;                 datetime signal1_time_m[10];
   int         signal2=0;                    int      signal2_m[10]        ={0   ,0    ,0    ,0    ,0    ,0};

   bool              signal_exists=false;
   int               signal_tempvalue=0;
   double            signal_tempvalueadx=0.0;
                     
   double     lots2;
   double sl=20000, tp=9000;
   double     average_win2;

   datetime          lastopen,lastopen2,lastclose;                     
   bool              open_bool=false;
   int               open_nr=0;
   int               open_array_ticket[200];
   double            open_array_lot[200];
   double            open_array_price[200];
   double               open_hlp1=0.0,open_hlp2=0.0;
   int               open_type=0;
   double            open_last_price=0.0;
   double            open_avgprice=0.0;
   double            open_total_lot=0.0;
   double            open_total_profit=0.0;
   double            pricegoal=0.0;

   bool               b_lezar_signal=false;
   
   int               total=0;
   int               order_send=0;
   double            profitmaxpip,profitactpip,profitfallback,initialequity;
   
   string            file_name;
   int               file;
   int               i_max_position,i_nr_tr,i_nr_tr2,
                     i_max_length,i_total_length,i_last_length;
                   

//--------------------------------------------------------------------------------------------------------


int init()
  {   F_init_5digitstep();
        file_name = program_name + Symbol() + Period(); 
      if (IsTesting() && !IsOptimization()) file=FileOpen(file_name,FILE_CSV|FILE_WRITE,CharToStr(9)); 
      if (IsOptimization()) file=FileOpen(file_name,FILE_CSV|FILE_READ|FILE_WRITE,CharToStr(9)); 


   return(0);  }


int deinit()
  {
   return(0);  }


int start()
  {
   F_check_open(false);
   if (open_bool==false && b_run_multistrat==false) 
      {  F_set_signal1();            
         F_open_now(signal2*signal1); }   
      
   if (open_bool==false && b_run_multistrat==true) 
         for (int j=0;j<=strat_nr-1;j++)
            if (strat_run[j]==true && open_bool==false)
            {  F_setup_multistrat(j); 
               F_setup_multisignal(j,1);
               F_set_signal1();               
               F_open_now(signal2*signal1);
               F_setup_multisignal(j,-1);
               }

   if (open_bool==true) 
      {  F_change();
         F_close(open_type);          
         //F_build(open_type,open_last_price,step,step_type);   
         F_change();            
         }
         
   return(0);
  }
 
 
 //----------- STRATEGIE 1 -------------------------------------------------------------------------------------------

int F_signal(int entry_ty)
   {       
   if (    (tradinghour_start<tradinghour_end && (TimeHour(TimeCurrent())<tradinghour_start || TimeHour(TimeCurrent())>=tradinghour_end))
         ||(tradinghour_end <tradinghour_start && (TimeHour(TimeCurrent())<tradinghour_start && TimeHour(TimeCurrent())>=tradinghour_end))) return(0);
   if (DayOfYear()>tradingdayoyearmax) return(0);
    
   if (entry_ty==3 && TimeCurrent()-lastopen>=delayminutes*60
            && iADX(Symbol(),strat_period,adx_preiod,PRICE_CLOSE,MODE_MAIN,1) >= signal_adx_limit
            && iADX(Symbol(),strat_period,adx_preiod,PRICE_CLOSE,MODE_MAIN,1) <= signal_adx_max
            && iADX(Symbol(),strat_period,adx_preiod2,PRICE_CLOSE,MODE_MAIN,1)>= signal_adx_limit2   
            && iATR(Symbol(),strat_period,atr_preiod,1)>=signal_atr_min*Point
            && iATR(Symbol(),strat_period,atr_preiod,1)<=signal_atr_max*Point
            &&(rsi_period==0 || iRSI(Symbol(),strat_period,rsi_period,PRICE_CLOSE,1)<=rsi_limit_down)
            &&(rsi_period==0 || iRSI(Symbol(),strat_period,rsi_period,PRICE_CLOSE,1)>=rsi_min_down))                  
                  return(F_signal_extra3(str3_type,str3_ma1,str3_ma1,str3_ma1,str3_korr));
   
     return(0);   
   }
   
void F_set_signal1()
   {     signal_tempvalue=F_signal(entry_type);  signal1=signal_tempvalue; signal2=1;  }  
    
  
   
void F_check_open(bool init)
   {  total=OrdersTotal(); 
         open_bool=false; open_nr=0; open_hlp1=0.0;open_hlp2=0.0; open_type=0; open_last_price=0.0; open_avgprice=0.0;
         open_total_lot=0.0;  open_total_profit=0.0; 
      if (total>0)
     {for(int cnt=0;cnt<=total;cnt++)
     {
      OrderSelect(cnt, SELECT_BY_POS,MODE_TRADES);
            if (init==true)
            for (int j=0;j<=strat_nr-1;j++)
            if (strat_run[j]==true && MAGIC_Rf_m[j]==OrderMagicNumber())
            F_setup_multistrat(j);           
      if (OrderMagicNumber()==MAGIC_Rf && OrderSymbol()==Symbol() && OrderType()<2)      // symbol changed
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
         if (OrderOpenPrice()*open_type<open_last_price*open_type) open_last_price=OrderOpenPrice();
         if (open_last_price==0) open_last_price=OrderOpenPrice();
         if (OrderOpenTime()<lastopen) lastopen=OrderOpenTime();
         
      }
     }
     if (open_hlp1>0) open_avgprice=open_hlp2/open_hlp1;
     pricegoal=open_avgprice+open_type*average_win2*Point;   
         if (open_type==1)  profitactpip=Bid-open_avgprice;          
         if (open_type==-1) profitactpip=open_avgprice-Ask;  
         if (profitactpip>profitmaxpip) profitmaxpip=profitactpip;
         profitfallback=profitmaxpip-profitactpip;
            if (open_nr>i_max_position) i_max_position=open_nr;
    //FileWrite(file,Symbol(),Period(),"position:",lastopen,lastclose,"tranzaction",i_nr_tr,i_nr_tr2,"minutes:",i_last_length,profitactpip);
    //if (MathMod(TimeCurrent(),60)==0) FileWrite(file,TimeCurrent(),profitactpip,profitmaxpip,profitfallback); 
    }
    if (open_bool==false) b_lezar_signal=false;
   }


void F_open_now(int order_type)
   {  if (b_compeetingbot==true && OrdersTotal()>0) return(0);
      if (b_compeetingbot==false && open_bool==true) return(0);
      if (money_management==true) lots=NormalizeDouble(AccountEquity()/lots_equityperlot*lots_multipliyer,2); lots2=lots;
      if (order_type==1)  {  
            open_array_ticket[open_nr+1]=OrderSend(Symbol(),OP_BUY,lots,Ask,3,0,0,program_name+strat_symbol,MAGIC_Rf,0,Green);   
            open_nr++; lastopen=TimeCurrent(); lastopen2=TimeCurrent();lastclose=TimeCurrent()-24*60*60;  
            profitmaxpip=0.0;profitactpip=0.0; profitfallback=0.0; average_win2=average_win; open_bool=true; initialequity=AccountEquity();}
      if (order_type==-1) {  
            open_array_ticket[open_nr+1]=OrderSend(Symbol(),OP_SELL,lots,Bid,3,0,0,program_name+strat_symbol,MAGIC_Rf,0,Green);   
            open_nr++; lastopen=TimeCurrent(); lastopen2=TimeCurrent();lastclose=TimeCurrent()-24*60*60;  
            profitmaxpip=0.0;profitactpip=0.0; profitfallback=0.0; average_win2=average_win; open_bool=true; initialequity=AccountEquity();}  
      return(0);}

   
void F_build(int order_type,double order_last_price,int order_step,int build_type)
   { 
      return(0);}
   
   
void F_change()
   {   }

   
void F_close(int order_type)
   {  bool b_lezar=false;          
      if (AccountEquity()/initialequity<=(1.00-max_loss_percent/100)) b_lezar=true;
      if (profitactpip>=average_win2*Point ) b_lezar=true;    
      if ((-profitactpip)>=stopp_loss*Point && stopp_loss!=0) b_lezar=true;    
      if (TimeCurrent()-lastopen>=stop_after_hour*3600 && stop_after_hour!=0 && stop_after_hour_minloss==0 && profitactpip>=stop_after_hour_minprofit*Point) b_lezar=true;    
      if (TimeCurrent()-lastopen>=stop_after_hour2*3600 && stop_after_hour2!=0 && stop_after_hour_minloss2==0 && profitactpip>=stop_after_hour_minprofit2*Point) b_lezar=true;    
      if (TimeCurrent()-lastopen>=stop_after_hour*3600 && stop_after_hour!=0 && stop_after_hour_minloss!=0 && stop_after_hour_minprofit==0 && profitactpip<=stop_after_hour_minloss*Point) b_lezar=true;    
      if (TimeCurrent()-lastopen>=stop_after_hour2*3600 && stop_after_hour2!=0 && stop_after_hour_minloss2!0 && stop_after_hour_minprofit2==0 && profitactpip<=stop_after_hour_minloss2*Point) b_lezar=true;    
        
      if (entry_type==3) if (TimeCurrent()-lastopen>=60*Period()-5) b_lezar=true;
        
         if (b_lezar==true) b_lezar_signal=true;
        
         if (b_lezar==true || b_lezar_signal==true)       
         {for(int cnt=open_nr;cnt>=0;cnt--)
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
                FileWrite(file,Symbol(),strat_period,Period(),"position:",TimeToStr(lastopen,TIME_DATE|TIME_SECONDS),TimeToStr(TimeCurrent(),TIME_DATE|TIME_SECONDS),"day:",TimeDayOfWeek(lastopen),"tranzaction_nr",open_nr,"minutes:", NormalizeDouble(i_last_length/60,2),"hour: " , NormalizeDouble(i_last_length/60/60,2),"day: " , NormalizeDouble(i_last_length/60/60/24,2),profitactpip,profitmaxpip,profitfallback); 
         }
   return(0);}

///-------------------------------------------------------------


void F_setup_multisignal(int nr,int type)
   {if (type==1) 
      {  signal1=signal1_m[nr];
         signal1_price=signal1_price_m[nr];
         signal1_pricem=signal1_pricem_m[nr];
         signal1_adxm=signal1_adxm_m[nr];
         signal1_time=signal1_time_m[nr];
         signal2=signal2_m[nr];   }
    if (type==-1) 
      {  signal1_m[nr]=signal1;
         signal1_price_m[nr]=signal1_price;
         signal1_pricem_m[nr]=signal1_pricem;
         signal1_adxm_m[nr]=signal1_adxm;
         signal1_time_m[nr]=signal1_time;
         signal2_m[nr]=signal2;   }
   }


void F_setup_multistrat(int nr)
   {
   strat_symbol      =strat_symbol_m[nr];
   strat_period      =strat_preiod_m[nr];
   b_signal2_trading=b_signal2_trading_m[nr];
   tradinghour_start =tradinghour_start_m[nr];
   tradinghour_end   =tradinghour_end_m[nr];
   tradingdayoyearmax=tradingdayoyearmax_m[nr];
   
   entry_type        =entry_type_m[nr];
   entry_reverse     =entry_reverse_m[nr];
   lots_equityperlot =lots_equityperlot_m[nr];
   if (b_aggressive==true) lots_equityperlot =lots_equityperlot_ma[nr];
   MAGIC_Rf          =MAGIC_Rf_m[nr];

   
   
   average_win             =average_win_m[nr];         
   
   max_loss_percent        =max_loss_percent_m[nr];  
   stopp_loss              =stopp_loss_m[nr];
   stop_after_hour            = stop_after_hour_m[nr];
   stop_after_hour_minprofit  =stop_after_hour_minprofit_m[nr];
   stop_after_hour_minloss = stop_after_hour_minloss_m[nr];
   stop_after_hour2           = stop_after_hour2_m[nr];
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
  
   delayminutes   =  delayminutes_m[nr];
      
      F_init_5digitstep();      
   return(0); }



void F_init_5digitstep()
   {  if (b_fivedigitbroker==true)
      {  average_win       *=10;
         stopp_loss        *=10;
         stop_after_hour_minprofit *=10;
         stop_after_hour_minprofit2 *=10;
         stop_after_hour_minloss *=10;
         stop_after_hour_minloss2 *=10;
         signal_atr_max*=10;
         signal_atr_min*=10;
      }
   return(0);  }
   
   



int F_signal_extra3(int tip_ell,int atl1,int atl2,int atl3,double korr)
   {
   if (tip_ell!=1 && tip_ell!=-1) return(0);
   if (Time[0]>TimeCurrent()-2) return(0);
   int i1;
   int max_i=60;  
   double ervaltozas[82],valtozas[82],er[82],atlag[82];

   er[max_i]=0;
   
   for (i1=max_i;i1>=1;i1--)
      {  valtozas[i1]=Close[i1]-Open[i1]; if (Time[i1]-Time[i1+1]>Period()*60*2) valtozas[i1]=0;
         ervaltozas[i1]=0;
         if(valtozas[i1+1]>0) ervaltozas[i1]=tip_ell*valtozas[i1];
         if(valtozas[i1+1]<0) ervaltozas[i1]=-tip_ell*valtozas[i1];    // követés: zöldre long
         er[i1]=er[i1+1]+ervaltozas[i1];  } 
   
         atlag[1]=er[1];
   for (i1=2;i1<=max_i;i1++)
      {  atlag[i1]=0;
         atlag[i1]=(atlag[i1-1]*(i1-1)+er[i1])/i1;  }
         
FileWrite(file,Symbol(),TimeToStr(lastopen,TIME_DATE|TIME_SECONDS),atlag[atl1],atlag[atl2],atlag[atl3]);

   if (atlag[atl1]>atlag[atl2]+korr && atlag[atl2]>atlag[atl3]+korr) return(1*tip_ell);
   if (atlag[atl1]<atlag[atl2]-korr && atlag[atl2]<atlag[atl3]-korr) return(-1*tip_ell);     
   return(0); 
   
   }