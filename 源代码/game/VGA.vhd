LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
entity VGA IS
PORT ( CLK,quadA, quadB		:	IN  STD_LOGIC;
       inDisplayArea		:   IN  STD_LOGIC;
       CounterX				:  	in  std_logic_vector(9 downto 0);
        CounterY 			:   in  std_logic_vector( 8 downto 0);
       vga_R, vga_G, vga_B  :   out std_logic );
END VGA;
ARCHITECTURE ONE OF VGA IS

component over IS
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		clock		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (2 DOWNTO 0)
	);
END component;

--SIGNAL 	PaddlePosition: STD_LOGIC_VECTOR(8 DOWNTO 0);
signal cnt:std_logic_vector(10 downto 0);
signal clk2,clk1:std_logic;
signal cnt1:std_logic_vector(6 downto 0);
signal qa1,qa2,qb1,qb2:std_logic;
signal quadAr,quadBr:std_logic;
signal PaddlePosition:std_logic_vector(9 downto 0);
signal ballX:std_logic_vector(9 downto 0):="0001000000";
signal ballY:std_logic_vector(9 downto 0):="0001000010";
signal ball_inX,ball_inY:std_logic;
signal ball:std_logic;
signal border,paddle, BouncingObject:std_logic;
signal ResetCollision:std_logic;
signal CollisionX1, CollisionX2, CollisionY1, CollisionY2:std_logic;
signal UpdateBallPosition:std_logic;
signal r,g,b,ball_dirX,ball_dirY:std_logic;
signal pa1,pa2:std_logic;

signal romaddr : std_logic_vector(15 downto 0);
signal rgb1 : std_logic_vector(2 downto 0);
signal gameover : std_logic;
begin
process(clk)
begin
    if clk'event and  clk='1'  then
	if (cnt=1249) then cnt<="00000000000"  ;clk1<=not clk1;
	else cnt<=cnt+1;
	end if;
	END IF;
end process ;
process(clk1)
	begin
	if clk1'event and  clk1='1'  then
	if (cnt1=49) then cnt1<="0000000"  ;clk2<=not clk2;
	else
	cnt1<=cnt1+1;
	end if;
	END IF;
end process;
process(clk2)
	begin
	if clk2'event and clk2='1' then
		qa1<=quadA;
		qa2<=qa1;
		qb1<=quadB;
		qb2<=qb1;
	end if;
	end process ;
quadAr<=not (qa1 or qa2);
quadBr<=not(qb1 or qb2);
process(clk2)
begin
	if clk2'event and clk2='1'then
		if quadAr ='1' then
			if(PaddlePosition<"0111111111") then       -- make sure the value doesn't overflow
				PaddlePosition <= PaddlePosition + 1;
			end if;
			
		elsif quadBr='1' then
			if(PaddlePosition>0)        THEN
				PaddlePosition <= PaddlePosition - 1;
			end if;
		end if;
	end if;
end process ;
process(clk,ballX,ballY,ball_inX,ball_inY)
begin
	if clk'event and clk='1' then
		if ball_inX='0' then
			if(CounterX=ballX) and  ball_inY='1'  then
			ball_inX <= '1'; 
			else ball_inX <= '0';
            end if;
		else 
			if(not(CounterX=ballX+16)) THEN
			ball_inX <= '1';
			else ball_inX <= '0';
			end if;
			end if;
		if ball_inY='0' then 
			if(CounterY=ballY) THEN
			ball_inY <= '1'; 
			else ball_inY <= '0';
            end if;
		else 
		    if(not(CounterY=ballY+16)) THEN
			ball_inY <= '1';
			else ball_inY <= '0';
		end if;
		end if ;
	end if;
	ball <= ball_inX and ball_inY;
end process ;


border <='1' when (CounterX(9 downto 2)="00001101") or (CounterX(9 downto 3)=79) or(CounterY(8 downto 3)=4) or (CounterY(8 downto 3)=59) else '0';
paddle <= '1' when (CounterX>(PaddlePosition+50)) and (CounterX<(PaddlePosition+150)) and (CounterY(8 DOWNTO 4)=27) else '0';
BouncingObject <= border or paddle;  --hit border
process(clk)
begin
	if clk'event and clk='1' then
		if(CounterY=500) and  (CounterX=0) THEN
			ResetCollision <='1' ;
		else ResetCollision <='0';
		end if;
		if(ResetCollision='1') THEN 
			
			CollisionX1<='0'; 
		elsif((BouncingObject='1') and (CounterX=ballX   ) and (CounterY=ballY+ 8)) THEN
			CollisionX1<='1';
		end if;
		if(ResetCollision='1') THEN 
			CollisionX2<='0'; 
		elsif((BouncingObject='1') and (CounterX=ballX+16) and (CounterY=ballY+ 8)) THEN 
			CollisionX2<='1';
		end if;
		if(ResetCollision='1') THEN 
			CollisionY1<='0'; 
		elsif((BouncingObject='1') and (CounterX=ballX+ 8) and(CounterY=ballY   )) THEN
			CollisionY1<='1';
		end if;
		if(ResetCollision='1')  THEN 
			CollisionY2<='0';
		elsif((BouncingObject='1') and (CounterX=ballX+ 8) and (CounterY=ballY+16)) THEN 
			CollisionY2<='1';
			if (ballY + 16 = 472) then
				gameover <= '1';
			else
				gameover <= '0';
			end if;
		end if;
	end if;
end process;
		

UpdateBallPosition<= ResetCollision;
process(clk)
begin
	if clk'event and clk='1' then
		if(UpdateBallPosition='1') THEN

			if(not((CollisionX1='1') and (CollisionX2='1')) )       THEN
			
			if(ball_dirX='1') THEN
				ballX <= ballX - 1;
				ELSE ballX <= ballX + 1;
			END IF;
				if((CollisionX2='1')) THEN ball_dirX <= '1';  
				elsif(CollisionX1='1') THEN 
				
				ball_dirX <= '0';
				end if;
				END IF;
			

			if(NOT(CollisionY1='1' AND CollisionY2='1'))   THEN    
				 IF(ball_dirY='1') THEN
					ballY <= ballY -1;
					ELSE ballY <= ballY +1;
					END IF;
				if(CollisionY2='1')   THEN    ball_dirY <= '1'; 
				elsif(CollisionY1='1') THEN 
					   ball_dirY <= '0';
				END IF;
			END IF;
		end IF;
	END IF;
END PROCESS;
R <= BouncingObject OR ball OR (CounterX(3) XOR CounterY(3)) when gameover = '0' else rgb1(2);
G <= BouncingObject OR ball when gameover = '0' else rgb1(1);
B <= BouncingObject OR ball when gameover = '0' else rgb1(0);
PROCESS(CLK)
BEGIN
if clk'event and clk='1' then
vga_R <= R AND inDisplayArea;
vga_G <= G AND inDisplayArea;
vga_B <= B AND inDisplayArea;
END IF;
END PROCESS;

romaddr <= CounterY(7 downto 0) & CounterX(7 downto 0);

rom : over
port map(
	address => romaddr,
	clock => clk,
	q => rgb1
);

END ONE;