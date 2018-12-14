Delivered-To: sfinfo@enteract.com
From: Stewart.Robertson@yeg.co.uk
X-OpenMail-Hops: 1
Date: Fri, 2 Jul 1999 15:05:31 +0100
Subject: Is this good code ?
To: alexd@au1.ibm.com, bedis@cellarmasters.com.au, davidp@ucs.com.au,
        dmassabu@hotmail.com, karl@webolution.com.au, mcicero@sandm.com.au,
        sfinfo@stevenfeuerstein.com, Vicky.Wills@nestlegb.nestle.com
Cc: Adrian.Huxley@yeg.co.uk, David.Thompson@yeg.co.uk

Here is the type of stuff that my Team Leader churns out. Now, I know
this is geeky but, has anyone ever seen anything like this ?

Steven, for a professional opinion I thought that I would also copy you
into this message. Is there any hope for him ?

Stewart


-----Original Message-----
From:       Thompson, David  
Sent:       Friday, July 02, 1999 2:31 PM
To:         Robertson, Stewart; Huxley, Adrian
Subject:    Big Ball of String


This is what poor Josie has to interpret.

Dave.

------------------------------------------------------

ps England 77-7


CREATE OR REPLACE PROCEDURE LOAD_BASE_TABLES (STATUS  OUT VARCHAR2,
                                  restart IN varchar2 default 'N',
                               start_point IN number  default 0)
                               IS
/***********************************************************************
*******
   NAME:       LOAD_BASE_TABLES
   PURPOSE:    script to load all base table data

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------
------------------------------------
   1.0        24/06/99   Patrick Paton      Shell Script to manage data
load

   PARAMETERS:
   INPUT:
   OUTPUT:
   RETURNED VALUE:
   CALLED BY:
   CALLS:
   EXAMPLE USE:     exec load_base_tables;
   ASSUMPTIONS:
   LIMITATIONS:
   ALGORITHM:
   NOTES:
************************************************************************
******/

v_status          varchar2(1);
invalid_point     exception;
start_point_failure exception;
extract_details_failed   exception;
max_start_point      number;
v_start_point     number;
extract_id        number;
extract_date      date;


BEGIN
/***Insert message, date and time into dr_session_progress*******/
   WRITE_LOG('Load_base_table started');



status := 'S';

/***********Getting extract information***************/

get_extract_details (v_status, extract_id, extract_date);
If v_status = 'F' then Raise extract_details_failed;
end if;


/**********Checking for restart point******************/

   IF restart = 'N'
    THEN GOTO start_point_10;
   END IF;

