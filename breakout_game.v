module breakout_game
(
	input clk,reset_n,
	input video_on,
	input [1:0] key,
	input [11:0] pixel_x,pixel_y,
	output reg [2:0] rgb
);
localparam WALL_1_XL=100, //wall 1
					WALL_1_XR=105,					
					WALL_2_XL=110, //wall 2
					WALL_2_XR=115, 
					WALL_3_XL=120, //wall 3
					WALL_3_XR=125, 
					WALL_4_XL=130, //wall 4
					WALL_4_XR=135, 
					WALL_5_XL=140, //wall 5
					WALL_5_XR=145, 
					
					BRICK_SPACE=3,
					
					BAR_XL=550, //left
					BAR_XR=555, //right
					BAR_LENGTH=80, //bar length
					BAR_V=4, //bar velocity
					BALL_DIAM=7, //ball diameter-1
					BALL_V=7; //ball velocity


wire wall_1_on,wall_2_on,wall_3_on,
wall_4_on,wall_5_on,bar_on,ball_box;
reg ball_on;
reg [2:0] rom_addr;
reg [7:0] rom_data;
reg [9:0] bar_top_reg=220,bar_top_next;
reg [9:0] ball_x_reg=280,ball_x_next;
reg [9:0] ball_y_reg=200,ball_y_next;
reg ball_x_delta_reg, ball_x_delta_next;
reg ball_y_delta_reg, ball_y_delta_next;
reg hold_reg,hold_next;
reg [4:0] wall_reg,wall_next;
//display conditions
assign wall_1_on= WALL_1_XL<=pixel_x && pixel_x<=WALL_1_XR && !( (120<=pixel_y && pixel_y<=125) || (240<=pixel_y && pixel_y<=245) || (360<=pixel_y && pixel_y<=365)); 
assign wall_2_on= WALL_2_XL<=pixel_x && pixel_x<=WALL_2_XR && !( (60<=pixel_y && pixel_y<=65) || (180<=pixel_y && pixel_y<=185) || (300<=pixel_y && pixel_y<=305) || (420<=pixel_y && pixel_y<=425));
assign wall_3_on= WALL_3_XL<=pixel_x && pixel_x<=WALL_3_XR && !( (120<=pixel_y && pixel_y<=125) || (240<=pixel_y && pixel_y<=245) || (360<=pixel_y && pixel_y<=365)); 
assign wall_4_on= WALL_4_XL<=pixel_x && pixel_x<=WALL_4_XR && !( (60<=pixel_y && pixel_y<=65) || (180<=pixel_y && pixel_y<=185) || (300<=pixel_y && pixel_y<=305) || (420<=pixel_y && pixel_y<=425));
assign wall_5_on= WALL_5_XL<=pixel_x && pixel_x<=WALL_5_XR && !( (120<=pixel_y && pixel_y<=125) || (240<=pixel_y && pixel_y<=245) || (360<=pixel_y && pixel_y<=365)); 

assign bar_on = pixel_x >= BAR_XL && pixel_x<=BAR_XR && pixel_y>=bar_top_reg && pixel_y <= (bar_top_reg + BAR_LENGTH);
assign ball_box = pixel_x >= ball_x_reg && pixel_x<= ball_x_reg + BALL_DIAM &&
pixel_y >= ball_y_reg && pixel_y <= ball_y_reg + BALL_DIAM;
//ball rom pattern
always @*
begin
	rom_addr=0;
	ball_on=0;
	if(ball_box)
	begin
		rom_addr = pixel_y - ball_y_reg;
		if(rom_data[pixel_x-ball_y_reg]) ball_on=1;
	end
end

always @* begin
	case(rom_addr)
		3'd0: rom_data=8'b0001_1000;
		3'd1: rom_data=8'b0011_1100;
		3'd2: rom_data=8'b0111_1110;
		3'd3: rom_data=8'b1111_1111;
		3'd4: rom_data=8'b1111_1111;
		3'd5: rom_data=8'b0111_1110;
		3'd6: rom_data=8'b0011_1100;
		3'd7: rom_data=8'b0001_1000;
	 endcase
end

