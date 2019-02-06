
import tensorflow as tf
import numpy as np
import DataSets as ds


LoadModel = False

experiment_name = '1k'
train = ds.DataSet('/Users/maelfabien/Desktop/LocalDB/MDI341/Databases/data_1k.bin','/Users/maelfabien/Desktop/LocalDB/MDI341/Databases/gender_1k.bin',1000)

def variable_summaries(var, name):
	with tf.name_scope('summaries'):
		mean = tf.reduce_mean(var)
		tf.summary.scalar( name + '/mean', mean)
		with tf.name_scope('stddev'):
			stddev = tf.sqrt(tf.reduce_sum(tf.square(var - mean)))
		tf.summary.scalar( name + '/sttdev' , stddev)
		tf.summary.scalar( name + '/max' , tf.reduce_max(var))
		tf.summary.scalar( name + 'min/' , tf.reduce_min(var))
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
	
train_step = tf.train.GradientDescentOptimizer(1e-5).minimize(loss)

merged = tf.summary.merge_all()


print ("-----------------------------------------------------")
print ("-----------",experiment_name)
print ("-----------------------------------------------------")



sess = tf.Session()	
sess.run(tf.global_variables_initializer())
writer = tf.summary.FileWriter(experiment_name, sess.graph)
saver = tf.train.Saver()
if LoadModel:
	saver.restore(sess, "./model.ckpt")

nbIt = 100000
for it in range(nbIt):
	trainDict = get_dict(train)
					
	sess.run(train_step, feed_dict=trainDict)
	if it%1000 == 0:
		print ("it= %6d - loss= %f" % (it, sess.run(loss, feed_dict=trainDict)))
		summary_merged = sess.run(merged, feed_dict=trainDict)
		writer.add_summary(summary_merged, it)	

writer.close()
if not LoadModel:
	saver.save(sess, "./model.ckpt")
sess.close()
