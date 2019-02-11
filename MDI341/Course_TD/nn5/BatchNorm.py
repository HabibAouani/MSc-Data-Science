import tensorflow as tf

class BatchNormalizer(object):

   def __init__(self, depth, decay=0.99, epsilon=0.01):
       self.beta = tf.Variable(tf.constant(0.0, shape=[depth]), trainable=True)
       self.gamma = tf.Variable(tf.constant(1.0, shape=[depth]), trainable=True)
       self.ema_trainer = tf.train.ExponentialMovingAverage(decay=decay)
       self.epsilon = epsilon

   def normalize(self, x, train):
       batch_mean, batch_var = tf.nn.moments(x, list(range(x.get_shape().ndims -1)))

       def updateStat():
           ema_apply = self.ema_trainer.apply([batch_mean, batch_var])
           with tf.control_dependencies([ema_apply]):

               return tf.identity(batch_mean), tf.identity(batch_var)

       def loadStat():

           return self.ema_trainer.average(batch_mean), self.ema_trainer.average(batch_var)

       mean, var = tf.cond(train, updateStat, loadStat)
       bn = tf.nn.batch_normalization(x, mean, var, self.beta, self.gamma, self.epsilon)

       return bn
