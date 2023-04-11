#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Jul 26 14:26:53 2022

@author: victor
"""

import os
from os.path import join
from nilearn import plotting
from nilearn.image import load_img
from nilearn.glm import threshold_stats_img

base_dir = os.getcwd()

data_dir = os.path.join(base_dir,'controls','neuroling')

derivatives_folder = 'derivatives/spm'

zmap = load_img(join(data_dir,derivatives_folder,'group_analysis/spmZ_0001.nii'))

thresholded_map, threshold = threshold_stats_img(
    
    zmap, alpha = 0.001, height_control = None, cluster_threshold = 68, two_sided = False)

display = plotting.plot_glass_brain(thresholded_map, display_mode = 'lyr', vmax = 6,
                                    
                                    resampling_interpolation = 'nearest', alpha = 1, colorbar = True)

display.savefig(join(base_dir, '2nd_level_Controls.png'), dpi = 1000)
