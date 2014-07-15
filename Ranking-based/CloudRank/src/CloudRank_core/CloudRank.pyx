########################################################
# CloudRank.pyx
# Author: Jamie Zhu <jimzhu@GitHub>
# Created: 2014/2/6
# Last updated: 2014/6/17
########################################################

import time
import sys
import numpy as np
from utilities import *
cimport numpy as np # import C-API


#########################################################
# Make declarations on functions from cpp file
#
cdef extern from "CloudRank_core.h":
    void CloudRank_core(double *removedData, int numUser, 
        int numService, int topK, int *predData)
#########################################################


#########################################################
# Function to wrap up the C++ function for python
#
def CloudRank_wrapper(removedMatrix, paraStruct):
    # get the parameters  
    cdef int numService = removedMatrix.shape[1] 
    cdef int numUser = removedMatrix.shape[0]
    cdef int topK = paraStruct['topK']

    # initialization
    cdef np.ndarray[int, ndim=2, mode='c'] predRankMatrix = \
        np.zeros((numUser, numService), dtype=np.int32)
    
    logger.info('Start CloudRank...')

    # Wrap up the CloudRank_core.cpp
    CloudRank_core(
        <double *> (<np.ndarray[double, ndim=2, mode='c']> removedMatrix).data,
        numUser,
        numService,
        topK,
        <int *> predRankMatrix.data
        )
    
    return predRankMatrix
#########################################################


