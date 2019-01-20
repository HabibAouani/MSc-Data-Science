package com.sparkProject

import org.apache.spark.SparkConf
import org.apache.spark.ml.classification.{BinaryLogisticRegressionSummary, LogisticRegression, RandomForestClassifier}
import org.apache.spark.ml.evaluation.{MulticlassClassificationEvaluator, RegressionEvaluator}
import org.apache.spark.ml.feature._
import org.apache.spark.sql.{Row, SparkSession}
import org.apache.spark.ml.feature.StringIndexer
import org.apache.spark.ml.tuning.{CrossValidator, ParamGridBuilder, TrainValidationSplit}
import org.apache.spark.ml.{Pipeline, PipelineModel}
import org.apache.spark.ml.classification

object Trainer {

  def main(args: Array[String]): Unit = {

    val conf = new SparkConf().setAll(Map(
      "spark.scheduler.mode" -> "FIFO",
      "spark.speculation" -> "false",
      "spark.reducer.maxSizeInFlight" -> "48m",
      "spark.serializer" -> "org.apache.spark.serializer.KryoSerializer",
      "spark.kryoserializer.buffer.max" -> "1g",
      "spark.shuffle.file.buffer" -> "32k",
      "spark.default.parallelism" -> "12",
      "spark.sql.shuffle.partitions" -> "12",
      "spark.driver.maxResultSize" -> "2g"
    ))

    val spark = SparkSession
      .builder
      .config(conf)
      .appName("TP_spark")
      .getOrCreate()


    /*******************************************************************************
      *
      *       TP 3
      *
      *       - lire le fichier sauvegarder précédemment
      *       - construire les Stages du pipeline, puis les assembler
      *       - trouver les meilleurs hyperparamètres pour l'entraînement du pipeline avec une grid-search
      *       - Sauvegarder le pipeline entraîné
      *
      *       if problems with unimported modules => sbt plugins update
      *
      ********************************************************************************/

    import spark.sqlContext.implicits._

    /*******************************************************************************
      *
      *       TP 2
      *
      *       - Charger un fichier csv dans un dataFrame
      *       - Pre-processing: cleaning, filters, feature engineering => filter, select, drop, na.fill, join, udf, distinct, count, describe, collect
      *       - Sauver le dataframe au format parquet
      *
      *       if problems with unimported modules => sbt plugins update
      *
      ********************************************************************************/

    // 1 : Chargement du dataset

    //Les fichiers Parquet ont été importés comme un dossier
    val data = spark.sqlContext.read.parquet("prepared_trainingset")

    // 2 : Utilisation des données textuelles avec TF-IDF
    // 2.a

    //Tokenizer
    val tokenizer = new RegexTokenizer()
      .setPattern("\\W+")
      .setGaps(true)
      .setInputCol("text")
      .setOutputCol("words")

    // 2.b
    //Enlever les StopSords
    val remover = new StopWordsRemover()
      .setInputCol("words")
      .setOutputCol("filtered")

    // 2.c
    //Partie TF avec un CountVectorizer
    val tf = new CountVectorizer()
      .setInputCol("filtered")
      .setOutputCol("vector_filter")


    // 2.d
    //Partie IDF
    val idf = new IDF()
      .setInputCol("vector_filter")
      .setOutputCol("tfidf")

    // 3
    // 3.e
    //Créer des index pour les pays et gérer une exception avec un pays
    val indexer_country = new StringIndexer()
      .setInputCol("country2")
      .setOutputCol("country_indexed")
      .setHandleInvalid("skip")

    // 3.f
    //Créer des index pour les devises
    val indexer_currency = new StringIndexer()
      .setInputCol("currency2")
      .setOutputCol("currency_indexed")

    // 3.g
    //Créer un OneHotEncoder sur la base des pays et des devises
    val encoder = new OneHotEncoderEstimator()
      .setInputCols(Array("country_indexed", "currency_indexed"))
      .setOutputCols(Array("country_onehot", "currency_onehot"))

    // 4
    // 4.h
    //Assembler les features dans une colonne
    val assembler = new VectorAssembler()
      .setInputCols(Array("tfidf", "days_campaign", "hours_prepa", "goal", "country_onehot", "currency_onehot"))
      .setOutputCol("features")

    // 4.i
    //Regression logistique
    val lr = new LogisticRegression()
      .setFitIntercept(true)
      .setFeaturesCol("features")
      .setLabelCol("final_status")
      .setStandardization(true)
      .setPredictionCol("prediction")
      .setRawPredictionCol("raw_predictions")

    // 4.j
    //Créer une pipeline avec les différentes étapes
    val pipeline = new Pipeline()
      .setStages(Array(tokenizer, remover, tf, idf, indexer_country, indexer_currency, encoder, assembler, lr))

    // 5. Model training
    //Random split entre Train et Test
    val Array(training, test) = data.randomSplit(Array(0.9, 0.1), seed = 12345)
    //val model = pipeline.fit(training)

    // 5.l
    //Grille de paramètres
    val paramGrid = new ParamGridBuilder()
      .addGrid(lr.regParam, Array(0.000000001, 0.0000001, 0.00001, 0.001))
      .addGrid(lr.threshold, Array(0.7, 0.3))
      .addGrid(tf.minDF, Array(55.0, 75.0, 95.0))
      .build()

    //Evaluator F1 Score
    val evaluator = new MulticlassClassificationEvaluator()
      .setLabelCol("final_status")
      .setPredictionCol("prediction")
      .setMetricName("f1")

    //Entrainer le modèle
    val trainValidationSplit = new TrainValidationSplit()
      .setEstimator(pipeline)
      .setEvaluator(evaluator)
      .setEstimatorParamMaps(paramGrid)
      .setTrainRatio(0.9)

    val model = trainValidationSplit.fit(training)

    // 5.m
    //Prediction avec le modèle
    val df_WithPrediction = model.transform(test)
    println("Confusion Matrix : ")
    //df_WithPrediction.show()

    // 5.n
    //Calculer le F1 Score
    df_WithPrediction.groupBy("final_status", "prediction").count.show()
    val metrics = evaluator.evaluate(df_WithPrediction)
    println("Logistic Regression F1 Score : " + metrics)

    //val trainingSummary = pipeline.summary
    //val LogisticSummary = trainingSummary.asInstanceOf[BinaryLogisticRegressionSummary]
    //val fMeasure = trainValidationSplit.fMeasureByThreshold
    //New model : Random Forest

    val NumTrees: Int = 100

    val rf = new RandomForestClassifier()
      .setLabelCol("final_status")
      .setFeaturesCol("features")
      .setNumTrees(NumTrees)
      .setPredictionCol("prediction")
      .setRawPredictionCol("raw_predictions")


    // 4.j
    //Créer une pipeline avec les différentes étapes
    val pipeline2 = new Pipeline()
      .setStages(Array(tokenizer, remover, tf, idf, indexer_country, indexer_currency, encoder, assembler, rf))

    // 5.l
    //Grille de paramètres
    val paramGrid2 = new ParamGridBuilder().build()

    //Evaluator F1 Score
    val evaluator2 = new MulticlassClassificationEvaluator()
      .setLabelCol("final_status")
      .setPredictionCol("prediction")
      .setMetricName("f1")

    //Entrainer le modèle
    val trainValidationSplit2 = new TrainValidationSplit()
      .setEstimator(pipeline2)
      .setEvaluator(evaluator2)
      .setEstimatorParamMaps(paramGrid2)
      .setTrainRatio(0.9)

    val Array(training2, test2) = data.randomSplit(Array(0.9, 0.1), seed = 12345)

    val model2 = trainValidationSplit2.fit(training2)

    // 5.m
    //Prediction avec le modèle
    val df_WithPrediction2 = model2.transform(test2)
    println("Confusion Matrix Random Forest: ")
    //df_WithPrediction.show()

    // 5.n
    //Calculer le F1 Score
    df_WithPrediction2.groupBy("final_status", "prediction").count.show()
    val metrics2 = evaluator2.evaluate(df_WithPrediction2)
    println("Random Forest F1 Score : " + metrics2)
  }
}