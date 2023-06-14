

extern int frequency=  150;
extern int rsi_period=20;
extern int stoch_period=20;
extern int adx_period=20;
extern int atr_period=20;
extern int bool_preiod=20;

extern int tp=4;
extern int sl=40;

   string            file_name="test_data.csv";
   int               file;
   datetime          lastopen;
   int               ticket;
   
   
double n1[30];
string n1_name[30];

double w1[30]={0,	0,	0,	0,	0,	-1073.3791665541,	0,	175.505864888617,	0,	-136.315285545009,	-46.6570008240563,	53.9256668561179,	786.203543964725,	0,	0,	547.666453454841};
double limit1=1.8;

int    n1_nr=16; 
int    model_nr=1;
double s0,s1;
   

//--------------------------------------------------------------------------------------------------------
int init()
  { file=FileOpen(file_name,FILE_CSV|FILE_WRITE,CharToStr(9));  
    lastopen=TimeCurrent()-60*60;  
      return(0);  }


int start()
   {
   if (TimeCurrent()-Time[0]<2 && TimeCurrent()-lastopen>frequency*60 && IsTesting()) F_testing_start();
   //if (TimeCurrent()-Time[0]<2 && TimeCurrent()-lastopen>frequency*60 && OrdersTotal()==0) F_1read_settings();   
   }


int deinit()
   {  if (IsTesting()==true) F_testing_deinit();
      FileClose(file);
      return(0);  }


//--------------------------------------------------------------------------------------------------------


void F_1read_settings()
      {
         n1_name[0]="4adxM5";       n1[0]=iADX(Symbol(),5,adx_period,PRICE_CLOSE,MODE_MAIN,1); 
         n1_name[1]="5atrH1";       n1[1]=iATR(Symbol(),60,atr_period,1); 
         n1_name[2]="5atrM5";       n1[2]=iATR(Symbol(),5,atr_period,1); 
         n1_name[3]="6boolH1";      n1[3]=iBands(Symbol(),60,bool_preiod,2,0,PRICE_CLOSE,MODE_UPPER,1); 
         n1_name[4]="6boolM5";      n1[4]=iBands(Symbol(),5,bool_preiod,2,0,PRICE_CLOSE,MODE_UPPER,1); 
         n1_name[5]="7CH10";        n1[5]=Close[1]-mhigh(1,11);
         n1_name[6]="7CH30";        n1[6]=Close[1]-mhigh(1,31);                            
         n1_name[7]="7CH90";        n1[7]=Close[1]-mhigh(1,91);  
         n1_name[8]="7CL10";        n1[8]=Close[1]-mlow(1,11);
         n1_name[9]="7CL30";        n1[9]=Close[1]-mlow(1,31);                            
         n1_name[10]="7CL90";       n1[10]=Close[1]-mlow(1,91);  
         n1_name[11]="7CO1";        n1[11]=Close[1]-Close[2]; 
         n1_name[12]="7CO10";       n1[12]=Close[1]-Close[11];      
         n1_name[13]="7CO120";      n1[13]=Close[1]-Close[121];    
         n1_name[14]="7CO20";       n1[14]=Close[1]-Close[21];               
         n1_name[15]="7CO5";        n1[15]=Close[1]-Close[6];          
        
         s0=0;
         for (int j=0; j<=n1_nr; j++) s0+= n1[j]*w1[j];         
         if (s0>=limit1) 
            { Alert("s0: " + s0);
            MessageBox("s0: " + s0);
            OrderSend(Symbol(),OP_BUY,0.1,Ask,3,Ask-sl*10*Point,Ask+tp*10*Point,"vami",1111,0,Green); }
               
      }



