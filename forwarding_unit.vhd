library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity forwarding_unit is
    Port ( 
           MEM_CRegWrite : std_logic; -- Señal de control proveniente de MEM que permite la escritura en el banco de registros
           RegDestino : in STD_LOGIC_VECTOR (4 downto 0); -- Direccion de registro destino
           WB_CRegWrite : std_logic;-- Señal de control proveniente de WB que permite la escritura en el banco de registros
           reg_wr : in STD_LOGIC_VECTOR (4 downto 0);
    
           rs : in STD_LOGIC_VECTOR (4 downto 0);
           rt : in STD_LOGIC_VECTOR (4 downto 0);
          
           FORWARD_A : out STD_LOGIC_VECTOR (1 downto 0);
           FORWARD_B : out STD_LOGIC_VECTOR (1 downto 0));
end forwarding_unit;

architecture Behavioral of Forwarding_unit is

begin

	process(MEM_CRegWrite, RegDestino, WB_CRegWrite, reg_wr, rs, rt ) is
		begin
		
			-- Forward A
			-- Riesgo EX
			if ((MEM_CRegWrite = '1') -- Señal de control que indica si se escribe o no en el registro. Habilita la escritura del mismo
				and (RegDestino /="00000") -- El registro $zero siempre debe vale cero. Su valor no puede ser modificado.
				and (RegDestino = rs)) then
					FORWARD_A <= b"10"; 
			-- Riesgo MEM	
			elsif ((WB_CRegWrite = '1')
				and (reg_wr /="00000") 
				-- si no se da riesgo ex
				and not(MEM_CRegWrite = '1' and (RegDestino /= "00000") 
					and (RegDestino = rs))
				and (reg_wr = rs)) then
					FORWARD_A <= b"01"; 
			else 
				FORWARD_A <= b"00";
			end if;
			-- forward b
			-- riesgo ex
			if ((MEM_CRegWrite = '1') 
				and (RegDestino /="00000") 
				and (RegDestino = rt)) then
					FORWARD_B <= b"10"; 
			--riesgo mem		
			elsif ((WB_CRegWrite = '1') 
				and (reg_wr /="00000") 
				-- si no se da riesgo ex
				and not(MEM_CRegWrite = '1' and (RegDestino /= "00000") 
				and (RegDestino = rt))
				and (reg_wr = rt)) then
					FORWARD_B <= b"01"; 
			else 
				FORWARD_B <= b"00";
			end if;
		end process;

end Behavioral;