/**********Checking for restart point if restarted
manually******************/

    IF start_point != 0
     THEN
      IF start_point = 10
       THEN GOTO start_point_10;
      Elsif start_point = 20
       THEN GOTO start_point_20;
      Elsif start_point = 30
       THEN GOTO start_point_30;
      Elsif start_point = 40
       THEN GOTO start_point_40;
      Elsif start_point = 50
       THEN GOTO start_point_50;
      Elsif start_point = 60
       THEN GOTO start_point_60;
      Elsif start_point = 70
       THEN GOTO start_point_70;
      Elsif start_point = 80
       THEN GOTO start_point_80;
      Elsif start_point = 90
       THEN GOTO start_point_90;
      Elsif start_point = 100
       THEN GOTO start_point_100;
      Elsif start_point = 120
       THEN GOTO start_point_120;
      Elsif start_point = 130
       THEN GOTO start_point_130;
      Elsif start_point = 140
       THEN GOTO start_point_140;
      Elsif start_point = 150
       THEN GOTO start_point_150;
      Elsif start_point = 160
       THEN GOTO start_point_160;
      Elsif start_point = 170
       THEN GOTO start_point_170;
     Elsif start_point = 180
       THEN GOTO start_point_180;
      Elsif start_point = 190
       THEN GOTO start_point_190;
     Elsif start_point = 200
       THEN GOTO start_point_200;
     Elsif start_point = 210
       THEN GOTO start_point_210;
     Elsif start_point = 220
       THEN GOTO start_point_220;
     Elsif start_point = 230
       THEN GOTO start_point_230;
     Elsif start_point = 235
       THEN GOTO start_point_235;
      Elsif start_point = 240
       THEN GOTO start_point_240;
      Elsif start_point = 250
       THEN GOTO start_point_250;
      Elsif start_point = 260
       THEN GOTO start_point_260;
      Elsif start_point = 265
       THEN GOTO start_point_265;
      Elsif start_point = 270
       THEN GOTO start_point_270;
      Elsif start_point = 280
       THEN GOTO start_point_280;
      Elsif start_point = 290
       THEN GOTO start_point_290;
      Elsif start_point = 310
       THEN GOTO start_point_310;
      Elsif start_point = 320
       THEN GOTO start_point_320;
      Elsif start_point = 330
       THEN GOTO start_point_330;
      Elsif start_point = 340
       THEN GOTO start_point_340;
      Elsif start_point = 350
       THEN GOTO start_point_350;
      Elsif start_point = 360
       THEN GOTO start_point_360;
      Elsif start_point = 370
       THEN GOTO start_point_370;
      Elsif start_point = 380
       THEN GOTO start_point_380;
      Elsif start_point = 390
       THEN GOTO start_point_390;
      Elsif start_point = 400
       THEN GOTO start_point_400;
      Elsif start_point = 410
       THEN GOTO start_point_410;
      Elsif start_point = 420
       THEN GOTO start_point_420;
      Elsif start_point = 430
       THEN GOTO start_point_430;
      Elsif start_point = 440
       THEN GOTO start_point_440;
      Elsif start_point = 450
       THEN GOTO start_point_450;
     Elsif start_point = 460
       THEN GOTO start_point_460;
     Elsif start_point = 470
       THEN GOTO start_point_470;
     Elsif start_point = 480
       THEN GOTO start_point_480;
     Elsif start_point = 490
       THEN GOTO start_point_490;
     Elsif start_point = 500
       THEN GOTO start_point_500;
     Elsif start_point = 510
       THEN GOTO start_point_510;
     Elsif start_point = 520
       THEN GOTO start_point_520;
    Elsif start_point = 530
       THEN GOTO start_point_530;
    Elsif start_point = 540
       THEN GOTO start_point_540;
    Elsif start_point = 550
       THEN GOTO start_point_550;
     Elsif start_point = 560
       THEN GOTO start_point_560;
     Elsif start_point = 570
       THEN GOTO start_point_570;
     Elsif start_point = 580
       THEN GOTO start_point_580;
     Elsif start_point = 590
       THEN GOTO start_point_590;
     Elsif start_point = 600
       THEN GOTO start_point_600;
     Elsif start_point = 610
       THEN GOTO start_point_610;
     Elsif start_point = 620
       THEN GOTO start_point_620;
     Elsif start_point = 630
       THEN GOTO start_point_630;
     Elsif start_point = 640
       THEN GOTO start_point_640;
     Elsif start_point = 650
       THEN GOTO start_point_650;
     Elsif start_point = 660
       THEN GOTO start_point_660;
     Elsif start_point = 670
       THEN GOTO start_point_670;
     Elsif start_point = 680
       THEN GOTO start_point_680;
     Elsif start_point = 690
       THEN GOTO start_point_690;
     Elsif start_point = 700
       THEN GOTO start_point_700;
     Elsif start_point = 710
       THEN GOTO start_point_710;
     Elsif start_point = 720
       THEN GOTO start_point_720;
     Elsif start_point = 730
       THEN GOTO start_point_730;
     Elsif start_point = 750
       THEN GOTO start_point_750;
     Elsif start_point = 760
       THEN GOTO start_point_760;
     Elsif start_point = 770
       THEN GOTO start_point_770;
    Elsif start_point = 780
       THEN GOTO start_point_780;
     Elsif start_point = 790
       THEN GOTO start_point_790;
      Else RAISE invalid_point;
      end if;
    END IF;

