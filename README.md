# Dream2015
Prostate Cancer DREAM Challenge

## Dependences
* [xgboost](https://github.com/dmlc/xgboost)
* [timeROC](http://cran.r-project.org/web/packages/timeROC/index.html)
* [randomForestSRC](http://cran.r-project.org/web/packages/randomForestSRC/index.html)

## Usage
* Data generation:
```
cd data
cp features/file_name.txt features_list.txt
./generate.py
```

* Cross valication:
```
./cross_validate.R model_name
```

* Submission:
```
./final.R model_name
./merge_submission.py model_name
```

* Clean:
```
make clean
```

