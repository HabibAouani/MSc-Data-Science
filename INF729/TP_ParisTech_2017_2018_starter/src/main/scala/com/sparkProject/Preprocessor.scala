package com.sparkProject

import org.apache.spark.SparkConf
import org.apache.spark.sql.SparkSession
import org.apache.spark.sql.functions.udf

object Preprocessor {

  def main(args: Array[String]): Unit = {

    // Des réglages optionels du job spark. Les réglages par défaut fonctionnent très bien pour ce TP
    // on vous donne un exemple de setting quand même
    val conf = new SparkConf().setAll(Map(
      "spark.scheduler.mode" -> "FIFO",
      "spark.speculation" -> "false",
      "spark.reducer.maxSizeInFlight" -> "48m",
      "spark.serializer" -> "org.apache.spark.serializer.KryoSerializer",
      "spark.kryoserializer.buffer.max" -> "1g",
      "spark.shuffle.file.buffer" -> "32k",
      "spark.default.parallelism" -> "12",
      "spark.sql.shuffle.partitions" -> "12"
    ))

    // Initialisation de la SparkSession qui est le point d'entrée vers Spark SQL (donne accès aux dataframes, aux RDD,
    // création de tables temporaires, etc et donc aux mécanismes de distribution des calculs.)
    val spark = SparkSession
      .builder
      .config(conf)
      .appName("TP_spark")
      .getOrCreate()

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

    // a :

    val df = spark.read
      .format("csv")
      .option("header", "true") //reading the headers
      //.option("mode", "DROPMALFORMED")
      .load("train_clean.csv")

    // b :
    println(s"Total number of rows: ${df.count}")
    println(s"Number of columns ${df.columns.length}")

    // c :
    df.show()

    // d :
    df.printSchema()

    // e :
    val dfCasted = df
      .withColumn("goal", $"goal".cast("Int"))
      .withColumn("deadline" , $"deadline".cast("Int"))
      .withColumn("state_changed_at", $"state_changed_at".cast("Int"))
      .withColumn("created_at", $"created_at".cast("Int"))
      .withColumn("launched_at", $"launched_at".cast("Int"))
      .withColumn("backers_count", $"backers_count".cast("Int"))
      .withColumn("final_status", $"final_status".cast("Int"))

    dfCasted.printSchema()


    // f :
    dfCasted.select("goal", "backers_count", "final_status").describe().show

    dfCasted.groupBy("disable_communication").count.orderBy($"count".desc).show(100)
    dfCasted.groupBy("country").count.orderBy($"count".desc).show(100)
    dfCasted.groupBy("currency").count.orderBy($"count".desc).show(100)
    dfCasted.select("deadline").dropDuplicates.show()
    dfCasted.groupBy("state_changed_at").count.orderBy($"count".desc).show(100)
    dfCasted.groupBy("backers_count").count.orderBy($"count".desc).show(100)
    dfCasted.select("goal", "final_status").show(30)
    dfCasted.groupBy("country", "currency").count.orderBy($"count".desc).show(50)

    val df2 = dfCasted.drop("disable_communication")

    df2.filter(df2("goal") < 0).show()
    df2.filter(df2("backers_count") < 0).show()

    val dfNoFutur = df2.drop("backers_count", "state_changed_at")

    dfNoFutur.filter($"country"==="False").groupBy("currency").count.orderBy($"count".desc).show(50)

    def udfCountry = udf{(country: String, currency: String) =>
      if (country == "False")
        currency
      else
        country //: ((String, String) => String)  pour éventuellement spécifier le type
    }

    def udfCurrency = udf{(currency: String) =>
      if ( currency != null && currency.length != 3 )
        null
      else
        currency //: ((String, String) => String)  pour éventuellement spécifier le type
    }

    val dfCountry = dfNoFutur
      .withColumn("country2", udfCountry($"country", $"currency"))
      .withColumn("currency2", udfCurrency($"currency"))
      .drop("country", "currency")

  }

}

//val curr = udf { (x: String) => if (x.length != 3) null else x }
