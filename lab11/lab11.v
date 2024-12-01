module counter(
    input clk,
    input rst_n,
    output clk_bps
);
reg[13:0]cnt_first,cnt_second;
always @(posedge clk,negedge rst_n) 
    if(!rst_n)
        cnt_first<=14'd0;
    else if (cnt_first==14'd10000) 
        cnt_first<=14'd0;
    else 
        cnt_first<=cnt_first+1'd1;


always @(posedge clk,negedge rst_n)
    if(!rst_n)
        cnt_second<=14'd0;
    else if(cnt_second==14'd10000)
        cnt_second<=14'd0;
    else if(cnt_first==14'd10000)
        cnt_second<=cnt_second+1'd1;
    else
        cnt_second<=cnt_second;

assign clk_bps=cnt_second==14'd10000;
endmodule

module breath_light(
    input clk,
    input rst_n,
    output light
);
counter ux(.clk(clk),.rst_n(rst_n),.light(clk_bps));

endmodule