/******************************************************************/
/* THIS IS AN AUTOMATICALLY GENERATED FILE.  DO NOT EDIT IT!!!!!! */
/******************************************************************/
#include <stdio.h>
#include "dumptypes.h"
void dump_Amendment (Amendment x)
{
	fprintf (stdout, "**************** Amendment ****************\n");
	fprintf (stdout, "x.coagyear = ");
coagyear);
	fprintf (stdout, "x.projectid = ");
	dump_string (x.projectid);
	fprintf (stdout, "x.subprojectid = ");
	dump_string (x.subprojectid);
	fprintf (stdout, "x.amendno = ");
amendno);
	fprintf (stdout, "x.amendrefno = ");
	dump_string (x.amendrefno);
	fprintf (stdout, "x.amenddate = ");
amenddate);
	fprintf (stdout, "x.cashonhand = ");
cashonhand);
	fprintf (stdout, "x.carryover = ");
carryover);
	fprintf (stdout, "x.new = ");
new);
	fprintf (stdout, "x.gain = ");
gain);
	fprintf (stdout, "x._datecreated = ");
_datecreated);
	fprintf (stdout, "x._usercreated = ");
	dump_string (x._usercreated);
	fprintf (stdout, "x._dateupdated = ");
_dateupdated);
	fprintf (stdout, "x._userupdated = ");
	dump_string (x._userupdated);
}

void dump_Budget (Budget x)
{
	fprintf (stdout, "**************** Budget ****************\n");
	fprintf (stdout, "x.coagyear = ");
coagyear);
	fprintf (stdout, "x.projectid = ");
	dump_string (x.projectid);
	fprintf (stdout, "x.subprojectid = ");
	dump_string (x.subprojectid);
	fprintf (stdout, "x.objectclassid = ");
objectclassid);
	fprintf (stdout, "x.itemno = ");
	dump_int (x.itemno);
	fprintf (stdout, "x.amendno = ");
amendno);
	fprintf (stdout, "x.itemdescription = ");
	dump_string (x.itemdescription);
	fprintf (stdout, "x.itemdescriptiond = ");
	dump_string (x.itemdescriptiond);
	fprintf (stdout, "x.restrict = ");
	dump_string (x.restrict);
	fprintf (stdout, "x.cashonhand = ");
cashonhand);
	fprintf (stdout, "x.carryover = ");
carryover);
	fprintf (stdout, "x.new = ");
new);
	fprintf (stdout, "x.total = ");
total);
	fprintf (stdout, "x.unit = ");
	dump_string (x.unit);
	fprintf (stdout, "x.qty = ");
	dump_int (x.qty);
	fprintf (stdout, "x.op1 = ");
op1);
	fprintf (stdout, "x.op2 = ");
op2);
	fprintf (stdout, "x.op3 = ");
op3);
	fprintf (stdout, "x.op4 = ");
op4);
	fprintf (stdout, "x.op5 = ");
op5);
	fprintf (stdout, "x._datecreated = ");
_datecreated);
	fprintf (stdout, "x._usercreated = ");
	dump_string (x._usercreated);
	fprintf (stdout, "x._dateupdated = ");
_dateupdated);
	fprintf (stdout, "x._userupdated = ");
	dump_string (x._userupdated);
}

void dump_CoAgYear (CoAgYear x)
{
	fprintf (stdout, "**************** CoAgYear ****************\n");
	fprintf (stdout, "x.coagyear = ");
coagyear);
	fprintf (stdout, "x.periodfrom = ");
periodfrom);
	fprintf (stdout, "x.periodto = ");
periodto);
	fprintf (stdout, "x.exchangerate = ");
exchangerate);
	fprintf (stdout, "x.exchangerateco = ");
exchangerateco);
	fprintf (stdout, "x.exchangeratecash = ");
exchangeratecash);
}

void dump_ObjectClass (ObjectClass x)
{
	fprintf (stdout, "**************** ObjectClass ****************\n");
	fprintf (stdout, "x.objectclassid = ");
objectclassid);
	fprintf (stdout, "x.objectclassname = ");
	dump_string (x.objectclassname);
}

void dump_Program (Program x)
{
	fprintf (stdout, "**************** Program ****************\n");
	fprintf (stdout, "x.programid = ");
programid);
	fprintf (stdout, "x.programname = ");
	dump_string (x.programname);
}

void dump_Project (Project x)
{
	fprintf (stdout, "**************** Project ****************\n");
	fprintf (stdout, "x.projectid = ");
	dump_string (x.projectid);
	fprintf (stdout, "x.projectname = ");
	dump_string (x.projectname);
	fprintf (stdout, "x.coagwith = ");
	dump_string (x.coagwith);
	fprintf (stdout, "x.research = ");
	dump_string (x.research);
	fprintf (stdout, "x.programid = ");
programid);
	fprintf (stdout, "x.technicalcoordinator = ");
	dump_string (x.technicalcoordinator);
}

void dump_ProjectSubproject (ProjectSubproject x)
{
	fprintf (stdout, "**************** ProjectSubproject ****************\n");
	fprintf (stdout, "x.coagyear = ");
coagyear);
	fprintf (stdout, "x.projectid = ");
	dump_string (x.projectid);
	fprintf (stdout, "x.subprojectid = ");
	dump_string (x.subprojectid);
	fprintf (stdout, "x.projectcoordinator = ");
	dump_string (x.projectcoordinator);
}

