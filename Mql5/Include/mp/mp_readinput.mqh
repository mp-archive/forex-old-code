
void Freadinput(string vname,string vartype,string varvalue)
{  double var2;
   if (vartype=="int" || vartype=="double") var2=StringToDouble(varvalue);
   if (vartype=="bool") {if (varvalue=="true") var2=1; else var2=0; }
   
   switch (vname)
   {
      case "sym": {if (vartype=="string") sym=varvalue; else sym=var2; }

   }


}