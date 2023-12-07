string filter_option = ".";
string select;
string pass;

integer protected = FALSE;
integer ichannel = 472;
integer cur_page = 1;
integer chanhandlr;
integer option = 0;

random(){ichannel = llFloor(llFrand(1000000) - 100000); llListenRemove(chanhandlr); chanhandlr = llListen(ichannel, "", NULL_KEY, "");}
list order_buttons(list buttons)
{
return llList2List(buttons, -3, -1) + llList2List(buttons, -6, -4) +
llList2List(buttons, -9, -7) + llList2List(buttons, -12, -10);
}
list numerizelist(list tlist, integer start, string apnd)
{
list newlist; integer lsize = llGetListLength(tlist); integer i;
for(; i < lsize; i++)
{
newlist += [(string)(start + i) + apnd + llList2String(tlist, i)];
}return newlist;}
dialog_songmenu(integer page)
{
list items = llLinksetDataFindKeys(filter_option,0,llLinksetDataCountKeys());
integer slist_size = llGetListLength(items);
integer pag_amt = llCeil((float)slist_size / 9.0);
if(page > pag_amt) page = 1;
else if(page < 1) page = pag_amt;
cur_page = page; integer songsonpage;
if(page == pag_amt)
songsonpage = slist_size % 9;
if(songsonpage == 0)
songsonpage = 9; integer fspnum = (page*9)-9; list dbuf; integer i;
for(; i < songsonpage; ++i)
{
dbuf += ["Play #" + (string)(fspnum+i)];
}
list snlist = numerizelist(make_list(fspnum,i), fspnum, ". ");
llDialog(llGetOwner(),
"data list"+"\n"+
"filter ' "+filter_option+" '\n\n"+
llDumpList2String(snlist, "\n"),order_buttons(dbuf + ["<<<", "[ main ]", ">>>"]),ichannel);
}
string unkn(string k){if("" == k){if(llLinksetDataReadProtected(select,pass) == ""){return "????";}else{return llLinksetDataReadProtected(select,pass);}}pass = ""; return k;}
string unk(string k,string a){if("" == llLinksetDataReadProtected(select,pass)){return "[ pass ]";}return a;}
string unknown(string k){if("" == k){return "????";}return k;}
list make_list(integer a,integer b)
{
  list inventory; integer i;
  for(i = 0; i < b; ++i)
  {
  list items = llLinksetDataFindKeys(filter_option,0,llLinksetDataCountKeys());
  string a = llDeleteSubString(llList2String(items,a+i)+"-"+unknown(llLinksetDataRead(llList2String(items,a+i))),40,1000);
  inventory += a;
  }return inventory;
}
dialog1()
{
random();
string a = llLinksetDataRead(select);
llDialog(llGetOwner(),"data - "+llDeleteSubString(select+"="+unkn(llLinksetDataRead(select)),40,1000)
,[unk(a,"[ delete ]"),unk(a,"[ rewrite ]"),unk(a,"[ say ]"),"[  🞪  ]","[ main ]","[  ←  ]"],ichannel);
}
dialog2()
{
random();
llDialog(llGetOwner(),
"main menu\n\n"+
"memory = "+(string)llLinksetDataAvailable()+"\n"+
"list count = "+(string)llGetListLength(llLinksetDataFindKeys(filter_option,0,llLinksetDataCountKeys()))+"\n"+
"filter = ' "+filter_option+" '\n",["[ filter ]","[ list ]","[ write ]","[  🞪  ]","...","[ Dele ]"],ichannel);
}
dialog0(){random();dialog_songmenu(cur_page);}
dialog3(){random();llDialog(llGetOwner(),"main",["[ main ]","[ delete_f ]","[ delete_all ]"],ichannel);}
dialog5(){random();llDialog(llGetOwner(),"main",["[ main ]","[ unprotect ]","[ protected ]"],ichannel);}
dialog4(string a,string b){random();llTextBox(llGetOwner(),a+".\n"+b,ichannel);}
default
{
    on_rez(integer start_param)
    {
    llResetScript();
    }
    touch_start(integer total_number)
    {
    if (llDetectedKey(0) == llGetOwner()){dialog2();}
    }
    listen(integer chan, string sname, key skey, string text)
    {  
    if(skey == llGetOwner()) 
    {
        if(text == "[ protected ]"){option = 6;dialog4("write","sample : name=data=pass");return;}  
        if(text == "[ unprotect ]"){option = 3;dialog4("write","sample : name=data");return;}  
        if(text == "[ filter ]"){option = 1;dialog4("filter","default ' . '");return;}
        if(text == "[ delete_f ]"){option = 2;dialog4("data delete found","");return;}
        if(text == "[ rewrite ]"){option = 4;dialog4("rewrite data","");return;}  
        if(text == "[ delete_all ]"){llLinksetDataReset();dialog2();return;}
        if(text == "[ pass ]"){option = 5;dialog4("enter pass","");return;}   
        if(text == "[ write ]"){dialog5();return;}
        if(text == "[ list ]"){dialog0();return;}
        if(text == "[ main ]"){dialog2();return;}
        if(text == "[ Dele ]"){dialog3();return;}
        if(text == "[  ←  ]"){dialog0();return;}
        if(text == "..."){dialog2();return;}
        if(text == ">>>"){dialog_songmenu(cur_page+1);return;}
        if(text == "<<<"){dialog_songmenu(cur_page-1);return;}
        if(llToLower(llGetSubString(text,0,5)) == "play #")
        {
        integer pnum = (integer)llGetSubString(text,6,-1);
        list a = llLinksetDataFindKeys(filter_option,0,llLinksetDataCountKeys());
        select = llList2String(a,pnum); dialog1(); return;
        }
        if(text == "[ say ]")
        {  
        if(llLinksetDataReadProtected(select,pass) == ""){ }else{llOwnerSay(select+"-"+llLinksetDataReadProtected(select,pass));}
        if(llLinksetDataRead(select) == ""){ }else{llOwnerSay(select+"-"+llLinksetDataRead(select));}
        dialog1();
        return;
        }
        if(text == "[ delete ]")
        {
        if(llLinksetDataReadProtected(select,pass) == ""){ }else{llLinksetDataDeleteProtected(select,pass);} 
        if(llLinksetDataRead(select) == ""){ }else{llLinksetDataDelete(select);}
        dialog0();
        return;
        }
        if(option == 4)
        {
        if(llLinksetDataReadProtected(select,pass) == ""){ }else{llLinksetDataWriteProtected(select,text,pass);}  
        if(llLinksetDataRead(select) == ""){ }else{llLinksetDataWrite(select,text);}
        dialog1();
        }
        if(option == 6)
        {
        list a = llParseString2List(text,["="], []);
        llLinksetDataWriteProtected(llList2String(a,0),llList2String(a,1),llList2String(a,2)); dialog2();
        }
        if(option == 3)
        {
        list a = llParseString2List(text,["="], []);
        llLinksetDataWrite(llList2String(a,0),llList2String(a,1)); dialog2();
        }
        if(option == 2){llLinksetDataDeleteFound(text,"");dialog2();}
        if(option == 1){filter_option = text;dialog2();} 
        if(option == 5){pass = text;dialog1();}
        }
        option = 0;
        return;
        }
    }