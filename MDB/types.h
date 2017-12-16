/******************************************************************/
/* THIS IS AN AUTOMATICALLY GENERATED FILE.  DO NOT EDIT IT!!!!!! */
/******************************************************************/
typedef struct _Amendment
{
coagyear;
	char *	projectid;
	char *	subprojectid;
amendno;
	char *	amendrefno;
amenddate;
cashonhand;
carryover;
new;
gain;
_datecreated;
	char *	_usercreated;
_dateupdated;
	char *	_userupdated;

} Amendment ;

typedef struct _Budget
{
coagyear;
	char *	projectid;
	char *	subprojectid;
objectclassid;
	int	itemno;
amendno;
	char *	itemdescription;
	char *	itemdescriptiond;
	char *	restrict;
cashonhand;
carryover;
new;
total;
	char *	unit;
	int	qty;
op1;
op2;
op3;
op4;
op5;
_datecreated;
	char *	_usercreated;
_dateupdated;
	char *	_userupdated;

} Budget ;

typedef struct _CoAgYear
{
coagyear;
periodfrom;
periodto;
exchangerate;
exchangerateco;
exchangeratecash;

} CoAgYear ;

typedef struct _ObjectClass
{
objectclassid;
	char *	objectclassname;

} ObjectClass ;

typedef struct _Program
{
programid;
	char *	programname;

} Program ;

typedef struct _Project
{
	char *	projectid;
	char *	projectname;
	char *	coagwith;
	char *	research;
programid;
	char *	technicalcoordinator;

} Project ;

typedef struct _ProjectSubproject
{
coagyear;
	char *	projectid;
	char *	subprojectid;
	char *	projectcoordinator;

} ProjectSubproject ;

typedef struct _Receive
{
coagyear;
	char *	projectid;
	char *	subprojectid;
datereceived;
receiveno;
amountreceivedusd;
exchangerate;
amountreceivedthb;
gain;
	char *	chequereceived;
	char *	remark;
_datecreated;
	char *	_usercreated;
_dateupdated;
	char *	_userupdated;

} Receive ;

typedef struct _Spend
{
coagyear;
	char *	projectid;
	char *	subprojectid;
objectclassid;
	int	itemno;
	int	spendno;
	char *	spenddescription;
datespent;
amountspent;
	char *	chequespent;
dateadjusted;
amountadjusted;
	char *	chequeadjusted;
dateobligated;
amountobligated;
	char *	remark;
_datecreated;
	char *	_usercreated;
_dateupdated;
	char *	_userupdated;

} Spend ;

typedef struct _Subproject
{
	char *	subprojectid;
	char *	subprojectname;

} Subproject ;

typedef struct _User
{
	char *	userid;
	char *	password;

} User ;

typedef struct _BudgetAmend
{
coagyear;
	char *	projectid;
	char *	subprojectid;
objectclassid;
	int	itemno;
amendno;
	char *	itemdescription;
	char *	itemdescriptiond;
	char *	restrict;
oldtotal;
total;
	char *	unit;
	int	qty;
op1;
op2;
op3;
op4;
op5;
upd;

} BudgetAmend ;

