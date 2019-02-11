import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import cv2
import tensorflow as tf
from tensorflow import keras

# Load image to predict, reshapeit
img = "/Users/maelfabien/TelecomParisTech/MDI341/Course_TD/4848.jpg"
toli_face = cv2.imread(img)
toli_face = cv2.cvtColor(toli_face, cv2.COLOR_BGR2GRAY)
to_predict = np.reshape(toli_face.flatten(), (1,48,48,1))
print(to_predict)

sess = tf.Session()
sess.run(tf.global_variables_initializer())
saver = tf.train.Saver()

saver.restore(sess, "./model.ckpt")

summ = sess.run(tf.constant(to_predict))
print(summ)

