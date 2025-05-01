-- LEDController.VHD
-- 2025.03.09
--
-- This SCOMP peripheral alters the brightness of LEDs based on data inputted from SCOMP.
-- LEDs can be individually controlled, or controlled in groups, through the usage of toggling
-- and untoggling LED brightness manipulation functionality.

LIBRARY IEEE;
LIBRARY LPM;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE LPM.LPM_COMPONENTS.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY LEDController IS
PORT(
    CS          : IN  STD_LOGIC;
    WRITE_EN    : IN  STD_LOGIC;
    RESETN      : IN  STD_LOGIC;
	 CLK     	 : IN  STD_LOGIC;
    LEDs        : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
    IO_DATA     : IN  STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END LEDController;

ARCHITECTURE a OF LEDController IS
	SIGNAL L_DATA  : STD_LOGIC_VECTOR(9 DOWNTO 0);
	SIGNAL TOGGLE	: STD_LOGIC_VECTOR(9 DOWNTO 0);
	SIGNAL A_LEDS  : STD_LOGIC_VECTOR(35 DOWNTO 0);
	SIGNAL CL_CNT  : INTEGER;
	SIGNAL PULSE   : STD_LOGIC;
	
	SIGNAL LED0		: INTEGER;
	SIGNAL DATA0	: STD_LOGIC_VECTOR(9 DOWNTO 0);
	SIGNAL LED1		: INTEGER;
	SIGNAL DATA1	: STD_LOGIC_VECTOR(9 DOWNTO 0);
	SIGNAL LED2		: INTEGER;
	SIGNAL DATA2	: STD_LOGIC_VECTOR(9 DOWNTO 0);
	SIGNAL LED3		: INTEGER;
	SIGNAL DATA3	: STD_LOGIC_VECTOR(9 DOWNTO 0);
	SIGNAL LED4		: INTEGER;
	SIGNAL DATA4	: STD_LOGIC_VECTOR(9 DOWNTO 0);
	SIGNAL LED5		: INTEGER;
	SIGNAL DATA5	: STD_LOGIC_VECTOR(9 DOWNTO 0);
	SIGNAL LED6		: INTEGER;
	SIGNAL DATA6	: STD_LOGIC_VECTOR(9 DOWNTO 0);
	SIGNAL LED7		: INTEGER;
	SIGNAL DATA7	: STD_LOGIC_VECTOR(9 DOWNTO 0);
	SIGNAL LED8		: INTEGER;
	SIGNAL DATA8	: STD_LOGIC_VECTOR(9 DOWNTO 0);
	SIGNAL LED9		: INTEGER;
	SIGNAL DATA9	: STD_LOGIC_VECTOR(9 DOWNTO 0);
BEGIN
	 -- LED toggling and brightness tuning
    PROCESS (RESETN, CS)
    BEGIN
		  IF (RESETN = '0') THEN
            -- Untoggle LEDs and clear data at reset
				TOGGLE <= "0000000000";
				A_LEDS <= "000000000000000000000000000000000000";
        ELSIF (RISING_EDGE(CS)) THEN
            IF WRITE_EN = '1' THEN
                -- If SCOMP is sending data to this peripheral,
                -- use that data to toggle LEDs or change brightness data.
					 IF IO_DATA(15 DOWNTO 12) = "0000" THEN
						TOGGLE <= IO_DATA(9 DOWNTO 0);
					 ELSIF IO_DATA(15 DOWNTO 12) = "0001" THEN
						A_LEDS(11 DOWNTO 0) <= IO_DATA(11 DOWNTO 0);
					 ELSIF IO_DATA(15 DOWNTO 12) = "0010" THEN
						A_LEDS(23 DOWNTO 12) <= IO_DATA(11 DOWNTO 0);
					 ELSIF IO_DATA(15 DOWNTO 12) = "0011" THEN
						A_LEDS(29 DOWNTO 24) <= IO_DATA(5 DOWNTO 0);
					 END IF;
            END IF;
        END IF;
    END PROCESS;
	 
	 -- Brightness control mechanism using clock
	 PROCESS (RESETN, CLK)
	 BEGIN
		IF (RESETN = '0') THEN
            -- Turn off LEDs at reset
				LEDs <= "0000000000";
				L_DATA <= "0000000000";
				DATA0 <= "0000000000";
				DATA1 <= "0000000000";
				DATA2 <= "0000000000";
				DATA3 <= "0000000000";
				DATA4 <= "0000000000";
				DATA5 <= "0000000000";
				DATA6 <= "0000000000";
				DATA7 <= "0000000000";
				DATA8 <= "0000000000";
				DATA9 <= "0000000000";
		ELSIF (RISING_EDGE(CLK)) THEN
			-- Each throttled clock cycle, calculate a brightness value by squaring the inputted value and adding 1
			-- Notting each value is crucial to ensuring 0 means no brightness and 7 means max brightness
			LED0 <= 1 + (to_integer(unsigned(NOT A_LEDS(2 DOWNTO 0))) * to_integer(unsigned(NOT A_LEDS(2 DOWNTO 0))));
			LED1 <= 1 + (to_integer(unsigned(NOT A_LEDS(5 DOWNTO 3))) * to_integer(unsigned(NOT A_LEDS(5 DOWNTO 3))));
			LED2 <= 1 + (to_integer(unsigned(NOT A_LEDS(8 DOWNTO 6))) * to_integer(unsigned(NOT A_LEDS(8 DOWNTO 6))));
			LED3 <= 1 + (to_integer(unsigned(NOT A_LEDS(11 DOWNTO 9))) * to_integer(unsigned(NOT A_LEDS(11 DOWNTO 9))));
			LED4 <= 1 + (to_integer(unsigned(NOT A_LEDS(14 DOWNTO 12))) * to_integer(unsigned(NOT A_LEDS(14 DOWNTO 12))));
			LED5 <= 1 + (to_integer(unsigned(NOT A_LEDS(17 DOWNTO 15))) * to_integer(unsigned(NOT A_LEDS(17 DOWNTO 15))));
			LED6 <= 1 + (to_integer(unsigned(NOT A_LEDS(20 DOWNTO 18))) * to_integer(unsigned(NOT A_LEDS(20 DOWNTO 18))));
			LED7 <= 1 + (to_integer(unsigned(NOT A_LEDS(23 DOWNTO 21))) * to_integer(unsigned(NOT A_LEDS(23 DOWNTO 21))));
			LED8 <= 1 + (to_integer(unsigned(NOT A_LEDS(26 DOWNTO 24))) * to_integer(unsigned(NOT A_LEDS(26 DOWNTO 24))));
			LED9 <= 1 + (to_integer(unsigned(NOT A_LEDS(29 DOWNTO 27))) * to_integer(unsigned(NOT A_LEDS(29 DOWNTO 27))));
			
			-- Check if each bit is toggled before changing its brightness
			IF TOGGLE(0) = '1' THEN
				-- Check if 0 was the inputted brightness value
				-- The MOD statement is also used to turn the LED off for periods of time
				-- This allows for duty cycle control which, in turn, allows for brightness control.
				IF LED0 = 50 OR NOT (CL_CNT MOD LED0 = 0) THEN
					DATA0 <= "0000000000";
				ELSIF ((CL_CNT MOD LED0) = 0) THEN
					DATA0 <= "0000000001";
				END IF;
			END IF;
			-- Each separate if statement represents a register and circuitry dedicated to each specific LED
			IF TOGGLE(1) = '1' THEN
				IF LED1 = 50 OR NOT (CL_CNT MOD LED1 = 0) THEN
					DATA1 <= "0000000000";
				ELSIF ((CL_CNT MOD LED1) = 0) THEN
					DATA1 <= "0000000010";
				END IF;
			END IF;
			IF TOGGLE(2) = '1' THEN
				IF LED2 = 50 OR NOT (CL_CNT MOD LED2 = 0) THEN
					DATA2 <= "0000000000";
				ELSIF ((CL_CNT MOD LED2) = 0) THEN
					DATA2 <= "0000000100";
				END IF;
			END IF;
			IF TOGGLE(3) = '1' THEN
				IF LED3 = 50 OR NOT (CL_CNT MOD LED3 = 0) THEN
					DATA3 <= "0000000000";
				ELSIF ((CL_CNT MOD LED3) = 0) THEN
					DATA3 <= "0000001000";
				END IF;
			END IF;
			IF TOGGLE(4) = '1' THEN
				IF LED4 = 50 OR NOT (CL_CNT MOD LED4 = 0) THEN
					DATA4 <= "0000000000";
				ELSIF ((CL_CNT MOD LED4) = 0) THEN
					DATA4 <= "0000010000";
				END IF;
			END IF;
			IF TOGGLE(5) = '1' THEN
				IF LED5 = 50 OR NOT (CL_CNT MOD LED5 = 0) THEN
					DATA5 <= "0000000000";
				ELSIF ((CL_CNT MOD LED5) = 0) THEN
					DATA5 <= "0000100000";
				END IF;
			END IF;
			IF TOGGLE(6) = '1' THEN
				IF LED6 = 50 OR NOT (CL_CNT MOD LED6 = 0) THEN
					DATA6 <= "0000000000";
				ELSIF ((CL_CNT MOD LED6) = 0) THEN
					DATA6 <= "0001000000";
				END IF;
			END IF;
			IF TOGGLE(7) = '1' THEN
				IF LED7 = 50 OR NOT (CL_CNT MOD LED7 = 0) THEN
					DATA7 <= "0000000000";
				ELSIF ((CL_CNT MOD LED7) = 0) THEN
					DATA7 <= "0010000000";
				END IF;
			END IF;
			IF TOGGLE(8) = '1' THEN
				IF LED8 = 50 OR NOT (CL_CNT MOD LED8 = 0) THEN
					DATA8 <= "0000000000";
				ELSIF ((CL_CNT MOD LED8) = 0) THEN
					DATA8 <= "0100000000";
				END IF;
			END IF;
			IF TOGGLE(9) = '1' THEN
				IF LED9 = 50 OR NOT (CL_CNT MOD LED9 = 0) THEN
					DATA9 <= "0000000000";
				ELSIF ((CL_CNT MOD LED9) = 0) THEN
					DATA9 <= "1000000000";
				END IF;
			END IF;
			-- Puts all LED data together to output to the LEDs
			-- Through separately determining each LED's data, we can allow
			-- for differing duty cycles which enables brightness control.
			L_DATA <= DATA0 OR DATA1 OR DATA2 OR DATA3 OR DATA4 OR DATA5 OR DATA6 OR DATA7 OR DATA8 OR DATA9;
			LEDs <= L_DATA;
		END IF;
	 END PROCESS;
	 
	 -- Creates counter based on clock that is used for modulo operations
	 PROCESS(RESETN, CLK)
	 BEGIN
		IF (RESETN = '0') THEN
            CL_CNT <= 0;
        ELSIF RISING_EDGE(CLK) THEN
            -- Each clock cycle, a counter is incremented.
            CL_CNT <= CL_CNT + 1;

            -- When the counter reaches the full desired value, start over.
				-- This ensures the integer value is contained, preventing any possible overflow
				-- and errors that may disrupt peripheral function.
            if CL_CNT = 4096 THEN
                -- Reset the counter
                CL_CNT <= 0;
				END IF;
        END IF;
	 END PROCESS;
END a;