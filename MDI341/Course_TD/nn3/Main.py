

import tensorflow as tf
import numpy as np
import DataSets as ds


LoadModel = False

experiment_name = '100k'
#train = ds.DataSet('../DataBases/data_1k.bin','../DataBases/gender_1k.bin',1000)
#train = ds.DataSet('../DataBases/data_10k.bin','../DataBases/gender_10k.bin',10000)
train = ds.DataSet('../DataBases/data_100k.bin','../DataBases/gender_100k.bin',100000)
test = ds.DataSet('../DataBases/data_test10k.bin','../DataBases/gender_test10k.bin',10000)


def variable_summaries(var, name):
	with tf.name_scope('summaries'):
		mean = tf.reduce_mean(var)
		tf.summary.scalar( name + '/mean', mean)
		with tf.name_scope('stddev'):
			stddev = tf.sqrt(tf.reduce_sum(tf.square(var - mean)))
		tf.summary.scalar( name + '/sttdev' , stddev)
		tf.summary.scalar( name + '/max' , tf.reduce_max(var))
		tf.summary.scalar( name + '/min' , tf.reduce_min(var))
		tf.summary.histogram(name, var)

def fc_layer(tensor, input_dim, output_dim,name):
	with tf.name_scope(name):
		Winit = tf.truncated_normal([input_dim, output_dim], stddev=0.1)
		W = tf.Variable(Winit)
		variable_summaries(W, name + '/W')
		Binit = tf.constant(0.0, shape=[output_dim])
		B = tf.Variable(Binit)
		variable_summaries(B, name + '/B')
		tensor = tf.matmul(tensor, W) + B
		return tensor
	
def get_dict(database):
	xs,ys = database.NextTrainingBatch()
	return {x:xs,y_desired:ys}

with tf.name_scope('input'):
	x = tf.placeholder(tf.float32, [None, train.dim],name='x')
	y_desired = tf.placeholder(tf.float32, [None, 2],name='y_desired')

with tf.name_scope('perceptron'):
	layer1 = fc_layer(x,train.dim,50,'layer_1')
	sigmo = tf.nn.sigmoid(layer1)
	y = fc_layer(sigmo,50,2,'layer_2')

with tf.name_scope('loss'):
	loss = tf.reduce_sum(tf.square(y - y_desired))
	tf.summary.scalar('loss', loss)

with tf.name_scope('accuracy'):
	with tf.name_scope('correct_prediction'):
		correct_prediction = tf.equal(tf.argmax(y, 1), tf.argmax(y_desired, 1))
	with tf.name_scope('accuracy'):
		accuracy = tf.reduce_mean(tf.cast(correct_prediction, tf.float32))
		tf.summary.scalar('accuracy', accuracy)	

train_step = tf.train.GradientDescentOptimizer(1e-5).minimize(loss)

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

nbIt = 300000
for it in range(nbIt):
	trainDict = get_dict(train)
					
	sess.run(train_step, feed_dict=trainDict)
	if it%100 == 0:
		print ("it= %6d - loss= %f" % (it, sess.run(loss, feed_dict=trainDict)))
		summary_merged = sess.run(merged, feed_dict=trainDict)
		writer.add_summary(summary_merged, it)	

	if it%1000 == 0:
		Acc_Train_value = train.mean_accuracy(sess,accuracy,x,y_desired)
		Acc_Test_value = test.mean_accuracy(sess,accuracy,x,y_desired)
		print ("mean accuracy train = %f  test = %f" % (Acc_Train_value,Acc_Test_value ))
		summary_acc = sess.run(MeanAcc_summary, feed_dict={Acc_Train:Acc_Train_value,Acc_Test:Acc_Test_value})
		writer.add_summary(summary_acc, it)	
	
writer.close()
if not LoadModel:
	saver.save(sess, "./model.ckpt")
sess.close()
