module control (
  input  logic clk, nrst, conv_finish, pooling_finish, [9:0]op_code_i,
  output logic pu_en, weight_en
);


  enum logic [3:0]{ idle  = 4'b0000,
                  buffer  = 4'b0001,
                  conv    = 4'b0010,
		   pooling = 4'b0100,
	            FC      = 4'b1000,
		    OUT     = 4'b1001} next_state,current_state;
				  
  logic [3:0] next_count,current_count;
				  
  always_ff @(posedge clk or negedge nrst) 
	begin
	    if(!nrst) 
                  begin  
                   current_state <= idle;
                  end
	    else
    		begin
      		   current_state <= next_state;
     	           current_count <= next_count;
    		end 
	 end				  
				
	always_comb
	begin
    next_state = current_state;
	  next_count = current_count;
		unique case(current_state) 
			idle: unique case(op_code_i[9:7])
			        3'b000:next_state = current_state; 
           			3'b010:next_state = conv;
              			3'b011:next_state = pooling;
              			3'b100:next_state = FC;
              			3'b101:next_state =buffer;	
		endcase
			buffer:
      			   begin
       				  pu_en = 0;
        			  weight_en = 1;
			        	if(next_count<op_code_i[4:0])
				           begin
			               next_count = current_count + 1;
			               next_state = buffer;
				        end
			        	else 
				            begin 
				               pu_en = 1;
            	    	   weight_en = 0;
           		         next_count = 0;	
            			     next_state = idle;				  
			              end        
      			   end     

			conv: unique case(op_code_i[6])
			        1'b1:next_state = pooling;
				1'b0:next_state = OUT;
			      endcase  

      			pooling: if(conv_finish==1)
               			begin 
			          unique case(op_code_i[5])
			            1'b1:next_state = FC;
				    1'b0:next_state = OUT;
			          endcase  
               			end

			FC: if(pooling_finish) 
			    begin 
            		        next_state = OUT;
         		    end 
			OUT:
      			begin 
        		        next_state = idle;
      			end    		  
		  endcase
	end			  

endmodule
