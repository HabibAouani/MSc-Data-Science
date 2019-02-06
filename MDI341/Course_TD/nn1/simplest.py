import tensorflow as tf
import numpy as np

# nombre d images
nbdata = 1000
trainDataFile = '/Users/maelfabien/Desktop/LocalDB/MDI341/Databases/data_1k.bin'
LabelFile = '/Users/maelfabien/Desktop/LocalDB/MDI341/Databases/gender_1k.bin'

# taille des images 48*48 pixels en niveau de gris
dim = 2304
f = open(trainDataFile, 'rb')
# remplir les données
data = np.empty([nbdata, dim], dtype=np.float32)
for i in range(nbdata):
	data[i,:] = np.fromfile(f, dtype=np.uint8, count=dim).astype(np.float32)
f.close()

# remplir les labels
f = open(LabelFile, 'rb')
label = np.empty([nbdata, 2], dtype=np.float32)
for i in range(nbdata):
	label[i,:] = np.fromfile(f, dtype=np.float32, count=2)
f.close()

# definir un fully connected layer
def fc_layer(tensor, input_dim, output_dim): 
	print ('tensor  ',tensor.get_shape()   )
    # initialiser les poids
	Winit = tf.truncated_normal([input_dim, output_dim], stddev=0.1)
	W = tf.Variable(Winit)
	print ('Winit  ',Winit.get_shape())
	print ('W      ',W.get_shape())
    # initialiser les constantes
	Binit = tf.constant(0.0, shape=[output_dim])
	B = tf.Variable(Binit)
	print ('Binit  ',Binit.get_shape())
	print ('B      ',B.get_shape())
    # schéma conceptuel du tenseur
	tensor = tf.matmul(tensor, W) + B
	print ('tensor  ',tensor.get_shape())
	print ('--------')
	return tensor
	

# données train
x = tf.placeholder(tf.float32, [None, dim])
# label train
y_desired = tf.placeholder(tf.float32, [None, 2])

# premier layer
layer1 = fc_layer(x,dim,50)
# une sigmoid
sigmo = tf.nn.sigmoid(layer1)
# un fully connected layer
y = fc_layer(sigmo,50,2)

# fonction de perte quadratique
loss = tf.reduce_sum(tf.square(y - y_desired))
train_step = tf.train.GradientDescentOptimizer(1e-5).minimize(loss)

# declarer la session
sess = tf.Session()	
sess.run(tf.global_variables_initializer())

# definir les paramètres
curPos = 0
batchSize = 256
nbIt = 1000000

# pour chaque itération
for it in range(nbIt):
    # s'arrêter si toutes les données ont été utilisées
	if curPos + batchSize > nbdata:
		curPos = 0
    
    # position de l'échantillon d'entrainement
    trainDict = {x:data[curPos:curPos+batchSize,:],y_desired:label[curPos:curPos+batchSize,:]}
		
	curPos += batchSize
    
    # demarrer la session
	sess.run(train_step, feed_dict=trainDict)
	if it%1000 == 0:
		print ("it= %6d - loss= %f" % (it, sess.run(loss, feed_dict=trainDict)))

sess.close()
