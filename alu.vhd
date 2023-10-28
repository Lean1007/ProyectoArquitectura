library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_Arith.ALL;
use IEEE.STD_LOGIC_Signed.ALL;

entity alu is port ( 
           a : in STD_LOGIC_VECTOR (31 downto 0);
           b : in STD_LOGIC_VECTOR (31 downto 0);
           control : in STD_LOGIC_VECTOR (2 downto 0);
           zero : out STD_LOGIC;
           result : out STD_LOGIC_VECTOR (31 downto 0));
end alu;

architecture behavioral of alu is

signal aux : STD_LOGIC_VECTOR (31 downto 0);

begin

process(a, b, control) -- Proceso con lista de sensibilidad
    begin
        case control is
            when "000" => result <= a and b;
            when "001" => result <= a or b;
            when "010" => result <= a + b;
            when "110" => result <= a - b;
            when "111" => 
                if(a<b) then
                    result <= x"00000001";
                    else result <= x"00000000";
                end if;
            when "100" => result <= b(15 downto 0) & x"0000";  
            when others => result <= x"00000000";   
        end case;
        if(a = b) then
            zero <= '1';
        else
            zero <= '0';
        end if;        
	end process;

end behavioral;