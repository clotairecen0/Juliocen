library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

entity testbench is

end testbench;

architecture tb1 of testbench is
--component declaration
--Pipeline multiplier
COMPONENT FPmul IS
   PORT( 
      FP_A : IN     std_logic_vector (31 DOWNTO 0);
      FP_B : IN     std_logic_vector (31 DOWNTO 0);
      clk  : IN     std_logic;
      FP_Z : OUT    std_logic_vector (31 DOWNTO 0)
   );
END COMPONENT;

--Data generation
COMPONENT data_maker is
  port (
    CLK  : in  std_logic;
    DATA : out std_logic_vector(31 downto 0));
end COMPONENT;

--extra signal declaration
signal CLK: std_logic; --Clock declaration
signal DATA_IN,DATA_OUT, PROD_CORRECT: std_logic_vector(31 DOWNTO 0);
signal pipeDelay: std_logic_vector(3 downto 0):="0000";
signal CORRECT: boolean;
constant TotPipeDEALY: std_logic_vector(3 downto 0):= "0101"; --5


Begin

--Clock process
CLK_PROCESS: process
BEGIN
CLK<='1', '0' after 10 ns, '1' after 20 ns, '0' after 30 ns;
wait for 40 ns;
END process CLK_PROCESS;

--ReadProdcutProcess
ReadProd_PROCESS: process (CLK)
    file fp : text open read_mode is "./fp_prod.hex";
    variable ptr : line;
    variable val : std_logic_vector(31 downto 0);
  begin  -- process
    if CLK'event and CLK = '1' then  -- rising clock edge
      if (pipeDelay/=TotPipeDEALY) then --wait until pipeline finish to compare the correct product
		pipeDelay<=pipeDelay+'1';
		end if;
	  if ((not(endfile(fp))) and pipeDelay=TotPipeDEALY)  then
        readline(fp, ptr);
        hread(ptr, val);        
      end if;
      PROD_CORRECT <= val;
    end if;
 end process;

--Datapath
Datamaker: data_maker PORT MAP (CLK=>CLK, DATA=>DATA_IN);
Multiplier: entity work.FPmul(pipeline_RegIN) PORT MAP (FP_A=>DATA_IN, FP_B=>DATA_IN, clk=>CLK, FP_Z=>DATA_OUT);
CORRECT <= (DATA_OUT=PROD_CORRECT); --Validation correctnes of square value

end tb1;
