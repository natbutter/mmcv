import numpy as np
import torch

from mmcv.ops import box_iou_rotated
from mmcv.utils import collect_env

import torch
import tensorflow as tf
import tensorboard

import os
import re
from shutil import rmtree
import shutil
import xml.etree.ElementTree as ET
import math
import random
import pandas as pd
from skimage import io
import pickle
import pandas
import matplotlib.pyplot as plt
import copy
import os.path as osp
import mmcv
import numpy as np
import xml.etree.ElementTree as ET
from mmdet.datasets.builder import DATASETS
from mmdet.datasets.custom import CustomDataset
from mmdet.apis import set_random_seed
from mmcv import Config
from mmdet.datasets import build_dataset
from mmdet.models import build_detector
from mmdet.apis import train_detector

print("All imported!"

def check_torch():
    print(torch.cuda.current_device())
    print(torch.cuda.device(0))
    print(torch.cuda.device_count())
    print(torch.cuda.get_device_name(0))
    print(torch.cuda.is_available())
    x = torch.rand(5, 3)
    print(x)

def check_tf():
    print(tf.config.list_physical_devices('GPU'))
    print(tf.reduce_sum(tf.random.normal([1000, 1000])))



def check_installation():
    """Check whether mmcv-full has been installed successfully."""
    np_boxes1 = np.asarray(
        [[1.0, 1.0, 3.0, 4.0, 0.5], [2.0, 2.0, 3.0, 4.0, 0.6],
         [7.0, 7.0, 8.0, 8.0, 0.4]],
        dtype=np.float32)
    np_boxes2 = np.asarray(
        [[0.0, 2.0, 2.0, 5.0, 0.3], [2.0, 1.0, 3.0, 3.0, 0.5],
         [5.0, 5.0, 6.0, 7.0, 0.4]],
        dtype=np.float32)
    boxes1 = torch.from_numpy(np_boxes1)
    boxes2 = torch.from_numpy(np_boxes2)

    # test mmcv-full with CPU ops
    box_iou_rotated(boxes1, boxes2)
    print('CPU ops were compiled successfully.')

    # test mmcv-full with both CPU and CUDA ops
    if torch.cuda.is_available():
        boxes1 = boxes1.cuda()
        boxes2 = boxes2.cuda()
        box_iou_rotated(boxes1, boxes2)
        print('CUDA ops were compiled successfully.')
    else:
        print('No CUDA runtime is found, skipping the checking of CUDA ops.')


if __name__ == '__main__':
    print('checking gpu and torch...')
    check_torch()
    print('Start checking the installation of mmcv-full ...')
    check_installation()
    print('mmcv-full has been installed successfully.\n')

    env_info_dict = collect_env()
    env_info = '\n'.join([(f'{k}: {v}') for k, v in env_info_dict.items()])
    dash_line = '-' * 60 + '\n'
    print('Environment information:')
    print(dash_line + env_info + '\n' + dash_line)
    print('checking tf...')
    check_tf()
