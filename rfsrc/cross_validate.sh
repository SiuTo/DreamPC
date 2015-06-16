#! /bin/bash

for ((i=0; i<1; ++i)) do
	cp "data_train_$i.csv" "data_train.csv"
	cp "data_test_$i.csv" "data_test.csv"
	cp "real_value_$i.csv" "real_value.csv"
	./cross_validate.R
	mv "data_pred_1a.txt" "data_pred_1a_$i.txt"
	mv "data_pred_1b.txt" "data_pred_1b_$i.txt"
done

