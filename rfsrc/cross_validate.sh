#! /bin/bash

rm -f result.txt
for ((i=0; i<3; ++i)) do
	cp "data_train_$i.csv" "data_train.csv"
	cp "data_test_$i.csv" "data_test.csv"
	cp "real_value_$i.csv" "real_value.csv"
	./cross_validate.R
	mv "pred_1a.txt" "pred_1a_$i.txt"
	mv "pred_1b.txt" "pred_1b_$i.txt"
done

