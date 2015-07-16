configure:

	cd data && ./generate_data.py

clean:

	rm -f data/*~
	rm -f data/*.pyc
	rm -f data/data_*.csv
	rm -f data/distribution.csv
	rm -f data/rpt_for_test.txt
	rm -f data/features_list.txt

	rm -f xgboost/*~
	rm -f xgboost/*.pyc
	rm -f xgboost/*.csv
	rm -f xgboost/*.txt

	rm -f rfsrc/*~
	rm -f rfsrc/*.csv
	rm -f rfsrc/*.txt

	rm -f cox/*~
	rm -f cox/*.csv
	rm -f cox/*.txt

