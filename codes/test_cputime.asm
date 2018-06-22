*        1         2         3         4         5         6         71
*23456789*12345*789012345678901234*678901234567890123456789012345678901
* $Id: test_cputime.asm 1029 2018-06-16 14:53:20Z mueller $
*
* Copyright 2018- by Walter F.J. Mueller <W.F.J.Mueller@gsi.de>
*
* This program is free software; you may redistribute and/or modify
* it under the terms of the GNU General Public License version 3.
* See Licence.txt in distribition directory for further details.
*
*  Revision History:
* Date         Rev Version  Comment
* 2018-06-15  1029   1.0    Initial version
* 2018-06-14  1028   0.1    First draft (derived from test_stck.asm)
*
      PRINT NOGEN              don't show macro expansions
*
* local macros --------------------------------------------------------
//** ##rinclude ../sios/otxtdsc.asm
*
* Test high-resolution CPU time retrieval
*   RC =  0  ok
*   RC = 16  open SYSPRINT failed
*
* main preamble -------------------------------------------------------
*
MAIN     START 0                  start main code csect at base 0
         SAVE  (14,12)            Save input registers
         LR    R12,R15            base register := entry address
         USING MAIN,R12           declare base register
         ST    R13,SAVE+4         set back pointer in current save area
         LR    R2,R13             remember callers save area
         LA    R13,SAVE           setup current save area
         ST    R13,8(R2)          set forw pointer in callers save area
*
* open datasets -------------------------------------------------------
*
         OPEN  (SYSPRINT,OUTPUT)  open SYSPRINT
         LTR   R15,R15            test return code
         BE    OOPENOK
         MVI   RC+3,X'10'
         B     EXIT               quit with RC=16
OOPENOK  EQU   *
*
* main body -----------------------------------------------------------
*
         L     R1,MSGHDR1
         BAL   R14,OTEXT
         L     R1,MSGHDR2
         BAL   R14,OTEXT
         L     R1,MSGHDR3
         BAL   R14,OTEXT
         BAL   R14,OPUTLINE       write line
*
         BAL   R14,CPUTIM
*
* outer loop
*   R2   ptr into RCLIST
*   R3   outer loop count
*   R4   inner loop count
*   R5   inst counter
*
         LA    R2,RCLIST          pointer to repeat count list
         LA    R3,(RCLISTE-RCLIST)/4  list length
         XR    R5,R5              clear inst counter
OLOOP    L     R4,0(R2)           load repeat count
         ST    R4,RCCUR           and save it
         LA    R2,4(R2)           push pointer
*
* inner loop
*
ILOOP    EQU   *
*
         A     R5,=F'1'           1th
         A     R5,=F'1'
         A     R5,=F'1'
         A     R5,=F'1'
         A     R5,=F'1'
         A     R5,=F'1'
         A     R5,=F'1'
         A     R5,=F'1'
         A     R5,=F'1'
         A     R5,=F'1'
*
         BCT   R4,ILOOP           inner loop
*
         BAL   R14,CPUTIM
         BCT   R3,OLOOP           outer loop
*
         LR    R1,R6
         BAL   R14,OINT10         print inst count
         BAL   R14,OPUTLINE       write line
*
* close datasets and return to OS -------------------------------------
*
EXIT     CLOSE SYSPRINT           close SYSPRINT
         L     R13,SAVE+4         get old save area back
         L     R0,RC              get return code
         ST    R0,16(R13)         store in old save R15
         RETURN (14,12)           return to OS (will setup RC)
*
* get CPU time in micro seconds (only printed)
*   R6      ptr to  LCCA
*   R7      ptr to  ASCB
*   R8,R9   double word load buffer
*   R10     retry loop counter
*
         USING PSA,R0
         USING LCCA,R6
         USING ASCB,R7
*
CPUTIM   EQU   *
         ST    R14,CPUTIML        save R14
*
         L     R6,PSALCCAV        get LCCA ptr
         L     R7,PSAAOLD         get ASCB ptr
         LA    R10,9              init retry loop count
