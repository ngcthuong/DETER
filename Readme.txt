------------------------------------------------------------------------------------------

    Demo software for Compressive Sensing Reconstruction via Decomposition
	
              Public release ver. 1.1 (27 Sept. 2016)

------------------------------------------------------------------------------------------

The software reproduces the experiments published in the paper

 T. N. Canh, K. Q. Dinh and B. Jeon, Compressive Sensing Reconstruction via Decomposition, 
submitted to Signal Processing: Image Communication, 2016. 
 
 DOI 

------------------------------------------------------------------------------------------

authors:               Thuong Nguyen Canh

web page:              https://sites.google.com/site/ngcthuong/

contact:               ngcthuong @ skku dot vn

------------------------------------------------------------------------------------------
Copyright (c) 2016 Sungkyunkwan University.
All rights reserved. 
This work should be used for nonprofit purposes only.
------------------------------------------------------------------------------------------

Contents
--------
Image                                       popular test image of size 256 and 512
demo_DTV.m                                  main script
Sensing/BCS_SPL_GenerateProjection_2.m 		generate gaussian sensing matrix
       KCS_SensingMTx.m                     generate KCS sensing matrix
Solver/PostProcess                          post processing (filtering) 
      /postBM3D.m                           post processing with BM3D
      /postMH.m                             post processing with multiple hypothesis
      /PostPrcessing.m                      general framwork for post processing
Solver/Regularization                       proposed nonlocal regularization method (AWTNL2 - gradient domain, AWTVNL1 - spatial domain)
Solver/Weighting                            proposed weighting scheme based on histogram (AWTV)
Solver/DCR                                  Decomposition based recovery method 
      /ATV.p                                Anisotropic TV recovery
      /DecWTVNLR.p                          general framwork for DCR which can en/disable Weighting, and Nonlocal gradient regularization 
      /recSepTV_Org.p                       Anisotropic TV recovery, 
      /SepTV_Recovery.p                     TV Recovery 
Solver/recSep.m                             framework for recovery, 
Solver/setup_parameter.m                    configuration file for various CS recovery 
Utilities                                   tools, write output, IQA 
      /Denoising                            Denoising tools, including NLM, BM3D, WNNM
      /QID                                  Quality index tool, PSNR, SSIM, FSIM, etc. 
      post_filter                           general framwork for filtering of various filter
      gradCal3.m                            calculate gradient matrix
      plot
								
Requirements
------------
This demo is designed for Matlab for Windows (ver. 7.4 and above)

Description
-----------
This packet support reconstruction of TV (total variation), WTV (weighted total 
variation), TV+NGL (Nonlocal gradient regularization), Decomposition based 
Reconstruction (DCR with TV - or DTV), and various combinations. Any filtering 
method can be used or further added. However, filter's degree configuration 
should be carefully selected to archieve the best resutls. 

DETER: DCR + NGL + WTW + BM3D
DETER*: DCR + NGL + WTV + WNNM

Runing
----------
1. Download and unpack KCS_Decomp_v01_20160923 packet
2. Setting setup_parameter.m file for desired combination of DCR 
2. Run the scrip demo_MRKCS_woPior.m
3. Enjoy.  

Note
---------
1. Running time is depend on the size of test image, filter 
2. Performance migh vary due to the recovery methods  

------------------------------------------------------------------------------------------

Disclaimer
----------
Copyright (c) 2016 Thuong Nguyen Canh

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.