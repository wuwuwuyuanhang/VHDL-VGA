library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity main_entity is
port(clk50MHz:in std_logic;
	change:in std_logic_vector(1 downto 0);
	frequence : in std_logic;
	 temp_wren :in std_logic;
	
			hs :  OUT  STD_LOGIC;
		vs :  OUT  STD_LOGIC;
		r :  OUT  STD_LOGIC;
		g :  OUT  STD_LOGIC;
		b :  OUT  STD_LOGIC
	);
end main_entity;

architecture behv of main_entity is

--------------component-------------------------
component signal_generator is
port(main_clk:in std_logic;
frequence : in std_logic;
sel_ect:in std_logic_vector(1 downto 0);
y_out:out std_logic_vector(7 downto 0));
end component;

component ram_test IS PORT(
	clock		: IN STD_LOGIC ;
	data		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
	rdaddress		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
	wraddress		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
	wren		: IN STD_LOGIC  := '1';
	q		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
END component;

component RAMvga640480 is port(			  
	clk	: in STD_LOGIC;
	frequence : in std_logic;
	hs	: out STD_LOGIc;
	vs	: out STD_LOGIc;
	r 	: out STD_LOGIC;
	g 	: out STD_LOGIC;
	b 	: out STD_LOGIC;
	rgbin	: in std_logic_vector(7 downto 0);
	hcntout	: out std_logic_vector(9 downto 0);
	vcntout	: out std_logic_vector(9 downto 0);
	en : in std_logic
	);
end component;
----------------component-------------------------

--signal
--fangbo, jieti, sanjiao, sin
signal temp_q1 : std_logic_vector(7 downto 0);
signal temp_data1 : STD_LOGIC_VECTOR (7 DOWNTO 0);
signal rdaddr1 : STD_LOGIC_VECTOR (7 DOWNTO 0);
signal wraddr1 : STD_LOGIC_VECTOR (7 DOWNTO 0);

signal temp_q2 : std_logic_vector(7 downto 0);
signal temp_data2 : STD_LOGIC_VECTOR (7 DOWNTO 0);
signal rdaddr2 : STD_LOGIC_VECTOR (7 DOWNTO 0);
signal wraddr2 : STD_LOGIC_VECTOR (7 DOWNTO 0);

signal temp_q3 : std_logic_vector(7 downto 0);
signal temp_data3 : STD_LOGIC_VECTOR (7 DOWNTO 0);
signal rdaddr3 : STD_LOGIC_VECTOR (7 DOWNTO 0);
signal wraddr3 : STD_LOGIC_VECTOR (7 DOWNTO 0);

signal temp_q4 : std_logic_vector(7 downto 0);
signal temp_data4 : STD_LOGIC_VECTOR (7 DOWNTO 0);
signal rdaddr4 : STD_LOGIC_VECTOR (7 DOWNTO 0);
signal wraddr4 : STD_LOGIC_VECTOR (7 DOWNTO 0);

signal qout1 : std_logic_vector(7 downto 0);
signal qout2 : std_logic_vector(7 downto 0);
signal qout3 : std_logic_vector(7 downto 0);
signal qout4 : std_logic_vector(7 downto 0);

--signal sel_ect: std_logic_vector(1 downto 0);
signal clk25MHz : std_logic;

signal hpos1,vpos1 : std_logic_vector(9 downto 0);
signal hpos2,vpos2 : std_logic_vector(9 downto 0);
signal hpos3,vpos3 : std_logic_vector(9 downto 0);
signal hpos4,vpos4 : std_logic_vector(9 downto 0);

signal hs1,vs1,r1,g1,b1:std_logic;
signal hs2,vs2,r2,g2,b2:std_logic;
signal hs3,vs3,r3,g3,b3:std_logic;
signal hs4,vs4,r4,g4,b4:std_logic;
signal hs0,vs0,r0,g0,b0:std_logic;

begin
--二分频
process(clk50MHz) begin
	if clk50MHz'event and clk50MHz = '1' then
		clk25MHz <= not clk25MHz;
	end if;
end process;

--改变波形，change模式0键8
--process(change)
--begin
--	if rising_edge(change) then
--		if sel_ect = "11" then
--			sel_ect<="00";
--		else
--			sel_ect<=sel_ect+1;
--		end if;
--	end if;
--end process;

process(change)
begin
     CASE change IS
		 WHEN "00" =>  hs0<=hs1 ; vs0<=vs1 ; r0<=r1 ; g0<=g1 ; b0<=b1; 
		 WHEN "01" =>  hs0<=hs2 ; vs0<=vs2 ; r0<=r2 ; g0<=g2 ; b0<=b2;
		 WHEN "10" =>  hs0<=hs3 ; vs0<=vs3 ; r0<=r3 ; g0<=g3 ; b0<=b3;
		 WHEN "11" =>  hs0<=hs4 ; vs0<=vs4 ; r0<=r4 ; g0<=g4 ; b0<=b4;
		 WHEN OTHERS => NULL;
     END CASE;
end process;

hs<=hs0 ; vs<=vs0 ; r<=r0 ; g<=g0 ; b<=b0;
---------write---------

process(clk25MHz)
begin
	if clk25MHz'event and clk25MHz = '1' then
		if temp_wren = '1' then
			if wraddr1 = 255 then
			wraddr1 <= (others=>'0');
			else
			wraddr1 <= wraddr1 + 1;
			end if;
		temp_data1 <= qout1;
		end if;
	end if;
end process;

process(clk25MHz)
begin
	if clk25MHz'event and clk25MHz = '1' then
		if temp_wren = '1' then
			if wraddr2 = 255 then
			wraddr2 <= (others=>'0');
			else
			wraddr2 <= wraddr2 + 1;
			end if;
		temp_data2 <= qout2;
		end if;
	end if;
end process;

process(clk25MHz)
begin
	if clk25MHz'event and clk25MHz = '1' then
		if temp_wren = '1' then
			if wraddr3 = 255 then
			wraddr3 <= (others=>'0');
			else
			wraddr3 <= wraddr3 + 1;
			end if;
		temp_data3 <= qout3;
		end if;
	end if;
end process;

process(clk25MHz)
begin
	if clk25MHz'event and clk25MHz = '1' then
		if temp_wren = '1' then
			if wraddr4 = 255 then
			wraddr4 <= (others=>'0');
			else
			wraddr4 <= wraddr4 + 1;
			end if;
		temp_data4 <= qout4;
		end if;
	end if;
end process;
----------------------------------
--读地址
--四路选择器实现切换
rdaddr1 <= hpos1(7 downto 0);
rdaddr2 <= hpos2(7 downto 0);
rdaddr3 <= hpos3(7 downto 0);
rdaddr4 <= hpos4(7 downto 0);

s1:signal_generator port map(clk25MHz,frequence,"00",qout1);
s2:signal_generator port map(clk25MHz,frequence,"01",qout2);
s3:signal_generator port map(clk25MHz,frequence,"10",qout3);
s4:signal_generator port map(clk25MHz,frequence,"11",qout4);

r11:ram_test port map(clock=>clk25MHz,data=>temp_data1,rdaddress=>rdaddr1,wraddress=>wraddr1,wren=>temp_wren,q=>temp_q1);
r22:ram_test port map(clock=>clk25MHz,data=>temp_data2,rdaddress=>rdaddr2,wraddress=>wraddr2,wren=>temp_wren,q=>temp_q2);
r33:ram_test port map(clock=>clk25MHz,data=>temp_data3,rdaddress=>rdaddr3,wraddress=>wraddr3,wren=>temp_wren,q=>temp_q3);
r44:ram_test port map(clock=>clk25MHz,data=>temp_data4,rdaddress=>rdaddr4,wraddress=>wraddr4,wren=>temp_wren,q=>temp_q4);

v1:RAMvga640480 port map(clk=>clk25MHz,
					frequence=>frequence,
					hs=>hs1,
					vs=>vs1,
					r=>r1,
					g=>g1,
					b=>b1,
					rgbin=>temp_q1,
					hcntout=>hpos1,
					vcntout=>vpos1,
					en =>temp_wren
);

v2:RAMvga640480 port map(clk=>clk25MHz,
					frequence=>frequence,
					hs=>hs2,
					vs=>vs2,
					r=>r2,
					g=>g2,
					b=>b2,
					rgbin=>temp_q2,
					hcntout=>hpos2,
					vcntout=>vpos2,
					en =>temp_wren
);

v3:RAMvga640480 port map(clk=>clk25MHz,
					frequence=>frequence,
					hs=>hs3,
					vs=>vs3,
					r=>r3,
					g=>g3,
					b=>b3,
					rgbin=>temp_q3,
					hcntout=>hpos3,
					vcntout=>vpos3,
					en =>temp_wren
);

v4:RAMvga640480 port map(clk=>clk25MHz,
					frequence=>frequence,
					hs=>hs4,
					vs=>vs4,
					r=>r4,
					g=>g4,
					b=>b4,
					rgbin=>temp_q4,
					hcntout=>hpos4,
					vcntout=>vpos4,
					en =>temp_wren
);
end behv;
