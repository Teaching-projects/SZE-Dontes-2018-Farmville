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
param money;
param M := 100;

var planting{Acres, Crops, Workers} binary;

s.t. OneAcreOneCropOneWorker{a in Acres}:
	sum{c in Crops, w in Workers} planting [a, c, w] <= 1;

s.t. PlantingTime:
	sum{a in Acres, c in Crops, w in Workers} planting[a, c, w] * plantingTime[c, w] <= availablePlantingTime;

s.t. CantBuyMoreThanWeHave:
	sum{a in Acres, c in Crops, w in Workers} buyprice[c] * planting[a, c, w] <= money;

maximize Profit:
	sum{a in Acres, c in Crops, w in Workers} sellprice[c] * planting[a, c, w]
	-
	sum{a in Acres, c in Crops, w in Workers} buyprice[c] * planting[a, c, w]
	-
	(sum{a in Acres, c in Crops, w in Workers} siloDistance[a] * harvestWeight[c] * transportationPrice * planting[a, c, w]);

solve;

for{a in Acres}{
	printf"%d acres:\n", a;
	for{c in Crops, w in Workers: planting[a, c, w] != 0}{
		printf"\t o Crop: %s\n\t o Worker: %s\n", c, w;
		printf"\t o Planting Time: %.1f\n", plantingTime[c, w];
		printf"\t o Buying Price: %d\n", buyprice[c];
		printf"\t o Selling Price: %d\n\t o Transportation Price: %d\n", sellprice[c], (transportationPrice * harvestWeight[c] * siloDistance[a]);
		printf"\t o Profit:%d\n", (sellprice[c] - (transportationPrice * harvestWeight[c] * siloDistance[a] + buyprice[c]));
	}
}

	printf"Total planting time: %d Days\n",sum{a in Acres, c in Crops, w in Workers} plantingTime[c, w] * planting[a, c, w];


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
Corn	125
Strawberry	200
Sunflower	175
Eggplant	215
;

param sellprice :=
Wheat	200
Corn	300
Strawberry	450
Sunflower	375
Eggplant	500
;

param harvestWeight :=
Wheat	100
Corn	110
Strawberry	55
Sunflower	65
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

param money := 2000;
param availablePlantingTime := 40;
param transportationPrice := 0.15;
