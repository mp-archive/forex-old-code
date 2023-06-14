

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
   
   
double n1[30],limit1[30];
string n1_name[30];
double w1_1[30],w1_2[30],w1_3[30],w1_4[30],w1_5[30],w1_6[30],w1_7[30],w1_8[30],w1_9[30],w1_10[30],
       w1_11[30],w1_12[30],w1_13[30],w1_14[30],w1_15[30],w1_16[30],w1_17[30],w1_18[30],w1_19[30],w1_20[30],
       w1_21[30],w1_22[30],w1_23[30],w1_24[30],w1_25[30],w1_26[30],w1_27[30],w1_28[30],w1_29[30],w1_30[30];     

int    n1_nr=16; 
int    model_nr=1;
   

//--------------------------------------------------------------------------------------------------------
int init()
  { file=FileOpen(file_name,FILE_CSV|FILE_WRITE,CharToStr(9));  
    lastopen=TimeCurrent()-60*60;  
      return(0);  }


int start()
   {
   if (TimeCurrent()-Time[0]<2 && TimeCurrent()-lastopen>frequency*60 && IsTesting()) F_testing_start();
   
   }


int deinit()
   {  if (IsTesting()==true) F_testing_deinit();
      FileClose(file);
      return(0);  }


//--------------------------------------------------------------------------------------------------------


void F_1read_settings()
      {
      n1_nr=16;
      model_nr=1;
      
      w1_1[30]={
      w1_2[30]={
      w1_3[30]={
      w1_4[30]={
      w1_5[30]={
      w1_6[30]={
      w1_7[30]={
      w1_8[30]={
      w1_9[30]={
      w1_10[30]={
      w1_11[30]={
      w1_12[30]={
      w1_13[30]={
      w1_14[30]={
      w1_15[30]={
      w1_16[30]={
      w1_17[30]={
      w1_18[30]={
      w1_19[30]={
      w1_20[30]={
      
      
      
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