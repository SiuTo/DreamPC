# Dream2015
Prostate Cancer DREAM Challenge

## Dependences
* [xgboost](https://github.com/dmlc/xgboost)
* R packages
  * [timeROC](http://cran.r-project.org/web/packages/timeROC/index.html)
  * [randomForestSRC](http://cran.r-project.org/web/packages/randomForestSRC/index.html)
  * [survival](https://cran.r-project.org/web/packages/survival/index.html)
  * [glmnet](https://cran.r-project.org/web/packages/glmnet/index.html)
  * [gbm](https://cran.r-project.org/web/packages/gbm/index.html)
  * [yaImpute](https://cran.r-project.org/web/packages/yaImpute/index.html)

## Documentation

### Data Generation
* 对训练集和测试集的每个feature的缺失情况和值的分布进行简单统计，并记录在表distribution.csv和table.csv
* 根据各自的分布对feature DISCONT，AGEGRP2, RACE_C, HGTBLCAT, WGTBLCAT, REGION_C进行重编码
* 对为连续值的features进行normalization, 使之均值为0，标准差为1
* 去掉无意义和在训练集或测试集缺失较多(>1000)的features，手工选出features/advance.txt中的80个特征
* 对于缺失较少(<100)的features，将对应的samples去掉；缺失较多的特征则用random forest或KNN进行填补
* 用lasso+cox从80个features中选出21个较相关的features，记录于features/lasso.txt

### Cross Validation
* 先对samples的顺序打乱，然后将训练集分成10份，每一份都作为测试集、其余作为训练集，测试10次

### Evaluation
* 采用官方提供的脚本进行评测
* 1a采用iAUC，1b采用RMSE，第二问采用P-R curve的AUC

### Training & Prediction

#### cox/lasso+cox (survival/glmnet)
* 先对训练集做10交叉选出合适的正则化参数lambda，再用选出的lambda选features或进行训练

#### random forest (rfsrc)
* 可以在训练/预测的时候利用random forest进行补全，而不需要预先补全
* 为离散的features选择R中的数据类型factors，其余设为实数或整数类型

#### boost (xgboost)
* 由于不能直接处理右缺失的情况，所以只是简单的丢弃指示变量DEATH直接预测时间
* 对于1a，效果不如其他模型；对于1b，效果最好。

## Usage
* Data generation:
```
cd data
cp features/file_name.txt features_list.txt
./generate.py
```

* Data imputation(random forest)
```
cd rfsrc
./impute.R
```

* Feature selection(lasso)
```
cd glm
./lasso.R
```

* Cross validation:
```
./cross_validate.R question_index model_name
```

* Submission:
```
./final.R question_index model_name
./merge_submission.py question_index model_name
```

* Clean:
```
make clean
```

