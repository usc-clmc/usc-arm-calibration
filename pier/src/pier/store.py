'''
Store
2010.7.26 - Jonathan Binney

Store variables using a heirarchical directory structure.

This comes in handy when you want to manipulate the variables using
file handling tools - for instance you can copy a variable from one
store to another simply by dragging and dropping the appropriate file.

It also works well when using file syncing tools such as dropbox.  Each
Time you change one variable, only that variable needs to be synced to
other computers. In addition, when using multiple processes to modify
variables within a single store, fine grained locking is possible.

By associating a custom viewer with the filetype we save things as,
we can make it possible to do things like matshow() a matrix when its
file is opened.

No meta data is cached, so there is a fair amount of overhead to do things
like list all of the variables. The advantage is that we do not have to
worry about consistency with what is on the disk.
'''
import shelve, os, os.path
from exceptions import IOError

class Store:
   def __init__(self, root):
      self.ext = '.ppas_store'
      self.root = os.path.abspath(root)
      if os.path.isfile(root):
         raise IOError('Root path is a file')
         
   def __getitem__(self, key):
      s = shelve.open(self.path(key) + self.ext, 'r')
      val = s['val']
      s.close()
      return val

   def __setitem__(self, key, val):
      key_dir, key_file = os.path.split(self.path(key))
      if not os.path.exists(key_dir):
         os.makedirs(key_dir)
      if os.path.exists(self.path(key)):
         os.remove(self.path(key))
      s = shelve.open(self.path(key) + self.ext, 'c')
      s['val'] = val
      s.close()

   def __str__(self):
      return 'Store(%s)' % self.root
   
   def path(self, key):
      return os.path.join(self.root, key)
   
   def keys(self, partial_key=''):
      keys = []
      for dirpath, dirnames, filenames in os.walk(self.path(partial_key)):
         for filename in filenames:
            filename_base, filename_ext = os.path.splitext(filename)
            if filename_ext == self.ext:
               keys.append(os.path.relpath(os.path.join(dirpath, filename_base), self.root))
      return keys