/**********Checking for restart point if not restarted
manually*************/

    SELECT max(start_point)INTO max_start_point FROM dr_start_point
    where start_stage = 40;

      IF max_start_point = 10
       THEN GOTO start_point_10;
      Elsif max_start_point = 20
       THEN GOTO start_point_20;
      Elsif max_start_point = 30
       THEN GOTO start_point_30;
      Elsif max_start_point = 40
       THEN GOTO start_point_40;
      Elsif max_start_point = 50
       THEN GOTO start_point_50;
      Elsif max_start_point = 60
       THEN GOTO start_point_60;
      Elsif max_start_point = 70
       THEN GOTO start_point_70;
      Elsif max_start_point = 80
       THEN GOTO start_point_80;
      Elsif max_start_point = 90
       THEN GOTO start_point_90;
      Elsif max_start_point = 100
       THEN GOTO start_point_100;
      Elsif max_start_point = 120
       THEN GOTO start_point_120;
      Elsif max_start_point = 130
       THEN GOTO start_point_130;
      Elsif max_start_point = 140
       THEN GOTO start_point_140;
      Elsif max_start_point = 150
       THEN GOTO start_point_150;
      Elsif max_start_point = 160
       THEN GOTO start_point_160;
      Elsif max_start_point = 170
       THEN GOTO start_point_170;
      Elsif max_start_point = 180
       THEN GOTO start_point_180;
      Elsif max_start_point = 190
       THEN GOTO start_point_190;
      Elsif max_start_point = 200
       THEN GOTO start_point_200;
      Elsif max_start_point = 210
       THEN GOTO start_point_210;
      Elsif max_start_point = 220
       THEN GOTO start_point_220;
      Elsif max_start_point = 230
       THEN GOTO start_point_230;
      Elsif max_start_point = 235
       THEN GOTO start_point_235;
      Elsif max_start_point = 240
       THEN GOTO start_point_240;
      Elsif max_start_point = 250
       THEN GOTO start_point_250;
      Elsif max_start_point = 260
       THEN GOTO start_point_260;
      Elsif max_start_point = 265
       THEN GOTO start_point_265;
      Elsif max_start_point = 270
       THEN GOTO start_point_270;
      Elsif max_start_point = 280
       THEN GOTO start_point_280;
      Elsif max_start_point = 290
       THEN GOTO start_point_290;
      Elsif max_start_point = 310
       THEN GOTO start_point_310;
      Elsif max_start_point = 320
       THEN GOTO start_point_320;
      Elsif max_start_point = 330
       THEN GOTO start_point_330;
      Elsif max_start_point = 340
       THEN GOTO start_point_340;
      Elsif max_start_point = 350
       THEN GOTO start_point_350;
      Elsif max_start_point = 360
       THEN GOTO start_point_360;
      Elsif max_start_point = 370
       THEN GOTO start_point_370;
      Elsif max_start_point = 380
       THEN GOTO start_point_380;
      Elsif max_start_point = 390
       THEN GOTO start_point_390;
      Elsif max_start_point = 400
       THEN GOTO start_point_400;
      Elsif max_start_point = 410
       THEN GOTO start_point_410;
      Elsif max_start_point = 420
       THEN GOTO start_point_420;
      Elsif max_start_point = 430
       THEN GOTO start_point_430;
      Elsif max_start_point = 440
       THEN GOTO start_point_440;
      Elsif max_start_point = 450
       THEN GOTO start_point_450;
      Elsif max_start_point = 460
       THEN GOTO start_point_460;
      Elsif max_start_point = 470
       THEN GOTO start_point_470;
      Elsif max_start_point = 480
       THEN GOTO start_point_480;
      Elsif max_start_point = 490
       THEN GOTO start_point_490;
      Elsif max_start_point = 500
       THEN GOTO start_point_500;
      Elsif max_start_point = 510
       THEN GOTO start_point_510;
      Elsif max_start_point = 520
       THEN GOTO start_point_520;
      Elsif max_start_point = 530
       THEN GOTO start_point_530;
      Elsif max_start_point = 540
       THEN GOTO start_point_540;
       Elsif max_start_point = 550
       THEN GOTO start_point_550;
      Elsif max_start_point = 560
       THEN GOTO start_point_560;
      Elsif max_start_point = 570
       THEN GOTO start_point_570;
      Elsif max_start_point = 580
       THEN GOTO start_point_580;
      Elsif max_start_point = 590
       THEN GOTO start_point_590;
      Elsif max_start_point = 600
       THEN GOTO start_point_600;
      Elsif max_start_point = 610
       THEN GOTO start_point_610;
      Elsif max_start_point = 620
       THEN GOTO start_point_620;
      Elsif max_start_point = 630
       THEN GOTO start_point_630;
      Elsif max_start_point = 640
       THEN GOTO start_point_640;
      Elsif max_start_point = 650
       THEN GOTO start_point_650;
      Elsif max_start_point = 660
       THEN GOTO start_point_660;
      Elsif max_start_point = 670
       THEN GOTO start_point_670;
      Elsif max_start_point = 680
       THEN GOTO start_point_680;
      Elsif max_start_point = 690
       THEN GOTO start_point_690;
      Elsif max_start_point = 700
       THEN GOTO start_point_700;
      Elsif max_start_point = 710
       THEN GOTO start_point_710;
      Elsif max_start_point = 720
       THEN GOTO start_point_720;
      Elsif max_start_point = 730
       THEN GOTO start_point_730;
      Elsif max_start_point = 750
       THEN GOTO start_point_750;
      Elsif max_start_point = 760
       THEN GOTO start_point_760;
      Elsif max_start_point = 770
       THEN GOTO start_point_770;
      Elsif max_start_point = 780
       THEN GOTO start_point_780;
      Elsif max_start_point = 790
       THEN GOTO start_point_790;
      END IF;

