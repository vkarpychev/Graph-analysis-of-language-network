#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Mar 17 21:52:24 2023

@author: victor
"""

import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from scipy.io import loadmat
import numpy as np
from nilearn import plotting

df1 = pd.read_csv('/Volumes/Projects_1/Results/fMRI/fc_PPI/GT_table.csv')

f = plt.figure(figsize = (15,10))

ax1 = f.add_subplot(231)

ax1 = sns.violinplot(x = 'class', y = 'Eglob', data = df1, linewidth = 3.0, palette = 'Set1', saturation = 0.35,  width = 0.6)

ax1 = plt.title('$E_{glob}$', fontsize = 18, fontname = 'Arial', style = 'italic')

ax1 = plt.xlabel('')

ax1 = plt.ylabel('')

ax1 = plt.yticks(fontsize = 14, fontname = 'Arial')

ax1 = plt.xticks(fontsize = 14, fontname = 'Arial')

ax2 = f.add_subplot(232)

ax2 = sns.violinplot(x = 'class', y = 'Eloc', data = df1, linewidth = 3.0, palette = 'Set1', saturation = 0.35,  width = 0.6)

ax2 = plt.title('$E_{loc}$', fontsize = 18, fontname = 'Arial', style = 'italic')

ax2 = plt.xlabel('')

ax2 = plt.ylabel('')

ax2 = plt.yticks(fontsize = 14, fontname = 'Arial')

ax2 = plt.xticks(fontsize = 14, fontname = 'Arial')

ax3 = f.add_subplot(233)

ax3 = sns.violinplot(x = 'class', y = 'IS', data = df1, linewidth = 3.0, palette = 'Set1', saturation = 0.35,  width = 0.6)

ax3 = plt.title('IS', fontsize = 18, fontname = 'Arial', style = 'italic')

ax3 = plt.xlabel('')

ax3 = plt.ylabel('')

ax3 = plt.yticks(fontsize = 14, fontname = 'Arial')

ax3 = plt.xticks(fontsize = 14, fontname = 'Arial')

df2 = pd.read_csv('/Volumes/Projects_1/Results/fMRI/fc_PPI/PWE/PWE_behav.csv')

ax4 = f.add_subplot(234)

ax4 = sns.regplot(x = 'duration', y = 'Eglob', data = df2, line_kws = {'color': '#667AA0', 'alpha': 1.0},
                                                         scatter_kws = {'color': '#667AA0', 'alpha': 1.0})

ax4 = plt.title('$E_{glob}$', fontsize = 18, fontname = 'Arial', style = 'italic')

ax4 = plt.xlabel('Epilepsy duration (years)', fontsize = 14, fontname = 'Arial')

ax4 = plt.ylabel('')

ax4 = plt.yticks(fontsize = 14, fontname = 'Arial')

ax4 = plt.xticks(fontsize = 14, fontname = 'Arial')

ax5 = f.add_subplot(235)

ax5 = sns.regplot(x = 'duration', y = 'Eloc', data = df2, line_kws = {'color': '#667AA0', 'alpha': 1.0},
                                                         scatter_kws = {'color': '#667AA0', 'alpha': 1.0})

ax5 = plt.title('$E_{loc}$', fontsize = 18, fontname = 'Arial', style = 'italic')

ax5 = plt.xlabel('Epilepsy duration (years)', fontsize = 14, fontname = 'Arial')

ax5 = plt.ylabel('')

ax5 = plt.yticks([0.11,0.12,0.13,0.14,0.15,0.16,0.17,0.18,0.19],fontsize = 14, fontname = 'Arial')

ax5 = plt.xticks(fontsize = 14, fontname = 'Arial')

ax6 = f.add_subplot(236)

ax6 = sns.regplot(x = 'duration', y = 'IS', data = df2, line_kws = {'color': '#667AA0', 'alpha': 1.0},
                                                         scatter_kws = {'color': '#667AA0', 'alpha': 1.0})

ax6 = plt.title('${IS}$', fontsize = 18, fontname = 'Arial', style = 'italic')

ax6 = plt.xlabel('Epilepsy duration (years)', fontsize = 14, fontname = 'Arial')

ax6 = plt.ylabel('')

ax6 = plt.yticks(fontsize = 14, fontname = 'Arial')

ax6 = plt.xticks(fontsize = 14, fontname = 'Arial')

f.savefig('/Volumes/Projects_1/Results/fMRI/fc_PPI/figures/Fig.2-A.png', dpi = 1000, bbox_inches = 'tight', pad_inches = 0.3)


f = plt.figure(figsize = (15,10))

ax1 = f.add_subplot(231)

ax1 = sns.violinplot(x = 'class', y = 'Nhubs', data = df1, linewidth = 3.0, palette = 'Set1', saturation = 0.35,  width = 0.6)

ax1 = plt.title('$N_{hubs}$', fontsize = 18, fontname = 'Arial', style = 'italic')

ax1 = plt.xlabel('')

ax1 = plt.ylabel('')

ax1 = plt.yticks(fontsize = 14, fontname = 'Arial')

ax1 = plt.xticks(fontsize = 14, fontname = 'Arial')

ax2 = f.add_subplot(232)

ax2 = sns.violinplot(x = 'class', y = 'Nhubs_L', data = df1, linewidth = 3.0, palette = 'Set1', saturation = 0.35,  width = 0.6)

ax2 = plt.title('$N_{hubs}-L$', fontsize = 18, fontname = 'Arial', style = 'italic')

ax2 = plt.xlabel('')

ax2 = plt.ylabel('')

ax2 = plt.yticks(fontsize = 14, fontname = 'Arial')

ax2 = plt.xticks(fontsize = 14, fontname = 'Arial')

ax3 = f.add_subplot(233)

ax3 = sns.violinplot(x = 'class', y = 'Nhubs_R', data = df1, linewidth = 3.0, palette = 'Set1', saturation = 0.35,  width = 0.6)

x1, x2 = 0, 1

y, h, col = df1['Nhubs_R'].max() + df1['Nhubs_R'].max() * 0.3, df1['Nhubs_R'].max() * 0.05, 'k'

plt.plot([x1, x1, x2, x2], [y, y + h, y + h, y], lw = 1.2, c = 'k')

plt.text((x1 + x2) * 0.5, y + df1['Nhubs_R'].max() * 0.035, '*', ha = 'center', va = 'bottom', color = 'k')

ax3 = plt.title('$N_{hubs}-R$', fontsize = 18, fontname = 'Arial', style = 'italic')

ax3 = plt.xlabel('')

ax3 = plt.ylabel('')

ax3 = plt.yticks(fontsize = 14, fontname = 'Arial')

ax3 = plt.xticks(fontsize = 14, fontname = 'Arial')

ax4 = f.add_subplot(234)

ax4 = sns.regplot(x = 'duration', y = 'N_hubs', data = df2, line_kws = {'color': '#667AA0', 'alpha': 1.0},
                                                         scatter_kws = {'color': '#667AA0', 'alpha': 1.0})

ax4 = plt.title('$N_{hubs}$', fontsize = 18, fontname = 'Arial', style = 'italic')

ax4 = plt.xlabel('Epilepsy duration (years)', fontsize = 14, fontname = 'Arial')

ax4 = plt.ylabel('')

ax4 = plt.yticks(fontsize = 14, fontname = 'Arial')

ax4 = plt.xticks(fontsize = 14, fontname = 'Arial')

ax5 = f.add_subplot(235)

ax5 = sns.regplot(x = 'duration', y = 'N_hubs_L', data = df2, line_kws = {'color': '#667AA0', 'alpha': 1.0},
                                                         scatter_kws = {'color': '#667AA0', 'alpha': 1.0})

ax5 = plt.title('$N_{hubs}-L$', fontsize = 18, fontname = 'Arial', style = 'italic')

ax5 = plt.xlabel('Epilepsy duration (years)', fontsize = 14, fontname = 'Arial')

ax5 = plt.ylabel('')

ax5 = plt.yticks(fontsize = 14, fontname = 'Arial')

ax5 = plt.xticks(fontsize = 14, fontname = 'Arial')

ax6 = f.add_subplot(236)

ax6 = sns.regplot(x = 'duration', y = 'N_hubs_R', data = df2, line_kws = {'color': '#667AA0', 'alpha': 1.0},
                                                         scatter_kws = {'color': '#667AA0', 'alpha': 1.0})

ax6 = plt.title('$N_{hubs}-R$', fontsize = 18, fontname = 'Arial', style = 'italic')

ax6 = plt.xlabel('Epilepsy duration (years)', fontsize = 14, fontname = 'Arial')

ax6 = plt.ylabel('')

ax6 = plt.yticks(fontsize = 14, fontname = 'Arial')

ax6 = plt.xticks(fontsize = 14, fontname = 'Arial')

f.savefig('/Volumes/Projects_1/Results/fMRI/fc_PPI/figures/Fig.2-B.png', dpi = 1000, bbox_inches = 'tight', pad_inches = 0.3)


f = plt.figure(figsize = (9,12))

plt.subplots_adjust(hspace = 0.04)

ax1 = f.add_subplot(121)

ppi_cor_group = loadmat('/Volumes/Projects_1/Data/fMRI/fc_PPI/controls/neuroling/derivatives/cPPI/cPPI_output_orig_group.mat')

ppi_cor_group = ppi_cor_group['ppi_cor_group']

labels_controls = list(['G_Angular-1-L','G_Angular-1-R','G_Frontal_Sup-2-R','G_SupraMarginal-7-R','G_Temporal_Mid-3-R','G_Temporal_Mid-4-R','G_Temporal_Sup-4-R',
                        'S_Inf_Frontal-2-R','S_Precentral-4-R','S_Sup_Temporal-3-R','S_Sup_Temporal-4-R','G_Frontal_Inf_Orb-1-L','G_Frontal_Inf_Orb-1-R',
                        'G_Frontal_Sup-2-L','G_Insula-anterior-2-L','G_Insula-anterior-2-R','G_Frontal_Inf_Tri-1-L','G_SupraMarginal-7-L','G_Temporal_Mid-3-L',
                        'G_Temporal_Mid-4-L','G_Temporal_Sup-4-L','S_Sup_Temporal-1-L','S_Sup_Temporal-1-R','S_Sup_Temporal-2-L','S_Sup_Temporal-2-R',
                        'S_Sup_Temporal-3-L','S_Sup_Temporal-4-L','G_Frontal_Inf_Tri-1-R','G_Insula-anterior-3-L','G_Insula-anterior-3-R','G_Supp_Motor_Area-2-L',
                        'G_Supp_Motor_Area-2-R','G_Supp_Motor_Area-3-L','G_Supp_Motor_Area-3-R','S_Inf_Frontal-2-L','S_Precentral-4-L'])

plotting.plot_matrix(ppi_cor_group, axes = ax1, cmap = 'Reds', colorbar = False, vmax = np.max(ppi_cor_group), vmin = 0, reorder = False)

ax1 = plt.xticks(ticks = [-1,9,19,29],labels = ['0','10','20','30'],fontsize = 8)

ax1 = plt.yticks(ticks = [-1,9,19,29],labels = ['0','10','20','30'],fontsize = 8)

ax1 = plt.xlabel('Regions', fontsize = 12)

ax1 = plt.ylabel('Regions', fontsize = 12)

del ppi_cor_group

ax2 = f.add_subplot(122)

ppi_cor_group = loadmat('/Volumes/Projects_1/Data/fMRI/fc_PPI/PWE/neuroling/derivatives/cPPI/cPPI_output_orig_group.mat')

ppi_cor_group = ppi_cor_group['ppi_cor_group']

labels_pwe = list(['G_Angular-1-L','G_Angular-1-R','G_SupraMarginal-7-L','G_SupraMarginal-7-R','G_Temporal_Mid-3-R','G_Temporal_Mid-4-R','G_Temporal_Sup-4-R',
                   'S_Sup_Temporal-3-R','S_Sup_Temporal-4-R','G_Frontal_Inf_Orb-1-L','G_Frontal_Inf_Orb-1-R','G_Frontal_Inf_Tri-1-L','G_Frontal_Inf_Tri-1-R',
                   'G_Insula-anterior-2-L','G_Insula-anterior-2-R','G_Insula-anterior-3-L','G_Insula-anterior-3-R','S_Sup_Temporal-1-L','S_Sup_Temporal-1-R',
                   'S_Sup_Temporal-2-R','G_Frontal_Sup-2-L','G_Frontal_Sup-2-R','G_Supp_Motor_Area-2-L','G_Supp_Motor_Area-2-R','G_Supp_Motor_Area-3-L',
                   'G_Supp_Motor_Area-3-R','S_Inf_Frontal-2-L','S_Inf_Frontal-2-R','S_Precentral-4-L','S_Precentral-4-R','G_Temporal_Mid-3-L','G_Temporal_Mid-4-L',
                   'G_Temporal_Sup-4-L','S_Sup_Temporal-2-L','S_Sup_Temporal-3-L','S_Sup_Temporal-4-L'])

plotting.plot_matrix(ppi_cor_group, axes = ax2, cmap = 'Reds', vmax = np.max(ppi_cor_group), vmin = 0, reorder = False)

ax2 = plt.xticks(ticks = [-1,9,19,29],labels = ['0','10','20','30'],fontsize = 8)

ax2 = plt.yticks(ticks = [-1,9,19,29],labels = ['0','10','20','30'],fontsize = 8)

ax2 = plt.xlabel('Regions', fontsize = 12)

del ppi_cor_group

f.savefig('/Volumes/Projects_1/Results/fMRI/fc_PPI/figures/Fig.3.png', dpi = 1200, bbox_inches = 'tight', pad_inches = 0.2)
