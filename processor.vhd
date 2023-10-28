library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity processor is
	port(
		Clk         : in  std_logic;
		Reset       : in  std_logic;
		-- Instruction memory
		I_Addr      : out std_logic_vector(31 downto 0);
		I_RdStb     : out std_logic;
		I_WrStb     : out std_logic;
		I_DataOut   : out std_logic_vector(31 downto 0);
		I_DataIn    : in  std_logic_vector(31 downto 0);
		-- Data memory
		D_Addr      : out std_logic_vector(31 downto 0);
		D_RdStb     : out std_logic;
		D_WrStb     : out std_logic;
		D_DataOut   : out std_logic_vector(31 downto 0);
		D_DataIn    : in  std_logic_vector(31 downto 0)
	);
end processor;

architecture processor_arq of processor is 

--DECLARACION DE COMPONENTES--

-- Dado por la materia--
component registers 
    port  (clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           wr : in STD_LOGIC;
           reg1_dr : in STD_LOGIC_VECTOR (4 downto 0);
           reg2_dr : in STD_LOGIC_VECTOR (4 downto 0);
           reg_wr : in STD_LOGIC_VECTOR (4 downto 0);
           data_wr : in STD_LOGIC_VECTOR (31 downto 0);
           data1_rd : out STD_LOGIC_VECTOR (31 downto 0);
           data2_rd : out STD_LOGIC_VECTOR (31 downto 0));           
end component;

--Hecho por nosotros--
component alu
	port(
		a,b:in std_logic_vector(31 downto 0); 
        control:in std_logic_vector(2 downto 0); 
        zero:out std_logic; 
        result:out std_logic_vector(31 downto 0)
	);
end component;

component forwarding_unit
	port(
		MEM_CRegWrite : std_logic;
           RegDestino : in STD_LOGIC_VECTOR (4 downto 0);
           WB_CRegWrite : std_logic;
           reg_wr : in STD_LOGIC_VECTOR (4 downto 0);
           rs : in STD_LOGIC_VECTOR (4 downto 0);
           rt : in STD_LOGIC_VECTOR (4 downto 0);
           FORWARD_A : out STD_LOGIC_VECTOR (1 downto 0);
           FORWARD_B : out STD_LOGIC_VECTOR (1 downto 0)
	);
end component;

--DECLARACION DE SENALES--

    --ETAPA IF--
signal PC: std_logic_vector(31 downto 0); -- Direccion de la instruccion actual
signal PCSrc: std_logic; -- Señal control del MUX que selecciona el branch o el pc+4	
signal PC_4: std_logic_vector(31 downto 0); -- Direccion de la instruccion siguiente
signal PC_Branch: std_logic_vector(31 downto 0); -- Direccion de un branch calculada en MEM
signal Jump: std_logic; -- Señal de control jump
signal IF_Instruction: std_logic_vector(31 downto 0);--Instruccion obtenida con la direccion del PC

    --ETAPA ID--

    --ETAPA EX--

    --ETAPA MEM--
     
    --ETAPA WB--    
        
begin 	
---------------------------------------------------------------------------------------------------------------
-- ETAPA IF
---------------------------------------------------------------------------------------------------------------
 Contador_de_programa: process(clk,reset) -- proceso con lista de sensibilidad
 	begin
		if reset = '1' then
      		PC <= ( others =>'0'); -- seteo todas las señales del pc en cero (others)
    	elsif rising_edge(clk) then -- sino si hay flanco ascendente en el clock
			if PCSrc = '0' then
				PC <= PC_4;
			else
			 	PC <= PC_Branch;
			end if;
    	end if;
end process;
 PC_4 <= PC + 4;
 I_Addr <= PC;
 I_RdStb <= '1';
 I_WrStb <= '0';
 -- PC_4 <= PC + 4;
---------------------------------------------------------------------------------------------------------------
-- REGISTRO DE SEGMENTACION IF/ID
--------------------------------------------------------------------------------------------------------------- 
 
 
 
---------------------------------------------------------------------------------------------------------------
-- ETAPA ID
---------------------------------------------------------------------------------------------------------------
-- Instanciacion del banco de registros
Registers_inst:  registers 
	Port map (
			clk => clk, 
			reset => reset, 
			wr => RegWrite, 
			reg1_dr => ID_Instruction(25 downto 21), 
			reg2_dr => ID_Instruction( 20 downto 16), 
			reg_wr => WB_reg_wr, 
			data_wr => WB_data_wr , 
			data1_rd => ID_data1_rd ,
			data2_rd => ID_data2_rd ); 

 
 

---------------------------------------------------------------------------------------------------------------
-- REGISTRO DE SEGMENTACION ID/EX
---------------------------------------------------------------------------------------------------------------

 
---------------------------------------------------------------------------------------------------------------
-- ETAPA EX
---------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------------------
-- REGISTRO DE SEGMENTACION EX/MEM
---------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------------------
-- ETAPA MEM
---------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------
-- REGISTRO DE SEGMENTACION MEM/WB
---------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------------------
-- ETAPA WB
---------------------------------------------------------------------------------------------------------------


end processor_arq;