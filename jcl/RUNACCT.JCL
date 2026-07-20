//ACCTJOB  JOB (ACCTG01),'NEEL PATEL',CLASS=A,MSGCLASS=X,
//         NOTIFY=&SYSUID
//*--------------------------------------------------------------
//* Runs the monthly account-interest batch job.
//* This is reference JCL: it shows the shape of a real mainframe
//* batch job (JOB card, EXEC step, DD statements for each dataset)
//* but is not executable outside a licensed z/OS environment.
//*--------------------------------------------------------------
//STEP010  EXEC PGM=ACCTPROC
//STEPLIB  DD  DSN=NEEL.LOADLIB,DISP=SHR
//*
//* Input: account extract, in practice this would be produced by
//* an earlier step that unloads rows from a DB2 table.
//ACCOUNT  DD  DSN=NEEL.ACCOUNTS.DAT,DISP=SHR
//*
//* Output: updated account balances after interest is applied.
//UPDATED  DD  DSN=NEEL.UPDATED.DAT,
//             DISP=(NEW,CATLG,DELETE),
//             SPACE=(TRK,(5,5)),
//             DCB=(RECFM=FB,LRECL=80)
//*
//* Output: human-readable summary report for operations/audit.
//REPORT   DD  DSN=NEEL.REPORT.TXT,
//             DISP=(NEW,CATLG,DELETE),
//             SPACE=(TRK,(5,5)),
//             DCB=(RECFM=FB,LRECL=80)
//*
//SYSOUT   DD  SYSOUT=*
//SYSIN    DD  DUMMY
