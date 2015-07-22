# Dream2015
Prostate Cancer DREAM Challenge

## Dependences
* [xgboost](https://github.com/dmlc/xgboost)
* R packages
  * [timeROC](http://cran.r-project.org/web/packages/timeROC/index.html)
  * [randomForestSRC](http://cran.r-project.org/web/packages/randomForestSRC/index.html)
  * [survival](https://cran.r-project.org/web/packages/survival/index.html)
  * [glmnet](https://cran.r-project.org/web/packages/glmnet/index.html)


## Usage
* Data generation:
```
cd data
cp features/file_name.txt features_list.txt
./generate.py
```

* Cross validation:
```
./cross_validate.R question_index model_name
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

