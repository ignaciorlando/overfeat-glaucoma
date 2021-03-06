
This software package corresponds to the implementation of preprocessing and experiments used in our SIPAIM 2016 paper.
Paper is accepted, but please wait for using this code in your research until we have the citation you have to include.

If you want to use the same crops we use in our paper, please contact us:
jiorlando@conicet.gov.ar

########################################################################

HOW TO USE THIS CODE

0) INSTALL SOFTWARE PACKAGES

    1) Install ImageMagick:
    sudo apt-get install imagemagick

    2) Install OverFeat
    Download the pre-trained CNN from:
    http://cilvr.nyu.edu/doku.php?id=software:overfeat:start
    Download the weight using the instructions in the webpage.

1) DOWNSAMPLE IMAGES IN A GIVEN FOLDER
   In Ubuntu:

    i) Go to the folder where the images are stored
    cd folder/where/images/are

    ii) Downsample all the images in the folder
    mogrify -resize 231x231 -background black -gravity center -format png -extent 231x231 *.<image_extensions>

2) EXTRACT FEATURES FROM THE IMAGES IN THE FOLDER

    i) overfeat_batch -i folder/where/images/are -o folder/to/put/features

3) GENERATE MAT FILE FROM THE FEATURES FILES

    i) Modify and run featureMapFromFiles.

4) RUN EXPERIMENTS USING FILES IN experiments FOLDER.

########################################################################

The following external libraries are also used in this software package.
If you use any of these, please include the corresponding citations in your article or
include the corresponding acknowledgements:

----------------------
VL_Feat
----------------------
```bibtex
@misc{vedaldi08vlfeat,
 Author = {A. Vedaldi and B. Fulkerson},
 Title = {{VLFeat}: An Open and Portable Library
          of Computer Vision Algorithms},
 Year  = {2008},
 Howpublished = {\url{http://www.vlfeat.org/}}
```

----------------------
vesselSegmentation
----------------------
 This is an improved version of our previous method for blood vessel segmentation in fundus images.
 If you use it, please include the following citations:

```bibtex
 @incollection{orlando2014learning,
  title={Learning fully-connected CRFs for blood vessel segmentation in retinal images},
  author={Orlando, Jos{\'e} Ignacio and Blaschko, Matthew},
  booktitle={Medical Image Computing and Computer-Assisted Intervention--MICCAI 2014},
  pages={634--641},
  year={2014},
  publisher={Springer}
}
```

Additionally, this method uses third-party code for computing features:

```bibtex
@article{azzopardi2015trainable,
  title={Trainable {COSFIRE} filters for vessel delineation with application to retinal images},
  author={Azzopardi, George and Strisciuglio, Nicola and Vento, Mario and Petkov, Nicolai},
  journal={Medical Image Analysis},
  volume={19},
  number={1},
  pages={46--57},
  year={2015},
  publisher={Elsevier}
}
```

```bibtex
@article{nguyen2013effective,
  title={An effective retinal blood vessel segmentation method using multi-scale line detection},
  author={Nguyen, Uyen TV and Bhuiyan, Alauddin and Park, Laurence AF and Ramamohanarao, Kotagiri},
  journal={Pattern Recognition},
  volume={46},
  number={3},
  pages={703--715},
  year={2013},
  publisher={Elsevier}
}
```

And third-party code for inference in fully-connected CRF and local-neighborhood based CRF

```bibtex
@inproceedings{krahenbuhl2012efficient,
  title={Efficient inference in fully connected {CRFs} with {Gaussian} edge potentials},
  author={Kr{\"a}henb{\"u}hl, Philipp and Koltun, Vladlen},
  booktitle={Advances in Neural Information Processing Systems},
  year={2012},
  pages = {109--117},
	numpages = {24}
}
```

```bibtex
@article{boykov2004experimental,
  title={An experimental comparison of min-cut/max-flow algorithms for energy minimization in vision},
  author={Boykov, Yuri and Kolmogorov, Vladimir},
  journal={Pattern Analysis and Machine Intelligence, IEEE Transactions on},
  volume={26},
  number={9},
  pages={1124--1137},
  year={2004},
  publisher={IEEE}
}
```

----------------------
k support regularized logistic regression
----------------------
```bibtex
@article{blaschko2013note,
  title={A note on k-support norm regularized risk minimization},
  author={Blaschko, Matthew},
  journal={arXiv preprint arXiv:1303.6390},
  year={2013}
}
```

```bibtex
@inproceedings{argyriou2012sparse,
  title={Sparse Prediction with the $ k $-Support Norm},
  author={Argyriou, Andreas and Foygel, Rina and Srebro, Nathan},
  booktitle={Advances in Neural Information Processing Systems},
  pages={1457--1465},
  year={2012}
}
```