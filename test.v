module stimulus;
    reg clk;
    reg [5:0] money;
    reg [2:0] drink_choose;
    reg cancel;
    wire [5:0] change;
    wire [3:0] drink_out;

vending_machine vm (
        .clk(clk),
        .money(money),
        .drink_choose(drink_choose),
        .cancel(cancel),
        .change(change),
        .drink_out(drink_out)
  );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        money = 0;
        drink_choose = 0;
        cancel = 0;
        #10 money = 1;
        #10 money = 5;
        #10 cancel = 1; 
        #10 cancel = 0;
        #10 money = 10; 
        #10 money = 5;
        #10 money = 0;
        #10 drink_choose = 3'b001;
        #10 drink_choose = 0;
        #10 drink_choose = 3'b111;
        #10 drink_choose = 0;
        #10 drink_choose = 3'b010;
        #10 drink_choose = 0;

        #10 money = 0;

        #10 money = 50;
        #10 drink_choose = 3'b100; 
        #10 drink_choose = 0;

        #10 money = 25;
        #10 drink_choose = 3'b001;
        #10 drink_choose = 3'b010;
        #10 drink_choose = 0;

        #10 money = 10;
        #10 drink_choose = 3'b001;
        #10 cancel = 1;
        #10 cancel = 0;

        #50 $stop;
    end
endmodule
