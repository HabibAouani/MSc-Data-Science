

import tensorflow as tf
import numpy as np
import DataSets as ds
import Layers

def get_dict(database):
	xs,ys = database.NextTrainingBatch()
	return {x:xs,y_desired:ys}

LoadModel = False

experiment_name = '1k'
train = ds.DataSet('../DataBases/data_1k.bin','../DataBases/gender_1k.bin',1000)
#train = ds.DataSet('../DataBases/data_10k.bin','../DataBases/gender_10k.bin',10000)
#train = ds.DataSet('../DataBases/data_100k.bin','../DataBases/gender_100k.bin',100000)
test = ds.DataSet('../DataBases/data_test10k.bin','../DataBases/gender_test10k.bin',10000)

with tf.name_scope('input'):
	x = tf.placeholder(tf.float32, [None, train.dim],name='x')
	y_desired = tf.placeholder(tf.float32, [None, 2],name='y_desired')

with tf.name_scope('CNN'):
	t = Layers.unflat(x,48,48,1)
	t = Layers.conv(t,3,3,1,'conv_1')
	t = Layers.maxpool(t,2,'pool_2')
	t = Layers.conv(t,6,3,1,'conv_3')
	t = Layers.maxpool(t,2,'pool_4')
	t = Layers.conv(t,12,3,1,'conv_5')
	t = Layers.maxpool(t,2,'pool_6')
	t = Layers.flat(t)
	y = Layers.fc(t,2,'fc_7',tf.nn.log_softmax)

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
	learning_rate = tf.train.exponential_decay(0.001,global_step,1000, 0.75, staircase=True)


with tf.name_scope('learning_rate'):
    tf.summary.scalar('learning_rate', learning_rate)

#train_step = tf.train.GradientDescentOptimizer(0.00001).minimize(cross_entropy)
train_step = tf.train.AdamOptimizer(learning_rate).minimize(cross_entropy,global_step=global_step)
merged = tf.summary.merge_all()

Acc_Train = tf.placeholder("float", name='Acc_Train');
Acc_Test = tf.placeholder("float", name='Acc_Test');
MeanAcc_summary = tf.summary.merge([tf.summary.scalar('Acc_Train', Acc_Train),tf.summary.scalar('Acc_Test', Acc_Test)])


print ("-----------------------------------------------------")
print ("-----------",experiment_name)
print ("-----------------------------------------------------")


sess = tf.Session()	
sess.run(tf.global_variables_initializer())
writer = tf.summary.FileWriter(experiment_name, sess.graph)
saver = tf.train.Saver()
if LoadModel:
	saver.restore(sess, "./model.ckpt")

nbIt = 5000
for it in range(nbIt):
	trainDict = get_dict(train)
					
	sess.run(train_step, feed_dict=trainDict)
	if it%10 == 0:
		acc,ce = sess.run([accuracy,cross_entropy], feed_dict=trainDict)
		print ("it= %6d - cross_entropy= %f - acc= %f" % (it,ce,acc ))
		summary_merged = sess.run(merged, feed_dict=trainDict)
		writer.add_summary(summary_merged, it)	
		
	if it%100 == 50:
		Acc_Train_value = train.mean_accuracy(sess,accuracy,x,y_desired)
		Acc_Test_value = test.mean_accuracy(sess,accuracy,x,y_desired)
		print ("mean accuracy train = %f  test = %f" % (Acc_Train_value,Acc_Test_value ))
		summary_acc = sess.run(MeanAcc_summary, feed_dict={Acc_Train:Acc_Train_value,Acc_Test:Acc_Test_value})
		writer.add_summary(summary_acc, it)
		
writer.close()
if not LoadModel:
	saver.save(sess, "./model.ckpt")
sess.close()
