// Testbench
module test;

  reg        clk_write;
  reg  [4:0] address_write;
  reg  [7:0] data_write;
  reg        write_enable;
  reg        clk_read;
  reg  [4:0] address_read;
  wire [7:0] data_read;
  
  // Instantiate design under test
  // D_WIDTH = 8
  // A_WIDTH = 5
  // A_MAX = 2^A_WIDTH = 32
  ram #(8, 5, 32) RAM (
    .clk_write(clk_write),
    .address_write(address_write),
    .data_write(data_write),
    .write_enable(write_enable),
    .clk_read(clk_read),
    .address_read(address_read),
    .data_read(data_read));
    
  initial begin
    
    clk_write = 0;
    clk_read = 0;
    write_enable = 0;
    address_read = 5'h1B;
    address_write = address_read;

    $display("Read initial data.");
    toggle_clk_read;
    $display("data[%0h]: %0h",
      address_read, data_read);
    
    $display("Write new data.");
    write_enable = 1;
    data_write = 8'hC5;
    toggle_clk_write;
    write_enable = 0;
    
    $display("Read new data.");
    toggle_clk_read;
    $display("data[%0h]: %0h",
      address_read, data_read);
  end
  
  task toggle_clk_write;
    begin
      #10 clk_write = ~clk_write;
      #10 clk_write = ~clk_write;
    end
  endtask

  task toggle_clk_read;
    begin
      #10 clk_read = ~clk_read;
      #10 clk_read = ~clk_read;
    end
  endtask

endmodule

/* 
 * Random Access Memory (RAM) with
 * 1 read port and 1 write port
 */
module ram (clk_write, address_write,
  data_write, write_enable,
  clk_read, address_read, data_read);
  
  parameter D_WIDTH = 16;
  parameter A_WIDTH = 4;
  parameter A_MAX = 16; // 2^A_WIDTH

  // Write port
  input                clk_write;
  input  [A_WIDTH-1:0] address_write;
  input  [D_WIDTH-1:0] data_write;
  input                write_enable;

  // Read port
  input                clk_read;
  input  [A_WIDTH-1:0] address_read;
  output [D_WIDTH-1:0] data_read;
  
  reg    [D_WIDTH-1:0] data_read;
  
  // Memory as multi-dimensional array
  reg [D_WIDTH-1:0] memory [A_MAX-1:0];

  // Write data to memory
  always @(posedge clk_write) begin
    if (write_enable) begin
      memory[address_write] <= data_write;
    end
  end

  // Read data from memory
  always @(posedge clk_read) begin
    data_read <= memory[address_read];
  end

endmodule
