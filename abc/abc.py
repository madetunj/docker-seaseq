#You can try importing them and then handle the ImportError if the module doesn't exist.

try:
    import numpy
    print("we have numpy")
except ImportError:
    print("numpy is not installed")
