
import tensorflow as tf
import numpy as np
import DataSets as ds
import Layers
import numpy as np

def get_dict(database,IsTrainingMode):
	xs,ys = database.NextTrainingBatch()
	return {x:xs,y_desired:ys,ITM:IsTrainingMode}

LoadModel = False
KeepProb_Dropout = 0.85

experiment_name = '10k_Dr%.3f'%KeepProb_Dropout
#train = ds.DataSet('../DataBases/data_1k.bin','../DataBases/gender_1k.bin',1000)
train = ds.DataSet('/Users/maelfabien/Desktop/LocalDB/MDI341/Databases/data_10k.bin','/Users/maelfabien/Desktop/LocalDB/MDI341/Databases/gender_10k.bin',10000)
#train = ds.DataSet('../DataBases/data_100k.bin','../DataBases/gender_100k.bin',100000)
test = ds.DataSet('/Users/maelfabien/Desktop/LocalDB/MDI341/Databases/data_test10k.bin','/Users/maelfabien/Desktop/LocalDB/MDI341/Databases/gender_test10k.bin',10000)
# t = tf.layers.batch_normalization(t)

with tf.name_scope('input'):
	x = tf.placeholder(tf.float32, [None, train.dim], name='x')
	y_desired = tf.placeholder(tf.float32, [None, 2], name='y_desired')
	ITM = tf.placeholder("bool", name='Is_Training_Mode')

with tf.name_scope('CNN'):
	t = Layers.unflat(x, 48, 48, 1)
	nb_conv_per_block = 2
	nbfilter = 16
	for k in range(4):
		for i in range(nb_conv_per_block):
			#t = tf.layers.batch_normalization(t)
			d = Layers.conv(t,nbfilter, 3,1,ITM,'conv33_%d_%d'%(k,i),KeepProb_Dropout)
			t = tf.concat([t, d], axis=3)
			#t = Layers.conv(t, nbfilter, 3, 1, ITM, 'conv_%d_%d' % (nbfilter, i), KeepProb_Dropout)
		t = Layers.maxpool(t, 2, 'pool')
		t = Layers.conv(t,32,1,1,ITM,'conv11_%d'%(k),KeepProb_Dropout)
		#t = tf.layers.batch_normalization(t)
		#nbfilter *= 2
	t = Layers.flat(t)
	t = Layers.fc(t, 50, ITM, 'fc_1', KeepProb_Dropout)
	#t = Layers.fc(t, 2, ITM, 'fc_2', act=tf.nn.log_softmax)
	y = Layers.fc(t, 2, ITM, 'fc_2', KP_dropout=1.0, act=tf.nn.log_softmax)

with tf.name_scope('cross_entropy'):
	diff = y_desired * y
	with tf.name_scope('total'):
		cross_entropy = -tf.reduce_mean(diff)
	tf.summary.scalar('cross entropy', cross_entropy)

with tf.name_scope('accuracy'):
	with tf.name_scope('correct_prediction'):
		correct_prediction = tf.equal(tf.argmax(y, 1), tf.argmax(y_desired, 1))
	with tf.name_scope('accuracy'):
		accuracy = tf.reduce_mean(tf.cast(correct_prediction, tf.float32))
	tf.summary.scalar('accuracy', accuracy)

with tf.name_scope('learning_rate'):
	global_step = tf.Variable(0, trainable=False)
	learning_rate = tf.train.exponential_decay(1e-3, global_step, 1000, 0.75, staircase=True)

with tf.name_scope('learning_rate'):
	tf.summary.scalar('learning_rate', learning_rate)

# train_step = tf.train.GradientDescentOptimizer(0.00001).minimize(cross_entropy)
train_step = tf.train.AdamOptimizer(learning_rate).minimize(cross_entropy, global_step=global_step)
merged = tf.summary.merge_all()

Acc_Train = tf.placeholder("float", name='Acc_Train');
Acc_Test = tf.placeholder("float", name='Acc_Test');
MeanAcc_summary = tf.summary.merge([tf.summary.scalar('Acc_Train', Acc_Train), tf.summary.scalar('Acc_Test', Acc_Test)])

print("-----------------------------------------------------")
print("-----------", experiment_name)
print("-----------------------------------------------------")

sess = tf.Session()
sess.run(tf.global_variables_initializer())
writer = tf.summary.FileWriter(experiment_name, sess.graph)
saver = tf.train.Saver()
if LoadModel:
	saver.restore(sess, "./model.ckpt")

nbIt = 5000
for it in range(nbIt):
	print("Iteration Number ", it)
	trainDict = get_dict(train, IsTrainingMode=True)
	sess.run(train_step, feed_dict=trainDict)

	if it % 10 == 0:
		acc, ce, lr = sess.run([accuracy, cross_entropy, learning_rate], feed_dict=trainDict)
		print("it= %6d - rate= %f - cross_entropy= %f - acc= %f" % (it, lr, ce, acc))
		summary_merged = sess.run(merged, feed_dict=trainDict)
		writer.add_summary(summary_merged, it)

	if it % 100 == 50:
		Acc_Train_value = train.mean_accuracy(sess, accuracy, x, y_desired, ITM)
		Acc_Test_value = test.mean_accuracy(sess, accuracy, x, y_desired, ITM)
		print("mean accuracy train = %f  test = %f" % (Acc_Train_value, Acc_Test_value))
		summary_acc = sess.run(MeanAcc_summary, feed_dict={Acc_Train: Acc_Train_value, Acc_Test: Acc_Test_value})
		writer.add_summary(summary_acc, it)

writer.close()
if not LoadModel:
	saver.save(sess, "./model.ckpt")
sess.close()

import sys
from PIL import Image

image_name = sys.argv[1]
toshow = np.reshape(ima,(48,48)) im2 = Image.fromarray(toshow) im2.show()
label,output = sess.run([tf.argmax(out, 1),out],{x:ima})
print ("label %d output %.4f %.4f "%(label,output[0,0],output[0,1]))