*
CPUTIMR  LM    R8,R9,LCCADTOD     get initial LCCADTOD
         STM   R8,R9,SAVDTOD      and save it
*
         STCK  CKBUF              store TOD
         LM    R0,R1,CKBUF
         SLR   R1,R9              low order:  sum=TOD-LCCADTOD
         BC    3,*+4+4            check for borrow
         SL    R0,=F'1'           and correct if needed
         SLR   R0,R8              high order: sum=TOD-LCCADTOD
*
         LM    R8,R9,ASCBEJST     load ASCBEJST
         ALR   R1,R9              low order:  sum+=ASCBEJST
         BC    12,*+4+4           check for carry
         AL    R0,=F'1'           and correct if needed
         ALR   R0,R8              high order: sum+=ASCBEJST
*
         LM    R8,R9,ASCBSRBT     load ASCBSRBT
         ALR   R1,R9              low order:  sum+=ASCBSRBT
         BC    12,*+4+4           check for carry
         AL    R0,=F'1'           and correct if needed
         ALR   R0,R8              high order: sum+=ASCBSRBT
*
         LM    R8,R9,LCCADTOD     get final LCCADTOD
         C     R9,SAVDTOD+4       check low order
         BNE   CPUTIMN            if ne, dispatch detected
         C     R8,SAVDTOD         check high order
         BE    CPUTIME            if eq, all fine
*
CPUTIMN  BCT   R10,CPUTIMR        retry in case dispatch detected
*
CPUTIME  STM   R0,R1,SAVSUM       save full sum
         SRDL  R0,12              shift to convert to microsec
         LR    R9,R1              save time in usec
*
         L     R1,RCCUR
         BAL   R14,OINT10         print RC
         LA    R1,CKBUF
         BAL   R14,OHEX210        print STCK     (as hex)
         LA    R1,SAVDTOD
         BAL   R14,OHEX210        print LCCADTOD (as hex)
         LA    R1,ASCBEJST
         BAL   R14,OHEX210        print ASCBEJST (as hex)
         LA    R1,ASCBSRBT
         BAL   R14,OHEX210        print ASCBSRBT (as hex)
         LA    R1,SAVSUM
         BAL   R14,OHEX210        print SAVSUM   (as hex)
         LR    R1,R9
         BAL   R14,OINT10         print CPUTIM   (in usec)
         LR    R1,R9
         S     R1,TOLD
         ST    R9,TOLD
         BAL   R14,OINT10         print dt (in usec)
         LA    R1,9
         SR    R1,R10
         BAL   R14,OINT02         print re-try count
         BAL   R14,OPUTLINE       write line
*
         L     R14,CPUTIML        restore R14 linkage
         BR    R14
*
         DROP  R0
         DROP  R6
         DROP  R7
