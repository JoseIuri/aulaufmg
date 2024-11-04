parameter NBITS = 8;

 module top;        
        logic clock, reset;
        logic [NBITS-1:0] A,B;
        logic [NBITS+NBITS-1:0]result;
        logic iReady, iValid, oReady, oValid;
        
        enum logic {S1, S2} state;
        
        initial begin
            clock = 0;
            reset = 1;
            #20 reset = 0;
        end
        
        always #5 clock = !clock;
        
        peasant #(NBITS) mult(.*);
        
        always_ff @(posedge clock)begin
            if(reset)begin
                iValid <= 0;
                oReady <= 0;
                state <= S1;
            end
            else case(state)
                S1: begin
                    A = 8'd12;
                    B = 8'd11;
                    iValid <= 1;
                    oReady <= 1;    
                    if(iReady)
                        state <= S2;   
                end
                
                S2: begin
                    if(oValid)begin
                        $display(A,B,result);
                        $finish();
                    end
                end
            endcase
        end
 endmodule

module peasant #(parameter NBITS = 20)
                (input logic [NBITS-1:0] A,B,
                 input logic clock, reset, oReady, iValid,
                 output logic iReady, oValid,
                 output logic [NBITS+NBITS-1:0]result);
    
    enum logic [1:0] {INIT, CALC, SEND} state; 
    logic [NBITS+NBITS-1:0] A_aux, B_aux;
                           
    always_ff @(posedge clock)begin
        if(reset)begin
            A_aux <= '0;
            B_aux <= '0;
            result <= '0;
            state <= INIT;
            iReady <= 0;
            oValid <= 0;
        end
         
        else begin
            case(state)
                INIT: begin
                        iReady <= 1;
                        oValid <= 0;
                        A_aux <= A;
                        B_aux <= B;
                        state <= CALC;        
                end
                
                CALC: begin
                    if(A_aux >= 1)begin
                        A_aux <= (A_aux >>> 1);
                        B_aux <= (B_aux <<< 1);
                        result <= result + (A_aux[0] ? B_aux : 0);
                    end  
                    else begin
                        state <= SEND;
                        oValid <= 1;
                    end
                end
                
                SEND: begin
                    if(oReady)begin
                        oValid <= 0;
                        state <= INIT;
                    end
                    else state <= SEND;
                end
            endcase
        end
    end                         
endmodule