void F_testing_start()
      {  ticket=OrderSend(Symbol(),OP_BUY,0.1,Ask,3,Ask-sl*10*Point,Ask+tp*10*Point,"vami",1111,0,Green); 
         lastopen=TimeCurrent(); 
         OrderSelect(ticket,SELECT_BY_TICKET);
         FileWrite(file,ticket,"1openprice",OrderOpenPrice()); 
         FileWrite(file,ticket,"2rsiM5",iRSI(Symbol(),5,rsi_period,PRICE_CLOSE,1)); 
         FileWrite(file,ticket,"3stochM5",iStochastic(Symbol(),5,30,5,3,MODE_SMA,0,MODE_MAIN,1)); 
         FileWrite(file,ticket,"4adxM5",iADX(Symbol(),5,adx_period,PRICE_CLOSE,MODE_MAIN,1)); 
         FileWrite(file,ticket,"5atrM5",iATR(Symbol(),5,atr_period,1)); 
         FileWrite(file,ticket,"6boolM5",iBands(Symbol(),5,bool_preiod,2,0,PRICE_CLOSE,MODE_UPPER,1)); 
         FileWrite(file,ticket,"2rsiH1",iRSI(Symbol(),60,rsi_period,PRICE_CLOSE,1)); 
         FileWrite(file,ticket,"3stochH1",iStochastic(Symbol(),60,30,5,3,MODE_SMA,0,MODE_MAIN,1)); 
         FileWrite(file,ticket,"4adxH1",iADX(Symbol(),60,adx_period,PRICE_CLOSE,MODE_MAIN,1)); 
         FileWrite(file,ticket,"5atrH1",iATR(Symbol(),60,atr_period,1)); 
         FileWrite(file,ticket,"6boolH1",iBands(Symbol(),60,bool_preiod,2,0,PRICE_CLOSE,MODE_UPPER,1)); 
         
         
         FileWrite(file,ticket,"7CO1",Close[1]-Close[2]); 
         FileWrite(file,ticket,"7CO5",Close[1]-Close[6]);          
         FileWrite(file,ticket,"7CO10",Close[1]-Close[11]);      
         FileWrite(file,ticket,"7CO20",Close[1]-Close[21]);               
         FileWrite(file,ticket,"7CO120",Close[1]-Close[121]);    
         FileWrite(file,ticket,"7CL10",Close[1]-mlow(1,11));
         FileWrite(file,ticket,"7CL30",Close[1]-mlow(1,31));                            
         FileWrite(file,ticket,"7CL90",Close[1]-mlow(1,91));  
         FileWrite(file,ticket,"7CH10",Close[1]-mhigh(1,11));
         FileWrite(file,ticket,"7CH30",Close[1]-mhigh(1,31));                            
         FileWrite(file,ticket,"7CH90",Close[1]-mhigh(1,91));  

         
     /*    FileWrite(file,ticket,"CO1",Close[1]-Open[1]); 
         FileWrite(file,ticket,"HO1",High[1]-Open[1]); 
         FileWrite(file,ticket,"LO1",Low[1]-Open[1]); 
         FileWrite(file,ticket,"CO2",Close[2]-Open[2]); 
         FileWrite(file,ticket,"HO2",High[2]-Open[2]); 
         FileWrite(file,ticket,"LO2",Low[2]-Open[2]); 
         FileWrite(file,ticket,"CO3",Close[3]-Open[3]); 
         FileWrite(file,ticket,"HO3",High[3]-Open[3]); 
         FileWrite(file,ticket,"LO3",Low[3]-Open[3]); 
         FileWrite(file,ticket,"CO4",Close[4]-Open[4]); 
         FileWrite(file,ticket,"HO4",High[4]-Open[4]); 
         FileWrite(file,ticket,"LO4",Low[4]-Open[4]); */
         }

void F_testing_deinit()
   {  int total=OrdersHistoryTotal();
      int win=0;
      for(int pos=0;pos<total;pos++)
         { win=0;
            if(OrderSelect(pos,SELECT_BY_POS,MODE_HISTORY)==false) continue;
            win=0;
            if (OrderClosePrice()>=OrderOpenPrice()) win=1;
            FileWrite(file,OrderTicket(),"8Result",OrderClosePrice()-OrderOpenPrice());
            FileWrite(file,OrderTicket(),"9win",win);
            FileWrite(file,OrderTicket(),"9loose",(1-win));
         }   
   }



//--------------------------------------------------------------------------------------------------------

double mlow(int x,int y)
   { double temp=9999.9;
   for (int z=x; z<=y ; z++)      
      if (Low[z]<temp) temp=Low[z];
   return(temp);
   }
   
double mhigh(int x,int y)
   { double temp=0;
   for (int z=x; z<=y ; z++)      
      if (High[z]>temp) temp=High[z];
   return(temp);
   }   