*
* Work area definitions -----------------------------------------------
*
* local data -------------------------------------
*
SAVE     DS    18F                local save area
RC       DC    F'0'               return code
*
CPUTIML  DS    1F                 save area for R14
RCCUR    DS    1F
TOLD     DC    F'0'
CKBUF    DS    1D
SAVDTOD  DS    1D
SAVSUM   DS    1D
*
MSGHDR1  OTXTDSC  C'  ......RC  ..............STCK  ..........LCCADTOD'
MSGHDR2  OTXTDSC  C'  ..........ASCBEJST  ..........ASCBSRBT' 
MSGHDR3  OTXTDSC  C'  ...............SUM      USEC   dt-USEC R' 
*
RCLIST   DC    F'1'
         DC    F'1'
         DC    F'1'
         DC    F'1'
         DC    F'1'
         DC    F'1'
         DC    F'1'
         DC    F'1'
         DC    F'1'
         DC    F'1'
         DC    F'10'
         DC    F'10'
         DC    F'10'
         DC    F'10'
         DC    F'10'
         DC    F'10'
         DC    F'10'
         DC    F'10'
         DC    F'10'
         DC    F'10'
         DC    F'100'
         DC    F'100'
         DC    F'100'
         DC    F'100'
         DC    F'100'
         DC    F'100'
         DC    F'100'
         DC    F'100'
         DC    F'100'
         DC    F'100'
         DC    F'1000'
         DC    F'1000'
         DC    F'1000'
         DC    F'1000'
         DC    F'1000'
         DC    F'1000'
         DC    F'1000'
         DC    F'1000'
         DC    F'1000'
         DC    F'1000'
         DC    F'10000'
         DC    F'10000'
         DC    F'10000'
         DC    F'10000'
         DC    F'10000'
         DC    F'10000'
         DC    F'10000'
         DC    F'10000'
         DC    F'10000'
         DC    F'10000'
         DC    F'10000'
         DC    F'10000'
         DC    F'10000'
         DC    F'10000'
         DC    F'10000'
         DC    F'10000'
         DC    F'10000'
         DC    F'10000'
         DC    F'10000'
         DC    F'10000'
         DC    F'10000'
         DC    F'10000'
         DC    F'10000'
         DC    F'10000'
         DC    F'10000'
         DC    F'10000'
         DC    F'10000'
         DC    F'10000'
         DC    F'10000'
         DC    F'10000'
         DC    F'10000'
         DC    F'10000'
         DC    F'10000'
         DC    F'10000'
         DC    F'10000'
         DC    F'10000'
         DC    F'10000'
         DC    F'10000'
         DC    F'10000'
         DC    F'10000'
         DC    F'10000'
         DC    F'10000'
         DC    F'10000'
         DC    F'10000'
         DC    F'10000'
         DC    F'10000'
         DC    F'10000'
         DC    F'10000'
         DC    F'10000'
         DC    F'10000'
         DC    F'100000'
         DC    F'100000'
         DC    F'100000'
         DC    F'100000'
         DC    F'100000'
         DC    F'100000'
         DC    F'100000'
         DC    F'100000'
         DC    F'100000'
         DC    F'100000'
         DC    F'100000'
         DC    F'100000'
         DC    F'100000'
         DC    F'100000'
         DC    F'100000'
         DC    F'100000'
         DC    F'100000'
         DC    F'100000'
         DC    F'100000'
         DC    F'100000'
         DC    F'100000'
         DC    F'100000'
         DC    F'100000'
         DC    F'100000'
         DC    F'100000'
         DC    F'100000'
         DC    F'100000'
         DC    F'100000'
         DC    F'100000'
         DC    F'100000'
         DC    F'100000'
         DC    F'100000'
         DC    F'100000'
         DC    F'100000'
         DC    F'100000'
         DC    F'100000'
         DC    F'100000'
         DC    F'100000'
         DC    F'100000'
         DC    F'100000'
         DC    F'100000'
         DC    F'100000'
         DC    F'100000'
         DC    F'100000'
         DC    F'100000'
         DC    F'100000'
         DC    F'100000'
         DC    F'100000'
         DC    F'100000'
         DC    F'100000'
         DC    F'1000000'
         DC    F'1000000'
         DC    F'1000000'
         DC    F'1000000'
         DC    F'1000000'
         DC    F'1000000'
         DC    F'1000000'
         DC    F'1000000'
         DC    F'1000000'
         DC    F'1000000'
         DC    F'10000000'
         DC    F'10000000'
RCLISTE  EQU   *
*
* include simple output system ----------------------------------------
//** ##rinclude ../sios/sos_base.asm
//** ##rinclude ../sios/sos_oint02.asm
//** ##rinclude ../sios/sos_oint10.asm
//** ##rinclude ../sios/sos_ohex10.asm
//** ##rinclude ../sios/sos_ohex210.asm
//** ##rinclude ../sios/sos_ofix1308.asm
*
* spill literal pool
*
         LTORG
*
* other defs and end
*
         IHAPSA
         IHALCCA
         IHAASCB
*
         YREGS ,
FR0      EQU   0
FR2      EQU   2
FR4      EQU   4
FR6      EQU   6
         END   MAIN               define main entry point
