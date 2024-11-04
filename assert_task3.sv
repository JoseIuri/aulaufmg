module tb();
  
logic clk;
logic cStart;
logic req,gnt;
  
 
  property pr1;
  	@ (posedge clk) cStart |-> req ##3 gnt;
  endproperty
  
  
  // create clock
  initial
  begin
    clk = 0;
    forever
      #1 clk <= ~clk;
  end
  
  // instantiate DUT
  req_ack 
  dut
  (
    // inputs
      .clk(clk),
      .req(req),
    
    // outputs
      .gnt(gnt)
  );
 
  // Main test
  initial
  begin
  
    req 	= 1'b1;
    cStart 	= 1'b1;
    
    assert property (pr1) $display(" DUT sequence OK"); else
      $display("BAD sequence");
    
    #20 $finish;
  
  end
 endmodule

module req_ack
(
    
    clk,
    req,
    gnt
  
);
  
  input clk;
  input req;
  output gnt;
  
  logic gnt;
  logic tmp1,tmp2;
  
  always @(posedge clk)
  begin
  		   tmp1 <= req;
    	   tmp2 <= tmp1;
    	   gnt  <= tmp2;
  end
  
endmodule
