CREATE OR REPLACE PACKAGE BODY chars
IS
   PROCEDURE clear_set
   IS
   BEGIN
      NULL;
   END clear_set;

   PROCEDURE add_printable (
      start_in   IN   PLS_INTEGER
    , end_in     IN   PLS_INTEGER DEFAULT NULL
   )
   IS
   BEGIN
      NULL;
   END add_printable;

   PROCEDURE add_non_printable (
      start_in   IN   PLS_INTEGER
    , end_in     IN   PLS_INTEGER DEFAULT NULL
   )
   IS
   BEGIN
      NULL;
   END add_non_printable;

   PROCEDURE set_name (
      position_in      IN   PLS_INTEGER
    , NAME_IN          IN   VARCHAR2
    , description_in   IN   VARCHAR2
   )
   IS
   BEGIN
      NULL;
   END set_name;

   PROCEDURE use_ascii_set
   IS
   BEGIN
      append_name ( 'SOH', 'Start of Header' );
      append_name ( 'STX', 'Start of Text' );
      append_name ( 'ETX', 'End of Text' );
      append_name ( 'EOT', 'End of Transmission' );
      append_name ( 'ENQ', 'Enquiry' );
      append_name ( 'ACK', 'Acknowledgment' );
      append_name ( 'BEL', 'Bell' );
      append_name ( 'BS', 'Backspace' );
      append_name ( 'HT', 'Horizontal Tab' );
      append_name ( 'LF', 'Line Feed' );
      append_name ( 'VT', 'Vertical Tab' );
      append_name ( 'FF', 'Form Feed' );
      append_name ( 'CR', 'Carriage Return' );
      append_name ( 'SO', 'Shift Out' );
      append_name ( 'SI', 'Shift In' );
      append_name ( 'DLE', 'Data Link Escape' );
      append_name ( 'DC1', 'XON - Device Control 1' );
      append_name ( 'DC2', 'Device Control 2' );
      append_name ( 'DC3', 'XOFF - Device Control 3' );
      append_name ( 'DC4', 'Device Control 4' );
      append_name ( 'NAK', 'Negative Acknowledgement' );
      append_name ( 'SYN', 'Synchronous Idle' );
      append_name ( 'ETB', 'End of Trans. Block' );
      append_name ( 'CAN', 'Cancel' );
      append_name ( 'EM', 'End of Medium' );
      append_name ( 'SUB', 'Substitute' );
      append_name ( 'ESC', 'Escape' );
      append_name ( 'FS', 'File Separator' );
      append_name ( 'GS', 'Group Separator' );
      append_name ( 'RS', 'Request to Send', 'Record Separator' );
      append_name ( 'US', 'Unit Separator' );
      append_name ( 'SP', 'Space' );
      set_name ( 127, 'DEL', 'Delete' );
   END use_ascii_set;

   PROCEDURE display (
      string_in        IN   VARCHAR2
    , preserve_nl_in   IN   BOOLEAN DEFAULT TRUE
   )
   IS
   BEGIN
      NULL;
   END display;
END chars;
/
