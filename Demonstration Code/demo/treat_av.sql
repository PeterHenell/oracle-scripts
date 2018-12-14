EurekaLog 5.1.12

Application:
-------------------------------------------------------
  1.1 Start Date      : Thu, 30 Aug 2007 09:24:10 -0500
  1.2 Name/Description: TOAD
  1.3 Version Number  : 9.1.0.62
  1.4 Parameters      : 
  1.5 Compilation Date: Wed, 6 Jun 2007 13:54:19 -0500

Exception:
---------------------------------------------------------------------------------------------------
  2.1 Date   : Thu, 30 Aug 2007 09:25:51 -0500
  2.2 Address: 00406013
  2.3 Module : toad.exe
  2.4 Type   : EAccessViolation
  2.5 Message: Access violation at address 00406013 in module 'toad.exe'. Read of address 0007C106.

Active Controls:
---------------------------------------------------------------------------------------------------------------------------
  3.1 Form Class   : TfrmMain
  3.2 Form Text    : Toad for Oracle - [HR@ORCL102 - Editor (SELECT *    FROM meal  WHERE TREAT (main_course AS dessert_t)]
  3.3 Control Class: TAdvToadSyntaxMemo
  3.4 Control Text : SELECT *    FROM meal  WHERE TREAT (main_course AS dessert_t)         IS NOT NULL;

Computer:
-------------------------------------------------------------
  4.3 Total Memory  : 1022 Mb
  4.4 Free Memory   : 261 Mb
  4.5 Total Disk    : 18.63 Gb
  4.6 Free Disk     : 1.73 Gb
  4.7 System Up Time: 7 hours, 39 minutes, 5 seconds
  4.8 Processor     : Intel(R) Pentium(R) M processor 2.13GHz
  4.9 Display Mode  : 1024 x 768, 32 bit

Operating System:
------------------------------------
  5.1 Type    : Microsoft Windows XP
  5.2 Build # : 2600
  5.3 Update  : Service Pack 2
  5.4 Language: English

Call Stack Information:
----------------------------------------------------------------------------------------------------------------------
|Address |Module      |Unit                  |Class                               |Procedure/Method            |Line |
----------------------------------------------------------------------------------------------------------------------
| Exception Thread: ID=2508; Priority=0; Class=; [Main]                                                              |
|--------------------------------------------------------------------------------------------------------------------|
|00406013|toad.exe    |system.pas            |                                    |_LStrFromPChar              |12132|
|0040600C|toad.exe    |system.pas            |                                    |_LStrFromPChar              |12128|
|005DB98A|toad.exe    |CLRClasses.pas        |Marshal                             |PtrToStringAnsi             |398  |
|005DB958|toad.exe    |CLRClasses.pas        |Marshal                             |PtrToStringAnsi             |392  |
|0062E5AB|toad.exe    |OraObjects.pas        |TOraObject                          |GetAttributeValue           |1797 |
|005EB0AE|toad.exe    |MemData.pas           |TData                               |GetChildField               |2185 |
|005EB050|toad.exe    |MemData.pas           |TData                               |GetChildField               |2181 |
|005EB78D|toad.exe    |MemData.pas           |TData                               |GetField                    |2434 |
|005EB6F0|toad.exe    |MemData.pas           |TData                               |GetField                    |2416 |
|005F62E6|toad.exe    |MemDS.pas             |TMemDataSet                         |GetFieldData                |1026 |
|005F62A0|toad.exe    |MemDS.pas             |TMemDataSet                         |GetFieldData                |1019 |
|00699574|toad.exe    |OraSmart.pas          |TCustomSmartQuery                   |GetFieldData                |1102 |
|00402F8D|toad.exe    |system.pas            |                                    |_FreeMem                    |2466 |
|00542539|toad.exe    |DB.pas                |TDataSet                            |GetFieldData                |9233 |
|00402254|toad.exe    |GETMEM.INC            |                                    |InsertFree                  |787  |
|00402949|toad.exe    |GETMEM.INC            |                                    |SysFreeMem                  |1135 |
|7C9010ED|ntdll.dll   |                      |                                    |RtlLeaveCriticalSection     |     |
|00402971|toad.exe    |GETMEM.INC            |                                    |SysFreeMem                  |1139 |
|00402F8D|toad.exe    |system.pas            |                                    |_FreeMem                    |2466 |
|00402F88|toad.exe    |system.pas            |                                    |_FreeMem                    |2456 |
|00405E20|toad.exe    |system.pas            |                                    |_LStrClr                    |11663|
|00405E04|toad.exe    |system.pas            |                                    |_LStrClr                    |11652|
|0062E722|toad.exe    |OraObjects.pas        |TOraObject                          |GetAttributeValue           |1821 |
|005EB0AE|toad.exe    |MemData.pas           |TData                               |GetChildField               |2185 |
|00405E04|toad.exe    |system.pas            |                                    |_LStrClr                    |11652|
|005EB0C5|toad.exe    |MemData.pas           |TData                               |GetChildField               |2187 |
|005EB050|toad.exe    |MemData.pas           |TData                               |GetChildField               |2181 |
|005EB78D|toad.exe    |MemData.pas           |TData                               |GetField                    |2434 |
|005EB6F0|toad.exe    |MemData.pas           |TData                               |GetField                    |2416 |
|005F62E6|toad.exe    |MemDS.pas             |TMemDataSet                         |GetFieldData                |1026 |
|005F62A0|toad.exe    |MemDS.pas             |TMemDataSet                         |GetFieldData                |1019 |
|00699574|toad.exe    |OraSmart.pas          |TCustomSmartQuery                   |GetFieldData                |1102 |
|7E41F642|user32.dll  |                      |                                    |CallWindowProcA             |     |
|0050704C|toad.exe    |Controls.pas          |TWinControl                         |DefaultHandler              |6369 |
|00542539|toad.exe    |DB.pas                |TDataSet                            |GetFieldData                |9233 |
|00405E04|toad.exe    |system.pas            |                                    |_LStrClr                    |11652|
|005425FB|toad.exe    |DB.pas                |TDataSet                            |GetFieldData                |9247 |
|005031F7|toad.exe    |Controls.pas          |TControl                            |WndProc                     |4645 |
|7C90F1CB|ntdll.dll   |                      |                                    |RtlMultiByteToUnicodeN      |     |
|7C90F0A5|ntdll.dll   |                      |                                    |RtlAnsiStringToUnicodeString|     |
|7C90D9BF|ntdll.dll   |                      |                                    |NtFindAtom                  |     |
|7E430038|user32.dll  |                      |                                    |GetPropA                    |     |
|7E430002|user32.dll  |                      |                                    |GetPropA                    |     |
|004FD598|toad.exe    |Controls.pas          |                                    |FindControl                 |1805 |
|00503018|toad.exe    |Controls.pas          |TControl                            |WndProc                     |4592 |
|00506F06|toad.exe    |Controls.pas          |TWinControl                         |WndProc                     |6342 |
|7C9010ED|ntdll.dll   |                      |                                    |RtlLeaveCriticalSection     |     |
|00427D8E|toad.exe    |classes.pas           |TThreadList                         |UnlockList                  |3151 |
|00427D80|toad.exe    |classes.pas           |TThreadList                         |UnlockList                  |3150 |
|00472E94|toad.exe    |Graphics.pas          |                                    |FreeMemoryContexts          |4670 |
|00506AD8|toad.exe    |Controls.pas          |TWinControl                         |MainWndProc                 |6237 |
|00472DFC|toad.exe    |Graphics.pas          |                                    |FreeMemoryContexts          |4658 |
|00506AED|toad.exe    |Controls.pas          |TWinControl                         |MainWndProc                 |6240 |
|004371A0|toad.exe    |classes.pas           |                                    |StdWndProc                  |10966|
|7E41D554|user32.dll  |                      |                                    |DefWindowProcA              |     |
|0050A634|toad.exe    |Controls.pas          |TWinControl                         |HandleAllocated             |7959 |
|00509F0F|toad.exe    |Controls.pas          |TWinControl                         |CMInvalidate                |7719 |
|005031F7|toad.exe    |Controls.pas          |TControl                            |WndProc                     |4645 |
|7E41F658|user32.dll  |                      |                                    |CallWindowProcA             |     |
|7E41F642|user32.dll  |                      |                                    |CallWindowProcA             |     |
|0050704C|toad.exe    |Controls.pas          |TWinControl                         |DefaultHandler              |6369 |
|00503AE4|toad.exe    |Controls.pas          |TControl                            |WMWindowPosChanged          |4885 |
|0040508C|toad.exe    |system.pas            |                                    |GetDynaMethod               |8673 |
|00405137|toad.exe    |system.pas            |TObject                             |Dispatch                    |8831 |
|00503018|toad.exe    |Controls.pas          |TControl                            |WndProc                     |4592 |
|00506F06|toad.exe    |Controls.pas          |TWinControl                         |WndProc                     |6342 |
|00506D78|toad.exe    |Controls.pas          |TWinControl                         |WndProc                     |6309 |
|004E6E54|toad.exe    |Forms.pas             |TCustomForm                         |WndProc                     |3098 |
|7C90F1CB|ntdll.dll   |                      |                                    |RtlMultiByteToUnicodeN      |     |
|7C90F0A5|ntdll.dll   |                      |                                    |RtlAnsiStringToUnicodeString|     |
|00502F02|toad.exe    |Controls.pas          |TControl                            |Perform                     |4552 |
|00502ECC|toad.exe    |Controls.pas          |TControl                            |Perform                     |4547 |
|00509F37|toad.exe    |Controls.pas          |TWinControl                         |CMInvalidate                |7721 |
|005031F7|toad.exe    |Controls.pas          |TControl                            |WndProc                     |4645 |
|7E4188CC|user32.dll  |                      |                                    |GetWindowLongW              |     |
|7E4188D5|user32.dll  |                      |                                    |GetWindowLongW              |     |
|00503018|toad.exe    |Controls.pas          |TControl                            |WndProc                     |4592 |
|00506F06|toad.exe    |Controls.pas          |TWinControl                         |WndProc                     |6342 |
|00502F02|toad.exe    |Controls.pas          |TControl                            |Perform                     |4552 |
|00502ECC|toad.exe    |Controls.pas          |TControl                            |Perform                     |4547 |
|00509F37|toad.exe    |Controls.pas          |TWinControl                         |CMInvalidate                |7721 |
|005031F7|toad.exe    |Controls.pas          |TControl                            |WndProc                     |4645 |
|0050A634|toad.exe    |Controls.pas          |TWinControl                         |HandleAllocated             |7959 |
|0050569C|toad.exe    |Controls.pas          |TWinControl                         |AlignControl                |5702 |
|7E41C025|user32.dll  |                      |                                    |SetWindowPos                |     |
|0050568C|toad.exe    |Controls.pas          |TWinControl                         |AlignControl                |5701 |
|00500521|toad.exe    |Controls.pas          |TControl                            |RequestAlign                |3345 |
|004050BC|toad.exe    |system.pas            |                                    |_CallDynaInst               |8706 |
|005098DE|toad.exe    |Controls.pas          |TWinControl                         |SetBounds                   |7555 |
|00472DFC|toad.exe    |Graphics.pas          |                                    |FreeMemoryContexts          |4658 |
|00506AED|toad.exe    |Controls.pas          |TWinControl                         |MainWndProc                 |6240 |
|7E41C133|user32.dll  |                      |                                    |GetClassLongW               |     |
|00503018|toad.exe    |Controls.pas          |TControl                            |WndProc                     |4592 |
|00506F06|toad.exe    |Controls.pas          |TWinControl                         |WndProc                     |6342 |
|7E41D44E|user32.dll  |                      |                                    |SetPropW                    |     |
|00502F02|toad.exe    |Controls.pas          |TControl                            |Perform                     |4552 |
|00502ECC|toad.exe    |Controls.pas          |TControl                            |Perform                     |4547 |
|00509F37|toad.exe    |Controls.pas          |TWinControl                         |CMInvalidate                |7721 |
|005031F7|toad.exe    |Controls.pas          |TControl                            |WndProc                     |4645 |
|7E41B631|user32.dll  |                      |                                    |OffsetRect                  |     |
|7E41B6C3|user32.dll  |                      |                                    |GetClientRect               |     |
|7E41B6AE|user32.dll  |                      |                                    |GetClientRect               |     |
|0050A2D1|toad.exe    |Controls.pas          |TWinControl                         |GetClientRect               |7832 |
|0050A2B8|toad.exe    |Controls.pas          |TWinControl                         |GetClientRect               |7831 |
|004E6612|toad.exe    |Forms.pas             |TCustomForm                         |GetClientRect               |2869 |
|00500DB5|toad.exe    |Controls.pas          |TControl                            |GetClientWidth              |3565 |
|00500DA4|toad.exe    |Controls.pas          |TControl                            |GetClientWidth              |3564 |
|004E3DBE|toad.exe    |Forms.pas             |TControlScrollBar                   |ControlSize                 |1763 |
|004E3D4C|toad.exe    |Forms.pas             |TControlScrollBar                   |ControlSize                 |1758 |
|004E477B|toad.exe    |Forms.pas             |TControlScrollBar                   |Update                      |2057 |
|004E4680|toad.exe    |Forms.pas             |TControlScrollBar                   |Update                      |2035 |
|004E4C5A|toad.exe    |Forms.pas             |TScrollingWinControl                |UpdateScrollBars            |2195 |
|004E4B8C|toad.exe    |Forms.pas             |TScrollingWinControl                |UpdateScrollBars            |2178 |
|004E5070|toad.exe    |Forms.pas             |TScrollingWinControl                |WMSize                      |2310 |
|005031F7|toad.exe    |Controls.pas          |TControl                            |WndProc                     |4645 |
|00503018|toad.exe    |Controls.pas          |TControl                            |WndProc                     |4592 |
|00506F06|toad.exe    |Controls.pas          |TWinControl                         |WndProc                     |6342 |
|00502F02|toad.exe    |Controls.pas          |TControl                            |Perform                     |4552 |
|00502ECC|toad.exe    |Controls.pas          |TControl                            |Perform                     |4547 |
|00509F37|toad.exe    |Controls.pas          |TWinControl                         |CMInvalidate                |7721 |
|005031F7|toad.exe    |Controls.pas          |TControl                            |WndProc                     |4645 |
|7E41D554|user32.dll  |                      |                                    |DefWindowProcA              |     |
|00503018|toad.exe    |Controls.pas          |TControl                            |WndProc                     |4592 |
|00506F06|toad.exe    |Controls.pas          |TWinControl                         |WndProc                     |6342 |
|00506D78|toad.exe    |Controls.pas          |TWinControl                         |WndProc                     |6309 |
|004E6E54|toad.exe    |Forms.pas             |TCustomForm                         |WndProc                     |3098 |
|7C9010ED|ntdll.dll   |                      |                                    |RtlLeaveCriticalSection     |     |
|00427D8E|toad.exe    |classes.pas           |TThreadList                         |UnlockList                  |3151 |
|00427D80|toad.exe    |classes.pas           |TThreadList                         |UnlockList                  |3150 |
|00472E94|toad.exe    |Graphics.pas          |                                    |FreeMemoryContexts          |4670 |
|004E69DC|toad.exe    |Forms.pas             |TCustomForm                         |WndProc                     |2995 |
|00F47374|toad.exe    |frmCodeHealthCheck.pas|TCodeHealthCheckForm                |WndProc                     |3893 |
|00506AD8|toad.exe    |Controls.pas          |TWinControl                         |MainWndProc                 |6237 |
|00472DFC|toad.exe    |Graphics.pas          |                                    |FreeMemoryContexts          |4658 |
|00506AED|toad.exe    |Controls.pas          |TWinControl                         |MainWndProc                 |6240 |
|004371A0|toad.exe    |classes.pas           |                                    |StdWndProc                  |10966|
|00503018|toad.exe    |Controls.pas          |TControl                            |WndProc                     |4592 |
|00506F06|toad.exe    |Controls.pas          |TWinControl                         |WndProc                     |6342 |
|00506D78|toad.exe    |Controls.pas          |TWinControl                         |WndProc                     |6309 |
|004E6E54|toad.exe    |Forms.pas             |TCustomForm                         |WndProc                     |3098 |
|00502F02|toad.exe    |Controls.pas          |TControl                            |Perform                     |4552 |
|00502ECC|toad.exe    |Controls.pas          |TControl                            |Perform                     |4547 |
|00509F37|toad.exe    |Controls.pas          |TWinControl                         |CMInvalidate                |7721 |
|005031F7|toad.exe    |Controls.pas          |TControl                            |WndProc                     |4645 |
|00405E04|toad.exe    |system.pas            |                                    |_LStrClr                    |11652|
|0083A8E7|toad.exe    |cbClasses.pas         |TcbHFormHookComponentWatchCaption   |MessageAfter                |712  |
|0083A884|toad.exe    |cbClasses.pas         |TcbHFormHookComponentWatchCaption   |MessageAfter                |698  |
|0083D0AE|toad.exe    |CaptionButton.pas     |TCustomCaptionButton                |MessageAfter                |1113 |
|7E41F642|user32.dll  |                      |                                    |CallWindowProcA             |     |
|0083A68F|toad.exe    |cbClasses.pas         |TcbFormHookComponent                |HookWndProc                 |572  |
|0083A6BD|toad.exe    |cbClasses.pas         |TcbFormHookComponent                |HookWndProc                 |575  |
|004371A0|toad.exe    |classes.pas           |                                    |StdWndProc                  |10966|
|00503018|toad.exe    |Controls.pas          |TControl                            |WndProc                     |4592 |
|00506F06|toad.exe    |Controls.pas          |TWinControl                         |WndProc                     |6342 |
|00502F02|toad.exe    |Controls.pas          |TControl                            |Perform                     |4552 |
|00502ECC|toad.exe    |Controls.pas          |TControl                            |Perform                     |4547 |
|00509F37|toad.exe    |Controls.pas          |TWinControl                         |CMInvalidate                |7721 |
|005031F7|toad.exe    |Controls.pas          |TControl                            |WndProc                     |4645 |
|7E41BB05|user32.dll  |                      |                                    |GetPropW                    |     |
|773E2067|comctl32.dll|                      |                                    |DefSubclassProc             |     |
|773E2026|comctl32.dll|                      |                                    |DefSubclassProc             |     |
|7E41B966|user32.dll  |                      |                                    |IsWindow                    |     |
|00503018|toad.exe    |Controls.pas          |TControl                            |WndProc                     |4592 |
|00506F06|toad.exe    |Controls.pas          |TWinControl                         |WndProc                     |6342 |
|7E41D554|user32.dll  |                      |                                    |DefWindowProcA              |     |
|7E41F658|user32.dll  |                      |                                    |CallWindowProcA             |     |
|7E41F642|user32.dll  |                      |                                    |CallWindowProcA             |     |
|0050704C|toad.exe    |Controls.pas          |TWinControl                         |DefaultHandler              |6369 |
|00507C96|toad.exe    |Controls.pas          |TWinControl                         |WMWindowPosChanging         |6678 |
|005031F7|toad.exe    |Controls.pas          |TControl                            |WndProc                     |4645 |
|7C90F1CB|ntdll.dll   |                      |                                    |RtlMultiByteToUnicodeN      |     |
|7C90F0A5|ntdll.dll   |                      |                                    |RtlAnsiStringToUnicodeString|     |
|7C90D9BF|ntdll.dll   |                      |                                    |NtFindAtom                  |     |
|7E430038|user32.dll  |                      |                                    |GetPropA                    |     |
|7E430002|user32.dll  |                      |                                    |GetPropA                    |     |
|004FD598|toad.exe    |Controls.pas          |                                    |FindControl                 |1805 |
|004050EC|toad.exe    |system.pas            |TObject                             |InheritsFrom                |8778 |
|0040505A|toad.exe    |system.pas            |                                    |_IsClass                    |8630 |
|0040504C|toad.exe    |system.pas            |                                    |_IsClass                    |8629 |
|7E41B966|user32.dll  |                      |                                    |IsWindow                    |     |
|0050A634|toad.exe    |Controls.pas          |TWinControl                         |HandleAllocated             |7959 |
|0050569C|toad.exe    |Controls.pas          |TWinControl                         |AlignControl                |5702 |
|7E41C025|user32.dll  |                      |                                    |SetWindowPos                |     |
|7E41C01B|user32.dll  |                      |                                    |SetWindowPos                |     |
|0050A318|toad.exe    |Controls.pas          |TWinControl                         |AdjustSize                  |7840 |
|0050568C|toad.exe    |Controls.pas          |TWinControl                         |AlignControl                |5701 |
|00500521|toad.exe    |Controls.pas          |TControl                            |RequestAlign                |3345 |
|0050A324|toad.exe    |Controls.pas          |TWinControl                         |AdjustSize                  |7841 |
|004050BC|toad.exe    |system.pas            |                                    |_CallDynaInst               |8706 |
|00505681|toad.exe    |Controls.pas          |TWinControl                         |AlignControls               |5695 |
|00505738|toad.exe    |Controls.pas          |TWinControl                         |EnableAlign                 |5724 |
|0050570F|toad.exe    |Controls.pas          |TWinControl                         |AlignControl                |5713 |
|004050BC|toad.exe    |system.pas            |                                    |_CallDynaInst               |8706 |
|00507CE0|toad.exe    |Controls.pas          |TWinControl                         |WMSize                      |6686 |
|005031F7|toad.exe    |Controls.pas          |TControl                            |WndProc                     |4645 |
|004E69DC|toad.exe    |Forms.pas             |TCustomForm                         |WndProc                     |2995 |
|00F47374|toad.exe    |frmCodeHealthCheck.pas|TCodeHealthCheckForm                |WndProc                     |3893 |
|7C90F1CB|ntdll.dll   |                      |                                    |RtlMultiByteToUnicodeN      |     |
|7C90F0A5|ntdll.dll   |                      |                                    |RtlAnsiStringToUnicodeString|     |
|7C90D9BF|ntdll.dll   |                      |                                    |NtFindAtom                  |     |
|7E430038|user32.dll  |                      |                                    |GetPropA                    |     |
|7E430002|user32.dll  |                      |                                    |GetPropA                    |     |
|004FD598|toad.exe    |Controls.pas          |                                    |FindControl                 |1805 |
|00503018|toad.exe    |Controls.pas          |TControl                            |WndProc                     |4592 |
|00506F06|toad.exe    |Controls.pas          |TWinControl                         |WndProc                     |6342 |
|7C9010ED|ntdll.dll   |                      |                                    |RtlLeaveCriticalSection     |     |
|00427D8E|toad.exe    |classes.pas           |TThreadList                         |UnlockList                  |3151 |
|00427D80|toad.exe    |classes.pas           |TThreadList                         |UnlockList                  |3150 |
|00472E94|toad.exe    |Graphics.pas          |                                    |FreeMemoryContexts          |4670 |
|7E41F891|user32.dll  |                      |                                    |CallNextHookEx              |     |
|7E41F85B|user32.dll  |                      |                                    |CallNextHookEx              |     |
|004371A0|toad.exe    |classes.pas           |                                    |StdWndProc                  |10966|
|7C90F1CB|ntdll.dll   |                      |                                    |RtlMultiByteToUnicodeN      |     |
|7C90F0A5|ntdll.dll   |                      |                                    |RtlAnsiStringToUnicodeString|     |
|7C90D9BF|ntdll.dll   |                      |                                    |NtFindAtom                  |     |
|7C9137A6|ntdll.dll   |                      |                                    |RtlUnlockHeap               |     |
|7C9010ED|ntdll.dll   |                      |                                    |RtlLeaveCriticalSection     |     |
|7C9137C2|ntdll.dll   |                      |                                    |RtlUnlockHeap               |     |
|7C9137A6|ntdll.dll   |                      |                                    |RtlUnlockHeap               |     |
|7C9010ED|ntdll.dll   |                      |                                    |RtlLeaveCriticalSection     |     |
|7C9137C2|ntdll.dll   |                      |                                    |RtlUnlockHeap               |     |
|76399B4F|imm32.dll   |                      |                                    |ImmUnlockClientImc          |     |
|76399B42|imm32.dll   |                      |                                    |ImmUnlockClientImc          |     |
|76399F91|imm32.dll   |                      |                                    |ImmUnlockIMC                |     |
|76399F65|imm32.dll   |                      |                                    |ImmUnlockIMC                |     |
|0050A634|toad.exe    |Controls.pas          |TWinControl                         |HandleAllocated             |7959 |
|00509F0F|toad.exe    |Controls.pas          |TWinControl                         |CMInvalidate                |7719 |
|005031F7|toad.exe    |Controls.pas          |TControl                            |WndProc                     |4645 |
|00503018|toad.exe    |Controls.pas          |TControl                            |WndProc                     |4592 |
|00506F06|toad.exe    |Controls.pas          |TWinControl                         |WndProc                     |6342 |
|00506D78|toad.exe    |Controls.pas          |TWinControl                         |WndProc                     |6309 |
|004E6E54|toad.exe    |Forms.pas             |TCustomForm                         |WndProc                     |3098 |
|00502F02|toad.exe    |Controls.pas          |TControl                            |Perform                     |4552 |
|00502ECC|toad.exe    |Controls.pas          |TControl                            |Perform                     |4547 |
|00509F37|toad.exe    |Controls.pas          |TWinControl                         |CMInvalidate                |7721 |
|005031F7|toad.exe    |Controls.pas          |TControl                            |WndProc                     |4645 |
|00503018|toad.exe    |Controls.pas          |TControl                            |WndProc                     |4592 |
|00506F06|toad.exe    |Controls.pas          |TWinControl                         |WndProc                     |6342 |
|00502F02|toad.exe    |Controls.pas          |TControl                            |Perform                     |4552 |
|00502ECC|toad.exe    |Controls.pas          |TControl                            |Perform                     |4547 |
|00509F37|toad.exe    |Controls.pas          |TWinControl                         |CMInvalidate                |7721 |
|005031F7|toad.exe    |Controls.pas          |TControl                            |WndProc                     |4645 |
|7E41D554|user32.dll  |                      |                                    |DefWindowProcA              |     |
|7C80CE30|kernel32.dll|                      |                                    |LCMapStringW                |     |
|7E419239|user32.dll  |                      |                                    |CharUpperBuffW              |     |
|7E41AEBF|user32.dll  |                      |                                    |CharUpperBuffA              |     |
|7E41AEE3|user32.dll  |                      |                                    |CharUpperBuffA              |     |
|7E41F891|user32.dll  |                      |                                    |CallNextHookEx              |     |
|7E41F85B|user32.dll  |                      |                                    |CallNextHookEx              |     |
|7C90F1CB|ntdll.dll   |                      |                                    |RtlMultiByteToUnicodeN      |     |
|7C90F0A5|ntdll.dll   |                      |                                    |RtlAnsiStringToUnicodeString|     |
|7C90D9BF|ntdll.dll   |                      |                                    |NtFindAtom                  |     |
|00503018|toad.exe    |Controls.pas          |TControl                            |WndProc                     |4592 |
|00506F06|toad.exe    |Controls.pas          |TWinControl                         |WndProc                     |6342 |
|0040279A|toad.exe    |GETMEM.INC            |                                    |SysGetMem                   |1038 |
|00405814|toad.exe    |system.pas            |                                    |_TryFinallyExit             |10497|
|00405804|toad.exe    |system.pas            |                                    |_TryFinallyExit             |10492|
|00402710|toad.exe    |GETMEM.INC            |                                    |SysGetMem                   |1016 |
|00402254|toad.exe    |GETMEM.INC            |                                    |InsertFree                  |787  |
|00402949|toad.exe    |GETMEM.INC            |                                    |SysFreeMem                  |1135 |
|7C9010ED|ntdll.dll   |                      |                                    |RtlLeaveCriticalSection     |     |
|00402971|toad.exe    |GETMEM.INC            |                                    |SysFreeMem                  |1139 |
|00402F8D|toad.exe    |system.pas            |                                    |_FreeMem                    |2466 |
|00402F88|toad.exe    |system.pas            |                                    |_FreeMem                    |2456 |
|004079F3|toad.exe    |system.pas            |                                    |_DynArrayClear              |16220|
|00427274|toad.exe    |classes.pas           |TList                               |Get                         |2824 |
|005E9F76|toad.exe    |MemData.pas           |TFieldDescs                         |GetItems                    |1623 |
|005E9F6C|toad.exe    |MemData.pas           |TFieldDescs                         |GetItems                    |1622 |
|005EB716|toad.exe    |MemData.pas           |TData                               |GetField                    |2421 |
|005EB6F0|toad.exe    |MemData.pas           |TData                               |GetField                    |2416 |
|005F62E6|toad.exe    |MemDS.pas             |TMemDataSet                         |GetFieldData                |1026 |
|005424F4|toad.exe    |DB.pas                |TDataSet                            |GetFieldData                |9231 |
|005F6644|toad.exe    |MemDS.pas             |TMemDataSet                         |GetFieldData                |1139 |
|00537FDE|toad.exe    |DB.pas                |TField                              |GetData                     |3668 |
|005393BF|toad.exe    |DB.pas                |TStringField                        |GetDataSize                 |4353 |
|00537F54|toad.exe    |DB.pas                |TField                              |GetData                     |3660 |
|005394ED|toad.exe    |DB.pas                |TStringField                        |GetValue                    |4382 |
|005425E5|toad.exe    |DB.pas                |TDataSet                            |GetFieldData                |9247 |
|005425FB|toad.exe    |DB.pas                |TDataSet                            |GetFieldData                |9247 |
|00405E04|toad.exe    |system.pas            |                                    |_LStrClr                    |11652|
|005EB0C5|toad.exe    |MemData.pas           |TData                               |GetChildField               |2187 |
|005EB050|toad.exe    |MemData.pas           |TData                               |GetChildField               |2181 |
|005EB78D|toad.exe    |MemData.pas           |TData                               |GetField                    |2434 |
|005EB6F0|toad.exe    |MemData.pas           |TData                               |GetField                    |2416 |
|005F62E6|toad.exe    |MemDS.pas             |TMemDataSet                         |GetFieldData                |1026 |
|005E9F6C|toad.exe    |MemData.pas           |TFieldDescs                         |GetItems                    |1622 |
|005EB716|toad.exe    |MemData.pas           |TData                               |GetField                    |2421 |
|005F62A0|toad.exe    |MemDS.pas             |TMemDataSet                         |GetFieldData                |1019 |
|00699574|toad.exe    |OraSmart.pas          |TCustomSmartQuery                   |GetFieldData                |1102 |
|005EB6F0|toad.exe    |MemData.pas           |TData                               |GetField                    |2416 |
|005F62E6|toad.exe    |MemDS.pas             |TMemDataSet                         |GetFieldData                |1026 |
|00542539|toad.exe    |DB.pas                |TDataSet                            |GetFieldData                |9233 |
|00405E04|toad.exe    |system.pas            |                                    |_LStrClr                    |11652|
|005425FB|toad.exe    |DB.pas                |TDataSet                            |GetFieldData                |9247 |
|00402F62|toad.exe    |system.pas            |                                    |_GetMem                     |2439 |
|00402F58|toad.exe    |system.pas            |                                    |_GetMem                     |2429 |
|00405ED4|toad.exe    |system.pas            |                                    |_NewAnsiString              |11866|
|0040DF68|toad.exe    |sysutils.pas          |                                    |StrLen                      |6003 |
|0054474F|toad.exe    |DB.pas                |TDataSet                            |Translate                   |10459|
|0053954B|toad.exe    |DB.pas                |TStringField                        |GetValue                    |4390 |
|00405E04|toad.exe    |system.pas            |                                    |_LStrClr                    |11652|
|00539561|toad.exe    |DB.pas                |TStringField                        |GetValue                    |4390 |
|005425E5|toad.exe    |DB.pas                |TDataSet                            |GetFieldData                |9247 |
|00405E04|toad.exe    |system.pas            |                                    |_LStrClr                    |11652|
|005425FB|toad.exe    |DB.pas                |TDataSet                            |GetFieldData                |9247 |
|7E41F658|user32.dll  |                      |                                    |CallWindowProcA             |     |
|7E41F642|user32.dll  |                      |                                    |CallWindowProcA             |     |
|0050704C|toad.exe    |Controls.pas          |TWinControl                         |DefaultHandler              |6369 |
|004A9C09|toad.exe    |ComCtrls.pas          |TCustomTabControl                   |TCMAdjustRect               |4715 |
|005031F7|toad.exe    |Controls.pas          |TControl                            |WndProc                     |4645 |
|7C90F1CB|ntdll.dll   |                      |                                    |RtlMultiByteToUnicodeN      |     |
|7C90F0A5|ntdll.dll   |                      |                                    |RtlAnsiStringToUnicodeString|     |
|7C90D9BF|ntdll.dll   |                      |                                    |NtFindAtom                  |     |
|7E430038|user32.dll  |                      |                                    |GetPropA                    |     |
|7E430002|user32.dll  |                      |                                    |GetPropA                    |     |
|004FD598|toad.exe    |Controls.pas          |                                    |FindControl                 |1805 |
|00503018|toad.exe    |Controls.pas          |TControl                            |WndProc                     |4592 |
|00506F06|toad.exe    |Controls.pas          |TWinControl                         |WndProc                     |6342 |
|00427D8E|toad.exe    |classes.pas           |TThreadList                         |UnlockList                  |3151 |
|00427D80|toad.exe    |classes.pas           |TThreadList                         |UnlockList                  |3150 |
|00472E94|toad.exe    |Graphics.pas          |                                    |FreeMemoryContexts          |4670 |
|00506AD8|toad.exe    |Controls.pas          |TWinControl                         |MainWndProc                 |6237 |
|00472DFC|toad.exe    |Graphics.pas          |                                    |FreeMemoryContexts          |4658 |
|00506AED|toad.exe    |Controls.pas          |TWinControl                         |MainWndProc                 |6240 |
|004371A0|toad.exe    |classes.pas           |                                    |StdWndProc                  |10966|
|7E41BEFD|user32.dll  |                      |                                    |InflateRect                 |     |
|7E44F767|user32.dll  |                      |                                    |DefMDIChildProcA            |     |
|7E41F658|user32.dll  |                      |                                    |CallWindowProcA             |     |
|7E41F642|user32.dll  |                      |                                    |CallWindowProcA             |     |
|0050704C|toad.exe    |Controls.pas          |TWinControl                         |DefaultHandler              |6369 |
|00506F10|toad.exe    |Controls.pas          |TWinControl                         |DefaultHandler              |6346 |
|004E88C8|toad.exe    |Forms.pas             |TCustomForm                         |DefaultHandler              |3770 |
|004E9F02|toad.exe    |Forms.pas             |TCustomForm                         |WMGetMinMaxInfo             |4369 |
|005031F7|toad.exe    |Controls.pas          |TControl                            |WndProc                     |4645 |
|00502CEC|toad.exe    |Controls.pas          |TControl                            |ConstrainedResize           |4494 |
|0050AF6E|toad.exe    |Controls.pas          |TWinControl                         |ConstrainedResize           |8275 |
|7E41F891|user32.dll  |                      |                                    |CallNextHookEx              |     |
|7E41F85B|user32.dll  |                      |                                    |CallNextHookEx              |     |
|0050AAE7|toad.exe    |Controls.pas          |                                    |DoCalcConstraints           |8130 |
|7C9010ED|ntdll.dll   |                      |                                    |RtlLeaveCriticalSection     |     |
|00427D8E|toad.exe    |classes.pas           |TThreadList                         |UnlockList                  |3151 |
|00427D80|toad.exe    |classes.pas           |TThreadList                         |UnlockList                  |3150 |
|00472E94|toad.exe    |Graphics.pas          |                                    |FreeMemoryContexts          |4670 |
|00506AD8|toad.exe    |Controls.pas          |TWinControl                         |MainWndProc                 |6237 |
|00472DFC|toad.exe    |Graphics.pas          |                                    |FreeMemoryContexts          |4658 |
|00506AED|toad.exe    |Controls.pas          |TWinControl                         |MainWndProc                 |6240 |
|0083A6BD|toad.exe    |cbClasses.pas         |TcbFormHookComponent                |HookWndProc                 |575  |
|7E41F658|user32.dll  |                      |                                    |CallWindowProcA             |     |
|7E41F642|user32.dll  |                      |                                    |CallWindowProcA             |     |
|0050704C|toad.exe    |Controls.pas          |TWinControl                         |DefaultHandler              |6369 |
|004A9C09|toad.exe    |ComCtrls.pas          |TCustomTabControl                   |TCMAdjustRect               |4715 |
|005031F7|toad.exe    |Controls.pas          |TControl                            |WndProc                     |4645 |
|7C90F1CB|ntdll.dll   |                      |                                    |RtlMultiByteToUnicodeN      |     |
|7C90F0A5|ntdll.dll   |                      |                                    |RtlAnsiStringToUnicodeString|     |
|7C90D9BF|ntdll.dll   |                      |                                    |NtFindAtom                  |     |
|7E430038|user32.dll  |                      |                                    |GetPropA                    |     |
|7E430002|user32.dll  |                      |                                    |GetPropA                    |     |
|004FD598|toad.exe    |Controls.pas          |                                    |FindControl                 |1805 |
|00503018|toad.exe    |Controls.pas          |TControl                            |WndProc                     |4592 |
|00506F06|toad.exe    |Controls.pas          |TWinControl                         |WndProc                     |6342 |
|00427D8E|toad.exe    |classes.pas           |TThreadList                         |UnlockList                  |3151 |
|00427D80|toad.exe    |classes.pas           |TThreadList                         |UnlockList                  |3150 |
|00472E94|toad.exe    |Graphics.pas          |                                    |FreeMemoryContexts          |4670 |
|00506AD8|toad.exe    |Controls.pas          |TWinControl                         |MainWndProc                 |6237 |
|00472DFC|toad.exe    |Graphics.pas          |                                    |FreeMemoryContexts          |4658 |
|00506AED|toad.exe    |Controls.pas          |TWinControl                         |MainWndProc                 |6240 |
|004371A0|toad.exe    |classes.pas           |                                    |StdWndProc                  |10966|
|7E41BEFD|user32.dll  |                      |                                    |InflateRect                 |     |
|7E44F767|user32.dll  |                      |                                    |DefMDIChildProcA            |     |
|7E41F658|user32.dll  |                      |                                    |CallWindowProcA             |     |
|7E41F642|user32.dll  |                      |                                    |CallWindowProcA             |     |
|0050704C|toad.exe    |Controls.pas          |TWinControl                         |DefaultHandler              |6369 |
|00506F10|toad.exe    |Controls.pas          |TWinControl                         |DefaultHandler              |6346 |
|004E88C8|toad.exe    |Forms.pas             |TCustomForm                         |DefaultHandler              |3770 |
|004E9F02|toad.exe    |Forms.pas             |TCustomForm                         |WMGetMinMaxInfo             |4369 |
|005031F7|toad.exe    |Controls.pas          |TControl                            |WndProc                     |4645 |
|00502CEC|toad.exe    |Controls.pas          |TControl                            |ConstrainedResize           |4494 |
|0050AF6E|toad.exe    |Controls.pas          |TWinControl                         |ConstrainedResize           |8275 |
|0050AAE7|toad.exe    |Controls.pas          |                                    |DoCalcConstraints           |8130 |
|0050AA38|toad.exe    |Controls.pas          |                                    |DoCalcConstraints           |8110 |
|0050AC66|toad.exe    |Controls.pas          |TWinControl                         |CalcConstraints             |8165 |
|00503018|toad.exe    |Controls.pas          |TControl                            |WndProc                     |4592 |
|00506F06|toad.exe    |Controls.pas          |TWinControl                         |WndProc                     |6342 |
|00506D78|toad.exe    |Controls.pas          |TWinControl                         |WndProc                     |6309 |
|004E6E54|toad.exe    |Forms.pas             |TCustomForm                         |WndProc                     |3098 |
|0050AAE7|toad.exe    |Controls.pas          |                                    |DoCalcConstraints           |8130 |
|00427D8E|toad.exe    |classes.pas           |TThreadList                         |UnlockList                  |3151 |
|00427D80|toad.exe    |classes.pas           |TThreadList                         |UnlockList                  |3150 |
|00472E94|toad.exe    |Graphics.pas          |                                    |FreeMemoryContexts          |4670 |
|00506AD8|toad.exe    |Controls.pas          |TWinControl                         |MainWndProc                 |6237 |
|00472DFC|toad.exe    |Graphics.pas          |                                    |FreeMemoryContexts          |4658 |
|00506AED|toad.exe    |Controls.pas          |TWinControl                         |MainWndProc                 |6240 |
|004371A0|toad.exe    |classes.pas           |                                    |StdWndProc                  |10966|
|0040279A|toad.exe    |GETMEM.INC            |                                    |SysGetMem                   |1038 |
|00402254|toad.exe    |GETMEM.INC            |                                    |InsertFree                  |787  |
|00402949|toad.exe    |GETMEM.INC            |                                    |SysFreeMem                  |1135 |
|7C9010ED|ntdll.dll   |                      |                                    |RtlLeaveCriticalSection     |     |
|00402971|toad.exe    |GETMEM.INC            |                                    |SysFreeMem                  |1139 |
|00402F8D|toad.exe    |system.pas            |                                    |_FreeMem                    |2466 |
|00402F88|toad.exe    |system.pas            |                                    |_FreeMem                    |2456 |
|00405E20|toad.exe    |system.pas            |                                    |_LStrClr                    |11663|
|00405E04|toad.exe    |system.pas            |                                    |_LStrClr                    |11652|
|00405F17|toad.exe    |system.pas            |                                    |_LStrFromPCharLen           |11912|
|00405EF4|toad.exe    |system.pas            |                                    |_LStrFromPCharLen           |11885|
|00405FAE|toad.exe    |system.pas            |                                    |_LStrFromPWCharLen          |12093|
|77124880|oleaut32.dll|                      |                                    |SysFreeString               |     |
|00406719|toad.exe    |system.pas            |                                    |_WStrFromPWCharLen          |13418|
|00406608|toad.exe    |system.pas            |                                    |_WStrClr                    |13278|
|0040668B|toad.exe    |system.pas            |                                    |_WStrFromPCharLen           |13361|
|7E41C660|user32.dll  |                      |                                    |CallWindowProcW             |     |
|7E41F658|user32.dll  |                      |                                    |CallWindowProcA             |     |
|7E41F642|user32.dll  |                      |                                    |CallWindowProcA             |     |
|0050704C|toad.exe    |Controls.pas          |TWinControl                         |DefaultHandler              |6369 |
|004A9C09|toad.exe    |ComCtrls.pas          |TCustomTabControl                   |TCMAdjustRect               |4715 |
|005031F7|toad.exe    |Controls.pas          |TControl                            |WndProc                     |4645 |
|7C90F1CB|ntdll.dll   |                      |                                    |RtlMultiByteToUnicodeN      |     |
|7C90F0A5|ntdll.dll   |                      |                                    |RtlAnsiStringToUnicodeString|     |
|7C90D9BF|ntdll.dll   |                      |                                    |NtFindAtom                  |     |
|7E430038|user32.dll  |                      |                                    |GetPropA                    |     |
|7E430002|user32.dll  |                      |                                    |GetPropA                    |     |
|004FD598|toad.exe    |Controls.pas          |                                    |FindControl                 |1805 |
|00503018|toad.exe    |Controls.pas          |TControl                            |WndProc                     |4592 |
|00506F06|toad.exe    |Controls.pas          |TWinControl                         |WndProc                     |6342 |
|00427D8E|toad.exe    |classes.pas           |TThreadList                         |UnlockList                  |3151 |
|00427D80|toad.exe    |classes.pas           |TThreadList                         |UnlockList                  |3150 |
|00472E94|toad.exe    |Graphics.pas          |                                    |FreeMemoryContexts          |4670 |
|00506AD8|toad.exe    |Controls.pas          |TWinControl                         |MainWndProc                 |6237 |
|00472DFC|toad.exe    |Graphics.pas          |                                    |FreeMemoryContexts          |4658 |
|00506AED|toad.exe    |Controls.pas          |TWinControl                         |MainWndProc                 |6240 |
|004371A0|toad.exe    |classes.pas           |                                    |StdWndProc                  |10966|
|7E41BEFD|user32.dll  |                      |                                    |InflateRect                 |     |
|7E44F767|user32.dll  |                      |                                    |DefMDIChildProcA            |     |
|7E41F658|user32.dll  |                      |                                    |CallWindowProcA             |     |
|0050704C|toad.exe    |Controls.pas          |TWinControl                         |DefaultHandler              |6369 |
|00506F10|toad.exe    |Controls.pas          |TWinControl                         |DefaultHandler              |6346 |
|004E88C8|toad.exe    |Forms.pas             |TCustomForm                         |DefaultHandler              |3770 |
|004E9F02|toad.exe    |Forms.pas             |TCustomForm                         |WMGetMinMaxInfo             |4369 |
|005031F7|toad.exe    |Controls.pas          |TControl                            |WndProc                     |4645 |
|00502CEC|toad.exe    |Controls.pas          |TControl                            |ConstrainedResize           |4494 |
|0050AF6E|toad.exe    |Controls.pas          |TWinControl                         |ConstrainedResize           |8275 |
|0050AAE7|toad.exe    |Controls.pas          |                                    |DoCalcConstraints           |8130 |
|0050AA38|toad.exe    |Controls.pas          |                                    |DoCalcConstraints           |8110 |
|0050AC66|toad.exe    |Controls.pas          |TWinControl                         |CalcConstraints             |8165 |
|00503018|toad.exe    |Controls.pas          |TControl                            |WndProc                     |4592 |
|00506F06|toad.exe    |Controls.pas          |TWinControl                         |WndProc                     |6342 |
|00506D78|toad.exe    |Controls.pas          |TWinControl                         |WndProc                     |6309 |
|004E6E54|toad.exe    |Forms.pas             |TCustomForm                         |WndProc                     |3098 |
|0050AAE7|toad.exe    |Controls.pas          |                                    |DoCalcConstraints           |8130 |
|00427D8E|toad.exe    |classes.pas           |TThreadList                         |UnlockList                  |3151 |
|00427D80|toad.exe    |classes.pas           |TThreadList                         |UnlockList                  |3150 |
|00472E94|toad.exe    |Graphics.pas          |                                    |FreeMemoryContexts          |4670 |
|00506AD8|toad.exe    |Controls.pas          |TWinControl                         |MainWndProc                 |6237 |
|00472DFC|toad.exe    |Graphics.pas          |                                    |FreeMemoryContexts          |4658 |
|00506AED|toad.exe    |Controls.pas          |TWinControl                         |MainWndProc                 |6240 |
|004371A0|toad.exe    |classes.pas           |                                    |StdWndProc                  |10966|
|00405E04|toad.exe    |system.pas            |                                    |_LStrClr                    |11652|
|0083A8E7|toad.exe    |cbClasses.pas         |TcbHFormHookComponentWatchCaption   |MessageAfter                |712  |
|0083A884|toad.exe    |cbClasses.pas         |TcbHFormHookComponentWatchCaption   |MessageAfter                |698  |
|0083D0AE|toad.exe    |CaptionButton.pas     |TCustomCaptionButton                |MessageAfter                |1113 |
|7E41F642|user32.dll  |                      |                                    |CallWindowProcA             |     |
|0083A68F|toad.exe    |cbClasses.pas         |TcbFormHookComponent                |HookWndProc                 |572  |
|0083A6BD|toad.exe    |cbClasses.pas         |TcbFormHookComponent                |HookWndProc                 |575  |
|004371A0|toad.exe    |classes.pas           |                                    |StdWndProc                  |10966|
|77F16BE7|GDI32.dll   |                      |                                    |GdiDrawStream               |     |
|7E41C660|user32.dll  |                      |                                    |CallWindowProcW             |     |
|77F170A8|GDI32.dll   |                      |                                    |CreateCompatibleBitmap      |     |
|7712501D|oleaut32.dll|                      |                                    |SafeArrayDestroy            |     |
|77125013|oleaut32.dll|                      |                                    |SafeArrayDestroy            |     |
|77124920|oleaut32.dll|                      |                                    |VariantClear                |     |
|00417993|toad.exe    |variants.pas          |                                    |VarArrayClear               |701  |
|7712AAD4|oleaut32.dll|                      |                                    |SafeArrayAllocData          |     |
|7712AA9C|oleaut32.dll|                      |                                    |SafeArrayAllocData          |     |
|7712AB9A|oleaut32.dll|                      |                                    |SafeArrayCreate             |     |
|7712AB11|oleaut32.dll|                      |                                    |SafeArrayCreate             |     |
|0041EBBC|toad.exe    |variants.pas          |                                    |VarArrayCreate              |4310 |
|00417A20|toad.exe    |variants.pas          |                                    |_VarClear                   |739  |
|0041EBD2|toad.exe    |variants.pas          |                                    |VarArrayCreate              |4314 |
|0041023C|toad.exe    |sysutils.pas          |                                    |AppendChars                 |11326|
|004102B4|toad.exe    |sysutils.pas          |                                    |AppendString                |11335|
|0041029C|toad.exe    |sysutils.pas          |                                    |AppendString                |11334|
|00410C21|toad.exe    |sysutils.pas          |                                    |AppendFormat                |11654|
|00405E28|toad.exe    |system.pas            |                                    |_LStrArrayClr               |11687|
|00410E2C|toad.exe    |sysutils.pas          |                                    |AppendFormat                |11707|
|77124CCC|oleaut32.dll|                      |                                    |SysAllocStringByteLen       |     |
|77124C98|oleaut32.dll|                      |                                    |SysAllocStringByteLen       |     |
|77124880|oleaut32.dll|                      |                                    |SysFreeString               |     |
|77124920|oleaut32.dll|                      |                                    |VariantClear                |     |
|004179B3|toad.exe    |variants.pas          |                                    |VarClearDeep                |710  |
|00417670|toad.exe    |variants.pas          |                                    |VarResultCheck              |581  |
|004179B8|toad.exe    |variants.pas          |                                    |VarClearDeep                |710  |
|004179A4|toad.exe    |variants.pas          |                                    |VarClearDeep                |707  |
|00417A2D|toad.exe    |variants.pas          |                                    |_VarClear                   |742  |
|00417A20|toad.exe    |variants.pas          |                                    |_VarClear                   |739  |
|0041F022|toad.exe    |variants.pas          |                                    |_VarArrayPut                |4556 |
|00539460|toad.exe    |DB.pas                |TStringField                        |GetValue                    |4373 |
|0053937A|toad.exe    |DB.pas                |TStringField                        |GetAsVariant                |4348 |
|0053D862|toad.exe    |DB.pas                |TObjectField                        |GetFieldValue               |6407 |
|0053D919|toad.exe    |DB.pas                |TObjectField                        |GetAsVariant                |6423 |
|0053D7F8|toad.exe    |DB.pas                |TObjectField                        |GetAsString                 |6401 |
|00538264|toad.exe    |DB.pas                |TField                              |GetText                     |3792 |
|00538090|toad.exe    |DB.pas                |TField                              |GetDisplayText              |3698 |
|0053805C|toad.exe    |DB.pas                |TField                              |GetDisplayText              |3694 |
|005CD512|toad.exe    |dxDBCtrl.pas          |TdxDBTreeListColumn                 |GetDisplayText              |976  |
|01653BD8|toad.exe    |dxDBGrid.pas          |TCustomdxDBGrid                     |GetNodeString               |4364 |
|005A4D02|toad.exe    |dxTL.pas              |TCustomdxTreeListControl            |GetCellText                 |19205|
|0059D48D|toad.exe    |dxTL.pas              |TCustomdxTreeList                   |DrawCellEx                  |14619|
|00427274|toad.exe    |classes.pas           |TList                               |Get                         |2824 |
|005A7D6A|toad.exe    |dxTL.pas              |TCustomdxTreeListControl            |GetColumn                   |20454|
|005933FC|toad.exe    |dxTL.pas              |                                    |DrawCells                   |9135 |
|77F1955E|GDI32.dll   |                      |                                    |ExcludeClipRect             |     |
|0046E77C|toad.exe    |Graphics.pas          |TCanvas                             |RequiredState               |2471 |
|0046E662|toad.exe    |Graphics.pas          |TCanvas                             |GetHandle                   |2429 |
|77F181E2|GDI32.dll   |                      |                                    |RectVisible                 |     |
|005917F4|toad.exe    |dxTL.pas              |                                    |DrawCells                   |8710 |
|00594D0D|toad.exe    |dxTL.pas              |TCustomdxTreeList                   |Paint                       |9567 |
|7C9010ED|ntdll.dll   |                      |                                    |RtlLeaveCriticalSection     |     |
|00427D8E|toad.exe    |classes.pas           |TThreadList                         |UnlockList                  |3151 |
|0050C6A6|toad.exe    |Controls.pas          |TCustomControl                      |PaintWindow                 |8918 |
|005071F8|toad.exe    |Controls.pas          |TWinControl                         |PaintHandler                |6415 |
|005070E0|toad.exe    |Controls.pas          |TWinControl                         |PaintHandler                |6398 |
|00507758|toad.exe    |Controls.pas          |TWinControl                         |WMPaint                     |6547 |
|00405070|toad.exe    |system.pas            |                                    |_AsClass                    |8645 |
|0050770C|toad.exe    |Controls.pas          |TWinControl                         |WMPaint                     |6541 |
|0050C637|toad.exe    |Controls.pas          |TCustomControl                      |WMPaint                     |8907 |
|005031F7|toad.exe    |Controls.pas          |TControl                            |WndProc                     |4645 |
|0050770C|toad.exe    |Controls.pas          |TWinControl                         |WMPaint                     |6541 |
|0050C637|toad.exe    |Controls.pas          |TCustomControl                      |WMPaint                     |8907 |
|005031F7|toad.exe    |Controls.pas          |TControl                            |WndProc                     |4645 |
|004F004C|toad.exe    |Forms.pas             |TApplication                        |CancelHint                  |7419 |
|004EFECA|toad.exe    |Forms.pas             |TApplication                        |HintMouseMessage            |7365 |
|005031F7|toad.exe    |Controls.pas          |TControl                            |WndProc                     |4645 |
|7E41F891|user32.dll  |                      |                                    |CallNextHookEx              |     |
|00503018|toad.exe    |Controls.pas          |TControl                            |WndProc                     |4592 |
|00506F06|toad.exe    |Controls.pas          |TWinControl                         |WndProc                     |6342 |
|00506D78|toad.exe    |Controls.pas          |TWinControl                         |WndProc                     |6309 |
|00594F78|toad.exe    |dxTL.pas              |TCustomdxTreeList                   |WndProc                     |9659 |
|00594E28|toad.exe    |dxTL.pas              |TCustomdxTreeList                   |WndProc                     |9612 |
|0164EF11|toad.exe    |dxDBGrid.pas          |TCustomdxDBGrid                     |WndProc                     |2293 |
|00506AD8|toad.exe    |Controls.pas          |TWinControl                         |MainWndProc                 |6237 |
|004371A0|toad.exe    |classes.pas           |                                    |StdWndProc                  |10966|
|7E4196C2|user32.dll  |                      |                                    |DispatchMessageA            |     |
|7E4196B8|user32.dll  |                      |                                    |DispatchMessageA            |     |
|004EEE80|toad.exe    |Forms.pas             |TApplication                        |ProcessMessage              |6873 |
|004EEDD4|toad.exe    |Forms.pas             |TApplication                        |ProcessMessage              |6860 |
|004EEEC7|toad.exe    |Forms.pas             |TApplication                        |HandleMessage               |6892 |
|004EEEB8|toad.exe    |Forms.pas             |TApplication                        |HandleMessage               |6891 |
|004EF162|toad.exe    |Forms.pas             |TApplication                        |Run                         |6976 |
|004EF0BC|toad.exe    |Forms.pas             |TApplication                        |Run                         |6960 |
|016AC22A|toad.exe    |Toad.dpr              |                                    |TOAD                        |162  |
|--------------------------------------------------------------------------------------------------------------------|
|                                                                                                                    |
| Running Thread: ID=1336; Priority=0; Class=TWorkerThread                                                           |
|--------------------------------------------------------------------------------------------------------------------|
|7C90E9BE|ntdll.dll   |                      |                                    |NtWaitForSingleObject       |     |
|7C802540|kernel32.dll|                      |                                    |WaitForSingleObjectEx       |     |
|7C80252D|kernel32.dll|                      |                                    |WaitForSingleObject         |     |
|7C802520|kernel32.dll|                      |                                    |WaitForSingleObject         |     |
|0070B039|toad.exe    |VirtualTrees.pas      |TWorkerThread                       |Execute                     |5162 |
|004155C0|toad.exe    |sysutils.pas          |TThreadLocalCounter                 |Delete                      |15958|
|004158F8|toad.exe    |sysutils.pas          |TMultiReadExclusiveWriteSynchronizer|EndWrite                    |16161|
|00434C02|toad.exe    |classes.pas           |                                    |ThreadProc                  |9372 |
|00402F8D|toad.exe    |system.pas            |                                    |_FreeMem                    |2466 |
|00405DA8|toad.exe    |system.pas            |                                    |ThreadWrapper               |11554|
|--------------------------------------------------------------------------------------------------------------------|
| Calling Thread: ID=2508; Priority=0; Class=; [Main]                                                                |
|--------------------------------------------------------------------------------------------------------------------|
|00409360|toad.exe    |Windows.pas           |                                    |ResumeThread                |29170|
|004351C4|toad.exe    |classes.pas           |TThread                             |Resume                      |9664 |
|00405284|toad.exe    |system.pas            |                                    |_AfterConstruction          |9065 |
|00427BE4|toad.exe    |classes.pas           |TThreadList                         |Create                      |3094 |
|004351B4|toad.exe    |classes.pas           |TThread                             |Resume                      |9663 |
|00434E0B|toad.exe    |classes.pas           |TThread                             |AfterConstruction           |9447 |
|0040528B|toad.exe    |system.pas            |                                    |_AfterConstruction          |9066 |
|00405284|toad.exe    |system.pas            |                                    |_AfterConstruction          |9065 |
|0070AF98|toad.exe    |VirtualTrees.pas      |TWorkerThread                       |Create                      |5126 |
|0070AF68|toad.exe    |VirtualTrees.pas      |TWorkerThread                       |Create                      |5124 |
|0070AEFE|toad.exe    |VirtualTrees.pas      |                                    |AddThreadReference          |5077 |
|0070AECC|toad.exe    |VirtualTrees.pas      |                                    |AddThreadReference          |5069 |
|0071423A|toad.exe    |VirtualTrees.pas      |TBaseVirtualTree                    |Create                      |11482|
|00713F70|toad.exe    |VirtualTrees.pas      |TBaseVirtualTree                    |Create                      |11395|
|007397D0|toad.exe    |XMLExplainTreeGrid.pas|TXMLExplainTreeGrid                 |Create                      |360  |
|00739794|toad.exe    |XMLExplainTreeGrid.pas|TXMLExplainTreeGrid                 |Create                      |357  |
|015E1FF3|toad.exe    |ToadExplainPlan.pas   |TToadExplainPlan                    |Create                      |130  |
|015E1FCC|toad.exe    |ToadExplainPlan.pas   |TToadExplainPlan                    |Create                      |129  |
|011CB807|toad.exe    |frmToadEditor.pas     |TFormToadEditor                     |Create                      |2233 |
|01536008|toad.exe    |dmCommonActions.pas   |TdmCommonActions                    |DisplayForm                 |1017 |
|01535D64|toad.exe    |dmCommonActions.pas   |TdmCommonActions                    |DisplayForm                 |945  |
|015399C7|toad.exe    |dmCommonActions.pas   |TdmCommonActions                    |DisplayEditor               |2844 |
|015398B4|toad.exe    |dmCommonActions.pas   |TdmCommonActions                    |DisplayEditor               |2817 |
|015961B0|toad.exe    |ConnectionObjects.pas |                                    |ShowForm                    |6472 |
|0159616C|toad.exe    |ConnectionObjects.pas |                                    |ShowForm                    |6462 |
|01596373|toad.exe    |ConnectionObjects.pas |TConnectionManager                  |AutoOpenWindows             |6525 |
|00402254|toad.exe    |GETMEM.INC            |                                    |InsertFree                  |787  |
|00402949|toad.exe    |GETMEM.INC            |                                    |SysFreeMem                  |1135 |
|7C9010ED|ntdll.dll   |                      |                                    |RtlLeaveCriticalSection     |     |
|00402971|toad.exe    |GETMEM.INC            |                                    |SysFreeMem                  |1139 |
|00402F8D|toad.exe    |system.pas            |                                    |_FreeMem                    |2466 |
|00402F88|toad.exe    |system.pas            |                                    |_FreeMem                    |2456 |
|00404E74|toad.exe    |system.pas            |TObject                             |FreeInstance                |8366 |
|7E41CBCF|user32.dll  |                      |                                    |PostMessageA                |     |
|7E41CB85|user32.dll  |                      |                                    |PostMessageA                |     |
|015845E5|toad.exe    |ConnectionObjects.pas |TConnectionManager                  |SetActive                   |1337 |
|01596214|toad.exe    |ConnectionObjects.pas |TConnectionManager                  |AutoOpenWindows             |6494 |
|0158390C|toad.exe    |ConnectionObjects.pas |TConnectionManager                  |NewConnection               |926  |
|01583734|toad.exe    |ConnectionObjects.pas |TConnectionManager                  |NewConnection               |872  |
|012BD8C5|toad.exe    |login.pas             |TfrmLogin                           |ConnectOne                  |2470 |
|012BD844|toad.exe    |login.pas             |TfrmLogin                           |ConnectOne                  |2467 |
|012B84FF|toad.exe    |login.pas             |TfrmLogin                           |btnOkClick                  |414  |
|00503422|toad.exe    |Controls.pas          |TControl                            |Click                       |4705 |
|0050339C|toad.exe    |Controls.pas          |TControl                            |Click                       |4696 |
|004D887F|toad.exe    |StdCtrls.pas          |TButton                             |Click                       |3472 |
|004D8850|toad.exe    |StdCtrls.pas          |TButton                             |Click                       |3469 |
|00492304|toad.exe    |Buttons.pas           |TBitBtn                             |Click                       |1506 |
|0040508C|toad.exe    |system.pas            |                                    |GetDynaMethod               |8673 |
|004050C0|toad.exe    |system.pas            |                                    |_CallDynaInst               |8709 |
|004050BC|toad.exe    |system.pas            |                                    |_CallDynaInst               |8706 |
|004D89E6|toad.exe    |StdCtrls.pas          |TButton                             |CNCommand                   |3524 |
|005031F7|toad.exe    |Controls.pas          |TControl                            |WndProc                     |4645 |
|7E41BFFB|user32.dll  |                      |                                    |NotifyWinEvent              |     |
|7E430038|user32.dll  |                      |                                    |GetPropA                    |     |
|7E4188CC|user32.dll  |                      |                                    |GetWindowLongW              |     |
|004FD544|toad.exe    |Controls.pas          |                                    |FindControl                 |1799 |
|7E4188D5|user32.dll  |                      |                                    |GetWindowLongW              |     |
|7C90F1CB|ntdll.dll   |                      |                                    |RtlMultiByteToUnicodeN      |     |
|7C90F0A5|ntdll.dll   |                      |                                    |RtlAnsiStringToUnicodeString|     |
|7C90D9BF|ntdll.dll   |                      |                                    |NtFindAtom                  |     |
|00503018|toad.exe    |Controls.pas          |TControl                            |WndProc                     |4592 |
|00506F06|toad.exe    |Controls.pas          |TWinControl                         |WndProc                     |6342 |
|00506D78|toad.exe    |Controls.pas          |TWinControl                         |WndProc                     |6309 |
|004D86CE|toad.exe    |StdCtrls.pas          |TButtonControl                      |WndProc                     |3414 |
|00502F02|toad.exe    |Controls.pas          |TControl                            |Perform                     |4552 |
|00502ECC|toad.exe    |Controls.pas          |TControl                            |Perform                     |4547 |
|005070C8|toad.exe    |Controls.pas          |                                    |DoControlMsg                |6388 |
|0050708C|toad.exe    |Controls.pas          |                                    |DoControlMsg                |6382 |
|005078A5|toad.exe    |Controls.pas          |TWinControl                         |WMCommand                   |6574 |
|005031F7|toad.exe    |Controls.pas          |TControl                            |WndProc                     |4645 |
|7C90F1CB|ntdll.dll   |                      |                                    |RtlMultiByteToUnicodeN      |     |
|7C90F0A5|ntdll.dll   |                      |                                    |RtlAnsiStringToUnicodeString|     |
|7C90D9BF|ntdll.dll   |                      |                                    |NtFindAtom                  |     |
|7E430038|user32.dll  |                      |                                    |GetPropA                    |     |
|7E430002|user32.dll  |                      |                                    |GetPropA                    |     |
|004FD598|toad.exe    |Controls.pas          |                                    |FindControl                 |1805 |
|00503018|toad.exe    |Controls.pas          |TControl                            |WndProc                     |4592 |
|00506F06|toad.exe    |Controls.pas          |TWinControl                         |WndProc                     |6342 |
|00506AD8|toad.exe    |Controls.pas          |TWinControl                         |MainWndProc                 |6237 |
|004371A0|toad.exe    |classes.pas           |                                    |StdWndProc                  |10966|
|7E41B8FE|user32.dll  |                      |                                    |SendMessageW                |     |
|7E41F658|user32.dll  |                      |                                    |CallWindowProcA             |     |
|7E41F642|user32.dll  |                      |                                    |CallWindowProcA             |     |
|0050704C|toad.exe    |Controls.pas          |TWinControl                         |DefaultHandler              |6369 |
|00503949|toad.exe    |Controls.pas          |TControl                            |WMLButtonUp                 |4836 |
|005031F7|toad.exe    |Controls.pas          |TControl                            |WndProc                     |4645 |
|7E41F891|user32.dll  |                      |                                    |CallNextHookEx              |     |
|0050A12C|toad.exe    |Controls.pas          |TWinControl                         |HandleNeeded                |7792 |
|0050A170|toad.exe    |Controls.pas          |TWinControl                         |GetHandle                   |7802 |
|7E4194DA|user32.dll  |                      |                                    |GetCapture                  |     |
|00506CCF|toad.exe    |Controls.pas          |TWinControl                         |IsControlMouseMsg           |6287 |
|00503018|toad.exe    |Controls.pas          |TControl                            |WndProc                     |4592 |
|00506F06|toad.exe    |Controls.pas          |TWinControl                         |WndProc                     |6342 |
|00506D78|toad.exe    |Controls.pas          |TWinControl                         |WndProc                     |6309 |
|004D86CE|toad.exe    |StdCtrls.pas          |TButtonControl                      |WndProc                     |3414 |
|00506AD8|toad.exe    |Controls.pas          |TWinControl                         |MainWndProc                 |6237 |
|004371A0|toad.exe    |classes.pas           |                                    |StdWndProc                  |10966|
|7E4196C2|user32.dll  |                      |                                    |DispatchMessageA            |     |
|7E4196B8|user32.dll  |                      |                                    |DispatchMessageA            |     |
|004EEE80|toad.exe    |Forms.pas             |TApplication                        |ProcessMessage              |6873 |
|004EEDD4|toad.exe    |Forms.pas             |TApplication                        |ProcessMessage              |6860 |
|004EEEC7|toad.exe    |Forms.pas             |TApplication                        |HandleMessage               |6892 |
|004EEEB8|toad.exe    |Forms.pas             |TApplication                        |HandleMessage               |6891 |
|004EACB8|toad.exe    |Forms.pas             |TCustomForm                         |ShowModal                   |4823 |
|012B89C4|toad.exe    |login.pas             |                                    |ConnectDb                   |505  |
|012B89A0|toad.exe    |login.pas             |                                    |ConnectDb                   |496  |
|01267D54|toad.exe    |mainform.pas          |TfrmMain                            |TmMainformShown             |6431 |
|005031F7|toad.exe    |Controls.pas          |TControl                            |WndProc                     |4645 |
|004270E4|toad.exe    |classes.pas           |TList                               |Delete                      |2779 |
|7C9010ED|ntdll.dll   |                      |                                    |RtlLeaveCriticalSection     |     |
|00427D8E|toad.exe    |classes.pas           |TThreadList                         |UnlockList                  |3151 |
|00427D80|toad.exe    |classes.pas           |TThreadList                         |UnlockList                  |3150 |
|0042CFD3|toad.exe    |classes.pas           |                                    |RemoveFixups                |5678 |
|00402254|toad.exe    |GETMEM.INC            |                                    |InsertFree                  |787  |
|00402949|toad.exe    |GETMEM.INC            |                                    |SysFreeMem                  |1135 |
|00406D64|toad.exe    |system.pas            |                                    |_FinalizeArray              |14362|
|00406D38|toad.exe    |system.pas            |                                    |_FinalizeRecord             |14276|
|00402F8D|toad.exe    |system.pas            |                                    |_FreeMem                    |2466 |
|00402F88|toad.exe    |system.pas            |                                    |_FreeMem                    |2456 |
|00404E74|toad.exe    |system.pas            |TObject                             |FreeInstance                |8366 |
|0040527E|toad.exe    |system.pas            |                                    |_ClassDestroy               |9060 |
|0040527C|toad.exe    |system.pas            |                                    |_ClassDestroy               |9060 |
|004E5C32|toad.exe    |Forms.pas             |TCustomForm                         |Destroy                     |2640 |
|00404EBC|toad.exe    |system.pas            |TObject                             |Free                        |8385 |
|00404EB4|toad.exe    |system.pas            |TObject                             |Free                        |8384 |
|004EA767|toad.exe    |Forms.pas             |TCustomForm                         |CMRelease                   |4567 |
|005031F7|toad.exe    |Controls.pas          |TControl                            |WndProc                     |4645 |
|00503018|toad.exe    |Controls.pas          |TControl                            |WndProc                     |4592 |
|00506F06|toad.exe    |Controls.pas          |TWinControl                         |WndProc                     |6342 |
|7E41F891|user32.dll  |                      |                                    |CallNextHookEx              |     |
|00506D78|toad.exe    |Controls.pas          |TWinControl                         |WndProc                     |6309 |
|004E6E54|toad.exe    |Forms.pas             |TCustomForm                         |WndProc                     |3098 |
|00506AD8|toad.exe    |Controls.pas          |TWinControl                         |MainWndProc                 |6237 |
|004371A0|toad.exe    |classes.pas           |                                    |StdWndProc                  |10966|
|7E41F658|user32.dll  |                      |                                    |CallWindowProcA             |     |
|7E41F642|user32.dll  |                      |                                    |CallWindowProcA             |     |
|0125C203|toad.exe    |mainform.pas          |                                    |NewWindowProc               |933  |
|7E4196C2|user32.dll  |                      |                                    |DispatchMessageA            |     |
|7E4196B8|user32.dll  |                      |                                    |DispatchMessageA            |     |
|004EEE80|toad.exe    |Forms.pas             |TApplication                        |ProcessMessage              |6873 |
|004EEDD4|toad.exe    |Forms.pas             |TApplication                        |ProcessMessage              |6860 |
|004EEEC7|toad.exe    |Forms.pas             |TApplication                        |HandleMessage               |6892 |
|004EEEB8|toad.exe    |Forms.pas             |TApplication                        |HandleMessage               |6891 |
|004EF162|toad.exe    |Forms.pas             |TApplication                        |Run                         |6976 |
|004EF0BC|toad.exe    |Forms.pas             |TApplication                        |Run                         |6960 |
|016AC22A|toad.exe    |Toad.dpr              |                                    |TOAD                        |162  |
----------------------------------------------------------------------------------------------------------------------

Modules Information:
--------------------

Registers:
----------

