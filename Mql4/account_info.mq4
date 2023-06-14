
datetime lastsend;
int sh[]={2,7,14,20,99};
int i=0;

int init()
  { lastsend=TimeCurrent()-25*60*60;  
     // F_infosend0();
  return(0);  }
  
int start()
  {   
  if (i==0) SendMail("subject text","body text");      
  i=1;

  return(0);
  }



void F_infosend0()
   {  /*double subjx[];
      subjx[0]=AccountNumber();
      subjx[1]=NormalizeDouble(AccountBalance(),0);
      subjx[2]=NormalizeDouble(AccountEquity(),0);
      subjx[3]=NormalizeDouble(AccountProfit(),0)};
      string subj1;
      subj1="" + subjx[0] + "> B:" +subjx[1] + " E:" + subjx[2] + " P:" + subjx[3];*/
      string subj=AccountNumber() + "> B:" + NormalizeDouble(AccountBalance(),0) + " E:" + NormalizeDouble(AccountEquity(),0) + " P:" + NormalizeDouble(AccountProfit(),0);
      string body=AccountNumber() + " info";
      //Alert(body,subj);}
      SendMail(subj,body);      
      int err=GetLastError();
      Alert(err);

      }
void F_infosend1()
   {  if  ((Hour()==sh[0] || Hour()==sh[1] || Hour()==sh[2] || Hour()==sh[3] || Hour()==sh[4]) && TimeCurrent()>lastsend+2*60*60) F_infosend0();}
   