configure:

	cd data && ./generate_data.py

clean:

	rm -f data/*~
	rm -f data/*.pyc
	rm -f data/data_*.csv
	rm -f data/distribution_*.csv
	rm -f data/rpt_for_test.txt

	rm -f xgboost/*~
	rm -f xgboost/*.pyc
	rm -f xgboost/*.csv
	rm -f xgboost/*.txt

	rm -f rfsrc/*~
	rm -f rfsrc/*.pyc
	rm -f rfsrc/*.csv