void dump_Receive (Receive x)
{
	fprintf (stdout, "**************** Receive ****************\n");
	fprintf (stdout, "x.coagyear = ");
coagyear);
	fprintf (stdout, "x.projectid = ");
	dump_string (x.projectid);
	fprintf (stdout, "x.subprojectid = ");
	dump_string (x.subprojectid);
	fprintf (stdout, "x.datereceived = ");
datereceived);
	fprintf (stdout, "x.receiveno = ");
receiveno);
	fprintf (stdout, "x.amountreceivedusd = ");
amountreceivedusd);
	fprintf (stdout, "x.exchangerate = ");
exchangerate);
	fprintf (stdout, "x.amountreceivedthb = ");
amountreceivedthb);
	fprintf (stdout, "x.gain = ");
gain);
	fprintf (stdout, "x.chequereceived = ");
	dump_string (x.chequereceived);
	fprintf (stdout, "x.remark = ");
	dump_string (x.remark);
	fprintf (stdout, "x._datecreated = ");
_datecreated);
	fprintf (stdout, "x._usercreated = ");
	dump_string (x._usercreated);
	fprintf (stdout, "x._dateupdated = ");
_dateupdated);
	fprintf (stdout, "x._userupdated = ");
	dump_string (x._userupdated);
}

void dump_Spend (Spend x)
{
	fprintf (stdout, "**************** Spend ****************\n");
	fprintf (stdout, "x.coagyear = ");
coagyear);
	fprintf (stdout, "x.projectid = ");
	dump_string (x.projectid);
	fprintf (stdout, "x.subprojectid = ");
	dump_string (x.subprojectid);
	fprintf (stdout, "x.objectclassid = ");
objectclassid);
	fprintf (stdout, "x.itemno = ");
	dump_int (x.itemno);
	fprintf (stdout, "x.spendno = ");
	dump_int (x.spendno);
	fprintf (stdout, "x.spenddescription = ");
	dump_string (x.spenddescription);
	fprintf (stdout, "x.datespent = ");
datespent);
	fprintf (stdout, "x.amountspent = ");
amountspent);
	fprintf (stdout, "x.chequespent = ");
	dump_string (x.chequespent);
	fprintf (stdout, "x.dateadjusted = ");
dateadjusted);
	fprintf (stdout, "x.amountadjusted = ");
amountadjusted);
	fprintf (stdout, "x.chequeadjusted = ");
	dump_string (x.chequeadjusted);
	fprintf (stdout, "x.dateobligated = ");
dateobligated);
	fprintf (stdout, "x.amountobligated = ");
amountobligated);
	fprintf (stdout, "x.remark = ");
	dump_string (x.remark);
	fprintf (stdout, "x._datecreated = ");
_datecreated);
	fprintf (stdout, "x._usercreated = ");
	dump_string (x._usercreated);
	fprintf (stdout, "x._dateupdated = ");
_dateupdated);
	fprintf (stdout, "x._userupdated = ");
	dump_string (x._userupdated);
}

void dump_Subproject (Subproject x)
{
	fprintf (stdout, "**************** Subproject ****************\n");
	fprintf (stdout, "x.subprojectid = ");
	dump_string (x.subprojectid);
	fprintf (stdout, "x.subprojectname = ");
	dump_string (x.subprojectname);
}

void dump_User (User x)
{
	fprintf (stdout, "**************** User ****************\n");
	fprintf (stdout, "x.userid = ");
	dump_string (x.userid);
	fprintf (stdout, "x.password = ");
	dump_string (x.password);
}

void dump_BudgetAmend (BudgetAmend x)
{
	fprintf (stdout, "**************** BudgetAmend ****************\n");
	fprintf (stdout, "x.coagyear = ");
coagyear);
	fprintf (stdout, "x.projectid = ");
	dump_string (x.projectid);
	fprintf (stdout, "x.subprojectid = ");
	dump_string (x.subprojectid);
	fprintf (stdout, "x.objectclassid = ");
objectclassid);
	fprintf (stdout, "x.itemno = ");
	dump_int (x.itemno);
	fprintf (stdout, "x.amendno = ");
amendno);
	fprintf (stdout, "x.itemdescription = ");
	dump_string (x.itemdescription);
	fprintf (stdout, "x.itemdescriptiond = ");
	dump_string (x.itemdescriptiond);
	fprintf (stdout, "x.restrict = ");
	dump_string (x.restrict);
	fprintf (stdout, "x.oldtotal = ");
oldtotal);
	fprintf (stdout, "x.total = ");
total);
	fprintf (stdout, "x.unit = ");
	dump_string (x.unit);
	fprintf (stdout, "x.qty = ");
	dump_int (x.qty);
	fprintf (stdout, "x.op1 = ");
op1);
	fprintf (stdout, "x.op2 = ");
op2);
	fprintf (stdout, "x.op3 = ");
op3);
	fprintf (stdout, "x.op4 = ");
op4);
	fprintf (stdout, "x.op5 = ");
op5);
	fprintf (stdout, "x.upd = ");
upd);
}

