function [vio2,vio,alllb,alleng,comptime,tw,tfog,time,round,tkh,ttkh1,works,fog,iter,npop,runtime,allcost,allVio] = InitializeParameters()

round = 2;
tkh = 5;
tfog = 20;
time = 10;
tw = 400;
ttkh1 = [200, 300, 400, 500, 600];
works = zeros(tw, 15);
fog = zeros(tfog, 7);
npop = 50;
alleng = zeros(5, tkh);
allcost = zeros(5, tkh);
alllb = zeros(5, tkh);
runtime = zeros(5, tkh);
allVio = zeros(5, tkh);
iter = zeros(1, tkh);
comptime = zeros(5, tkh);
vio = zeros(5, tkh);
vio2 = zeros(5, time, tkh);

end