/**********Starting to load data for Dr_customer******************/

<<start_point_10>>

   v_start_point := 10;

    Log_start_point(v_status, 40, 10);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    dr_customer_truncate(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

<<start_point_20>>

    v_start_point := 20;

    Log_start_point(v_status, 40, 20);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    Dr_customer_drop_index(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

<<start_point_30>>

    v_start_point := 30;

    Log_start_point(v_status, 40, 30);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    Dr_customer_drop_index2(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

<<start_point_40>>

    v_start_point := 40;

    Log_start_point(v_status, 40, 40);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    Dr_customer_drop_index3(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

<<start_point_50>>

    v_start_point := 50;

    Log_start_point(v_status, 40, 50);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    load_dr_customer(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;


<<start_point_60>>

    v_start_point := 60;

    Log_start_point(v_status, 40, 60);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    update_dr_customer(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

 <<start_point_70>>

    v_start_point := 70;

    Log_start_point(v_status, 40, 70);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    dr_customer_index(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

 <<start_point_80>>

    v_start_point := 80;

    Log_start_point(v_status, 40, 80);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    dr_customer_index2(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    <<start_point_90>>

    v_start_point := 90;

    Log_start_point(v_status, 40, 90);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    dr_customer_index3(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    <<start_point_100>>

    v_start_point := 100;

    Log_start_point(v_status, 40, 100);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    analyze_table(v_status, 'dr_customer');
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

/**********Starting to load data for Dr_Cust_Trans******************/

    <<start_point_120>>

    v_start_point := 120;

    Log_start_point(v_status, 40, 120);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    Load_tmp_cust_trans_a1(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    <<start_point_130>>

    v_start_point := 130;

    Log_start_point(v_status, 40, 130);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    Load_tmp_cust_trans_a2(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    <<start_point_140>>

    v_start_point := 140;

    Log_start_point(v_status, 40, 140);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    Load_tmp_cust_trans_B(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    Load_tmp_cust_trans_C(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    <<start_point_150>>

    v_start_point := 150;

    Log_start_point(v_status, 40, 150);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    Tmp_cust_trans_a1_index(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    <<start_point_160>>

    v_start_point := 160;

    Log_start_point(v_status, 40, 160);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    Tmp_cust_trans_a2_index(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    <<start_point_170>>

    v_start_point := 170;

    Log_start_point(v_status, 40, 170);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    Tmp_cust_trans_B_index(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    <<start_point_180>>

    v_start_point := 180;

    Log_start_point(v_status, 40, 180);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    Tmp_cust_trans_C_index(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    <<start_point_190>>

    v_start_point := 190;

    Log_start_point(v_status, 40, 190);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    Dr_cust_trans_drop_index(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    <<start_point_200>>

    v_start_point := 200;

    Log_start_point(v_status, 40, 200);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    load_dr_cust_trans_incr_A1(v_status, extract_id);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    <<start_point_210>>

    v_start_point := 210;

    Log_start_point(v_status, 40, 210);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    Load_dr_cust_trans_incr_a2(v_status, extract_id);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    <<start_point_220>>

    v_start_point := 220;

    Log_start_point(v_status, 40, 220);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    Load_dr_cust_trans_incr2(v_status, extract_id);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    <<start_point_230>>

    v_start_point := 230;

    Log_start_point(v_status, 40, 230);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    Tmp_cust_trans_D_index(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    <<start_point_235>>

    v_start_point := 235;

    Log_start_point(v_status, 40, 235);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    dr_cust_trans_index(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    <<start_point_240>>

    v_start_point := 240;

    Log_start_point(v_status, 40, 240);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    Load_tmp_cust_trans_e(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    Load_tmp_cust_trans_f(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;


    <<start_point_250>>

    v_start_point := 250;

    Log_start_point(v_status, 40, 250);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    Tmp_cust_trans_E_index(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    <<start_point_260>>

    v_start_point := 260;

    Log_start_point(v_status, 40, 260);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    Tmp_cust_trans_F_index(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    <<start_point_265>>
     
    v_start_point := 265;

    Log_start_point(v_status, 40, 265);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    dr_cust_trans_drop_index(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

     
     
    <<start_point_270>>

    v_start_point := 270;

    Log_start_point(v_status, 40, 270);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    Load_dr_cust_trans_incr3(v_status, extract_id);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    <<start_point_280>>

    v_start_point := 280;

    Log_start_point(v_status, 40, 280);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    Dr_cust_trans_index(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    <<start_point_290>>

    v_start_point := 290;

    Log_start_point(v_status, 40, 290);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    Analyze_table_estimate(v_status, 'Dr_cust_trans');
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

 /**********Starting to load data for Dr_Debt_Comp******************/

    <<start_point_310>>

    v_start_point := 310;

    Log_start_point(v_status, 40, 310);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    Dr_debt_comp_truncate(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;


    <<start_point_320>>

    v_start_point := 320;

    Log_start_point(v_status, 40, 320);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    dr_debt_comp_drop_index(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    <<start_point_330>>

    v_start_point := 330;

    Log_start_point(v_status, 40, 330);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    dr_debt_comp_drop_index2(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    <<start_point_340>>

    v_start_point := 340;

    Log_start_point(v_status, 40, 340);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    dr_debt_comp_drop_index3(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    <<start_point_350>>

    v_start_point := 350;

    Log_start_point(v_status, 40, 350);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    dr_debt_comp_drop_index4(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    <<start_point_360>>

    v_start_point := 360;

    Log_start_point(v_status, 40, 360);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    dr_debt_comp_drop_index5(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    <<start_point_370>>

    v_start_point := 370;

    Log_start_point(v_status, 40, 370);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    dr_debt_comp_drop_index6(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;


    <<start_point_380>>

    v_start_point := 380;

    Log_start_point(v_status, 40, 380);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    Derive_Dr_debt_comp(v_status, extract_id, extract_date);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    <<start_point_390>>

    v_start_point := 390;

    Log_start_point(v_status, 40, 390);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    Dr_debt_comp_index(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;


    <<start_point_400>>

    v_start_point := 400;

    Log_start_point(v_status, 40, 400);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    Dr_debt_comp_index2(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    <<start_point_410>>

    v_start_point := 410;

    Log_start_point(v_status, 40, 410);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    Dr_debt_comp_index3(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    <<start_point_420>>

    v_start_point := 420;

    Log_start_point(v_status, 40, 420);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    Dr_debt_comp_index4(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    <<start_point_430>>

    v_start_point := 430;

    Log_start_point(v_status, 40, 430);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    Dr_debt_comp_index5(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;


    <<start_point_440>>

    v_start_point := 440;

    Log_start_point(v_status, 40, 440);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    Dr_debt_comp_index6(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    <<start_point_450>>

    v_start_point := 450;

    Log_start_point(v_status, 40, 450);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    Analyze_table(v_status, 'Dr_debt_comp');
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    /**********Starting to load data for Dr_Debt_Summary && debt_summary
                                2******************/

    <<start_point_460>>

    v_start_point := 460;

    Log_start_point(v_status, 40, 460);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    dr_debt_summary_truncate(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    <<start_point_470>>

    v_start_point := 470;

    Log_start_point(v_status, 40, 470);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    dr_debt_summary_drop_index(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    <<start_point_480>>

    v_start_point := 480;

    Log_start_point(v_status, 40, 480);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    Derive_dr_debt_summary(v_status, extract_id);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

   <<start_point_490>>

   v_start_point := 490;

    Log_start_point(v_status, 40, 490);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    dr_debt_summary_index(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    <<start_point_500>>

    v_start_point := 500;

    Log_start_point(v_status, 40, 500);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    Analyze_table(v_status, 'Dr_Debt_summary');
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    <<start_point_510>>

    v_start_point :=510;

    Log_start_point(v_status, 40, 510);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    dr_debt_summary2_truncate(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    <<start_point_520>>

    v_start_point := 520;

    Log_start_point(v_status, 40, 520);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    dr_debt_summary2_drop_index(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;


     <<start_point_530>>

    v_start_point := 530;

    Log_start_point(v_status, 40, 530);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    dr_debt_summary2_drop_index2(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    <<start_point_540>>

    v_start_point := 540;

    Log_start_point(v_status, 40, 540);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    Derive_dr_debt_summary2(v_status, extract_id);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    <<start_point_550>>

    v_start_point := 550;

    Log_start_point(v_status, 40, 550);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    dr_debt_summary2_index(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

     <<start_point_560>>

     v_start_point := 560;

    Log_start_point(v_status, 40, 560);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    dr_debt_summary2_index2(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

     <<start_point_570>>

     v_start_point := 570;

    Log_start_point(v_status, 40, 570);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    Analyze_table(v_status,'dr_debt_summary2');
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

/**********Starting to load data for Dr_crn_mpan******************/

   <<start_point_580>>

    v_start_point := 580;

    Log_start_point(v_status, 40, 580);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    dr_crn_mpan_truncate(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    <<start_point_590>>


    v_start_point := 590;

    Log_start_point(v_status, 40, 590);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    dr_crn_mpan_drop_index(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;


    <<start_point_600>>

    v_start_point := 600;

    Log_start_point(v_status, 40, 600);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    dr_crn_mpan_drop_index2(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;


    <<start_point_610>>

    v_start_point := 610;

    Log_start_point(v_status, 40, 610);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    load_dr_crn_mpan(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    <<start_point_620>>

    v_start_point := 620;

    Log_start_point(v_status, 40, 620);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    dr_crn_mpan_index(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    <<start_point_630>>

    v_start_point := 630;

    Log_start_point(v_status, 40, 630);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    dr_crn_mpan_index2(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    <<start_point_640>>

    v_start_point := 640;

    Log_start_point(v_status, 40, 640);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    Analyze_table(v_status, 'dr_crn_mpan');
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;


/**********Starting to load data for Dr_account******************/

   <<start_point_650>>


   v_start_point := 650;

    Log_start_point(v_status, 40, 650);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    Dr_account_drop_index(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    <<start_point_660>>

    v_start_point := 660;

    Log_start_point(v_status, 40, 660);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    Load_Dr_account_incr(v_status, extract_id);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    <<start_point_670>>

    v_start_point := 670;

    Log_start_point(v_status, 40, 670);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    Dr_account_index(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    <<start_point_680>>

    v_start_point := 680;

    Log_start_point(v_status, 40, 680);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    Analyze_table_estimate(v_status, 'Dr_account');
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

/**********Starting to load data for
Dr_Special_collection******************/

     <<start_point_690>>

    v_start_point := 690;

    Log_start_point(v_status, 40, 690);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    dr_special_collection_truncate(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    <<start_point_700>>

    v_start_point := 700;

    Log_start_point(v_status, 40, 700);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    dr_special_collection_drop_ind(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;


    <<start_point_710>>

    v_start_point := 710;

    Log_start_point(v_status, 40, 710);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    Load_dr_special_collection(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    <<start_point_720>>

    v_start_point := 720;

    Log_start_point(v_status, 40, 720);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    dr_special_collection_index(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;


    <<start_point_730>>

    v_start_point := 730;

    Log_start_point(v_status, 40, 730);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    Analyze_table(v_status, 'Dr_special_collection');
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

/**********Starting to load data for Dr_consumption******************/

    <<start_point_750>>

    v_start_point := 750;

    Log_start_point(v_status, 40, 750);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    dr_consumption_truncate(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    <<start_point_760>>

    v_start_point := 760;

    Log_start_point(v_status, 40, 760);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    dr_consumption_drop_index(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;


    <<start_point_770>>

    v_start_point := 770;

    Log_start_point(v_status, 40, 770);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    load_dr_consumption(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    <<start_point_780>>

    v_start_point := 780;

    Log_start_point(v_status, 40, 780);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    dr_consumption_index(v_status);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    <<start_point_790>>

    v_start_point := 790;

    Log_start_point(v_status, 40, 790);
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;

    Analyze_table_estimate(v_status, 'Dr_consumption');
    If v_status = 'F'
    THEN RAISE start_point_failure;
    END IF;



/***Insert message, date and time into dr_session_progress*******/
   WRITE_LOG('load_Base_table complete');

   EXCEPTION

    WHEN extract_details_failed THEN
    Rollback;
    Status := 'F';
    WRITE_LOG('extract details failed');

    WHEN INVALID_point THEN
    Rollback;
    Status := 'F';
    WRITE_LOG('LOAD_BASE_TABLES failed - invalid start point parameter'
);

    WHEN start_point_failure THEN
    Rollback;
    Status := 'F';
    WRITE_LOG('LOAD_BASE_TABLES failed at start point '||
v_start_point);

     WHEN OTHERS THEN
    Rollback;
    Status := 'F';
     WRITE_LOG(substr(sqlerrm,1,80) ||' '|| sqlcode);

END;
/




<NOTE:  The information contained in this e-mail is intended for the named recipient(s) only.  It may also be privileged and confidential.  If you are not an intended recipient, you must not copy, distribute or take any action in reliance upon it.  No warranties or assurances are made in relation to the safety and content of this e-mail and any attachments.  No liability is accepted for any consequences arising from it.>