param nAcres;
set Acres := 1..nAcres;
set Crops;
set Workers;

param plantingTime{Crops, Workers};
param buyprice{Crops};
param sellprice{Crops};
param harvestWeight{Crops};
param siloDistance{Acres};
param availablePlantingTime;
param transportationPrice;
param startcapital;
param support;

var planting{Acres, Crops, Workers} binary;
var capital integer;
var notplanted{Acres} binary;

s.t. OneAcreOneCropOneWorker{a in Acres}:
	sum{c in Crops, w in Workers} planting[a, c, w] <= 1;

s.t. PlantingTime:
	sum{a in Acres, c in Crops, w in Workers} planting[a, c, w] * plantingTime[c, w] <= availablePlantingTime;

s.t. PlantedOrNotPlanted{a in Acres}:
	notplanted[a] <= 1 - sum{c in Crops, w in Workers} planting[a, c ,w];

s.t. InitCapital:
	capital = startcapital + sum{a in Acres} notplanted[a] * support;  

s.t. CantBuyMoreThanWeHave:
	sum{a in Acres, c in Crops, w in Workers} buyprice[c] * planting[a, c, w] <= capital;

maximize Profit:
	sum{a in Acres, c in Crops, w in Workers} sellprice[c] * planting[a, c, w]
	-
	sum{a in Acres, c in Crops, w in Workers} buyprice[c] * planting[a, c, w]
	-
	(sum{a in Acres, c in Crops, w in Workers} siloDistance[a] * harvestWeight[c] * transportationPrice * planting[a, c, w])
	+
	(capital - sum{a in Acres, c in Crops, w in Workers} planting[a, c, w] * buyprice[c]);
	
solve;

printf"\n\nTotal Profit: %.1f $", Profit;
printf"\nTotal planting time: %d Days\n",sum{a in Acres, c in Crops, w in Workers} plantingTime[c, w] * planting[a, c, w];
printf"Planted acres: %d\n", (nAcres - sum{a in Acres} notplanted[a]);


for{a in Acres}{
	printf"\n%d acres:\n", a;
	for{c in Crops, w in Workers: planting[a, c, w] != 0}{
		printf"\t o Crop: %s\n\t o Worker: %s\n", c, w;
		printf"\t o Planting Time: %.1f\n", plantingTime[c, w];
		printf"\t o Buying Price: %d\n", buyprice[c];
		printf"\t o Selling Price: %d\n\t o Transportation Price: %d\n", sellprice[c], (transportationPrice * harvestWeight[c] * siloDistance[a]);
		printf"\t o Profit:%d\n", (sellprice[c] - (transportationPrice * harvestWeight[c] * siloDistance[a] + buyprice[c]));
	}
}

data;

param nAcres := 19;

set Crops := Wheat Corn Strawberry Sunflower Eggplant;
set Workers := Miki Dani Peti Niki;

param plantingTime : Miki Dani Peti Niki :=
Wheat	3	2.5	4	3.5
Corn	4.5	2	3	5
Strawberry	5	6	4	4.5
Sunflower	4	5	4	6
Eggplant	5.5	7	4.5	6
;

param buyprice :=
Wheat	100
Corn	155
Strawberry	210
Sunflower	175
Eggplant	215
;

param sellprice :=
Wheat	400
Corn	500
Strawberry	650
Sunflower	575
Eggplant	700
;

param harvestWeight :=
Wheat	100
Corn	110
Strawberry	75
Sunflower	85
Eggplant	80
;

param siloDistance :=
1	2
2	1
3	1
4	2
5	3
6	2
7	1
8	2
9	3
10	4
11	3
12	2
13	3
14	4
15	5
16	4
17	3
18	4
19	5
;

param startcapital := 2000;
param availablePlantingTime := 40;
param transportationPrice := 0.15;
param support := 70;
