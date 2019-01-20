#!/usr/bin/env bash

#Configuration
cd spark-2.2.0-bin-hadoop2.7/conf
cp log4j.properties.template log4j.properties
brew install sbt

#Launching Spark
cd spark-2.3.1-bin-hadoop2.7/bin
./spark-shell

#Launching RDD and not Data Frame
sc.

#We will work with the ReadMe file
val myfile = sc.textFile("file:/Users/maelfabien/spark-2.3.1-bin-hadoop2.7/README.md")

#Display 5 lines of the file
myfile.take(5).foreach(println(_))

#Do a wordcount on the text
val wordcount = myfile.flatMap{line : String => line.split(" ")}.map{word : String => (word,1)}.reduceByKey{ (i: Int, j: Int) => i + j }.toDF("word", "count")
wordcount.show()

#Order results
wordcount.orderBy($"count".desc).show()

#Standardize variables to lower Case
val df_lower = wordcount.withColumn("word_lower", lower($"word"))
val df_grouped = df_lower.groupBy("word_lower").agg(sum("count").as("new_count"))

#Group results
df_grouped.orderBy($"new_count".desc).show()

#We can do the same with the DataFrames :
val df2 = spark.read.text("file:/Users/maelfabien/spark-2.3.1-bin-hadoop2.7/README.md")
.withColumn("words", split($"value", " "))
.select("words")
.withColumn("words", explode($"words"))
.withColumn("words", lower($"words"))
.groupBy("words")
.count
.show()



