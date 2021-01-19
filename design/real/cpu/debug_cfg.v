//log switch for debug

`define CPU_FETCH_LOG_OPT           1
`define CPU_DECODE_EXEC_LOG_OPT     1

`ifdef CPU_FETCH_LOG_OPT
    `define CPU_FETCH_LOG_1(A)                  $display(A)                
    `define CPU_FETCH_LOG_2(A,B)                $display(A,B)              
    `define CPU_FETCH_LOG_3(A,B,C)              $display(A,B,C)            
    `define CPU_FETCH_LOG_4(A,B,C,D)            $display(A,B,C,D)          
    `define CPU_FETCH_LOG_5(A,B,C,D,E)          $display(A,B,C,D,E)        
    `define CPU_FETCH_LOG_6(A,B,C,D,E,F)        $display(A,B,C,D,E,F)      
    `define CPU_FETCH_LOG_7(A,B,C,D,E,F,G)      $display(A,B,C,D,E,F,G)    
    `define CPU_FETCH_LOG_8(A,B,C,D,E,F,G,H)    $display(A,B,C,D,E,F,G,H)  
    `define CPU_FETCH_LOG_9(A,B,C,D,E,F,G,H,I)  $display(A,B,C,D,E,F,G,H,I)
`else
    `define CPU_FETCH_LOG_1(A)
    `define CPU_FETCH_LOG_2(A,B)
    `define CPU_FETCH_LOG_3(A,B,C)
    `define CPU_FETCH_LOG_4(A,B,C,D)
    `define CPU_FETCH_LOG_5(A,B,C,D,E)      
    `define CPU_FETCH_LOG_6(A,B,C,D,E,F)
    `define CPU_FETCH_LOG_7(A,B,C,D,E,F,G)
    `define CPU_FETCH_LOG_8(A,B,C,D,E,F,G,H)
    `define CPU_FETCH_LOG_9(A,B,C,D,E,F,G,H,I)    
`endif

`ifdef CPU_DECODE_EXEC_LOG_OPT
    `define CPU_DECODE_EXEC_LOG_1(A)                  $display(A)                
    `define CPU_DECODE_EXEC_LOG_2(A,B)                $display(A,B)              
    `define CPU_DECODE_EXEC_LOG_3(A,B,C)              $display(A,B,C)            
    `define CPU_DECODE_EXEC_LOG_4(A,B,C,D)            $display(A,B,C,D)          
    `define CPU_DECODE_EXEC_LOG_5(A,B,C,D,E)          $display(A,B,C,D,E)        
    `define CPU_DECODE_EXEC_LOG_6(A,B,C,D,E,F)        $display(A,B,C,D,E,F)      
    `define CPU_DECODE_EXEC_LOG_7(A,B,C,D,E,F,G)      $display(A,B,C,D,E,F,G)    
    `define CPU_DECODE_EXEC_LOG_8(A,B,C,D,E,F,G,H)    $display(A,B,C,D,E,F,G,H)  
    `define CPU_DECODE_EXEC_LOG_9(A,B,C,D,E,F,G,H,I)  $display(A,B,C,D,E,F,G,H,I)
`else
    `define CPU_DECODE_EXEC_LOG_1(A)
    `define CPU_DECODE_EXEC_LOG_2(A,B)
    `define CPU_DECODE_EXEC_LOG_3(A,B,C)
    `define CPU_DECODE_EXEC_LOG_4(A,B,C,D)
    `define CPU_DECODE_EXEC_LOG_5(A,B,C,D,E)      
    `define CPU_DECODE_EXEC_LOG_6(A,B,C,D,E,F)
    `define CPU_DECODE_EXEC_LOG_7(A,B,C,D,E,F,G)
    `define CPU_DECODE_EXEC_LOG_8(A,B,C,D,E,F,G,H)
    `define CPU_DECODE_EXEC_LOG_9(A,B,C,D,E,F,G,H,I)
`endif