//logic for moving bar and self-bouncing ball
always @(posedge clk or negedge reset_n)
begin
	if(!reset_n)
	begin
		bar_top_reg <= 220;
		ball_x_reg <= 280;
		ball_y_reg <= 280;
		ball_x_delta_reg <= 0;
		ball_y_delta_reg <= 0;
		wall_reg <= 5'b11111;
		hold_reg <= 0;
	end
	else
	begin
		bar_top_reg <= bar_top_next;
		ball_x_reg <= ball_x_next;
		ball_y_reg <= ball_y_next;
		ball_x_delta_reg <= ball_x_delta_next;
		ball_y_delta_reg <= ball_y_delta_next;	
		wall_reg <= wall_next;
		hold_reg <= hold_next;
	end
end
always @*
begin
	bar_top_next = bar_top_reg;
	ball_x_next = ball_x_reg;
	ball_y_next = ball_y_reg;
	ball_x_delta_next = ball_x_delta_reg;
	ball_y_delta_next = ball_y_delta_reg;
	wall_next = wall_reg;
	hold_next = hold_reg;

	if(pixel_y == 500 && pixel_x==0) //every frame
	begin
		if(key[0] && bar_top_reg > BAR_V) bar_top_next = bar_top_reg - BAR_V;
		else if(key[1] && bar_top_reg <(480-BAR_LENGTH)) bar_top_next = bar_top_reg + BAR_V;

		//bouncing ball logic
		if(ball_x_reg <= WALL_5_XR)
		begin
			if(!hold_reg && ball_x_delta_reg == 0)
			begin
				case(wall_reg)
					5'b11111:
						if(ball_x_reg <= WALL_5_XR)
						begin
							ball_x_delta_next = 1;

							wall_next = wall_reg << 1;
							hold_next = 1;
						end
					5'b11110:
						if(ball_x_reg <= WALL_4_XR)
						begin
							ball_x_delta_next = 1;

							wall_next = wall_reg << 1;
							hold_next = 1;
						end
					5'b11100:
						if(ball_x_reg <= WALL_3_XR)
						begin
							ball_x_delta_next = 1;

							wall_next = wall_reg << 1;
							hold_next = 1;
						end
					5'b11000:
						if(ball_x_reg <= WALL_2_XR)
						begin
							ball_x_delta_next = 1;

							wall_next = wall_reg << 1;
							hold_next = 1;
						end
					5'b10000:
						if(ball_x_reg <= WALL_1_XR)
						begin
							ball_x_delta_next = 1;
							wall_next = wall_reg << 1;
							hold_next = 1;
						end				
				endcase
			end
		end
		else
			hold_next = 0;

		if(ball_x_reg <= BAR_XR && ball_x_reg >= BAR_XL && 
		ball_y_reg+BALL_DIAM >= bar_top_reg && ball_y_reg <= bar_top_reg+BAR_LENGTH)
			ball_x_delta_next = ~ball_x_delta_reg;
		else if(ball_x_reg <=5) ball_x_delta_next = ~ball_x_delta_reg;
		else if(ball_x_reg + BALL_DIAM >= 640) ball_x_delta_next = ~ball_x_delta_reg;
			
		if(ball_y_reg <=5) ball_y_delta_next = ~ball_y_delta_reg;
		else if(ball_y_reg + BALL_DIAM >= 480) ball_y_delta_next = ~ball_y_delta_reg;
		
		ball_x_next = (ball_x_delta_next)? ball_x_reg + BALL_V : ball_x_reg - BALL_V;
		ball_y_next = (ball_y_delta_next)? ball_y_reg + BALL_V: ball_y_reg - BALL_V ;
	end
end
//overall display logic
always @(*)
begin
	rgb=0;
	if(video_on)
	begin
		if(wall_1_on && wall_reg[4]) rgb = 3'b111;
		else if(wall_2_on && wall_reg[3]) rgb = 3'b001;
		else if(wall_3_on && wall_reg[2]) rgb = 3'b010;
		else if(wall_4_on && wall_reg[1]) rgb = 3'b011;
		else if(wall_5_on && wall_reg[0]) rgb = 3'b100;

		else if(bar_on) rgb = 3'b010;
		else if(ball_on) rgb=3'b100;
		else 
			rgb=3'b110;
	end
end
endmodule
