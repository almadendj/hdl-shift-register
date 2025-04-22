// without shift enable
module ShiftRegister(
  input wire clk, 
  input wire reset,
  input wire direction, // 0 for right, 1 for left
  input wire in,
  output wire [3:0] out
);

  reg [3:0] register;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      register <= 4'b0000;
    end
    else begin
      // left shift
      if (direction) begin
        register <= {register[2:0], in};
      end
      else begin
        register <= {in, register[3:1]};
      end
    end
  end

  assign out = register;

endmodule

module ShiftRegisterTB;
  reg clk, reset, direction, in;
  wire [3:0] out;

  ShiftRegister sr(
    .clk(clk),
    .reset(reset),
    .direction(direction),
    .in(in),
    .out(out)
  );

  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    $dumpfile("ShiftRegister.vcd");
    $dumpvars;

    reset = 1;
    direction = 0;
    in = 0;
    #15;
    reset = 0;

    // test 1010, right shift
    direction = 0;
    
    in = 1; #10;
    in = 0; #10;
    in = 1; #10;
    in = 0; #10;

    // test 0101, left shift
    direction = 1;
    
    in = 0; #10;
    in = 1; #10;
    in = 0; #10;
    in = 1; #10;
    $finish;
  end

endmodule
