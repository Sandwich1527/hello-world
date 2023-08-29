`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/29 17:32:53
// Design Name: 
// Module Name: dds_fir
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module dds_fir(
    input       Clk,
    input       Reset_n,
    output wire [7:0]Sin1,
    output wire [7:0]Sin2,
    output wire [15:0]P1,
    output reg [8:0]P2
    );
    reg [7:0]p2;
    

    dds1 dds1_inst (
        .aclk(Clk),                               // input wire aclk
        .m_axis_data_tvalid(m_axis_data_tvalid),  // output wire m_axis_data_tvalid
        .m_axis_data_tdata(Sin1)                  // output wire [7 : 0] m_axis_data_tdata
      );

    dds2 dds2_inst (
      .aclk(Clk),                               // input wire aclk
      .m_axis_data_tvalid(m_axis_data_tvalid),  // output wire m_axis_data_tvalid
      .m_axis_data_tdata(Sin2)                  // output wire [7 : 0] m_axis_data_tdata
    );

    always @(posedge Clk or negedge Reset_n) begin
       if(!Reset_n)
        P2 <= 8'b0 ;
        else if((!Sin1[7]&&!Sin2[7])||(Sin1[7]&&Sin2[7]))
        P2 <= Sin1 + Sin2;
        else begin
            p2 <= Sin1 + Sin2;
            if (p2[7]) begin
                P2 <= p2; 
                P2[8]<=1;
            end
            else
                P2 <= p2;
        end


    end

    mult_gen_0 mult_gen_0_inst (
        .CLK(Clk),     // input wire CLK
        .A(Sin1),      // input wire [7 : 0] A
        .B(Sin2),      // input wire [7 : 0] B
        .P(P1)          // output wire [15 : 0] P
    );





endmodule
