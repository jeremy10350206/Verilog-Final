module vending_machine (
    input clk,
    input [5:0] money,
    input [2:0] drink_choose,
    input cancel,
    output reg [5:0] change,
    output reg [3:0] drink_out
);

    parameter S0 = 2'b00,
              S1 = 2'b01,
              S2 = 2'b10,
              S3 = 2'b11;

    reg [1:0] current_state, next_state;

    parameter TEA = 6'd10,
              COKE = 6'd15,
              COFFEE = 6'd20,
              MILK = 6'd25;

    reg [5:0] total_money;

    initial begin
        total_money = 6'd0;
    end

    always @(posedge clk or posedge cancel) begin
        if (cancel) begin
            if (current_state == S1 || current_state == S0) begin
                change <= total_money;
                $display("Transaction cancelled. Returning money: %d. Resetting state.", change);
                total_money <= 6'd0;
                current_state <= S0;
            end
        end else begin
            current_state <= next_state;
        end
    end

    always @(current_state or money or drink_choose) begin
        next_state = current_state;
        change = 6'd0;
        drink_out = 4'b0000;

        case (current_state)
            S0: begin
                if (money > 0) begin
                    total_money = total_money + money;
                    $display("Money inserted: %d. Total money: %d", money, total_money);
                    $display("Available drinks:");
                    if (total_money >= TEA) $display("Tea");
                    if (total_money >= COKE) $display("Coke");
                    if (total_money >= COFFEE) $display("Coffee");
                    if (total_money >= MILK) $display("Milk");
                    if (total_money < TEA) $display("None");
                    if (total_money >= TEA) next_state = S1;
                end
            end

            S1: begin
                if (drink_choose > 0 && drink_out == 4'b0000) begin
                    case (drink_choose)
                        3'b001: if (total_money >= TEA) begin
                            next_state = S2;
                            total_money = total_money - TEA;
                            drink_out = 4'b0001;
                            $display("Tea selected. Remaining money: %d", total_money);
                        end
                        3'b010: if (total_money >= COKE) begin
                            next_state = S2;
                            total_money = total_money - COKE;
                            drink_out = 4'b0010;
                            $display("Coke selected. Remaining money: %d", total_money);
                        end
                        3'b011: if (total_money >= COFFEE) begin
                            next_state = S2;
                            total_money = total_money - COFFEE;
                            drink_out = 4'b0100;
                            $display("Coffee selected. Remaining money: %d", total_money);
                        end
                        3'b100: if (total_money >= MILK) begin
                            next_state = S2;
                            total_money = total_money - MILK;
                            drink_out = 4'b1000;
                            $display("Milk selected. Remaining money: %d", total_money);
                        end
                        default: begin
                            $display("Invalid drink selection.");
                            next_state = S1;
                        end
                    endcase
                end
            end

            S2: begin
                $display("Drink dispensed. Transitioning to change state.");
                next_state = S3;
            end

            S3: begin
                change = total_money;
                $display("Returning change: %d. Resetting to initial state.", change);
                total_money = 6'd0;
                next_state = S0;
            end

            default: next_state = S0;
        endcase
    end

endmodule