LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

PACKAGE constant_bag IS
	CONSTANT order 	 : positive := 10;		         --This is order of the filter
	CONSTANT nb	 : positive := 13;		             --This is input data parallelism
	CONSTANT tot_bit : positive := (order+1)*nb;	 --This is total number of bits of a flatten array of coefficients
	CONSTANT n_pipe : positive := 1;		         --This is number of pipeline stages

	TYPE REG_ARRAY IS ARRAY (0 TO order) OF STD_LOGIC_VECTOR(nb-1 DOWNTO 0); 	    --This is internal 2D vector for register
	TYPE REG_ARRAY_UNF IS ARRAY (0 TO order+2) OF STD_LOGIC_VECTOR(nb-1 DOWNTO 0); 	--This is internal 2D vector for register (unfolding)
	TYPE MULT_ARRAY IS ARRAY (0 TO order) OF SIGNED (2*nb-1 DOWNTO 0);				--This is internal 2D vector for output of mult
	TYPE ADD_ARRAY IS ARRAY (0 TO order-1) OF SIGNED (nb-1 DOWNTO 0);				--This is internal 2D vector for output of add
END PACKAGE constant_bag;
